#!/bin/sh

#draft - do not use

export LANG=en_US.UTF-8

user='User'

pacman -Sy
pacman -S postgresql postgresql-libs 

sudo -iu postgres
initdb --locale=C.UTF-8 --encoding=UTF8 -D /var/lib/postgres/data --data-checksums
createdb test
createuser -sdl $user
exit

systemctl enable postgresql


mkdir /opt/pgadmin4 /var/lib/pgadmin /var/log/pgadmin
chown -R $user /var/log/pgadmin
chown -R $user /var/lib/pgadmin

cd /opt
python3 -m venv pgadmin4
source pgadmin4/bin/activate
pip install pgadmin4 simple-websocket