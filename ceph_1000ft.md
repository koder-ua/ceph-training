!SLIDE
## Ceph from 1000ft

### Danylov Kostiantyn, Mirantis
### http://koder-ua.blogspot.com/
### https://github.com/koder-ua/

!SLIDE
### Storage
* Free lunch is over (not really)

* Consistency
* Availability
* Partitioning tolerance

!SLIDE
### Modern storages - what will you do in case of P
* There is no P - NAS (Netapp, EMC, ...)
* A - Cassandra*, Reak*, ...
* C - Ceph, Sheepdog, ...

!SLIDE
### Ceph from 1000ft
* Object storage (Rados)
* CRUSH - controled distribution, aware of failure domains
* Pools - namespaces with storage settings
* RBD, RadosGW, CephFS

!SLIDE
### Ceph from 1000ft
* Mon + OSD + MDS + RadosGW

!SLIDE
### Mon
* Keep consistent cluster configuration
* Survive nodes failure as long as quorum online
* Pass config to OSD/CLients/etc
* Store/process no user data

Config consists of:

* CLuster settings
* Nodes tree (failure domain aware)
* CRUSH
* Pool information

!SLIDE
### Mon
* When no quorum present - cluster became fully unavailable
* Creates very moderate load
* Requires low IO/CPU/Net latency
* Up to ~7 nodes, ususally 3 or 5

!SLIDE
### Rados
* Reliable Autonomic Distributed Object Store
* librados

!SLIDE
### OSD
* Store user data; remote access to HDD
* 1 OSD per 1 HDD
* Not need any RAID
* LVM should not be used
* Responcible for data replication

!SLIDE
### MDS
* CephFS metadata storage
* Not used in production yet

!SLIDE
### RadosGW
* Swift API on top of Rados

!SLIDE
### Configuration and logs
* /etc/ceph/ceph.conf

!SLIDE
### CLI
* rados - pools/objects operations, some very basic performance tests (ones should never use thos tests)
* ceph - the rest
* rbd - rbd commands
* СMD --format json | json_pp | less
* СMD -c CONF_FILE -k KEY_FILE

!SLIDE
### Authentification + Autorization - CephX
* http://docs.ceph.com/docs/master/rados/operations/user-management/
* Each user and service has it own key with own previledges
* ceph auth list
* /etc/ceph/ceph.client.admin.keyring
* /var/lib/ceph/bootstrap-osd/

!SLIDE
### OSD tree
* ceph osd tree

!SLIDE
### How data stored
* File-like
* Everything is stored in object (except for monitor data)
* Each object has uniq name(in it's pool), data and attributes

!SLIDE
### Data storage - CRUSH
* Simple programming language to select OSD's using OSD tree

ceph osd getcrushmap -o FILE.bin
crushtool -d FILE.bin -o FILE.txt
EDIT FILE.txt
crushtool -c FILE.txt -o FILE_new.bin
ceph osd setcrushmap -i FILE_new.bin


!SLIDE
### Data storage - CRUSH

	rule RULENAME {
	    ruleset <ruleset>
	    type [ replicated | erasure ]
	    min_size <min-size>
	    max_size <max-size>
	    step take <bucket-type>
	    step [choose|chooseleaf] [firstn|indep] <N> <bucket-type>
	    step emit
	}

!SLIDE
### PG
![PG](../images/ceph-data-placement.jpg)

!SLIDE
### PG
* Optimization, which allows to process objects by groups
* Each object beelong to one PG
* All object from same PG stored on same set of OSD
* More PG leads to more even data distribution and better performance
* More PG leads to more RAM and CPU used
* More PG leads to longer peering
* 100-300 PG per OSD (with replication) 

!SLIDE
### Pools
* Object namespaces
* Like folders on FS
* Replication, storage and autentification settings
* EC
* Cache

!SLIDE
### Pools CLI
* rados lspools / ceph osd lspools
* ceph osd dump
* rados df
* ceph osd df

!SLIDE
### Пулы CLI создание
* ceph osd pool create {pool-name} {pg-num} [crush-ruleset-name]

!SLIDE
### Пулы CLI mksnap/
* ceph osd pool create {pool-name} {pg-num} [crush-ruleset-name]

ceph osd map test my-object
ceph pg 4.0 query

$ rados put -p testpool logo.png logo.png
$ ceph osd map testpool logo.png

!SLIDE
### RBD
![rbd](../images/rbd.jpg)

!SLIDE
### RBD
* Virtual disk splitted on fixed-size blocks  (powr of 2, 4M by default)
* Ech block is mapped to special object with known name 
* Object, as usually, ar ecreated on first request
* http://ceph.com/docs/master/start/quick-rbd/
* krbd in kernel may be too old


