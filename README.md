# Pkg Binaries

Collection of NodeJS precompiled binaries to use with [pkg][207006e9]. Please submit a pull request if you have others that are not present in pkg resources.


## Compilation guide

Here is a guide to manually compile a nodejs binary from source.
Usually pkg automatically compiles this binary if it doesn't find them in his resources but this process may fail and this is how to do it by your self. In this example I'm compiling nodejs 8 LTS using a device with Linux with architecture arm64 (to check the information about your device run the comand `uname -a`).

1. Install required build tools:

`sudo apt-get install build-essential`

2. Than clone node:

`git clone https://github.com/nodejs/node.git`

3. Checkout to the desired version:

`cd node`
`git checkout v8.11.3`

4. Create the patch file inside the node dir and paste the content from the patch file you find on pkg-fetch github inside [patch][a9bdf3ee] directory (https://raw.githubusercontent.com/zeit/pkg-fetch/master/patches/node.v8.11.3.cpp.patch)


`sudo nano node.v8.11.3.cpp.patch` (Ctrl+Maiusc+V - Ctrl+X - Y)

`git apply node.v8.11.3.cpp.patch`

`./configure`

`make` (this takes many minutes, even hours in some devices)

5. Finally copy the binary:
`cp node ~/.pkg-cache/v2.5/fetched-v8.11.3-linux-arm64`



[207006e9]: https://github.com/zeit/pkg "Zeit Pkg"

[a9bdf3ee]: https://github.com/zeit/pkg-fetch/tree/master/patches "Patch"
