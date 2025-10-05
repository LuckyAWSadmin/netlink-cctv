#!/bin/bash
set -eux

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Netlink CCTV</title>
  </head>
  <body>
    <h1>Netlink CCTV</h1>
    <p>Deployed via Terraform + GitHub Actions</p>
  </body>
</html>
EOF

