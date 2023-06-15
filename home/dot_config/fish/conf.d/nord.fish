# name: Nord
# preferred_background: #2e3440
# url: https://www.nordtheme.com

if status is-interactive

    # Polar Night
    set -U nord_dark_black '#2e3440'
    set -U nord_black '#3b4252'
    set -U nord_bright_black '#434c5e'
    set -U nord_gray '#4c566a'

    # Custom
    set -U nord_darkish_black '#3B414D'
    set -U nord_grayish '#667084'
    set -U nord_dark_black_alt '#2B303B'

    # Snow Storm
    set -U nord_dark_white '#d8dee9'
    set -U nord_white '#e5e9f0'
    set -U nord_bright_white '#eceff4'

    # Frost
    set -U nord_cyan '#8fbcbb'
    set -U nord_bright_cyan '#88c0d0'
    set -U nord_blue '#81a1c1'
    set -U nord_intense_blue '#5e81ac'

    # Aurora
    set -U nord_red '#bf616a'
    set -U nord_orange '#d08770'
    set -U nord_yellow '#ebcb8b'
    set -U nord_green '#a3be8c'
    set -U nord_purple '#b48ead'

    set -U fish_color_autosuggestion $nord_blue
    set -U fish_color_cancel -r
    set -U fish_color_command $nord_blue
    set -U fish_color_comment $nord_bright_black
    set -U fish_color_cwd $nord_green
    set -U fish_color_cwd_root $nord_red
    set -U fish_color_end $nord_bright_cyan
    set -U fish_color_error $nord_yellow
    set -U fish_color_escape $nord_blue
    set -U fish_color_history_current --bold
    set -U fish_color_host normal
    set -U fish_color_keyword $nord_blue
    set -U fish_color_match --background=$nord_intense_blue
    set -U fish_color_normal normal
    set -U fish_color_operator $nord_intense_blue
    set -U fish_color_option $nord_blue
    set -U fish_color_param $nord_blue
    set -U fish_color_quote $nord_white
    set -U fish_color_redirection $nord_red
    set -U fish_color_search_match $nord_yellow --background=$nord_bright_black
    set -U fish_color_selection $nord_white --bold --background=$nord_bright_black
    set -U fish_color_user $nord_green
    set -U fish_color_valid_path --underline
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description $nord_yellow $nord_yellow
    set -U fish_pager_color_prefix normal --bold --underline
    set -U fish_pager_color_progress $nord_bright_white --background=$nord_cyan
    set -U fish_pager_color_selected_background --background=$nord_bright_black
end
