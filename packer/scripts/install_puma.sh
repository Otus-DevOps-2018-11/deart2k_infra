#!/bin/bash

#install our application

su appuser -c "cd ~ && \
git clone -b monolith https://github.com/express42/reddit.git && \
cd reddit &&\
bundle install"

#add init systemd unit for puma

cat <<EOT > /etc/systemd/system/puma.service
[Unit]
Description=Puma Server
After=After=syslog.target network.target

[Service]
Type=forking
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOT

#add puma to autostart
systemctl enable puma
