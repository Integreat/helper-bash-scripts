#!/bin/bash
TARGET=""
BACKUPDIR="/var/backup/matomo"
CURRENT_DATE=$(date +%Y%m%d-%H%M)
OLD_UMASK=$(umask)
umask 177
mkdir -p $BACKUPDIR
openssl rand -base64 32 > ~/key.bin
mysqldump matomo | gzip -9 | openssl enc -aes-256-cbc -salt -out $BACKUPDIR/database-$CURRENT_DATE.sql.gz.enc -pass file:$HOME/key.bin
openssl rsautl -encrypt -inkey ~/backup_pubkey.pem -pubin -in ~/key.bin -out $BACKUPDIR/key-$CURRENT_DATE.bin.enc
rm ~/key.bin
if [ -n "$TARGET" ]; then
  scp $BACKUPDIR/key-$CURRENT_DATE.bin.enc $TARGET
  scp $BACKUPDIR/database-$CURRENT_DATE.sql.gz.enc $TARGET
fi
find $BACKUPDIR/ -mtime +7 -type f -delete
umask $OLD_UMASK
