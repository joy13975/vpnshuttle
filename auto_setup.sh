#!/bin/bash

dry_run=${dry_run:-0}

install_stuff() {
    app=$1
    appAlias=$2
    installCmd=$3
    if [[ $# != 3 ]]; then
        echo "Function argument syntax error: $@"
        exit 1
    fi
    if [[ ! $(command -v $app) ]]; then
        echo "Installing $appAlias..."
        if [[ $dry_run != 0 ]]; then
            echo Would run: "$installCmd"
        else
            eval $installCmd
            if [[ ! $(command -v $app) ]]; then
                echo "Failed to install $appAlias - google why..."
                exit 1
            fi
        fi
    else
        echo "$appAlias already installed - good"
    fi
}

installCmd='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
install_stuff brew Homebrew "$installCmd"

installCmd='brew cask install docker'
install_stuff docker Docker "$installCmd"

installCmd='brew install pyenv; pyenv install 3.7.0'
install_stuff python3 Python3 "$installCmd"

installCmd='python3 -m pip install sshuttle'
install_stuff sshuttle sshuttle "$installCmd"

installCmd='curl -L https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb > sshpass.rb && brew install sshpass.rb && rm sshpass.rb'
install_stuff sshpass sshpass "$installCmd"
