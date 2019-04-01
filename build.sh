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
            folder=armv7
			break
			;;
		2)
            arch=arm64v8
            folder=arm64
			break
			;;
		*)
			echo '####################'
			echo '## Invalid option ##'
			echo '####################'
			exit
	esac
done

sudo docker run --rm --privileged multiarch/qemu-user-static:register
docker build -f Dockerfile.${arch} -t robertslando/pkgbinaries:${arch}-latest .

docker cp $(docker ps -a -q | head -n 1):~/fetched-v8.11.3-linux-${arch} ./${folder}/fetched-v8.11.3-linux-${arch}