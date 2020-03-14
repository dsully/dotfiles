set -gx SSH_ENV $HOME/.ssh/environment

function start_agent
  echo "Initializing new SSH agent ..."
  ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
  echo "succeeded"
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
  ssh-add
end

function bootstrap_ssh_agent

  if [ -n "$SSH_AUTH_SOCK" ]
    return
  end

  if [ ! -n "$TMPDIR" ]
    set -l TMPDIR /tmp
  end

  set -l TEST_SOCKET (find $TMPDIR -name agent.\* -uid (id -u) ^ /dev/null|head -n 1)
  # set -l TEST_PID (echo $TEST_SOCKET | sed -e 's!^.*/agent.\(\d*\)!\1!')

  # Check if the socket exists and we can talk to it.
  if [ -n "$TEST_SOCKET" ]

    begin
      set -lx SSH_AUTH_SOCK $TEST_SOCKET
      ssh-add -l ^ /dev/null > /dev/null
    end

    # If so, set the global variable and add the key to the ssh-agent.
    # In the case where the socket path is bogus, try to remove it.
    if [ $status -eq 0 ]
      set -gx SSH_AUTH_SOCK $TEST_SOCKET

      # Add to the keychain as well.
      if [ "$OS" = "Darwin" ]
        ssh-add -K
      else
        ssh-add
      end

    else
      rm -f $TEST_SOCKET
      set -e $TEST_SOCKET
    end
  else

    # The socket wasn't valid. Start a new agent.
    start_agent
  end
end
