# docker-influxdb

This project provides resources for deploying InfluxDB in Docker.

## Image Platform

RHEL 7.1

## Image Dependencies

RHEL7 Subscription

## Building

Simply run:

    $ docker build -t influxdb .

## Launching InfluxDB

Simply run:

    $ docker run -d influxdb

## Networking

The InfluxDB image exposes ports 8083 and 8086.

## Security

By default, no authentication is configured on this image.

To add authentication, you'll need to do the following:

 1. Modify "influxdb.conf" to contain:

    ```
    [http]
    auth-enabled = true
    ```

 2. Modify the dockerfile to run the commands to add users. For example:

    ```
    RUN bash -c '/opt/influxdb/influxd -config /etc/opt/influxdb/influxdb.conf &' &&\
        until curl -G http://localhost:8086/query --data-urlencode "q=CREATE USER root WITH PASSWORD secret WITH ALL PRIVILEGES"; do sleep 1; done
    ```

 3. Rebuild the image.

## Entrypoints

This image defines an entrypoint which runs:

    ```
    /opt/influxdb/influxd -config /etc/opt/influxdb/influxdb.conf
    ```
