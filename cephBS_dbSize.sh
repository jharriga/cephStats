#!/bin/bash
# For each running OSD query the BlueStore DB size and entries and calculate avg size per entry
# NOTE: must be executed on an OSD node
#
# Original Author: Wido den Hollander <wido@widodh.nl>
#

for OSD_ID in $(find /var/run/ceph -name 'ceph-osd.*.asok' -type s -printf "%f\n"|cut -d '.' -f 2); do
    DB_USED_BYTES=$(ceph daemon osd.$OSD_ID perf dump|jq '.bluefs.db_used_bytes')
    BLUESTORE_ONODES=$(ceph daemon osd.$OSD_ID perf dump|jq '.bluestore.bluestore_onodes')
    echo "osd.$OSD_ID: db_used_bytes=$DB_USED_BYTES bluestore_onodes=$BLUESTORE_ONODES db_entry_size=$(($DB_USED_BYTES / BLUESTORE_ONODES))"
done
