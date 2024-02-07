xrandr --output eDP-1 --set "PRIME Synchronization" 1
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xset -r rate 400 25
exec awesome
