#!/bin/bash

# if we don’t have a file, start at 80
if [ ! -f “/tmp/value.dat” ] ; then
slidevalue=80

# otherwise read the value from the file
else
slidevalue=`cat /tmp/value.dat`
fi

# take the value from the slider and set it to a variable
value=$(zenity –scale –title “Set Window Opacity” –text “Set value in %. After clicking OK select the title bar of the window you wish to add transparency.” –min-value=10 –max-value=100 –step=5 –value=${slidevalue})

# use the slider variable and use it in the script to apply opacity to a window.
xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * ${value}/ 100)))

# save the slider value to a tmp file that the script can set the slider to during the next run.
echo “${value}” > /tmp/value.dat