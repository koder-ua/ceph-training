.PHONY: ALL

ALL: ceph_1000ft/index.html ceph_OSD/index.html ceph_troubleshutting/index.html ceph_operates/index.html

ceph_1000ft/index.html: ceph_1000ft.md images/*
		pydown ceph_1000ft.md ceph_1000ft

ceph_OSD/index.html: ceph_OSD.md images/*
		pydown ceph_OSD.md ceph_OSD

ceph_troubleshutting/index.html: ceph_troubleshutting.md images/*
		pydown ceph_troubleshutting.md ceph_troubleshutting

ceph_operates/index.html: ceph_operates.md images/*
		pydown ceph_operates.md ceph_operates
