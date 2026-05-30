from .base import *
import os

# Trust the headers passed by Ingress/Nginx
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
USE_X_FORWARDED_HOST = True
USE_X_FORWARDED_PORT = True

ENABLE_HOME_ASSISTANT_SUPPORT = True
MESSAGE_STORAGE = "django.contrib.messages.storage.session.SessionStorage"

# Use non-manifest whitenoise storage to avoid ValueError on missing entries
# (CompressedManifestStaticFilesStorage requires a perfect collectstatic run
# which is brittle when plugins add static files at runtime)
STORAGES = {
    **STORAGES,
    "staticfiles": {
        "BACKEND": "whitenoise.storage.CompressedStaticFilesStorage",
    },
}

# Comma-separated origins: strip segments and drop empties. Scheme validation
# for each segment happens in etc/services.d/babybuddy/run before Gunicorn.
_csrf_env = os.getenv("CSRF_TRUSTED_ORIGINS")
if _csrf_env:
    origins = [o.strip() for o in _csrf_env.split(",") if o.strip()]
    if origins:
        CSRF_TRUSTED_ORIGINS = origins
