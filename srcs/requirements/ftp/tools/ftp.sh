#!/bin/bash

# attendre que WordPress demarre et se mette dans le volume

while [ ! -f /var/www/html/wp-config.php ]; do
	echo "En attente des fichiers de WordPress..."
	sleep 2
done

# permet de creer l user ftp
if ! id -u ftpuser &>/dev/null; then
	useradd -m -d /var/www/html ftpuser
	echo "ftpuser:${FTP_PASSWORD}" | chpasswd
fi

# permet d avoir acces au volume WordPress

chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

# creer le dossier empty requis par vsftpd
mkdir -p /var/run/vsftpd/empty

# configuer vsftpd
cat > /etc/vsftpd.conf << EOF
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=21000
pasv_max_port=21010
local_root=/var/www/html
seccomp_sandbox=NO
EOF

exec vsftpd /etc/vsftpd.conf
