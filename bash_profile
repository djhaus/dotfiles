if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# MacPorts Installer addition on 2015-04-07_at_10:06:13: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

