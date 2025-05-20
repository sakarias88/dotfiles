# Make delete button not output `~` in terminal.
bindkey "^[[3~" delete-char

function kill_work_env() {
    sessionName="work_env"
    tmux kill-session -t "$sessionName"
}

# TODO: Add support for reading work envs from file.
function work_env() {
    echo "Setting up tmux work environment."
    if [ -z "$TMUX" ]; then
        sessionName="work_env"

        # Try to attach to an already existing work session
        tmux a -t "$sessionName" 2>&1 >/dev/null

        # Create a new one in case that fails
        if [ $? -ne 0 ]; then
            echo "Creating new session..."
            cd ~/code
            paneSize=10

            # Defining window titles here since it fucks up my text editor.
            # An emoji is not always the same size...
            pipelineTitle="pipeline"
            firmTitle="firm"
            nedrylandTitle="nedryland"
            nedryglotTitle="nedryglot"
            racerTracerTitle="racer-tracer"
            # Tmux does not like ~ in paths.
            # It can use relative paths or full paths.
            workingDirectory=$(realpath ~/code)
            pipelinePath=$(realpath ~/code/pipeline)
            firmPath=$(realpath ~/code/firm)
            nedrylandPath=$(realpath ~/code/nedryland)
            nedryglotPath=$(realpath ~/code/nedryglot)
            racerTracerPath=$(realpath ~/code/racer-tracer)

            tmux new-session -s "$sessionName" -c $workingDirectory "cd $pipelinePath; emacs -nw" \; rename-window -t 0 "$pipelineTitle" \; split-window -c $pipelinePath -v \; resize-pane -t 1 -y $paneSize \; \
                 new-window -c $firmPath "emacs -nw" \; rename-window -t 1 "$firmTitle" \; split-window -c  $firmPath -v \; resize-pane -t 1 -y $paneSize \; \
                 new-window -c $nedrylandPath "emacs -nw" \; rename-window -t 2 "$nedrylandTitle" \; split-window -c $nedrylandPath -v \; resize-pane -t 1 -y $paneSize \; \
                 new-window -c $nedryglotPath "emacs -nw" \; rename-window -t 3 "$nedryglotTitle" \; split-window -c $nedryglotPath -v \; resize-pane -t 1 -y $paneSize \; \
                 new-window -c $racerTracerPath "emacs -nw" \; rename-window -t 4 "$racerTracerTitle" \; split-window -c $racerTracerPath -v \; resize-pane -t 1 -y $paneSize \;
        fi
    else
        echo "You are already in a tmux session!"
    fi
}

# allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# mark completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
typeset -g -A key
bindkey "''${terminfo[khome]}" beginning-of-line
bindkey "''${terminfo[kend]}" end-of-line
bindkey "''${terminfo[kdch1]}" delete-char

# arrow to search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
