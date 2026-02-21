{ config, ... }:

{
    home.stateVersion = "25.11";

    xdg.configFile."foot/foot.ini".source = ./foot/foot.ini;
    xdg.configFile."mako/config".source = ./mako/config;
    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;

    home.file."pictures/wallpapers/hypr-wall.jxl".source = ./wallpapers/hypr-wall.jxl;

}
