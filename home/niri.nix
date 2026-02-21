{ config, ... }:

{
    programs.niri.enable = true;
    programs.niri.settings = {
        input = {
            keyboard = {
                # xkb = {
                #     layout = "us,ru";
                #     options = "caps:hyper";
                # };
                "repeat-delay" = 300;
                "repeat-rate" = 50;
            };
            mouse = {
                "accel-speed" = 0.0;
                "accel-profile" = "flat";
            };
            "focus-follows-mouse" = {
                "max-scroll-amount" = "0%";
            };
            # "mod-key" = "Mod3";
            # "mod-key-nested" = "Alt";
        };

        output = {
            "DP-3" = {
                mode = "3840x2160@143.999";
                scale = 2;
            };
        };

        workspace = [ "1" "2" "3" "4" "5" ];

        layout = {
            gaps = 8;
            "center-focused-column" = "on-overflow";
            "preset-column-widths" = [
                { proportion = 0.33333; }
                { proportion = 0.5; }
                { proportion = 0.66667; }
            ];
            "default-column-width" = { proportion = 0.5; };
            "focus-ring" = {
                width = 2;
                "active-color" = "#7fc8ff";
                "inactive-color" = "#505050";
            };
            border.off = true;
            "background-color" = "#111111";
        };

        "prefer-no-csd" = true;
        "screenshot-path" = "~/pictures/screenshots/%Y-%m-%d-%H%M%S.png";
        "hotkey-overlay"."skip-at-startup" = true;
        animations.off = true;

        "spawn-at-startup" = [
            { argv = [ "waybar" ]; }
            { argv = [ "mako" ]; }
            { argv = [ "swaybg" "-m" "fill" "-i" "/home/ivan/pictures/wallpapers/hypr-wall.jxl" ]; }
        ];

        binds = with config.lib.niri.actions; {
            "Mod+T".action.spawn = "foot";
            "Mod+D".action.spawn = "fuzzel";
            "Mod+Shift+BackSpace".action.spawn = "swaylock";

            # "Mod+Space".action = switch-layout "next";

            "Mod+Q".action = close-window;
            "Mod+F".action = fullscreen-window;
            "Mod+O" = {
                repeat = false;
                action = toggle-overview;
            };

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;
            "Mod+L".action = focus-column-right;
            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-down;
            "Mod+Up".action = focus-window-up;
            "Mod+Right".action = focus-column-right;

            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+J".action = move-window-down;
            "Mod+Shift+K".action = move-window-up;
            "Mod+Shift+L".action = move-column-right;
            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Down".action = move-window-down;
            "Mod+Shift+Up".action = move-window-up;
            "Mod+Shift+Right".action = move-column-right;

            "Mod+R".action = switch-preset-column-width;
            "Mod+Shift+R".action = switch-preset-window-height;
            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";
            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            "Mod+1".action = focus-workspace "1";
            "Mod+2".action = focus-workspace "2";
            "Mod+3".action = focus-workspace "3";
            "Mod+4".action = focus-workspace "4";
            "Mod+5".action = focus-workspace "5";

            "Mod+Shift+1".action."move-column-to-workspace" = "1";
            "Mod+Shift+2".action."move-column-to-workspace" = "2";
            "Mod+Shift+3".action."move-column-to-workspace" = "3";
            "Mod+Shift+4".action."move-column-to-workspace" = "4";
            "Mod+Shift+5".action."move-column-to-workspace" = "5";

            "Mod+Tab".action = focus-workspace-previous;
            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;
            "Mod+Shift+Page_Down".action = move-column-to-workspace-down;
            "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
            "Mod+WheelScrollDown".action = focus-workspace-down;
            "Mod+WheelScrollUp".action = focus-workspace-up;
            "Mod+WheelScrollRight".action = focus-column-right;
            "Mod+WheelScrollLeft".action = focus-column-left;

            "Print".action = screenshot;
            "Ctrl+Print".action = screenshot-screen;
            "Alt+Print".action = screenshot-window;

            "Mod+Shift+E".action = quit;
            # "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
        };
    };
}
