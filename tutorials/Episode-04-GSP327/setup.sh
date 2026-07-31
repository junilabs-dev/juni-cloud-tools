#!/bin/bash
# shellcheck disable=SC2086,SC2162,SC2039,SC3037

source ../../bash/utils.sh

print_banner
print_info "Starting GSP327: Engineer Data for Predictive Modeling with BigQuery ML..."
echo ""

echo -e "${YELLOW}Please enter the exact randomized values from your Qwiklabs manual:${NC}"

read -p "1. Cleaned Table Name (e.g. taxi_training_data_995): " TARGET_TABLE
read -p "2. Target Column Name (e.g. fare_amount_332): " TARGET_COLUMN
read -p "3. 'Ensure trip_distance is greater than': " TRIP_DISTANCE
read -p "4. 'fare_amount is very small (less than \$Value)' (Enter Value): " FARE_AMOUNT
read -p "5. 'Ensure passenger_count is greater than': " PASSENGER_COUNT
read -p "6. Model Name (e.g. fare_model_103): " MODEL_NAME

echo ""
print_info "Starting Task 1: Cleaning the training data..."
bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE taxirides.${TARGET_TABLE} AS
SELECT
    (tolls_amount + fare_amount) AS ${TARGET_COLUMN},
    pickup_datetime,
    pickup_longitude AS pickuplon, 
    pickup_latitude AS pickuplat, 
    dropoff_longitude AS dropofflon, 
    dropoff_latitude AS dropofflat,
    passenger_count
FROM
    taxirides.historical_taxi_rides_raw
WHERE
    trip_distance > ${TRIP_DISTANCE}
    AND fare_amount >= ${FARE_AMOUNT}
    AND passenger_count > ${PASSENGER_COUNT}
    AND pickup_longitude > -78
    AND pickup_longitude < -70
    AND dropoff_longitude > -78
    AND dropoff_longitude < -70
    AND pickup_latitude > 37
    AND pickup_latitude < 45
    AND dropoff_latitude > 37
    AND dropoff_latitude < 45
    AND rand() < 0.001;
"
success "Task 1 complete!"

echo ""
print_info "Starting Task 2: Creating BigQuery ML Model (This may take ~2-5 minutes)..."
bq query --use_legacy_sql=false "
CREATE OR REPLACE MODEL taxirides.${MODEL_NAME}
TRANSFORM(
  * EXCEPT(pickup_datetime),
  ST_Distance(ST_GeogPoint(pickuplon, pickuplat), ST_GeogPoint(dropofflon, dropofflat)) AS euclidean,
  CAST(EXTRACT(DAYOFWEEK FROM pickup_datetime) AS STRING) AS dayofweek,
  CAST(EXTRACT(HOUR FROM pickup_datetime) AS STRING) AS hourofday
)
OPTIONS(model_type='linear_reg', input_label_cols=['${TARGET_COLUMN}']) 
AS
SELECT * FROM taxirides.${TARGET_TABLE};
"
success "Task 2 complete!"

echo ""
print_info "Starting Task 3: Performing batch prediction..."
bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE taxirides.2015_fare_amount_predictions AS
SELECT * FROM ML.PREDICT(MODEL taxirides.${MODEL_NAME}, (
  SELECT * FROM taxirides.report_prediction_data
));
"
success "Task 3 complete!"

echo ""
echo -e "${BOLD}${CYAN}🎉 ALL TASKS COMPLETE! Go back to Qwiklabs and check your progress!${NC}"
