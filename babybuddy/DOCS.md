# Home Assistant Add-on: Baby Buddy
[BabyBuddy](https://github.com/babybuddy/babybuddy), wrapped into a Home Assistant addon

## Config Options

### Option: `CSRF_TRUSTED_ORIGINS`

If you are hosting your baby buddy via another domain (such as babybuddy.mydomain.com) then add this here to be allowed to access it. If you are shown an error message while trying to log in, this is the place to set it.

### Option: `Network port`

Access baby buddy through this port. (ex: hassio.local:8889 when set to 8889)

## Ingress

### Option: `INGRESS_USER` (default: blank)

Automatically log in as this user using HomeAssistant ingress (e.g. `admin`) if set. 

**WARNING** this enables header based authentication so do not use in conjunction with publicly exposing the network port above.
