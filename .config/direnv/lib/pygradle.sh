layout_pygradle() {
  export VIRTUAL_ENV=$(basename $PWD)
  PATH_add $(expand_path "../build/$VIRTUAL_ENV/venv/bin")
}
