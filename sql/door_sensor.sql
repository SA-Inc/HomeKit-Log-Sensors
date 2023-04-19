CREATE TABLE "door_sensor" (
  "id" SERIAL PRIMARY KEY,
  "date" TIMESTAMPTZ NOT NULL DEFAULT now()::timestamptz(0),
  "sensor_id" TEXT NOT NULL,
  "state" BOOLEAN NOT NULL
)
