# If running non-interactive shell, don't execute this file. Tools like
# scp will break if we echo text.

if [ -z "$PS1" ]; then
    return
else
    echo "Executing $HOME/.bashrc"
fi

# Set the Bash prompt
export PS1='\h:\W\$ '

# If it exists, source the Bash aliases file

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
