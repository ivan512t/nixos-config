{ config, pkgs, ... }:

let
    homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in

{
    imports = [
        ./hardware-configuration.nix
        (homeManager + "/nixos")
    ];

    # Bootloader: Limine + Windows chainload
    boot.loader.systemd-boot.enable = false;
    boot.loader.limine.enable = true;
    boot.loader.limine.efiSupport = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine.extraEntries = ''
        /Windows 10
            protocol: efi
            path: uuid(84ee5c89-13ca-4b3e-89e1-221310609649):/EFI/Microsoft/Boot/bootmgfw.efi
    '';

    # Kernel/module settings
    boot.kernelParams = [
        "usbcore.autosuspend=-1"
        "cfg80211.ieee80211_regdom=TW"
    ];
    boot.extraModprobeConfig = ''
        options hid_apple fnmode=2
    '';

    # Identity / locale / time
    networking.hostName = "nixos";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";
    time.timeZone = "Asia/Taipei";
    services.timesyncd.enable = true;

    # Network (DHCP via NetworkManager)
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;

    # Display manager (ly)
    services.displayManager.lemurs.enable = false;
    services.displayManager.ly.enable = true;
    services.getty.autologinUser = null;
    services.getty.autologinOnce = false;
    systemd.services."getty@tty1".enable = true;
    systemd.services."getty@tty2".enable = true;
    systemd.services."getty@tty3".enable = true;
    systemd.services."getty@tty4".enable = true;
    systemd.services."getty@tty5".enable = true;
    systemd.services."getty@tty6".enable = true;

    # User
    users.users.ivan = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "seat" ];
        shell = pkgs.bashInteractive;
    };
    programs.bash.enable = true;
    programs.bash.shellAliases = {
        startniri = "XDG_CURRENT_DESKTOP=niri NIXOS_OZONE_WL=1 niri-session";
        niri-login = "XDG_CURRENT_DESKTOP=niri NIXOS_OZONE_WL=1 niri-session";
    };
    programs.bash.interactiveShellInit = "";
    environment.sessionVariables = {
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "96";
    };

    # Fonts
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
    fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" "Noto Sans CJK TC" ];
    fonts.fontconfig.defaultFonts.serif = [ "Noto Serif" "Noto Serif CJK TC" ];
    fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

    # Wayland desktop
    programs.niri.enable = true;
    programs.niri.useNautilus = false;
    programs.thunar.enable = true;
    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;
    xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
    ];
    xdg.portal.config.common.default = [ "gnome" "gtk" ];

    # Keyring and policy agent
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "Polkit GNOME authentication agent";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
        };
    };

    # Home Manager (user-level config and dotfiles)
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = false;
    home-manager.users.ivan = import ./home.nix;

    # SSH + firewall
    services.openssh.enable = true;
    services.openssh.openFirewall = true;
    services.openssh.ports = [ 22 ];
    services.openssh.settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
    };
    networking.firewall.enable = true;

    # Hardware baseline
    hardware.enableRedistributableFirmware = true;
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Audio (PipeWire)
    security.rtkit.enable = true;
    services.pipewire.enable = true;
    services.pipewire.audio.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.alsa.support32Bit = true;
    services.pipewire.pulse.enable = true;
    services.pipewire.wireplumber.enable = true;

    # Docs and tools
    documentation.man.enable = true;
    nixpkgs.config.allowUnfree = true;
    xdg.icons.enable = true;
    xdg.icons.fallbackCursorThemes = [ "Adwaita" ];
    gtk.iconCache.enable = true;
    environment.pathsToLink = [ "/share/icons" ];
    environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        waybar
        mako
        swaybg
        fuzzel
        swaylock
        foot
        firefox
        google-chrome
        _1password-gui
        spotify
        dropbox
        helix
        xwayland-satellite
        wl-clipboard
        libnotify
        pavucontrol
        impala
        bluetui
        wiremix
        alsa-utils
        efibootmgr
        vulkan-tools
        mesa-demos
        pciutils
        libva-utils
        vim
        curl
        wget
        git
        htop
        tmux
        tree
        unzip
        zip
        ripgrep
    ];

    # Keep matching the initially installed NixOS release
    system.stateVersion = "25.11";
}
