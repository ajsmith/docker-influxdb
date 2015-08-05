FROM rhel7.1

RUN yum install -y --disablerepo=* --enablerepo=rhel-7-server-rpms procps-ng http://influxdb.s3.amazonaws.com/influxdb-0.9.2-1.x86_64.rpm

COPY influxdb.conf /etc/opt/influxdb/influxdb.conf

RUN bash -c '/opt/influxdb/influxd -config /etc/opt/influxdb/influxdb.conf &' &&\
    until curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE metrics"; do sleep 1; done

EXPOSE 8083 8086

ENTRYPOINT ["/opt/influxdb/influxd", "-config", "/etc/opt/influxdb/influxdb.conf"]
