# Home Assistant Add-on: Baby Buddy
[BabyBuddy](https://github.com/babybuddy/babybuddy), wrapped into a Home Assistant addon

## Config Options

**Warnings** Please see warning about using both ingress and network port at the same time.

### Option: `CSRF_TRUSTED_ORIGINS`

If you are hosting your baby buddy via another domain (such as babybuddy.mydomain.com) then add this here to be allowed to access it. If you are shown an error message while trying to log in, this is the place to set it. If you want to use multiple domains, enter them with a comma and no space (eg `http://baby.example.com,https://babybuddy.mydomain.com`) 

### Option: `Network port`

Access baby buddy through this port. (ex: hassio.local:8889 when set to 8889) Be sure to check that this port is not already taken.

## Ingress

### Option: `INGRESS_USER` (default: blank)

Automatically log in as this Baby Buddy user through ingress. (eg `admin`)

**WARNING** this enables header based authentication so do not use in conjunction with publicly exposing the `network port` above. This includes using BB through a domain name like you'd set in `CSRF_TRUSTED_ORIGINS` (since that uses port as well).
