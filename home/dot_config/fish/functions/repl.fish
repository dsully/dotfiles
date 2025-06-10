function repl --wraps=ptpython
    command uv run --with icecream,ipython,ptpython ptpython $argv
end
