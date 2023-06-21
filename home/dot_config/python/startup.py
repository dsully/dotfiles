"""Startup script that adds niceties to the interactive interpreter.

This script adds the following things:

- Readline bindings, tab completion, and history (in ~/.pyhistory,
  which can be disabled by setting NOHIST in the environment)

- Pretty printing of expression output (with Pygments highlighting)

- Pygments highlighting of tracebacks

- Function arguments in repr() for callables

- A source() function that displays the source of an arbitrary object
  (in a pager, with Pygments highlighting)

Note: The default versions of Python that ship with Mac OS X don't
come with readline. To get readline support, you can try a stand-alone
readline library[1], or you can use a different Python distribution
(like the one from MacPorts).

[1]: http://pypi.python.org/pypi/readline
"""

import atexit
import os
import sys

from contextlib import suppress
from linecache import cache
from pathlib import Path


def _pythonrc_enable_readline():
    """Enable readline, tab completion, and history."""
    import sys

    try:
        import readline
        import rlcompleter  # noqa
    except ImportError:
        sys.stderr.write("readline unavailable - tab completion disabled.\n")
        return

    old_complete = readline.get_completer()

    def complete(text, state):
        if not text:
            # Insert four spaces for indentation
            return ("    ", None)[state]

        return old_complete(text, state)

    readline.parse_and_bind("tab: complete")
    readline.set_completer(complete)


def _pythonrc_enable_history():

    try:
        import readline
    except ImportError:
        return

    # "NOHIST= python" will disable history
    if "NOHIST" not in os.environ:
        history_path = Path.home() / ".cache/pyhistory"

        has_written = [False]

        def write_history():
            if not has_written[0]:
                readline.write_history_file(history_path)
                has_written[0] = True

        atexit.register(write_history)

        if os.path.isfile(history_path):
            readline.read_history_file(history_path)
        readline.set_history_length(-1)


def _pythonrc_enable_pprint():
    """Enable pretty printing of evaluated expressions."""
    import pprint
    import sys

    try:
        from io import StringIO
        from pygments import highlight
        from pygments.lexers import PythonLexer, PythonTracebackLexer
        from pygments.formatters import TerminalFormatter

        def pphighlight(o, *a, **kw):
            s = pprint.pformat(o, *a, **kw)
            try:
                sys.stdout.write(highlight(s, PythonLexer(), TerminalFormatter()))
            except UnicodeError:
                sys.stdout.write(s)
                sys.stdout.write("\n")

        _old_excepthook = sys.excepthook

        def excepthook(exctype, value, traceback):
            """Prints exceptions to sys.stderr and colorizes them."""

            # traceback.format_exception() isn't used because it's
            # inconsistent with the built-in formatter
            old_stderr = sys.stderr
            sys.stderr = StringIO()
            try:
                _old_excepthook(exctype, value, traceback)
                old_stderr.write(highlight(sys.stderr.getvalue(), PythonTracebackLexer(), TerminalFormatter()))
            finally:
                sys.stderr = old_stderr

        sys.excepthook = excepthook
    except ImportError:
        pphighlight = pprint.pprint

    import builtins as __builtin__
    import inspect
    import pydoc
    import sys
    import types

    help_types = [
        types.BuiltinFunctionType,
        types.BuiltinMethodType,
        types.FunctionType,
        types.MethodType,
        types.ModuleType,
        type,
        # method_descriptor
        type(list.remove),
    ]
    if hasattr(types, "UnboundMethodType"):
        help_types.append(types.UnboundMethodType)
    help_types = tuple(help_types)

    def _ioctl_width(fd):
        from fcntl import ioctl
        from struct import pack, unpack
        from termios import TIOCGWINSZ

        return unpack("HHHH", ioctl(fd, TIOCGWINSZ, pack("HHHH", 0, 0, 0, 0)))[1]

    def get_width():
        """Returns terminal width."""

        width = 0

        with suppress(ImportError):
            width = _ioctl_width(0) or _ioctl_width(1) or _ioctl_width(2)

        if not width:

            width = os.environ.get("COLUMNS", 0)
        return width

    getargspec = inspect.getfullargspec

    def pprinthook(value):
        """Pretty print an object to sys.stdout and also save it in __builtin__."""

        if value is None:
            return

        __builtin__._ = value

        if isinstance(value, help_types):
            reprstr = repr(value)
            try:
                if inspect.isfunction(value):
                    parts = reprstr.split(" ")
                    parts[1] += inspect.formatargspec(*getargspec(value))
                    reprstr = " ".join(parts)
                elif inspect.ismethod(value):
                    parts = reprstr[:-1].split(" ")
                    parts[2] += inspect.formatargspec(*getargspec(value))
                    reprstr = " ".join(parts) + ">"
            except TypeError:
                pass
            sys.stdout.write(reprstr)
            sys.stdout.write("\n")
            if getattr(value, "__doc__", None):
                sys.stdout.write("\n")
                sys.stdout.write(pydoc.getdoc(value))
                sys.stdout.write("\n")
        else:
            pphighlight(value, width=get_width() or 80)

    sys.displayhook = pprinthook


def _pythonrc_fix_linecache():
    """Add source(obj) that shows the source code for a given object."""

    # linecache.updatecache() replacement that actually works with zips.
    # See http://bugs.python.org/issue4223 for more information.
    def updatecache(filename, module_globals=None):
        """Update a cache entry and return its list of lines.

        If something's wrong, print a message, discard the cache entry,
        and return an empty list.
        """

        if filename in cache:
            del cache[filename]
        if not filename or filename[0] + filename[-1] == "<>":
            return []

        fullname = filename
        try:
            stat = os.stat(fullname)
        except OSError:
            basename = os.path.split(filename)[1]

            if module_globals and "__loader__" in module_globals:
                name = module_globals.get("__name__")
                loader = module_globals["__loader__"]
                get_source = getattr(loader, "get_source", None)

                if name and get_source:
                    try:
                        data = get_source(name)
                    except (ImportError, OSError):
                        pass
                    else:
                        if data is None:
                            return []
                        cache[filename] = (
                            len(data),
                            None,
                            [line + "\n" for line in data.splitlines()],
                            fullname,
                        )
                        return cache[filename][2]

            for dirname in sys.path:
                try:
                    fullname = os.path.join(dirname, basename)
                except (TypeError, AttributeError):
                    pass
                else:
                    try:
                        stat = os.stat(fullname)
                        break
                    except os.error:
                        pass
            else:
                return []

        try:
            lines = Path(fullname).read_text().splitlines()
        except OSError:
            return []

        size, mtime = stat.st_size, stat.st_mtime
        cache[filename] = size, mtime, lines, fullname

        return lines

    import linecache

    linecache.updatecache = updatecache


def source(obj):
    """Display the source code of an object.

    Applies syntax highlighting if Pygments is available.
    """
    from inspect import findsource, getmodule, getsource, getsourcefile
    from pydoc import pager

    try:
        # Check to see if the object is defined in a shared library, which
        # findsource() doesn't do properly (see issue4050)
        if not getsourcefile(obj):
            raise TypeError
        s = getsource(obj)

    except TypeError:
        sys.stderr.write(
            "Source code unavailable (maybe it's part of a C extension?)\n"
        )
        return

    # Detect the module's file encoding. We could use
    # tokenize.detect_encoding(), but it's only available in Python 3.
    import re

    enc = "ascii"
    for line in findsource(getmodule(obj))[0][:2]:
        m = re.search(r"coding[:=]\s*([-\w.]+)", line)
        if m:
            enc = m.group(1)
    if hasattr(s, "decode"):
        try:
            s = s.decode(enc, "replace")
        except LookupError:
            s = s.decode("ascii", "replace")

    try:
        from pygments import highlight
        from pygments.lexers import PythonLexer
        from pygments.formatters import TerminalFormatter

        s = highlight(s, PythonLexer(), TerminalFormatter())
    except (ImportError, UnicodeError):
        pass

    # Display the source code in the pager, and try to convince less not to
    # escape color control codes.
    has_lessopts = "LESS" in os.environ
    lessopts = os.environ.get("LESS", "")
    try:
        os.environ["LESS"] = lessopts + " -R"
        if hasattr(s, "decode"):
            pager(s.encode(sys.stdout.encoding, "replace"))
        else:
            pager(s)
    finally:
        if has_lessopts:
            os.environ["LESS"] = lessopts
        else:
            os.environ.pop("LESS", None)


if __name__ == "__main__":
    __doc__ = None  # type:ignore

    # Make sure modules in the current directory can't interfere
    try:
        try:
            cwd = sys.path.index("")
            sys.path.pop(cwd)
        except ValueError:
            cwd = ""

        sys.ps1 = "\001\033[1;32m\002>>> \001\033[1;37m\002"
        sys.ps2 = "\001\033[1;31m\002... \001\033[1;37m\002"

        # Run installation functions and don't taint the global namespace
        try:
            try:
                import jedi.utils  # type: ignore

                jedi.utils.setup_readline()
                del jedi
            except Exception:
                print("No jedi here. Coming to the dark side.")
                _pythonrc_enable_readline()
                del _pythonrc_enable_readline

            _pythonrc_enable_history()
            _pythonrc_enable_pprint()
            _pythonrc_fix_linecache()

            del _pythonrc_enable_history
            del _pythonrc_enable_pprint
            del _pythonrc_fix_linecache

        finally:
            if cwd:
                sys.path.insert(cwd, "")
            del cwd

    finally:
        pass
