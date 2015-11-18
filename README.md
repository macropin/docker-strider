# Strider-CD Docker 

[![Docker Repository on Quay.io](https://quay.io/repository/macropin/strider/status "Docker Repository on Quay.io")](https://quay.io/repository/macropin/strider)
[![](https://badge.imagelayers.io/macropin/strider:latest.svg)](https://imagelayers.io/?images=macropin/strider:latest)

Possibly the best `Dockerfile` for [Strider-CD](https://github.com/Strider-CD/strider).

## Features

- Uses [node](https://registry.hub.docker.com/_/node/) base image
- Doesn't run as root
- Thin Container. Uses linked [MongoDB](https://registry.hub.docker.com/_/mongo/) and [SMTP](https://registry.hub.docker.com/u/panubo/postfix/) containers for those services
- Installs latest Strider-CD cleanly from Git source
- Supports installing and upgrading plugins from the web UI.

## Usage

The most straight forward usage if via Docker links: 

```
docker run -d --name mongo mongodb
docker run -d --name smtp panubo/postfix
docker run -d --link mongo --link smtp macropin/strider
```

## Environment variables

These are the base Strider variables. Docker links can be use in place of configuring the SMTP and MongoDB services:

- `SERVER_NAME` - Required; Address at which server will be accessible on the Internet. E.g. https://strider.example.com (note: no trailing slash)
- `HOST` - Host where strider listens, optional (defaults to 0.0.0.0).
- `PORT` - Port that strider runs on, optional (defaults to 3000).
- `DB_URI` - MongoDB DB URI (or use `--link MONGO`), alternatively define both `MONGO_HOST` and `MONGO_PORT`
- `HTTP_PROXY` - Proxy support, optional (defaults to null)
If you want email notifications, configure an SMTP server (we recommend Mailgun for SMTP if you need a server - free account gives 200 emails / day):
- `SMTP_HOST` - SMTP server hostname e.g. smtp.example.com
- `SMTP_PORT` - SMTP server port e.g. 587 (default)
- `SMTP_USER` - SMTP auth username e.g. "myuser"
- `SMTP_PASS` - SMTP auth password e.g. "supersecret"
- `SMTP_FROM` - Default FROM address e.g. "Strider noreply@stridercd.com" (default)

Initial config variables. If these are defined then they will be used to create an admin account:

- `STRIDER_ADMIN_EMAIL`
- `STRIDER_ADMIN_PASSWORD`

## Status

Stable.
