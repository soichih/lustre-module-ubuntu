# lustre-module-ubuntu
Dockerfile to build lustre kernel module for Ubuntu 16. 

To build, do following.

1. Copy your build config of your current kernel to where you have the Dockerfile checked out.


```
cp /boot/config-$(uname -r) config
```

2. Build the container

```
docker build . -t lustre-module
```

3. Extract the deb packages

```
docker run --name lustre-module lustre-module 
docker cp lustre-module `pwd`/debs
docker rm lustre-module
```

4. Install the deb packages

```
dpkg -i debs/lustre-client-modules-4.4.0-87-generic_2.10.0-5-gbb3c407-1_amd64.deb
dpkg -i debs/lustre-utils_2.10.0-5-gbb3c407-1_amd64.deb
modprobe lustre
lctl list_nids
```

# Credit

Thanks to Nathan Lavender <nblavend@iu.edu> who created the original build script.
