!SLIDE
## Fixing ceph

### Danylov Kostiantyn, Mirantis
### http://koder-ua.blogspot.com/
### https://github.com/koder-ua/

!SLIDE
### Root causes
* Running out of free space (OSD would not start)
* Clock out of sync in cluster
* Network issues
* Disk failing
* Different disks used as a storages
* Monitor running out of free space

!SLIDE
### Ceph best practices
https://docs.google.com/document/d/1ShXkcdbU0jTrbuBcpVS8wdz_P4kT3yyhQa926U9yBL4


!SLIDE
### General fix steps
* Start all failed services
* Wait till ceph finish recovery
* Fix all the rest manually
* Update to new ceph version

!SLIDE
### Performance issues
* How performance measured
* wally, ceph reporing tool
* ALWAYS collect performance metrics during tests and on idle
* Check partition alligment on OSD

BW (also limited by network)
* BW ~= 150 MBps * HDD count / replication factor (if journal on SSD)
* BW ~= 150 MBps * HDD count / replication factor * 2


!SLIDE
### Diagnostic
* ceph -s - peering/incomplete PG, "blocked requests"
* ceph osd tree
* ceph health
* ceph df
* Node load - iostat/vmstat
* dmesg
* ps aux | grep osd
* /etc/ceph, /var/log, ... - file access right
* Логи

!SLIDE
### OSD Diagnostic
* Logs - /var/log/ceph/ceph-osd.XXX.log
* Free space - /var/lib/ceph/osd/ceph-0
* Network - OSD should listen for other nodes
* tcp - 6800-6803: telnet IP 6800
* ceph tell osd.XXX injectargs --debug-osd 0/5

!SLIDE
## OSD repaire
* Read logs, fix issue, try to start, repeat
* Broken PG might be moved away from /var/lib/ceph/osd/ceph-0 - BUT ONLY INSIDE SINGLE PARTITION
* Ceph should restore them, if other copies awailable
* No free space - temporary increase full_ration. Move some PG to other folder
* ceph_objectstore_tool --op export --pgid X.XXX .....

!SLIDE
## Mon repair
* Disk/CPU network load
* Read logs, fix issue, try to start, repeat
* No free space - 'mon compact on start = True'

!SLIDE
## PG states
* http://ceph.com/docs/master/rados/operations/pg-states/
* Down - OSD with data not running
* Peering - trying to agreed on PG state
* Peered - agreed, but something wrong, this state qould not be fixed by ceph itself
* Backfill-toofull - no space for backfill - increase osd_backfull_ration
* Incomplete - some data missed. Start all OSD, os extract data from storage
* Stale - no updates for a while

!SLIDE
## Extracting data from broken OSD
* 0.80.10+ - ceph_objectstore_tool --op export --pgid X.XXX .....
* Or tar with '--xattrs' option


* OSD T/S: OSD don't starts, OSD flapping.
* PG T/S: PG statuses, how to find/reciver PG
* MON T/S
* Upgraiding ceph
