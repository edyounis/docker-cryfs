[![logo](https://raw.githubusercontent.com/edyounis/docker-cryfs/master/cryfs.png)](https://www.cryfs.org)

# CryFS

CryFS docker container

## What is CryFS?

CryFS encrypts your files, so you can safely store them anywhere. It works well together with cloud services like Dropbox, iCloud, OneDrive and others. [Check out their website.](https://www.cryfs.org)

## How to use this image

Run the container with two volumes mounted at /decrypted and /encrypted and pass
a password through the PASSWD environment variable. Make sure you
add SYS\_ADMIN capabilities and /dev/fuse device:

	sudo docker run -it -e PASSWD=badpass --name cryfs \
				-v /path/to/encrypted_data:/encrypted \
				-v /path/to/place/decrypted_data:/decrypted:shared \
				--device /dev/fuse:/dev/fuse \
				--cap-add SYS_ADMIN

or with docker-compose:

```yml
version: '3'

services:
  cryfs:
    image: edyounis/cryfs
    container_name: cryfs
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
    devices:
      - '/dev/fuse:/dev/fuse'
    environment:
      - PASSWD: 'badpass'
    volumes:
      - '/path/to/encrypted_data:/encrypted'
      - '/path/to/place/decrypted_data:/decrypted:shared'
```

### Environment Variables

* `PASSWD` - Set the password for encrypted filesystem
* `USERID` - Set the UID for the user running cryfs, default: 1000
* `GROUPID` - Set the GID for the user running cryfs, default: 1000
* `TZ` - Set the timezone
* `CRYFS_OPTIONS` - Set cryfs run options, defaults: "--create-missing-{basedir,mountpoint}"
* `MOUNT_OPTIONS` - Set fuse mount options, defaults: "allow\_other,noatime,nodiratime"

## Issues

If you encounter any issues or have any questions with this image, please
open a [GitHub issue](https://github.com/edyounis/docker-cryfs/issues).

