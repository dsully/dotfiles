import os
import readline
import sys

from dataclasses import dataclass, field  # noqa: F401
from datetime import datetime, time, timedelta  # noqa: F401
from pathlib import Path
from pprint import pprint  # noqa: F401

from icecream import ic  # noqa: F401
from ptpython.layout import CompletionVisualisation
from ptpython.repl import embed
from rich.traceback import install

install(show_locals=True)

__all__ = ["configure"]


def configure(repl) -> None:
    """Configuration method. This is called during the start-up of ptpython."""

    # Show function signature (bool).
    repl.show_signature = True

    # Show docstring (bool).
    repl.show_docstring = True

    # Show the "[Meta+Enter] Execute" message when pressing [Enter] only
    # inserts a newline instead of executing the code.
    repl.show_meta_enter_message = True

    # Show completions. (NONE, POP_UP, MULTI_COLUMN or TOOLBAR)
    repl.completion_visualisation = CompletionVisualisation.POP_UP

    # When CompletionVisualisation.POP_UP has been chosen, use this
    # scroll_offset in the completion menu.
    repl.completion_menu_scroll_offset = 0

    # Show line numbers (when the input contains multiple lines.)
    repl.show_line_numbers = False

    # Show status bar.
    repl.show_status_bar = False

    # When the sidebar is visible, also show the help text.
    repl.show_sidebar_help = True

    # Swap light/dark colors on or off
    repl.swap_light_and_dark = False

    # Highlight matching parethesis.
    repl.highlight_matching_parenthesis = True

    # Line wrapping. (Instead of horizontal scrolling.)
    repl.wrap_lines = True

    # Mouse support.
    repl.enable_mouse_support = False

    # Complete while typing. (Don't require tab before the completion menu is shown.)
    repl.complete_while_typing = True

    # Fuzzy and dictionary completion.
    repl.enable_fuzzy_completion = False
    repl.enable_dictionary_completion = False

    # Vi mode.
    repl.vi_mode = False

    # Paste mode. (When True, don't insert whitespace after new line.)
    repl.paste_mode = False

    # Use the classic prompt. (Display '>>>' instead of 'In [1]'.)
    repl.prompt_style = "classic"  # 'classic' or 'ipython'

    # Don't insert a blank line after the output.
    repl.insert_blank_line_after_output = False

    # History Search.
    # When True, going back in history will filter the history on the records
    # starting with the current input. (Like readline.)
    # Note: When enable, please disable the `complete_while_typing` option.
    #       otherwise, when there is a completion available, the arrows will
    #       browse through the available completions instead of the history.
    repl.enable_history_search = False

    # Enable auto suggestions. (Pressing right arrow will complete the input, based on the history.)
    repl.enable_auto_suggest = True

    # Enable open-in-editor. Pressing C-x C-e in emacs mode or 'v' in
    # Vi navigation mode will open the input in the current editor.
    repl.enable_open_in_editor = True

    # Enable system prompt. Pressing meta-! will display the system prompt.
    # Also enables Control-Z suspend.
    repl.enable_system_bindings = True

    # Ask for confirmation on exit.
    repl.confirm_exit = False

    # Enable input validation. (Don't try to execute when the input contains
    # syntax errors.)
    repl.enable_input_validation = True

    # Use this colorscheme for the code.
    # Ptpython uses Pygments for code styling, so you can choose from Pygments'
    # color schemes. See:
    # https://pygments.org/docs/styles/
    # https://pygments.org/demo/
    # repl.use_code_colorscheme("nord")

    # A colorscheme that looks good on dark backgrounds is 'native':
    repl.use_code_colorscheme("native")

    # Set color depth (keep in mind that not all terminals support true color).
    repl.color_depth = "DEPTH_24_BIT"  # True color.

    # Min/max brightness
    repl.min_brightness = 0.0  # Increase for dark terminal backgrounds.
    repl.max_brightness = 1.0  # Decrease for light terminal backgrounds.

    # Syntax.
    repl.enable_syntax_highlighting = True

    # Get into Vi navigation mode at startup
    repl.vi_start_in_navigation_mode = False

    # Preserve last used Vi input mode between main loop iterations
    repl.vi_keep_last_used_mode = False

    # Custom key binding for some simple autocorrection while typing.
    corrections = {
        "impotr": "import",
        "pritn": "print",
    }

    @repl.add_key_binding(" ")
    def _(event):
        """When a space is pressed. Check & correct word before cursor."""
        b = event.cli.current_buffer
        w = b.document.get_word_before_cursor()

        if w is not None and w in corrections:
            b.delete_before_cursor(count=len(w))
            b.insert_text(corrections[w])

        b.insert_text(" ")


if __name__ == "__main__":
    # Disable default history file
    readline.write_history_file = lambda *args: None  # noqa: ARG005

    # Enable history
    history_file = Path(os.environ["XDG_DATA_HOME"]) / "python" / "history"
    history_file.parent.mkdir(parents=True, exist_ok=True)

    sys.exit(
        embed(
            configure=configure,
            globals=globals(),
            locals=locals(),
            history_filename=history_file,
        )
    )
