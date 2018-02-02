import sys
import rados

cluster = rados.Rados(conffile='ceph.conf', conf = dict(keyring = 'ceph.client.admin.keyring'))
print "\nlibrados version: " + str(cluster.version())
print "Will attempt to connect to: " + str(cluster.conf_get('mon initial members'))

cluster.connect()
print "\nCluster ID: " + cluster.get_fsid()

print "\n\nCluster Statistics"
print "=================="
cluster_stats = cluster.get_cluster_stats()

for key, value in cluster_stats.iteritems():
    print key, value

print "\n\nPool Operations"
print "==============="

print "\nAvailable Pools"
print "----------------"
pools = cluster.list_pools()

for pool in pools:
    print pool

#print "\nCreate 'test' Pool"
#print "------------------"
#cluster.create_pool('test')

print "\nPool named 'test' exists: " + str(cluster.pool_exists('test'))
print "\nVerify 'test' Pool Exists"
print "-------------------------"
pools = cluster.list_pools()

for pool in pools:
    print pool

#print "\nDelete 'test' Pool"
#print "------------------"
#cluster.delete_pool('test')
#print "\nPool named 'test' exists: " + str(cluster.pool_exists('test'))

print "\nAvailable Pools"
print "----------------"
pools = cluster.list_pools()

for pool in pools:
    print pool
