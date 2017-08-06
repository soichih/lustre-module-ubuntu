tag=lustre-module-$(uname -r)
cp /boot/config-$(uname -r) config && \
	docker build . -t $tag && \
	docker run --name $tag $tag ls /usr/local/src/lustre-release/debs && \
	docker cp $tag:/usr/local/src/lustre-release/debs `pwd`/debs && \
	docker rm $tag
