{ config, ... }:

{
    home.stateVersion = "25.11";

    xdg.configFile."foot/foot.ini".source = ./foot/foot.ini;
    xdg.configFile."mako/config".source = ./mako/config;
    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;

    systemd.user.services.waybar = {
        Unit = {
            Description = "Waybar";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
        };
        Service = {
            ExecStart = "/run/current-system/sw/bin/waybar";
            Restart = "on-failure";
            RestartSec = 1;
        };
        Install.WantedBy = [ "graphical-session.target" ];
    };

    systemd.user.services.mako = {
        Unit = {
            Description = "Mako notification daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
        };
        Service = {
            ExecStart = "/run/current-system/sw/bin/mako";
            Restart = "on-failure";
            RestartSec = 1;
        };
        Install.WantedBy = [ "graphical-session.target" ];
    };

    systemd.user.services.swaybg = {
        Unit = {
            Description = "Swaybg wallpaper";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
        };
        Service = {
            ExecStart = "/run/current-system/sw/bin/swaybg -m fill -i /home/ivan/pictures/wallpapers/hypr-wall.jxl";
            Restart = "on-failure";
            RestartSec = 1;
        };
        Install.WantedBy = [ "graphical-session.target" ];
    };

    home.file."pictures/wallpapers/hypr-wall.jxl".source = ./wallpapers/hypr-wall.jxl;

}
