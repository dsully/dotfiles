# Defined in /var/folders/5j/mr0j9xws5pl4yvmm38tt8lfh0003dm/T//fish.GhtYAq/gru.fish @ line 2
function gru --wraps=git-review --description 'git review update'
    command git review update --no-amend --update-desc $argv
end
