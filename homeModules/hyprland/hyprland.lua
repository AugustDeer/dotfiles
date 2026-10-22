local term = "ghostty";
local browser = "firefox";
local files = "thunar";

hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")

hl.monitor({
  output = "eDP-1",
  mode = "2560x1600@240",
  position = "0x0",
  scale = 1.25,
  vrr = 1,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)

hl.config({
  general = {
    border_size = 2,
    layout = "dwindle",
    col = {
      active_border = "rgb(76946a)",
      inactive_border = "rgb(363646)",
    },
  },
  misc = {
    background_color = "rgb(1f1f28)",
    disable_hyprland_logo = true,
    vrr = 1,
  },
  group = {
    col = { border_active = "rgb(7e9cd8)" },
  },
  decoration = {
    rounding = 10,
    blur = {
      enabled = true,
      variant = "frost",
    },
  },
  animations = { enabled = true },
  input = { touchpad = { natural_scroll = true } },
  dwindle = { force_split = 0, preserve_split = true },
  scrolling = {
    column_width = 0.5,
    explicit_column_widths = "0.5, 0.8, 1.0",
  },
})

hl.animation({ leaf = "global", enabled = true, speed = 3, spring = "default" })

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + CTRL + RETURN", hl.dsp.exec_cmd(files))

hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mod .. " + Q", hl.dsp.window.close())

hl.bind(mod .. " + TAB", hl.dsp.layout("cyclenext"))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

hl.bind(mod .. " + I", function()
  if hl.get_workspace("special:minimized") then
    hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
    hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
  else
    hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
  end
end)
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("minimized"))

for i = 1, 10 do
  hl.bind(mod .. " + " .. i % 10, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + N", function()
  local workspace = hl.get_active_workspace()
  if hl.get_active_special_workspace() then
    workspace = hl.get_active_special_workspace()
  end
  if not workspace then
    return
  end

  local layouts = { "dwindle", "scrolling", "monocle" }

  local next_layout = "dwindle"
  for i = 1, #layouts do
    if layouts[i] == workspace.tiled_layout then
      local next_layout_idx = (i % #layouts) + 1
      next_layout = layouts[next_layout_idx]
      break
    end
  end

  if workspace.special then
    hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
  else
    hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
  end
end)

hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mod .. " + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { repeating = true, locked = true })
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("noctalia msg brightness-down"),
  { repeating = true, locked = true }
)

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

---@param w HL.Window
hl.on("window.open", function(w)
  if w.class ~= "firefox" then return end
  if w.initial_title ~= "Mozilla Firefox" then return end

  local ff_windows = hl.get_windows({ class = "firefox" })
  if #ff_windows <= 1 then return end

  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
    if tw.address ~= w.address then return end
    if tw.title == ""
        or tw.title == "Mozilla Firefox"
        or tw.title == "about:blank"
        or tw.title:match("^about:.*Mozilla Firefox$") then
      return
    end

    sub:remove()

    if tw.title:match("^Extension:") then
      hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
      hl.dispatch(hl.dsp.window.center({ window = tw }))
      hl.dispatch(hl.dsp.focus({ window = tw }))
    else
      hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
    end
  end)
end)
