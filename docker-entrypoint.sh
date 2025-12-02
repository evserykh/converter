#!/bin/bash

set -e

/usr/bin/soffice --headless --nofirststartwizard --accept='socket,host=127.0.0.1,port=8080;urp' & > /dev/null 2>&1
/opt/apache-tomcat-8.0.26/bin/catalina.sh start > /dev/null 2>&1

exec gosu ruby "${@}"
