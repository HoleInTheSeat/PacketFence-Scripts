#!/bin/sh

# run certbot (checks for existing cert and renews if needed)
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /home/packetfence/.secrets/cloudflare.ini -d <DOMAIN> --preferred-challenges dns-01 --non-interactive

# backup old cert (honestly no reason too)
cp /usr/local/pf/conf/ssl/server.pem /usr/local/pf/conf/ssl/server--OLD.pem

# copy in new cert
cat /etc/letsencrypt/live/<DOMAIN>/fullchain.pem > /usr/local/pf/conf/ssl/server.pem
cat /etc/letsencrypt/live/<DOMAIN>/privkey.pem >> /usr/local/pf/conf/ssl/server.pem

# Restart HAPROXY
/usr/local/pf/bin/pfcmd service haproxy-admin restart
/usr/local/pf/bin/pfcmd service haproxy-portal restart