export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

#necessary for Wayland (e.g. Rviz2 will not run otherwise)
export QT_QPA_PLATFORM=xcb

plugins=(git fast-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

source $HOME/workspaces/go2_ws/devel/setup.zsh

if [[ -f /etc/os-release && "$(grep '^ID=' /etc/os-release)" == "ID=ubuntu" ]]; then

    source /usr/local/texlive/2024/bin/x86_64-linux 
    unset COLCON_CURRENT_PREFIX
    unset _colcon_prefix_chain_zsh_source_script


    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/thomas/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
    if [ -f "/home/thomas/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/thomas/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/thomas/anaconda3/bin:$PATH"
    fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi

# Sources like ROS which only should be sourced when I am in my Ubuntu distro
if [[ -f /etc/os-release && "$(grep '^ID=' /etc/os-release)" == "ID=ubuntu" ]]; then
    export PATH="$PATH:/opt/nvim-linux64/bin"
    alias whichRos="echo $ROS_DISTRO"

    source /opt/ros/humble/setup.zsh
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh
    source /opt/ros/humble/share/ros2cli/environment/ros2-argcomplete.zsh
fi

alias dots="cd ~/dots"
alias eb="vim ~/.zshrc"
alias sb="source ~/.zshrc"

_colcon_prefix_chain_zsh_source_script() {
  if [ -f "$1" ]; then
    if [ -n "$COLCON_TRACE" ]; then
      echo "# . \"$1\""
    fi
    . "$1"
  else
    echo "not found: \"$1\"" 1>&2
  fi
}

eval "$(starship init zsh)"
