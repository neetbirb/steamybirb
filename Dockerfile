FROM debian:bookworm-slim

# Prevent interactive popups during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Enable 32-bit architecture (Strictly required for Steam)
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wget curl ca-certificates xserver-xorg xinit openbox \
    pulseaudio sudo pciutils \
    libgl1-mesa-dri libgl1-mesa-dri:i386 \
    libgl1-mesa-glx libgl1-mesa-glx:i386 \
    libvulkan1 libvulkan1:i386 \
    libc6:i386 locales && \
    rm -rf /var/lib/apt/lists/*

# Set local language encoding
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

# Download and install Steam
RUN wget -O /tmp/steam.deb https://repo.steampowered.com/steam/archive/precise/steam_latest.deb && \
    apt-get update && apt-get install -y /tmp/steam.deb && \
    rm /tmp/steam.deb && rm -rf /var/lib/apt/lists/*

# Create a non-root user (Steam refuses to run as root)
RUN useradd -m -s /bin/bash steamuser && \
    usermod -aG video,audio,render steamuser && \
    echo "steamuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Inject our custom configurations and startup script
COPY xorg.conf /etc/X11/xorg.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Switch to the new user and set the default display environment
USER steamuser
ENV HOME=/home/steamuser
ENV DISPLAY=:0

# Fire the ignition
ENTRYPOINT ["/start.sh"]
