# Strider-CD Docker 

Possibly the best `Dockerfile` for Strider-CD

- Uses `node` base image
- Doesn't run as root.
- Thin Container. Uses linked MongoDB and SMTP services
- Installs latest Strider-CD cleanly from Git sources.

## Environment variables

These are the base Strider ones
```
SERVER_NAME - Required; Address at which server will be accessible on the Internet. E.g. https://strider.example.com (note: no trailing slash)
HOST - Host where strider listens, optional (defaults to 0.0.0.0).
PORT - Port that strider runs on, optional (defaults to 3000).
DB_URI - MongoDB DB URI if not localhost (you can safely use MongoLab free plan - works great)
HTTP_PROXY - Proxy support, optional (defaults to null)
If you want email notifications, configure an SMTP server (we recommend Mailgun for SMTP if you need a server - free account gives 200 emails / day):
SMTP_HOST - SMTP server hostname e.g. smtp.example.com
SMTP_PORT - SMTP server port e.g. 587 (default)
SMTP_USER - SMTP auth username e.g. "myuser"
SMTP_PASS - SMTP auth password e.g. "supersecret"
SMTP_FROM - Default FROM address e.g. "Strider noreply@stridercd.com" (default)
```

Our docker initial config ones. If defined they'll be used to create a admin account:
```
STRIDER_ADMIN_EMAIL
STRIDER_ADMIN_PASSWORD
```

## Status

Generally a work in progress
