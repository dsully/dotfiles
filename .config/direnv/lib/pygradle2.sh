layout_pygradle2() {
  export VIRTUAL_ENV=$(basename $PWD)
  PATH_add $(expand_path "../build/$VIRTUAL_ENV/environments/development-venv/bin")
}
