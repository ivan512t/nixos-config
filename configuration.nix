{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
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

    # TTY autologin without a display manager
    services.getty.autologinUser = "ivan";

    # User
    users.users.ivan = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.bashInteractive;
    };
    programs.bash.enable = true;
    programs.bash.loginShellInit = ''
        if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec uwsm start niri
        fi
    '';

    # Fonts
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        noto-fonts-extra
        nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
    fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" "Noto Sans CJK TC" ];
    fonts.fontconfig.defaultFonts.serif = [ "Noto Serif" "Noto Serif CJK TC" ];
    fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

    # Wayland desktop base via UWSM
    programs.niri.enable = true;
    programs.niri.useNautilus = false;
    programs.thunar.enable = true;
    programs.uwsm.enable = true;
    programs.uwsm.waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri";
    };
    programs.waybar.enable = true;
    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;
    xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
    ];
    xdg.portal.config.common.default = [ "hyprland" "gtk" ];

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
    systemd.user.tmpfiles.rules = [
        "d %h/.config - - - -"
        "d %h/.config/mako - - - -"
        "d %h/.config/waybar - - - -"
        "L+ %h/.config/mako/config - - - - /etc/nixos/mako/config"
        "L+ %h/.config/waybar/config.jsonc - - - - /etc/nixos/waybar/config.jsonc"
        "L+ %h/.config/waybar/style.css - - - - /etc/nixos/waybar/style.css"
    ];

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
    hardware.cpu.amd.updateMicrocode = true;
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
    environment.systemPackages = with pkgs; [
        impala
        bluetui
        wiremix
        alsa-utils
        efibootmgr
        vulkan-tools
        mesa-demos
        pciutils
        libva-utils
        swaybg
        mako
        libnotify
        polkit_gnome
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
