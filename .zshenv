export XCURSOR_PATH=/usr/share/icons

export LESS='-iXF -R --use-color -Dd+r$Du+b'
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export MANPAGER="bat"

export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=nvidia
export XDG_SESSION_TYPE=x11
export QT_QPA_PLATFORMTHEME=gtk2
export DESKTOP_SESSION=gnome
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export SAL_USE_VCLPLUGIN=gtk3

export VAGRANT_HOME="$HOME/.local/share/vagrant"
export GOPATH="$HOME/.local/share/go"
export PATH="${PATH}:$HOME/.local/bin:$GOPATH/bin"

export EDITOR=nvim
export VISUAL=nvim
