#!/bin/bash
set -ex  # Enable debug mode to show each command and its result

# Set VNC password
mkdir -p /root/.vnc/
echo "$VNCPWD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
echo "VNC password set."

# Start VNC server (running in localhost mode)
vncserver :0 -rfbport "$VNCPORT" -geometry "$VNCDISPLAY" -depth "$VNCDEPTH" -localhost \
  > /var/log/vncserver.log 2>&1
echo "VNC server started."

# Start noVNC server
if [ ! -f /etc/ssl/certs/novnc_cert.pem ] || [ ! -f /etc/ssl/private/novnc_key.pem ]; then
  openssl req -new -x509 -days 365 -nodes \
    -subj "/C=US/ST=IL/L=Springfield/O=OpenSource/CN=localhost" \
    -out /etc/ssl/certs/novnc_cert.pem -keyout /etc/ssl/private/novnc_key.pem \
    > /dev/null 2>&1
  echo "SSL certificate generated."
fi

cat /etc/ssl/certs/novnc_cert.pem /etc/ssl/private/novnc_key.pem > /etc/ssl/private/novnc_combined.pem
chmod 600 /etc/ssl/private/novnc_combined.pem

/usr/share/novnc/utils/novnc_proxy --listen "$NOVNCPORT" --vnc localhost:"$VNCPORT" \
  --cert /etc/ssl/private/novnc_combined.pem --ssl-only \
  > /var/log/novnc.log 2>&1 &
echo "noVNC proxy started."

echo "Launch your web browser and open https://localhost:9020/vnc.html"
echo "Verify the certificate fingerprint:"
openssl x509 -in /etc/ssl/certs/novnc_cert.pem -noout -fingerprint -sha256

echo "Container is running. Press Ctrl+C to exit."
exec sleep infinity
