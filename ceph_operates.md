!SLIDE
## Операции над кластером

### Данилов Константин, Mirantis
### http://koder-ua.blogspot.com/
### https://github.com/koder-ua/

!SLIDE
### Изменения в кластере
* OSD постоянно обмениваются информацией с соседями и мониторами
* OSD "доносят" мониторам на подвисших соседей
* Монитора тоже постоянно присматривают друг за другом
* CLI команды, которые меняют кластер передают изменения в мониторы
* Среди мониторов есть один "главный", через который проходят все операции
* Если главный монитор "тупит", то происходят перевыборы и появляется новый главный

!SLIDE
### Мониторы
* ceph mon_status

!SLIDE
### OSD
* ceph osd stat

!SLIDE
### Изменения в OSD - удаление (падение)
* Если OSD упал, то через некоторое время это заметят и osd будет отмечен, как down
* Если OSD пропадает или появляется, то изменяется версия osd_map
* ceph -s --- osdmap eXXX:
* Кластер начинает "пиринг", что бы договориться о состоянии PG
* После того, как окончен пиринг появляется новый "acting set"
* Еще через некоторое время начинается создание новых копий объекта - backfilling

!SLIDE
### Добавление/Удаление OSD
http://ceph.com/docs/master/rados/operations/add-or-rm-osds/

!SLIDE
### Управление восстановлением
* osd recovery max active
* osd recovery threads

!SLIDE
### Изменения в OSD
* sudo initctl stop/start/status ceph-all
* noout, nodown

!SLIDE
### Изменения в OSD
* Обновление сефа
* ceph osd set noout
* sudo initctl stop ceph-all (stop ceph-osd id=XXX)
* Update packages
* sudo initctl start ceph-all (start ceph-osd id=XXX)
* ceph osd unset noout

!SLIDE
### CRUSH
* root=default row=a rack=a2 chassis=a2a host=a2a1
* ceph osd getcrushmap -o /tmp/cr
* crushtool -d /tmp/cr  -o /tmp/cr.txt

!SLIDE
### CRUSH
rule replicated_ruleset {
        ruleset 0
        type replicated
        min_size 1
        max_size 10
        step take default
        step chooseleaf firstn 0 type host
        step emit
}


!SLIDE
### Вопросы и помидоры
`