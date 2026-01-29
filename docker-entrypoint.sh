#!/bin/bash

set -e

# Run LibreOffice in background
/usr/bin/soffice --headless --nofirststartwizard --accept='socket,host=127.0.0.1,port=8100;urp' > /dev/null 2>&1 &

# pause before initialize LibreOffice
sleep 2

# Run Tomcat with JodConverter
/opt/apache-tomcat-8.0.26/bin/catalina.sh start > /dev/null 2>&1

# Pause for initialize Tomcat
sleep 3

exec gosu ruby "${@}"
