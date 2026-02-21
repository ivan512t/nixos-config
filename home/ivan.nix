{ ... }:

{
    home.stateVersion = "25.11";

    xdg.configFile."niri/config.kdl".source = ../niri/config.kdl;
    xdg.configFile."mako/config".source = ../mako/config;
    xdg.configFile."waybar/config.jsonc".source = ../waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../waybar/style.css;

    home.file."pictures/wallpapers/hypr-wall.jxl".source = ../wallpapers/hypr-wall.jxl;

}
