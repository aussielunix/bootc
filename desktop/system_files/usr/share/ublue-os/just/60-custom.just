# Local Just tasks belong here

# Bootstrap new workstation with yadm
bootstrap:
  #!/usr/bin/env bash
  set -e
  mkdir $HOME/bin
  curl --silent -fLo $HOME/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
  chmod a+x $HOME/bin/yadm
  $HOME/bin/yadm clone --bootstrap https://github.com/aussielunix/dotfiles.git
  echo "Running '$HOME/bin/yadm checkout $HOME'"
  $HOME/bin/yadm checkout $HOME
  echo "Logout and back in and then run 'yadm decrypt'"
