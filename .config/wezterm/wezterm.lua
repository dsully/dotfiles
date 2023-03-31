local wezterm = require("wezterm")

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

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local bar = "❙ "

    if tab.tab_index + 1 == #tabs then
        bar = ""
    end

    -- ensure that the titles fit in the available space, and that we have room for the edges.
    local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

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
            { Text = " " },
            { Foreground = { Color = colors.white.dim } },
        }
    end

    table.insert(output, { Text = string.format(" %d: %s %s", tab.tab_index + 1, title, bar) })

    return output
end)

return {
    font = wezterm.font("Menlo", { stretch = "Expanded" }),
    font_size = 16.3,
    custom_block_glyphs = true,
    unicode_version = 14,

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
    enable_kitty_graphics = true,
    enable_scroll_bar = false,
    exit_behavior = "CloseOnCleanExit",
    hide_tab_bar_if_only_one_tab = true,

    hyperlink_rules = {
        -- Linkify things that look like URLs and the host has a TLD name.
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
            format = "$0",
        },

        -- linkify email addresses
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
            format = "mailto:$0",
        },

        -- file:// URI
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = [[\bfile://\S*\b]],
            format = "$0",
        },

        -- Linkify things that look like URLs with numeric addresses as hosts.
        -- E.g. http://127.0.0.1:8000 for a local development server,
        -- or http://192.168.1.1 for the web interface of many routers.
        {
            regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
            format = "$0",
        },

        -- Make username/project paths clickable. This implies paths like the following are for GitHub.
        -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
        -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
        {
            regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
            format = "https://www.github.com/$1/$3",
        },
    },

    initial_cols = 180,
    initial_rows = 55,

    keys = {
        -- Always start in $HOME.
        { mods = "CMD", key = "t", action = wezterm.action({ SpawnCommandInNewTab = { cwd = wezterm.home_dir } }) },

        -- CTRL-SHIFT-l activates the debug overlay
        { mods = "CTRL", key = "L", action = wezterm.action.ShowDebugOverlay },
        { mods = "CTRL", key = "P", action = wezterm.action.ActivateCommandPalette },

        { mods = "CMD", key = "c", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
        { mods = "CMD", key = "v", action = wezterm.action.PasteFrom("Clipboard") },

        { mods = "CMD", key = "RightArrow", action = wezterm.action.MoveTabRelative(1) },
        { mods = "CMD", key = "LeftArrow", action = wezterm.action.MoveTabRelative(-1) },
    },

    scrollback_lines = 50000,
    selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",

    -- https://wezfurlong.org/wezterm/config/keyboard-concepts.html?h=mod+key#macos-left-and-right-option-key
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true,

    show_new_tab_button_in_tab_bar = false,
    show_tab_index_in_tab_bar = true,

    ssh_domains = create_ssh_domain_from_ssh_config(),

    tab_max_width = 64,

    use_dead_keys = false,
    use_fancy_tab_bar = false,
    window_close_confirmation = "NeverPrompt",

    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    window_frame = {
        border_left_width = "0.5cell",
        border_right_width = "0.5cell",
        border_bottom_height = "0.1cell",
        border_top_height = "0.1cell",
    },
}
