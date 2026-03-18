#!/bin/bash

# 1. Start the raw display server in the background using the hardcoded HDMI config
sudo Xorg :0 -config /etc/X11/xorg.conf &

# Give the GPU a few seconds to successfully handshake with the physical monitor
sleep 4 

# 2. Start a highly lightweight window manager (Openbox) to manage the screen space
openbox-session &

# 3. Launch Steam directly into full-screen Big Picture mode (gamepadui)
steam -gamepadui
