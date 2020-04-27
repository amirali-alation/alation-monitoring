FROM alation-analytics-docker-virtual.alationdevops.com/grafana:1.0.0
LABEL maintainer="Amirali Shahinpour <amirali.shahinpour@alation.com>"
COPY datasources /etc/grafana/provisioning/datasources
COPY dashboards/config.yaml /etc/grafana/provisioning/dashboards
COPY dashboards/dashboard.json /var/lib/grafana/dashboards/dashboard.json
