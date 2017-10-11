#!/bin/bash
BACKUPED_DATA_DIR=/root/redmine/backups
REDMINE_DATA_DIR=/root/redmine

EXPIRED_DAYS=6
DATE=`date '+%Y%m%d%H%M%S'`
BACKUP_LOGFILE=${DATE}.log
BACKUPED_MYSQL_FILE=redmine.sql-${DATE}
BACKUPED_REDMINE_FILE=redmine-files-${DATE}.tar.gz

mkdir -p ${BACKUPED_DATA_DIR}
docker run --rm -t -v ${BACKUPED_DATA_DIR}:/tmp/mysql-data -w /tmp/mysql-data \
--link mysql:redmine-db mysql:5.7 mysqldump -uroot -predmine \
-hmysql --databases redmine mysql -r ${BACKUPED_MYSQL_FILE}>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
if [ $? -ne 0 ];then
   echo [ERROR]:Redmine database mysql backup for ${DATE} was failed...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
   exit 1
fi
cd ${BACKUPED_DATA_DIR}
gzip -v ${BACKUPED_MYSQL_FILE}

tar -zcvf ${BACKUPED_DATA_DIR}/${BACKUPED_REDMINE_FILE} ${REDMINE_DATA_DIR}/files >>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
if [ $? -ne 0 ];then
   echo [ERROR]:Redmine files[attachments] backup was failed...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
   exit 1
fi

echo [INFO]:Start to delete old backups and logs before ${DATE} ...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
find $BACKUPED_DATA_DIR -name "*" -type f -mtime +$EXPIRED_DAYS -exec rm -rf {} \;>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
#find $BACKUPED_DATA_DIR -name "*" -type f -mtime 0 -exec rm -rf {} \;>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
if [ $? -ne 0 ];then
   echo [ERROR]:Redmine database mysql delete old backuped file before ${DATE} was failed...>>${BACKUPED_DATA_DIR}/${BACKUP_LOGFILE}
   exit 1
fi

