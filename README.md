[![logo](https://raw.githubusercontent.com/edyounis/docker-cryfs/master/cryfs.png)](https://www.cryfs.org)

# CryFS

CryFS docker container

## What is CryFS?

CryFS encrypts your files, so you can safely store them anywhere. It works well together with cloud services like Dropbox, iCloud, OneDrive and others. [Check out their website.](https://www.cryfs.org)

## How to use this image

Run the container with two volumes mounted at /decrypted and /encrypted and pass
a password through the PASSWD environment variable. Make sure you
add SYS\_ADMIN capabilities and /dev/fuse device:

	sudo docker run -it -d -e PASSWD=badpass --name cryfs \
				-v /path/to/encrypted_data:/encrypted \
				-v /path/to/place/decrypted_data:/decrypted:shared \
				--device /dev/fuse:/dev/fuse \
				--cap-add SYS_ADMIN \
				edyounis/cryfs

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

## Disclaimer

The CryFS filesystem can become corrupted. Although this is rare and the
developers are constantly improving the software, back up any important 
data often. The common case is concurrent access from multiple locations.
To quote the [website](https://www.cryfs.org/tutorial):
> Warning!  Never access the file system from two devices at the same time. This can corrupt your file system. When switching devices, always make sure to stop CryFS on the first device, let Dropbox finish synchronization, and then start CryFS on the second device. There are some ideas on how future versions of CryFS could allow for concurrent access, but in the current version this is not safe.
