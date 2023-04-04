local wezterm = require("wezterm")
local act = wezterm.action

local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- From my nvim/lua/plugins/nightfox.lua
local colors = {
    red = { base = "#bf616a", bright = "#d06f79", dim = "#a54e56" },
    orange = { base = "#d08770", bright = "#d89079", dim = "#b46950" },
    green = { base = "#a3be8c", bright = "#b1d196", dim = "#8aa872" },
    yellow = { base = "#ebcb8b", bright = "#f0d399", dim = "#d9b263" },
    magenta = { base = "#b48ead", bright = "#c895bf", dim = "#9d7495" },
    pink = { base = "#bf88bc", bright = "#d092ce", dim = "#a96ca5" },

    -- nordic: blue, intense_blue, none
    blue = { base = "#81a1c1", bright = "#5e81ac", dim = "#668aab" },

    -- nordic: black, bright_black, dark_black
    black = { base = "#3b4252", bright = "#434c5e", dim = "#2e3440" },

    -- nordic: cyan, bright_cyan, none
    cyan = { base = "#8fbcbb", bright = "#88c0d0", dim = "#69a7ba" },

    -- nordic: white, bright_white, dark_white
    white = { base = "#e5e9f0", bright = "#eceff4", dim = "#d8dee9" },

    -- noridc: gray, grayish, dark_black_alt
    gray = { base = "#4c566a", bright = "#667084", dim = "#2b303b" },
}

local function create_ssh_domain_from_ssh_config()
    local ssh_domains = {}

    for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
        table.insert(ssh_domains, {
            name = host,
            remote_address = config.hostname .. ":" .. config.port,
            username = config.user,
            multiplexing = "None",
            assume_shell = "Posix",
        })
    end
    return ssh_domains
end

local hyperlink_rules = function()
    -- Use the defaults as a base
    local rules = wezterm.default_hyperlink_rules()

    -- Make Go links clickable.
    -- the first matched regex group is captured in $1.
    table.insert(rules, {
        regex = [[\bgo/(\S+)\b]],
        format = "https://go/$1",
    })

    -- Make username/project paths clickable. this implies paths like the following are for github.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- as long as a full url hyperlink regex exists above this it should not match a full url to
    -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
    table.insert(rules, {
        regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?%s+]],
        format = "https://www.github.com/$1/$3",
    })

    return rules
end

local padding_with_spaces = function(target_str, max_width)
    while target_str:len() < max_width - 2 do
        target_str = " " .. target_str .. " "
    end
    return target_str
end

---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    --
    local bar = "❙"

    if tab.tab_index + 1 == #tabs then
        bar = ""
    end

    local process_name = basename(tab.active_pane.foreground_process_name)
    local pane_title = tab.active_pane.title

    if process_name == "nvim" then
        pane_title = pane_title:gsub("^(nvim %S+) .*", "%1")
    end

    pane_title = pane_title:gsub("^Zellij .+%[(%S+)%]", "%1")

    local has_unseen_output = false

    for _, pane in ipairs(tab.panes) do
        if pane.has_unseen_output then
            has_unseen_output = true
            break
        end
    end

    local output = {}

    if has_unseen_output then
        output = {
            { Foreground = { Color = colors.cyan.dim } },
            { Attribute = { Intensity = "Bold" } },
            { Text = " *" },
            { Foreground = { Color = colors.white.dim } },
        }
    end

    -- Highlight just the relevant text in active mode.
    table.insert(output, { Background = { Color = colors.black.base } })

    if tab.tab_index == 0 then
        table.insert(output, { Text = "  " })
    else
        table.insert(output, { Text = " " })
    end

    if tab.is_active then
        table.insert(output, { Background = { Color = colors.gray.base } })
    else
        table.insert(output, { Background = { Color = colors.black.base } })
    end

    -- Ensure that the titles fit in the available space, and that we have room for the edges.
    local title = wezterm.truncate_right(string.format("%d: %s", tab.tab_index + 1, pane_title), max_width - 2)

    table.insert(output, { Text = padding_with_spaces(title, max_width) })
    table.insert(output, { Background = { Color = colors.black.base } })
    table.insert(output, { Text = " " .. bar })

    return output
end)

return {
    font = wezterm.font("Menlo", { stretch = "Expanded" }),
    font_size = 16.3,
    custom_block_glyphs = true,
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    unicode_version = 14,

    adjust_window_size_when_changing_font_size = false,
    animation_fps = 1,
    bold_brightens_ansi_colors = true,
    check_for_updates = false,

    color_scheme = "nordfox",
    color_schemes = {
        nordfox = {
            background = colors.black.dim,
            foreground = colors.white.dim,

            cursor_bg = colors.white.dim,
            cursor_fg = colors.gray.base,
            cursor_border = colors.white.dim,

            compose_cursor = colors.orange.dim,

            selection_bg = colors.white.dim,
            selection_fg = colors.black.dim,

            copy_mode_active_highlight_bg = { Color = colors.white.dim },
            copy_mode_active_highlight_fg = { Color = colors.black.dim },
            copy_mode_inactive_highlight_bg = { Color = colors.white.dim },
            copy_mode_inactive_highlight_fg = { Color = colors.black.dim },

            scrollbar_thumb = colors.gray.bright,
            split = colors.black.bright,
            visual_bell = colors.white.dim,
            ansi = {
                colors.black.base,
                colors.red.base,
                colors.green.base,
                colors.yellow.base,
                colors.blue.base,
                colors.magenta.base,
                colors.cyan.base,
                colors.white.base,
            },
            brights = {
                colors.black.bright,
                colors.red.bright,
                colors.green.bright,
                colors.yellow.bright,
                colors.blue.bright,
                colors.magenta.bright,
                colors.cyan.bright,
                colors.white.bright,
            },

            indexed = {
                [16] = colors.pink.dim,
                [17] = colors.orange.dim,
            },

            tab_bar = {
                -- The color of the strip that goes along the top of the window
                -- (does not apply when fancy tab bar is in use)
                background = colors.black.dim,

                -- The active tab is the one that has focus in the window
                active_tab = {
                    bg_color = colors.gray.base,
                    fg_color = colors.white.base,
                },

                -- Inactive tabs are the tabs that do not have focus
                inactive_tab = {
                    bg_color = colors.black.base,
                    fg_color = colors.white.dim,
                },

                -- You can configure some alternate styling when the mouse pointer moves over inactive tabs
                inactive_tab_hover = {
                    bg_color = colors.gray.bright,
                    fg_color = colors.white.bright,
                },

                -- The new tab button that let you create new tabs
                new_tab = {
                    bg_color = colors.gray.base,
                    fg_color = colors.white.base,
                },

                new_tab_hover = {
                    bg_color = colors.gray.bright,
                    fg_color = colors.white.bright,
                },
            },
        },
    },

    command_palette_bg_color = colors.black.base,
    command_palette_fg_color = colors.white.dim,
    command_palette_font_size = 18,

    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    default_cursor_style = "BlinkingBlock",
    default_cwd = wezterm.home_dir,

    disable_default_key_bindings = true,
    disable_default_mouse_bindings = true,

    enable_kitty_graphics = true,
    enable_scroll_bar = false,
    exit_behavior = "CloseOnCleanExit",
    hide_tab_bar_if_only_one_tab = true,

    hyperlink_rules = hyperlink_rules(),

    initial_cols = 180,
    initial_rows = 55,

    keys = {
        -- Always start in $HOME.
        { mods = "SUPER", key = "t", action = act({ SpawnCommandInNewTab = { cwd = wezterm.home_dir } }) },

        { key = "-", mods = "CMD|SHIFT", action = "DecreaseFontSize" },
        { key = "+", mods = "CMD|SHIFT", action = "IncreaseFontSize" },
        { key = "0", mods = "CMD|SHIFT", action = "ResetFontSize" },

        { key = 'q', mods = 'CMD', action = act.QuitApplication },
        { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },

        -- CTRL-SHIFT-l activates the debug overlay
        { mods = "CTRL", key = "L", action = act.ShowDebugOverlay },
        { mods = "CTRL", key = "P", action = act.ActivateCommandPalette },

        { mods = "SUPER", key = "c", action = act.CopyTo("ClipboardAndPrimarySelection") },
        { mods = "SUPER", key = "v", action = act.PasteFrom("Clipboard") },
        { mods = "SUPER", key = "f", action = act.Search({ CaseInSensitiveString = "" }) },

        { mods = "SUPER", key = "RightArrow", action = act.ActivateTabRelative(1) },
        { mods = "SUPER", key = "LeftArrow", action = act.ActivateTabRelative(-1) },

        { mods = "SUPER|SHIFT", key = "RightArrow", action = act.MoveTabRelative(1) },
        { mods = "SUPER|SHIFT", key = "LeftArrow", action = act.MoveTabRelative(-1) },

        { key = "1", mods = "CMD", action = act({ ActivateTab = 0 }) },
        { key = "2", mods = "CMD", action = act({ ActivateTab = 1 }) },
        { key = "3", mods = "CMD", action = act({ ActivateTab = 2 }) },
        { key = "4", mods = "CMD", action = act({ ActivateTab = 3 }) },
        { key = "5", mods = "CMD", action = act({ ActivateTab = 4 }) },
        { key = "6", mods = "CMD", action = act({ ActivateTab = 5 }) },
        { key = "7", mods = "CMD", action = act({ ActivateTab = 6 }) },
        { key = "8", mods = "CMD", action = act({ ActivateTab = 7 }) },
        { key = "9", mods = "CMD", action = act({ ActivateTab = 8 }) },
        { key = "0", mods = "CMD", action = act({ ActivateTab = 9 }) },
    },

    mouse_bindings = {
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        { event = { Up = { streak = 1, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("PrimarySelection") },
        { event = { Up = { streak = 2, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("Clipboard") },
        { event = { Up = { streak = 3, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("Clipboard") },

        { event = { Down = { streak = 1, button = "Left" } }, mods = "NONE", action = act.SelectTextAtMouseCursor("Cell") },
        { event = { Down = { streak = 2, button = "Left" } }, mods = "NONE", action = act.SelectTextAtMouseCursor("Word") },
        { event = { Down = { streak = 2, button = "Left" } }, mods = "SHIFT", action = act.SelectTextAtMouseCursor("Word") },

        { event = { Drag = { streak = 1, button = "Left" } }, mods = "NONE", action = act({ ExtendSelectionToMouseCursor = "Cell" }) },
        { event = { Drag = { streak = 1, button = "Left" } }, mods = "SHIFT", action = act({ ExtendSelectionToMouseCursor = "Cell" }) },

        { event = { Drag = { streak = 2, button = "Left" } }, mods = "NONE", action = act({ ExtendSelectionToMouseCursor = "Word" }) },
        { event = { Drag = { streak = 3, button = "Left" } }, mods = "NONE", action = act({ ExtendSelectionToMouseCursor = "Line" }) },

        { event = { Down = { streak = 1, button = { WheelUp = 1 } } }, mods = "NONE", action = act.ScrollByCurrentEventWheelDelta },
        { event = { Down = { streak = 1, button = { WheelDown = 1 } } }, mods = "NONE", action = act.ScrollByCurrentEventWheelDelta },

        -- Make CTRL-Click open hyperlinks.
        { event = { Up = { streak = 1, button = "Left" } }, mods = "SUPER", action = act.OpenLinkAtMouseCursor },

        -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
        { event = { Down = { streak = 1, button = "Left" } }, mods = "SUPER", action = act.Nop },
    },
    mouse_wheel_scrolls_tabs = false,

    scrollback_lines = 50000,

    -- https://wezfurlong.org/wezterm/config/lua/config/selection_word_boundary.html
    selection_word_boundary = " \t\n{}[]()\"'`,;|│",

    -- https://wezfurlong.org/wezterm/config/keyboard-concepts.html?h=mod+key#macos-left-and-right-option-key
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true,

    show_new_tab_button_in_tab_bar = false,
    show_tab_index_in_tab_bar = true,

    ssh_domains = create_ssh_domain_from_ssh_config(),

    tab_max_width = 64,
    term = "wezterm",

    use_dead_keys = false,
    use_fancy_tab_bar = false,

    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    window_frame = {
        border_left_width = "0.5cell",
        border_right_width = "0.5cell",
        border_bottom_height = "0.1cell",
        border_top_height = "0.1cell",
    },
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
