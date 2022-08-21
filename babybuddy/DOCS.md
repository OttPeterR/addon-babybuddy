# Home Assistant Add-on: Baby Buddy
[BabyBuddy](https://github.com/babybuddy/babybuddy), wrapped into a Home Assistant addon

## Config Options

### Option: `CSRF_TRUSTED_ORIGINS`

If you are hosting your baby buddy via another domain (such as babybuddy.mydomain.com) then add this here to be allowed to access it. If you are shown an error message while trying to log in, this is the place to set it.

### Option: `Network port`

Access baby buddy through this port. (ex: hassio.local:8889 when set to 8889)

## Ingress
Ingress does not work at the moment, however this is under development and should come to a release in the future.