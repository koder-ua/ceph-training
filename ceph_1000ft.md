!SLIDE
## Ceph с высоты птичьего полета

### Данилов Константин, Mirantis
### http://koder-ua.blogspot.com/
### https://github.com/koder-ua/

!SLIDE
### Эволюция систем хранения - 90+х
* Большой Дорогой Яшик С RAID


!SLIDE
### Эволюция систем хранения - 2000+
* Множество дешевых серверов
* CAP
* ACID vs. BASE
* Mongo - прямоугольная архитуктура
* reak, cassandra - "кольцевая" архитектура
* Sheepdog

!SLIDE
### Ceph from 1000ft
* Ceph
* Согласованность + надежность
* CRUSH 

!SLIDE
### Ceph from 1000ft
* Mon + OSD + MDS + RadosGW

!SLIDE
### Mon
* Хранят согласованную конфигурацию кластера
* Передают ее клиентам и OSD нодам

Конфигурация включает:

* Часть настроек
* Дерево нод
* Правила CRUSH
* Информацию о пулах

!SLIDE
### Rados
* Reliable Autonomic Distributed Object Store
* librados

!SLIDE
### Mon
* Нечетное число
* 2N + 1 мониторов спокойно переносят потерю N машин
* При отсутвии кворума мониторов кластер становится полностью неработоспособным
* Генерирую небольшую нагрузку
* Требуют низкую латентность дисковой системы
* И стабильное сетевое соединение
* до ~7 штук

!SLIDE
### OSD
* Хранит данные, фактически предоставляя сетевой диступ к диску
* По одному OSD на один диск (Можно несколько на один SSD)
* Заменяют RAID
* LVM только мешает
* Отвечает за передачу данных от и к клиенту и репликацию

!SLIDE
### MDS
* Хранит метаданные CephFS
* Промышленно не используется

!SLIDE
### RadosGW
* Гейтвей, иммитирующий Swift API поверх Rados
* Промышленно не используется

!SLIDE
### Авторизация
* http://docs.ceph.com/docs/master/rados/operations/user-management/
* У всех свои ключи
* ceph auth list
* /etc/ceph/ceph.client.admin.keyring
* /var/lib/ceph/bootstrap-osd/


!SLIDE
### Конфигурация и логи
* /etc/ceph/ceph.conf


!SLIDE
### CLI
* rados - операции с пулами/объектами, тесты скорости
* ceph - остальное
* СMD --format json | json_pp | less
* СMD -c CONF_FILE -k KEY_FILE

!SLIDE
### OSD tree
* ceph osd tree

!SLIDE
### Хранение данных - объекты
* Все хранится в объектах (кроме данных монитора)
* Объект - именованный кусок данных переменного размера с аттрибутами
* Подобие файлов

!SLIDE
### Хранение данных - PG
* Оптимизация для ускорения работы с CRUSH
* Объекты группируются в PG
* Все объекты из PG располагаются на одном наборе OSD нод
* Чем больше PG, тем равномернее распределение
* Чем больше PG, тем больше RAM & CPU используется
* Чем больше PG, тем дольше согласование состояние
* PG не влияет на скорость
* Нормальным считается 100-300 PG на OSD - не забываем про репликацию и это в сумме по всем пулам

!SLIDE
### Пулы
* Именованные группы объектов и пространсва имен
* Подобны папкам
* Пул имеет свой размер, правила репликации, др

!SLIDE
### Пулы
* EC
* Cache

!SLIDE
### Пулы CLI список
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
* Диск бьется на блоки (по умолчанию 4M)
* Каждому блоку ставиться в соответствие объект
* Объекты создаются отложенно, при первом обращении
* http://ceph.com/docs/master/start/quick-rbd/
* krbd в ядре бывает старым и может не смочь смотнтировать устройство

!SLIDE
### Вопросы и помидоры

