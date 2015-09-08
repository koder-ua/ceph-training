!SLIDE
## Операции над кластером

### Данилов Константин, Mirantis
### http://koder-ua.blogspot.com/
### https://github.com/koder-ua/

!SLIDE
## Общий алгоритм
* Пытаемся поднять все, что упало
* Ждем, пока сеф сделает все, что может
* Когда сеф окончил самокопание - смотрим что с PG и чиним их руками

!SLIDE
## Диагностика общая
* ceph -s - отсутсвующие PG, "заблокированный запросы"
* ceph osd tree
* ceph health
* ceph df
* Нагрузка на ноду - iostat/vmstat
* dmesg
* ps aux | grep osd
* /etc/ceph, права доступа к файлам
* Логи

!SLIDE
## Диагностика OSD
* Логи - /var/log/ceph/ceph-osd.XXX.log
* Свободное место - /var/lib/ceph/osd/ceph-0
* Сеть - OSD должен слушать другие ноды
* tcp - 6800-6803: telnet IP 6800
* ceph tell osd.XXX injectargs --debug-osd 0/5

!SLIDE
## Чиним OSD
* Читаем логи - чиним, пробуем запустить и далее по циклу
* Битые PG можно переносить из /var/lib/ceph/osd/ceph-0 - НО ТОЛЬКО в пределах одного диска, через mv
* Ceph должен восстановить их, если копии еще есть
* Нет места - поднять full_ration. Перенести PG в другую папку, если они есть на других нодах
* ceph_objectstore_tool --op export --pgid X.XXX .....

!SLIDE
## Монитору плохо
* Нагрузка на диск/сеть
* Логи
* Читаем логи - чиним, пробуем запустить и далее по циклу

!SLIDE
## PG состояния
* http://ceph.com/docs/master/rados/operations/pg-states/
* Down - OSD с данными не запущен
* Peering - пытается договориться о состоянии
* Peered - договорился, но все плохо и не может работать с группой
* Backfill-toofull - нет места для бекфила - можно увеличить osd_backfull_ration
* Incomplete - часть данных недоступна. Запустить мертвый OSD, или извлечь данные из его диска
* Stale - долго тупит

!SLIDE
## Перенос данных с мертвого OSD
* 0.80.10+ - ceph_objectstore_tool --op export --pgid X.XXX .....
* Необходимо архивировать с аттрибутами


* OSD T/S: OSD don't starts, OSD flapping.
* PG T/S: PG statuses, how to find/reciver PG
* MON T/S
* Upgraiding ceph
