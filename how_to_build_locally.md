use this command to build images locally for testing:
cd into the addon-babybuddy/babybuddy directory and run

```
docker run \
	--rm \
	--privileged \
	-v ~/.docker:/root/.docker \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v "$(pwd)":/data \
	homeassistant/amd64-builder \
		--all \
		-t /data
```

when updating versions, make sure to bump the build.yaml as well
