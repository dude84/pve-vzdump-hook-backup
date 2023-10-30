#!/bin/bash
usb_backupdir='/mnt/usb_ssd/pve/dump/'

print_env() {
  echo "VZDUMP $1 hookscript $0:"
  echo "  STOREID: ${STOREID}"
  echo "  DUMPDIR: ${DUMPDIR}"
  echo "  VMTYPE: ${VMTYPE}"
  echo "  HOSTNAME: ${HOSTNAME}"
  echo "  TARGET: ${TARGET}"
  echo "  LOGFILE: ${LOGFILE}"
}

prune_usb_backups() {
  echo "VZDUMP [$1] hookscript $0: Prunning USB backup store"
  /usr/sbin/pvesm prune-backups pve_usb
}

copy_file() {
  echo "VZDUMP [$1] hookscript $0: Copying $2 to $3"
  #use standard linux copy if rsync is not available
  #cp $2 $3
  rsync -ah --progress $2 $3
}

if [ "$1" == "backup-end" ]; then
  #show environment variables - usefull for debugging
  #print_env
  copy_file $1 ${TARGET} $usb_backupdir
fi

if [ "$1" == "log-end" ]; then
  copy_file $1 ${LOGFILE} $usb_backupdir
fi

if [ "$1" == "job-end" ]; then
  prune_usb_backups $1
fi

exit 0
