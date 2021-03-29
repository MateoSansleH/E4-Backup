#!/bin/sh

#===============================#
# - Script de sauvegarde        #
#         - DC1                 #
#         - Nextcloud           #
#                               #
#                               #
# Matéo DUCHÊNE                 #
#===============================#

#Backup DC1
#l'utilisateur AD backup_user est le seul avec l'administrateur a avoir acces au partage "Sauvegarde"
LDAP_USER="backup_user"
LDAP_PASSWORD="Not24get"
LDAP_DOMAIN="megaprod.lan"


DATESAVE=$(date "+%Y%m%d")



creation_backupfolder(){
    mkdir -p /home/backup_user/backup-megaprod-${DATESAVE}
}

backup_DC1(){
    mkdir -p /media/partage
    mkdir -p /home/backup_user/backup-megaprod-${DATESAVE}/DC1
    mount -t cifs //10.152.53.2/sauvegardes /media/partage -o username=administrateur,workgroup=megaprod.lan,password=Not24get
    mv /media/partage/WindowsImageBackup /home/backup_user/backup-megaprod-${DATESAVE}/DC1
    
    umount /media/partage
}

compression_DC1(){
    cd /home/backup_user/backup-megaprod-${DATESAVE}/
    tar czf DC1.tar.gz /home/backup_user/backup-megaprod-${DATESAVE}/
    rm -rf /home/backup_user/backup-megaprod-${DATESAVE}/DC1
}


main(){
    creation_backupfolder
    backup_DC1
    compression_DC1
}

main