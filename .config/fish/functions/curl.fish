# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.FYDQ8K/curl.fish @ line 2
function curl --description 'Run curl with timing information.' --wraps=curl
    command curl -s -w "@$HOME/.curl-format.txt" $argv
end
