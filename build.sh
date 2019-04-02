PS3="Architecture: >"
options=(
	"armv7"
	"arm64"
)
echo ''

select option in "${options[@]}"; do
	case "$REPLY" in
		1)
            arch=arm32v6
            pkg_arch=armv7
			qemu=arm
			break
			;;
		2)
            arch=arm64v8
            pkg_arch=arm64
			qemu=aarch64
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
	"8.11.3"
	"10.4.1"
)
echo ''

select option in "${options[@]}"; do
	case "$REPLY" in
		1)
            node_version=8.11.3
			pkg_node=node8
			break
			;;
		2)
            node_version=10.4.1
			pkg_node=node10
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
			break
			;;
		2)
			pkg_os=alpine
            os_version=-alpine
			break
			;;
		*)
			echo '####################'
			echo '## Invalid option ##'
			echo '####################'
			exit
	esac
done

# sudo docker run --rm --privileged multiarch/qemu-user-static:register
cp Dockerfile.cross Dockerfile.build

sed -i "s|__ARCH__|${arch}|g" Dockerfile.build
sed -i "s|__NODE_VERSION__|${node_version}|g" Dockerfile.build
sed -i "s|__OS_VERSION__|${os_version}|g" Dockerfile.build
sed -i "s|__QEMU__|${qemu}|g" Dockerfile.build

sed -i "s|__NODE_PKG__|${pkg_node}|g" Dockerfile.build
sed -i "s|__PKG_OS__|${pkg_os}|g" Dockerfile.build
sed -i "s|__PKG_ARCH__|${pkg_arch}|g" Dockerfile.build

docker build -f Dockerfile.build -t ${arch}/pkgbinaries:${pkg_os}-${pkg_node} .
docker run -it -d ${arch}/pkgbinaries:${pkg_os}-${pkg_node} sh
docker cp $(docker ps -a -q | head -n 1):/fetched-v${node_version}-${pkg_os}-${pkg_arch} ./${pkg_arch}/fetched-v${node_version}-${pkg_os}-${pkg_arch}

rm Dockerfile.build