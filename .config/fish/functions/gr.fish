# Defined in /var/folders/5j/mr0j9xws5pl4yvmm38tt8lfh0003dm/T//fish.XPE4fl/gr.fish @ line 2
function gr --wraps=git-review --description 'git review create'
    command git review create -o --no-prompt --no-amend $argv
end
