# HomeKit Temperature Sensor
Get and store HomeKit Data (e.g. Aqara Temperature and Humidity Sensor WSDCGQ11LM) in SQL Database and visualize on Grafana

What need:
- Aqara Sensors
- Apple HomeKit supported Device (AppleTV/HomePod/iPad(maybe))
- Homebridge (Homebridge Advanced Timer Plugin)
- PostgreSQL Server
- PostgREST
- Grafana

## Homebridge
Install Advanced Timer Plugin and setting for example at 1 Minute 

## HomeKit
Create Automation trigers of Time State changing


## Table in PostgreSQL
```sql
CREATE TABLE "temperature_humidity_sensor" (
  "id" SERIAL PRIMARY KEY,
  "date" TIMESTAMPTZ NOT NULL DEFAULT now()::timestamptz(0),
  "sensor_id" TEXT NOT NULL,
  "temperature" DECIMAL NOT NULL,
  "humidity" DECIMAL NOT NULL
)
```

## HTTP Server PostgREST
Config file place in `/etc/postgrest`
```
db-uri = "postgres://username:password@ip:port/db_name"
db-schemas = "public"
db-anon-role = "postgres"
server-port = 5000
```

Default SystemD Unit Config `/etc/systemd/system/postgrest.service`
```
[Unit]
Description=REST API for PostgreSQL database IoT
After=postgresql.service

[Service]
ExecStart=/usr/local/bin/postgrest /etc/postgrest/temperature_humidity_sensor_api_postgres.conf
ExecReload=/bin/kill -SIGUSR1 $MAINPID

[Install]
WantedBy=multi-user.target
```
