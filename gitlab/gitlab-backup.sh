#!/bin/bash
BACKUPED_DATA_DIR=/root/gitlab/data/backups
EXPIRED_DAYS=6
DATE=`date '+%Y%m%d'`
BACKUP_LOGFILE=${DATE}.log

echo [INFO]:Start to delete old backups and logs before ${DATE} ...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
find $BACKUPED_DATA_DIR -name "*" -type f -mtime +$EXPIRED_DAYS -exec rm -rf {} \;>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
#find $BACKUPED_DATA_DIR -name "*" -type f -mtime 0 -exec rm -rf {} \;>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
if [ $? -ne 0 ];then
   echo [ERROR]:Gitlab delete old backuped file before ${DATE} was failed...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
   exit 1
fi

echo [INFO]:Start to backup gitlab for ${DATE} ...>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
sudo docker-compose -f /root/git/tools/gitlab/docker-compose.yml exec gitlab gitlab-rake gitlab:backup:create
if [ $? -ne 0 ];then
   echo [ERROR]:Gitlab backup for ${DATE} was failed...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
   exit 1
fi

