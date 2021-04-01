#!/bin/bash
set -e


ENC_PATH=/encrypted
DEC_PATH=/decrypted


function sigterm_handler {
  echo "sending SIGTERM to child pid"
  kill -SIGTERM ${pid}
  echo "Unmounting: cryfs_mount ${DEC_FOLDER} at: $(date +%Y.%m.%d-%T)"
  cryfs_unmount "${DEC_PATH}"
  echo "exiting container now"
  exit $?
}


function sighup_handler {
  echo "sending SIGHUP to child pid"
  kill -SIGHUP ${pid}
  wait ${pid}
}


trap sigterm_handler SIGINT SIGTERM
trap sighup_handler SIGHUP


[[ "${USERID:-""}" =~ ^[0-9]+$ ]] && usermod -u $USERID -o cryfsuser
[[ "${GROUPID:-""}" =~ ^[0-9]+$ ]] && groupmod -g $GROUPID -o cryfs


unset pid
if [ ! -z "$PASSWD" ]; then
	echo "${PASSWD}" | su-exec cryfsuser cryfs ${CRYFS_OPTIONS} -o ${MOUNT_OPTIONS} -f encrypted decrypted & pid=($!)
else
	su-exec cryfsuser cryfs ${CRYFS_OPTIONS} -o ${MOUNT_OPTIONS} -f encrypted decrypted & pid=($!)
fi
wait "${pid}"


echo "cryfs crashed at: $(date +%Y.%m.%d-%T)"
echo "Unmounting: cryfs_mount ${DEC_FOLDER} at: $(date +%Y.%m.%d-%T)"
cryfs_unmount "${DEC_PATH}"
echo "exiting container now"


exit $?

