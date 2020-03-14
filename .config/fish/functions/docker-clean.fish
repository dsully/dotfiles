# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.Y6JNzG/docker-clean.fish @ line 1
function docker-clean --description 'Clean up stale Docker images.'
    command docker rm -v (docker ps -a -q -f status=exited)
    command docker rmi (docker images -f "dangling=true" -q)
end
