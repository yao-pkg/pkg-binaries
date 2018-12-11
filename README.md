Install required build tools: sudo apt-get install build-essential

Than clone node:

git clone https://github.com/nodejs/node.git

Checkout to the desired version:

cd node
git checkout v8.11.3

Create the patch file inside the node dir and paste the content from the patch file (https://raw.githubusercontent.com/zeit/pkg-fetch/master/patches/node.v8.11.3.cpp.patch)

sudo nano node.v8.11.3.cpp.patch (Ctrl+Maiusc+V - Ctrl+X - Y)
git apply node.v8.11.3.cpp.patch
./configure
make (this takes many minutes)

Finally copy the binary: cp node ~/.pkg-cache/v2.5/fetched-v8.11.3-linux-arm64
