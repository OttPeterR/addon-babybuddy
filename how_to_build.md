use this command to build images locally for testing:
cd into the addon-babybuddy/babybuddy directory and run

```
docker run \
  --rm \
  --privileged \
  -v ~/.docker:/root/.docker \
  -v "$(pwd)":/data \
  homeassistant/amd64-builder \
  	--all \
  	-t /data
```

(switch --all for --amd64 or any single arch do just build one)

when updating versions, make sure to bump the build.yaml as well

Then for a new release:

- have PR branch ready
- make new release in github with new version
  - point at PR branch to build+publish
  - wait for the action to complete
- merge branch into main
  - this causes end users to see the update in HA
