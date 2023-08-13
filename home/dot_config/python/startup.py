"""Executed on startup of an interactive Python session"""

# https://github.com/prompt-toolkit/ptpython

from __future__ import annotations

import os
import readline
import sys

from dataclasses import dataclass  # noqa: F401
from datetime import datetime, time, timedelta  # noqa: F401
from pathlib import Path
from pprint import pprint  # noqa: F401

# Disable default history file
readline.write_history_file = lambda *args: None  # noqa: ARG005


def configure(repl):
    repl.color_depth = "DEPTH_24_BIT"
    repl.complete_while_typing = True
    repl.confirm_exit = False
    repl.enable_auto_suggest = True
    repl.highlight_matching_parenthesis = True
    repl.prompt_style = "classic"
    repl.show_signature = True
    repl.show_status_bar = False
    repl.use_code_colorscheme("nord")
    repl.vi_mode = False


def launch_repl():
    """Launch a better REPL (ptpython), if available"""

    # HACK: inject ptpython
    libs = list(Path.home().joinpath(".rye/tools/ptpython/lib").glob("python*"))

    if not libs:
        return

    sys.path.append(str(libs[0] / "site-packages"))

    try:
        from ptpython.ipython import embed  # type: ignore

    except ImportError:
        print("ptpython is not available: falling back to standard prompt")

    else:
        # Enable history
        history_file = Path(os.environ["XDG_DATA_HOME"]) / "python" / "history"
        history_file.parent.mkdir(parents=True, exist_ok=True)

        # Launch
        sys.exit(
            embed(
                globals=globals(),
                configure=configure,
                history_filename=history_file,
            )
        )


launch_repl()
