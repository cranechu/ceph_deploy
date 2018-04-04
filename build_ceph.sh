rm -rf ceph
git clone https://github.com/ceph/ceph.git
cd ceph
git submodule update --init --recursive
./install-deps.sh
./run-make-check.sh -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_C_FLAGS_DEBUG="-g3 -O0 -ggdb" -DCMAKE_CXX_FLAGS_DEBUG="-g3 -O0 -ggdb" -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cd build
make -j4
rdm
MON=5 OSD=9 ../src/vstart.sh -d -n -x
./bin/ceph_test_cls_hello
../src/stop.sh
