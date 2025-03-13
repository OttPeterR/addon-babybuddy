# Baby Buddy - Home Assistant Addon

Run Baby Buddy on Home Assistant!

## Other Important Repos

- [Baby Buddy Integration](https://github.com/jcgoette/baby_buddy_homeassistant)
  - get BB data as sensors and entities in HA so you can automate! You can install this from HACS.
- [Baby Buddy Source Code](https://github.com/babybuddy/babybuddy)
  - application code is located in that repo, the repo you are currently viewing simply takes that code and wraps it up into a Home Assistant addon

## Contributing

PRs welcome!

If you'd like to make a modification to Baby Buddy, fork this repo and add your changes! There's a github action that builds the container so you can check that your code works. See [here](https://developers.home-assistant.io/docs/add-ons/) for more info about developing Home Assistant Add-Ons

# Accessing Baby Buddy

Access BB though ingress in HA as you normally would. If you would like to skip the login process, there is a way to auto-login, but please be aware of the security implications. [See more in the docs](https://github.com/OttPeterR/addon-babybuddy/blob/main/babybuddy/DOCS.md)

Alternatively, you can configure the Home Assistant Nginx Proxy Manager using the instructions below to access Baby Buddy via your custom domain (e.g., `babybuddy.example.duckdns.org`).

You can also expose the port to the Baby Buddy Django instance on your host machine to access Baby Buddy through `http://your-home-assistant.local:PORT`. However, this approach will not serve user uploaded content (e.g., child images stored in the `/media/` directory).

If you come across a `CSRF_TRUSTED_ORIGINS` error, you can add that domain in the addon's `Configuration` page. Multiple domains can be added with a comma and no space to separate them.

## Home Assistant Integration

This addon only runs Baby Buddy, if you would like to see some of the data as sensors in Home Asssitant to crete automations, you also need [the integration](https://github.com/jcgoette/baby_buddy_homeassistant) that pulls data from the addon.

## Installation (basic)

Add this addon-repo to your home assistant by going to to **Settings** -> **Add-ons** -> **Add-on Store** and add this URL as an additional repository:

```txt
https://github.com/OttPeterR/addon-babybuddy
```

### Additional setup for HTTPS via NGINX (using your own domain)

The standard way of accessing Baby Buddy is through Home Assistant Ingress, so under normal use these instructions won't be needed.

Follow these additional instructions if your Home Assistant instance is set up so that it can only be accessed via HTTPS (e.g., using the [DuckDNS add-on](https://github.com/home-assistant/addons/tree/master/duckdns). For example, you access your Home Assistant instance at `https://example.duckdns.org:8123`.

1. Install the [Nginx Proxy Manager](https://github.com/hassio-addons/addon-nginx-proxy-manager) available from the Home Assistant Add-on Store. Closely follow the [installation instructions](https://github.com/hassio-addons/addon-nginx-proxy-manager/blob/main/proxy-manager/DOCS.md). We will use this add-on the set up a reverse proxy so that you can access BabyBuddy via HTTPS externally.

2. From a machine on the same local network as your Home Assistant instance, identify the local IP address of the Home Assistant machine (e.g., `192.168.1.100`). Then, direct your browser to `http://192.168.1.100:81` to access the Nginx Proxy Manager admin page. *(Note, even though Home Assistant is set up to only be accessed on your domain via HTTPS, you can access Nginx Proxy Manager locally because it is an add-on running in a separate Docker container. The Nginx Proxy Manager admin page will only ever be accessible via your local network for security reasons, assuming your router does not forward port `81` to your Home Assistant machine)*

3. Forward port `80` and `443` on your router to your Home Assistant machine. These ports will be sent to the Nginx Proxy Manager add-on, and not directly to Home Assistant Core. This will allow you to access Baby Buddy via HTTPS on your domain.

4. On the Nginx Proxy Manager admin dashboard, navigate to **Hosts** -> **Proxy Hosts** -> **Add Proxy Host**. Enter the domain you want to use to access Baby Budy (e.g., `babybuddy.example.duckdns.org`). Use `http` as the scheme (i.e., how Baby Buddy is accessed locally). Enter the hostname of the Baby Buddy addon container on the Home Assistant internal network. This hostname is most liekly `68152197-baby-buddy` unless you installed the Baby Buddy addon in a non-standard way (e.g., if you copied the source to your local addons directory, the hostname would instead be `local-baby-buddy`). Enter `1337` as the forward port (This is the port that Baby Buddy would expect Ingress to use, but we'll use it with this approach too.) Under the **SSL** tab, select **_Request a new SSL certificate_** and check **_Force SSL_** and agree.

5. In the Baby Budy add-on configuration, under `CSRF_TRUSTED_ORIGINS` enter your domain for Baby Buddy (e.g., `https://babybuddy.example.duckdns.org`). If you want to use multiple domains, enter them with a comma and no space (eg `http://baby.example.com,https://babybuddy.mydomain.com`) You do NOT need to expose a port for the web interface.

You should now be able to acess Baby Buddy via your domain (e.g., [https://babybuddy.example.duckdns.org]). You may want to use a Markdown card or a Button set up to your domain.
