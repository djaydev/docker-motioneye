# Motioneye Linux app, Dockerized and on Alpine

docker run \
   --device=/dev/video0                       # (optional) if you will use a local v4l camera \
    -p 8765:8765                              # web interface of MotionEye \
    -e TZ="America/New_York"                  # your timezone \
    -v /mnt/appdata/motioneye:/etc/motioneye  # configuration files \
    -v /mnt/user/camera/:/var/lib/motioneye   # captured movies and pictures \
    -e UID=1000 \                             # User ID \
    -e GID=100 \                              # Group ID \
    djaydev/motioneye

First run will start with motioneye default settings, but if you want to start with your own motioneye.conf configuration file save it /mnt/appdata/motioneye/motioneye.conf.

If you need a specific UID and/or GID, add -e UID:1000 -e GID:100 to your docker run command

## Credits

startup script edited from <https://github.com/tyzbit/motioneye>
