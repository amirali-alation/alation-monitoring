#!/bin/bash 


LOG_FILE="/var/log/alation-monitoring-installer.log"
START_TIME=`date`

echo "${START_TIME}: INFO: Starting init process" >> $LOG_FILE


out=$(/usr/bin/yum -y update)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to run update" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success update" >> $LOG_FILE
fi

out=$(/usr/bin/yum -y install fontconfig freetype* urw-fonts)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install dependencies" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success installing dependencies " >> $LOG_FILE
fi


out=$(wget -O /tmp/influxdb-1.7.7.x86_64.rpm https://dl.influxdata.com/influxdb/releases/influxdb-1.7.7.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to download influx RPM" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success to download influx RPM" >> $LOG_FILE
fi

out=$(rpm -ivh /tmp/influxdb-1.7.7.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install influx" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success installing influx" >> $LOG_FILE
fi


out=$(wget -O /tmp/telegraf-1.11.3-1.x86_64.rpm https://dl.influxdata.com/telegraf/releases/telegraf-1.11.3-1.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to download Telegraf" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success download Telagraf" >> $LOG_FILE
fi



out=$(rpm -ivh /tmp/telegraf-1.11.3-1.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install Telegraf" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success to install Telegraf" >> $LOG_FILE
fi

out=$(wget -O /tmp/grafana-6.2.5-1.x86_64.rpm https://dl.grafana.com/oss/release/grafana-6.2.5-1.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to download grafana" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success download grafana" >> $LOG_FILE
fi


out=$(rpm -ivh /tmp/grafana-6.2.5-1.x86_64.rpm)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install grafana" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success install grafana" >> $LOG_FILE
fi


out=$(systemctl enable telegraf)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable telegraf" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success enabling telegraf" >> $LOG_FILE
fi

out=$(systemctl enable grafana-server)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable grafana" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success enabling grafana" >> $LOG_FILE
fi


out=$(systemctl enable influxdb)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable influxdb" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success enabling influxdb" >> $LOG_FILE
fi


out=$(systemctl daemon-reload)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to reload daemon" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success reloading daemon" >> $LOG_FILE
fi

out=$(systemctl start influxdb influxd telegraf grafana-server)
ret=$?
if [[ ${ret} != 0  ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to start all services" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success starting all services" >> $LOG_FILE
fi
