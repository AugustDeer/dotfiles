{ pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
        };
        dwindle.preserve_split = true;
        misc.force_default_wallpaper = 0;
        decoration = {
          rounding = 10;
          dim_inactive = true;
          dim_strength = 0.1;
          blur.variant = "frost";
          blur.passes = 2;
        };
        input.touchpad.natural_scroll = true;
      };
      monitor = {
        output = "eDP-1";
        mode = "2560x1600@240";
        position = "0x0";
        scale = 1.25;
        vrr = 3;
      };
      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };
      window_rule = [
        {
          name = "suppress-maximize-events";
          match = {
            class = ".*";
          };
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
        {
          name = "noctalia-settings";
          match = {
            class = "dev.noctalia.Noctalia";
          };
          float = true;
          size = lib.mkLuaInline /* lua */ "{1080, 920}";
        }
      ];
      layer_rule = [
        {
          name = "noctalia";
          match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
          };
          no_anim = true;
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      ];
    };
    extraConfig =
      let
        noctalia = lib.getExe pkgs.noctalia;
      in
      /* lua */ ''
        hl.on("hyprland.start", function ()
          hl.exec_cmd("${noctalia}");
        end)

        hl.curve("quick", {type = "bezier", points = {{0.15, 0}, {0.1, 1}}})
        hl.curve("easy", {type = "spring", mass = 1, stiffness = 256, dampening = 26})

        hl.animation({leaf = "global", enabled = true, speed = 5, spring = "easy"})


        hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("${lib.getExe pkgs.kitty}"))
        hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("${lib.getExe pkgs.firefox}"))
        hl.bind("SUPER + CTRL + RETURN", hl.dsp.exec_cmd("${lib.getExe pkgs.thunar}"))

        hl.bind("SUPER + M", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprshutdown}"))
        hl.bind("SUPER + Q", hl.dsp.window.close())

        hl.bind("SUPER + TAB", hl.dsp.group.next())
        hl.bind("SUPER + SHIFT + TAB", hl.dsp.group.prev())

        hl.bind("SUPER + H", hl.dsp.focus({direction = "left"}))
        hl.bind("SUPER + J", hl.dsp.focus({direction = "down"}))
        hl.bind("SUPER + K", hl.dsp.focus({direction = "up"}))
        hl.bind("SUPER + L", hl.dsp.focus({direction = "right"}))

        hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({direction = "left", group_aware = true}))
        hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({direction = "down", group_aware = true}))
        hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({direction = "up", group_aware = true}))
        hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({direction = "right", group_aware = true}))

        hl.bind("SUPER + V", hl.dsp.window.float())
        hl.bind("SUPER + F", hl.dsp.window.fullscreen())
        hl.bind("SUPER + I", hl.dsp.window.move({workspace = "special:scratchpad", follow = false}))
        hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))

        for i = 1, 10 do
          local key = i % 10
          hl.bind("SUPER + " .. key, hl.dsp.focus({workspace = i}))
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("${noctalia} msg panel-toggle launcher"))
        hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("${noctalia} msg settings-toggle"))

        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${noctalia} msg volume-up"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${noctalia} msg volume-down"), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${noctalia} msg volume-mute"), { locked = true })
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${noctalia} msg mic-mute"), { locked = true })
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${noctalia} msg brightness-up"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${noctalia} msg brightness-down"), { locked = true, repeating = true })

        hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("${noctalia} msg screenshot-region"))

        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      '';
  };
}
