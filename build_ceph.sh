rm -rf ceph
git clone https://github.com/ceph/ceph.git
cd ceph
#git checkout tags/v13.1.1
git submodule update --init --recursive
./install-deps.sh
./run-make-check.sh -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_C_FLAGS_DEBUG="-g3 -O0 -ggdb" -DCMAKE_CXX_FLAGS_DEBUG="-g3 -O0 -ggdb" -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cd build
make -j4
rdm
MON=5 OSD=9 ../src/vstart.sh -d -n -x
./bin/ceph_test_cls_hello
./bin/ceph tell osd.0 injectargs --debug-osd 50/50
./bin/rados mkpool test_pool_crane
./bin/rados -p test_pool_crane put test_object_crane ./compile_commands.json
./bin/rados -p test_pool_crane bench 10 write
../src/stop.sh
