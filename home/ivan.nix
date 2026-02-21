{ config, pkgs, ... }:

{
    home.stateVersion = "25.11";

    xdg.configFile."mako/config".source = ../mako/config;
    xdg.configFile."waybar/config.jsonc".source = ../waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../waybar/style.css;
}
