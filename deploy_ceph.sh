#starting over
ceph-deploy purge admin mon0 osd0 osd1 osd2
ceph-deploy purgedata admin mon0 osd0 osd1 osd2
ceph-deploy forgetkeys
rm ceph.*

#create ceph cluster
ceph-deploy new mon0

#install ceph on nodes
ceph-deploy install --release luminous mon0 osd0 osd1 osd2

#initialize the cluster
ceph-deploy mon create-initial

#copy ceph conf/key to all nodes
ceph-deploy admin mon0 osd0 osd1 osd2

#add OSDs
ceph-deploy osd create osd0:sdc osd1:sdc osd2:sdc

#check status
ssh mon0 sudo ceph health
ssh osd0 sudo ceph health
ssh osd1 sudo ceph health
ssh osd2 sudo ceph health
ssh mon0 sudo ceph -s

#RGW instance
ceph-deploy rgw create mon0
