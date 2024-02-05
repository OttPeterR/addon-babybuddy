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

1. have PR branch ready
2. Make sure it passes build test (GitHub action)
3. Make a new tag in GitHub, this will run an action to build then publish
4. Wait for action to complete
5. Merge PR branch into main (home assistant will pick up changes when they hit main)