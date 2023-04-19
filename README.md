# HomeKit Log Sensors
Get and store HomeKit Data (e.g. Aqara Temperature and Humidity Sensor WSDCGQ11LM) in SQL Database and visualize on Grafana

The color Range from Blue to Purple indicates the Percentage of cool to warm Temperatures. Gray Line - Moving average Filter (to eliminate Outliers).

![Room Temperature](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/Screenshot%202023-04-17%20004610.png)

Temperature and Humidity Charts and big Numbers
![Room Measurments](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/Screenshot%202023-04-17%20010223.png)

## What need:
- Aqara Sensors
- Apple HomeKit supported Device (AppleTV/HomePod/iPad(maybe))
- Homebridge (Homebridge Advanced Timer Plugin)
- PostgreSQL Server
- PostgREST
- Grafana (if need Charts)

## Algorithm Steps
1. Homebridge triggers Timer each n Seconds
2. HomeKit Automation reacts and run Script Shortcut
3. Sctipt Shortcut get Sensor Data and make HTTP Post Request on PostgREST Server
4. PostgREST Server performs Request and make Insertion Query

General Schema
![Schema](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/photo_2023-04-13_15-08-52.jpg)

## Homebridge
Install Advanced Timer Plugin and setting for example at 1 Minute 

## HomeKit
Create Automation trigers of Time State changing
![HomeKit](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/photo_2023-04-17_00-54-59.jpg)
![HomeKit](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/photo_2023-04-13_15-08-49.jpg)
![HomeKit](https://github.com/SA-Inc/HomeKit-Temperature-Sensor/blob/main/photo_2023-04-13_15-28-08.jpg)

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
- `id` - autoinc Value
- `date` - ISO 8601 Date Time (without Milliseconds and with Timezone)
- `sensor_id` - self random Value on HomeKit Side (can be named Entity or random String)
- `temperature` - Sensor Data in Celsius
- `humidity` - Sensor Data in Relative


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

```
sudo systemctl daemon-reload
sudo systemctl enable postgrest.service
sudo systemctl start postgrest.service
sudo systemctl status postgrest.service
```
