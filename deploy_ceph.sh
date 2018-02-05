#starting over
ceph-deploy purge admin mon0 osd0 osd1 osd2 osd3
ceph-deploy purgedata admin mon0 osd0 osd1 osd2 osd3
ceph-deploy forgetkeys
rm ceph.*

#create ceph cluster
ceph-deploy new mon0

#install ceph on nodes
ceph-deploy install --release luminous admin mon0 osd0 osd1 osd2 osd3

#initialize the cluster
ceph-deploy mon create-initial

#copy ceph conf/key to all nodes
ceph-deploy admin mon0 osd0 osd1 osd2 osd3

#add OSDs
ceph-deploy --overwrite-conf osd prepare osd0:/dev/sdb osd1:/dev/sdb osd2:/dev/sdb osd3:/dev/sdb
ceph-deploy --overwrite-conf osd activate osd0:/dev/sdb osd1:/dev/sdb osd2:/dev/sdb osd3:/dev/sdb
ceph-deploy --overwrite-conf config push mon0 osd0 osd1 osd2 osd3

#check status
ssh mon0 sudo ceph health
ssh osd0 sudo ceph health
ssh osd1 sudo ceph health
ssh osd2 sudo ceph health
ssh osd3 sudo ceph health
ssh mon0 sudo ceph osd tree
ssh mon0 sudo ceph -s

#mgr
ceph-deploy mgr create mon0:foo
ssh mon0 sudo ceph mgr module enable dashboard #mon0:7000

#RGW instance
ceph-deploy rgw create mon0
