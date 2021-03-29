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



architecture(){
    ##
    ##  Création de l'arborecence + assurence dossier toujours present.
    ##
    mkdir -p /home/backup_user/temp # Construction des Backup
    rm -rf /home/backup_user/temp/* # Assurance que Temp est vide

    mkdir -p /home/backup_user/backup # Repertoire contenant les backups 
    mkdir -p /home/backup_user/restore # Repertoire contenant les fichier lors d'une restoration
    mkdir -p /home/backup_user/script # Repertoire contenant les scripts
}

creation_backupfolder(){
    ##
    ##  Création du repertoire contenant la sauvegarde du jour. 
    ##          - forme backup-megaprod-20210329
    ##
    mkdir -p /home/backup_user/temp/backup-megaprod-${DATESAVE}
}

backup_DC1(){
    ##
    ##  Montage du paratage conetant la sauvegarde 
    ##  Recuperation de la sauvegarde pour traitement
    ##  Demontage / fermeture du partage du partage
    ##
    mkdir -p /media/partage
    mkdir -p /home/backup_user/backup-megaprod-${DATESAVE}/DC1
    mount -t cifs //10.152.53.2/sauvegardes /media/partage -o username=${LDAP_USER},workgroup=${LDAP_DOMAIN},password=${LDAP_PASSWORD}
    mv /media/partage/WindowsImageBackup /home/backup_user/backup-megaprod-${DATESAVE}/DC1
    umount /media/partage
}

compression_DC1(){
    cd /home/backup_user/backup-megaprod-${DATESAVE}/
    tar czf DC1.tar.gz /home/backup_user/backup-megaprod-${DATESAVE}/
    rm -rf /home/backup_user/backup-megaprod-${DATESAVE}/DC1
}


main(){
    architecture
    creation_backupfolder
    backup_DC1
    #compression_DC1
}

main