#!/bin/bash

# Start SSH service (optional, for internal communication if needed)
sudo service ssh start

# Wait for required services depending on SERVICE_TYPE
if [ "$SERVICE_TYPE" == "metastore" ]; then
  echo "[INFO] Starting Hive Metastore..."

    # echo "[INFO] Waiting for PostgreSQL at $DB_HOST..."
    # until pg_isready -h "$DB_HOST" -p 5432; do
    #  sleep 2
    #done
    #until psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
    #sleep 2
    #done
   

  # Initialize Hive Metastore schema only once
  if [ ! -f /usr/local/hive/metastore_initialized ]; then
    echo "[INFO] Initializing Hive Metastore schema..."

    hdfs dfs -mkdir -p /user/hive/warehouse
    hdfs dfs -mkdir -p /apps/tez
    hdfs dfs -put /usr/local/tez/share/*  /apps/tez
    schematool -dbType postgres -initSchema || echo "[WARN] Schema may already exist"
    touch /usr/local/hive/metastore_initialized
  fi

  hive --service metastore

elif [ "$SERVICE_TYPE" == "hiveserver2" ]; then
  echo "[INFO] Starting HiveServer2..."

  

  #echo "[INFO] Waiting for Hive Metastore at $METASTORE_HOST:9083..."
  #until nc -z "$METASTORE_HOST" 9083; do
    sleep 2
  #done

  hive --service hiveserver2


else
  echo "[ERROR] Unknown SERVICE_TYPE: $SERVICE_TYPE"
  exit 1
fi
