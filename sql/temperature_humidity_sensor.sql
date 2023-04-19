CREATE TABLE "temperature_humidity_sensor" (
  "id" SERIAL PRIMARY KEY,
  "date" TIMESTAMPTZ NOT NULL DEFAULT now()::timestamptz(0),
  "sensor_id" TEXT NOT NULL,
  "temperature" DECIMAL NOT NULL,
  "humidity" DECIMAL NOT NULL
)
