#!/bin/bash
set -e

# One line usage: ./build.sh <arch> <nodeVersion> <os>
# arch: arm32v6 | arm32v7 | arm64
# node: node<version>
# os: linux | alpine
# 
if [ ! -z "$1" ]; then

	if [ "$1" == "arm32v7" ]; then
		arch=arm32v7
		pkg_arch=armv6 # cannot build for armv7
		platform="linux/arm/v7"
	elif [ "$1" == "arm32v6" ]; then
		arch=arm32v6
		pkg_arch=armv6
		platform="linux/arm/v6"
	elif [ "$1" == "arm64" ]; then
		arch=arm64v8
		pkg_arch=arm64
		platform="linux/arm/v8"
	else
		echo '####################'
		echo '## Invalid arch   ##'
		echo '####################'
		exit
	fi

	pkg_node=$2

	if [ "$3" == "linux" ]; then
		pkg_os=linux
		tag="node:latest"
		dependencies="apt-get update \&\& apt-get install -y --no-install-recommends wget build-essential git"
	elif [ "$3" == "alpine" ]; then
		pkg_os=alpine
		tag="node:alpine"
		dependencies="apk update \&\& apk --no-cache add git wget build-base python paxctl linux-headers"
	else
		echo '####################'
		echo '## Invalid OS     ##'
		echo '####################'
		exit
	fi	  
else

	PS3="Architecture: >"
	options=(
		"arm32v6"
		"arm32v7"
		"arm64"
	)
	echo ''
	select option in "${options[@]}"; do
		case "$REPLY" in
			1)
				arch=arm32v6
				pkg_arch=armv6
				platform="linux/arm/v6"
				break
				;;
			2)
				arch=arm32v7
				pkg_arch=armv6
				platform="linux/arm/v7"
				break
				;;
			3)
				arch=arm64v8
				pkg_arch=arm64
				platform="linux/arm/v8"
				break
				;;
			*)
				echo '####################'
				echo '## Invalid option ##'
				echo '####################'
				exit
		esac
	done

	PS3="NodeJS version: >"
	options=(
		"Node 8 LTS (Carbon)"
		"Node 10 LTS (Dubnium) "
		"Node 12 LTS (Current)"
	)
	echo ''

	select option in "${options[@]}"; do
		case "$REPLY" in
			1)
				pkg_node=node8
				break
				;;
			2)
				pkg_node=node10
				break
				;;
			3)
				pkg_node=node12
				break
				;;
			*)
				echo '####################'
				echo '## Invalid option ##'
				echo '####################'
				exit
		esac
	done

	PS3="OS version: >"
	options=(
		"linux"
		"alpine"
	)
	echo ''

	select option in "${options[@]}"; do
		case "$REPLY" in
			1)
				pkg_os=linux
				tag="node:latest"
				dependencies="apt-get update \&\& apt-get install -y --no-install-recommends wget build-essential git"
				break
				;;
			2)
				pkg_os=alpine
				tag="node:alpine"
				dependencies="apk update \&\& apk --no-cache add git wget build-base python paxctl linux-headers"
				break
				;;
			*)
				echo '####################'
				echo '## Invalid option ##'
				echo '####################'
				exit
		esac
	done
fi

cp Dockerfile.cross Dockerfile.build

sed -i "s|__TAG__|${tag}|g" Dockerfile.build

sed -i "s|__DEPENDENCIES__|${dependencies}|g" Dockerfile.build

docker buildx build -f Dockerfile.build \
	--platform $platform \
	--build-arg PKG_NODE="$pkg_node" \
	--build-arg PKG_OS="$pkg_os" \
	--build-arg PKG_ARCH="$pkg_arch" \
	--load \
	-t ${arch}/pkgbinaries:${pkg_os}-${pkg_node} .

APP=$(docker run --rm -it -d ${arch}/pkgbinaries:${pkg_os}-${pkg_node})
mkdir -p tmp
docker cp $APP:/fetched/ ./tmp/
docker kill $APP
mv tmp/fetched/v*/built* ./
rename 's/built/fetched/g' *
rm -rf tmp Dockerfile.build