# Check for CUDA bins and libraries.
if status is-interactive

    if test -d /usr/local/cuda
        set -gx CUDA_HOME /usr/local/cuda
        fish_add_path --append "$CUDA_HOME/bin"
    end
end
