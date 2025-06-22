if status is-interactive; and command -q ghq

    __fzf_picker_args

    function __ghq_cd_repository -d "Change local repository directory"
        command ghq list --full-path | command fzf $PICKER_ARGS --preview "bat --color=always {}/README.md || echo 'No README.md'" \
            --bind "ctrl-u:preview-up,ctrl-d:preview-down" --exit-0 | read -l repo_path

        [ -n "$repo_path" ]; and cd "$repo_path"
    end

    bind \cg __ghq_cd_repository

    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \cg __ghq_cd_repository
    end
end
