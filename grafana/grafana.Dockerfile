FROM grafana/grafana
COPY ./grafana/etc/grafana/provisioning /etc/grafana/provisioning
COPY ./grafana//var/lib/grafana/dashboards /var/lib/grafana/dashboards


