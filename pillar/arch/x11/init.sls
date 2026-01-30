x11:
  pkgs:
    - xorg-server

    # xorg-apps group (cannot use pkg.installed w a Pacman group)
    # pacman -Sg xorg-apps | awk '{ print $2 }' | xargs -n1 echo "    -" >> pillar/arch/x11/init.sls
    - xorg-bdftopcf
    - xorg-iceauth
    - xorg-mkfontscale
    - xorg-sessreg
    - xorg-setxkbmap
    - xorg-smproxy
    - xorg-x11perf
    - xorg-xauth
    - xorg-xbacklight
    - xorg-xcmsdb
    - xorg-xcursorgen
    - xorg-xdpyinfo
    - xorg-xdriinfo
    - xorg-xev
    - xorg-xgamma
    - xorg-xhost
    - xorg-xinput
    - xorg-xkbcomp
    - xorg-xkbevd
    - xorg-xkbprint
    - xorg-xkbutils
    - xorg-xkill
    - xorg-xlsatoms
    - xorg-xlsclients
    - xorg-xmodmap
    - xorg-xpr
    - xorg-xprop
    - xorg-xrandr
    - xorg-xrdb
    - xorg-xrefresh
    - xorg-xset
    - xorg-xsetroot
    - xorg-xvinfo
    - xorg-xwd
    - xorg-xwininfo
    - xorg-xwud
q
