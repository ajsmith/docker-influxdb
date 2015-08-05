FROM rhel7.1

# RUN yum install -y --disablerepo=* --enablerepo=rhel-7-server-rpms https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y --disablerepo=* --enablerepo=rhel-7-server-rpms procps-ng https://s3.amazonaws.com/influxdb/influxdb-0.8.8-1.x86_64.rpm

EXPOSE 8090 8099 8083 8086

RUN bash -c '/opt/influxdb/current/influxdb -config /opt/influxdb/current/config.toml &' &&\
    until curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{"name": "riemann"}'; do sleep 1; done &&\
    curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{"name": "grafana"}' &&\
    curl -X POST 'http://localhost:8086/db/riemann/users?u=root&p=root' -d '{"name": "riemann", "password": "riemann"}' &&\
    curl -X POST 'http://localhost:8086/db/grafana/users?u=root&p=root' -d '{"name": "grafana", "password": "grafana"}'

ENTRYPOINT ["/opt/influxdb/current/influxdb", "-config", "/opt/influxdb/shared/config.toml"]
