if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
	[ -x "$f" ] && . "$f"
 done
 unset f
fi

xrdb -merge ~/.Xresources

# keyboard repeate rate
xset r rate 200 35

exec i3
# exec /usr/bin/i3 >~/i3log-$(date +'%F-%k-%M-%S') 2>&1
