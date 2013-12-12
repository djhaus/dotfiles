# MacPorts Installer addition on 2013-11-16_at_18:58:20: adding an appropriate PATH variable for use with MacPorts.

export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
