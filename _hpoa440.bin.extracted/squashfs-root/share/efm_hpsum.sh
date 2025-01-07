#!/bin/bash
MNTPT=/mnt/bootdevice
HDU_BOOTENV_SMPJTB="yes"
export HDU_BOOTENV_SMPJTB
SWPKG=hp/swpackages
MNTPTSWPKG=${MNTPT}/${SWPKG}
TMPSWPKG=/tmp/${SWPKG}
HPSUM_LOG_DIR=/var/hp/log
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< $(date)"
chmod +x /tmp/efm_heartbeat.sh
/tmp/efm_heartbeat.sh hpsum &
HEARTBEAT_PID=$!
if [ "${FORCE_DOWNGRADE}" = "YES" ]; then
FORCEOPT=" -force:rom -downgrade"
fi
cd $MNTPTSWPKG
echo "== Executing HP SUM - $(date)"
if [ "$1" = "" -o "$1" = "discovery" ]; then
./hpsum -firmware_report -logdir /var
else
./hpsum -silent -skip_ilo${FORCEOPT} -logdir /var
fi
HPSUM_RET_CODE=$?
kill $HEARTBEAT_PID >/dev/null 2>&1
echo "== Displaying HP SUM logs - $(date)"
cat ${HPSUM_LOG_DIR}/localhost/hpsum*.txt
cat ${HPSUM_LOG_DIR}/hpsum_execution_log_*.log
if [ "$EFM_DEBUG" = "YES" ]; then
cat /var/cpq/flash.debug.log
fi
echo "== HP SUM completed ($HPSUM_RET_CODE) - $(date)"
