rcpath="/home/{{ .Env.USER }}/{{ .Env.XDGC }}/shell/rc" 
[ -f "$rcpath" ] && . "$rcpath"
