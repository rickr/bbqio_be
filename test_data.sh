while true; do
  chamberTemp=$(( ( RANDOM % 20 )  + 250 ))
  fanStatus=$(( ( RANDOM % 1 ) ))
  smokeLevel=$(( ( RANDOM % 20 )  + 250 ))
  meatTemp=$(( ( RANDOM % 20 )  + 100 ))
  curl --data "timestamp=$(date +%s)&chamberTemp=${chamberTemp}&fanStatus=${fanStatus}&smokeLevel=${smokeLevel}&meatTemp=${meatTemp}" http://localhost:4567/sensor_data; echo
  sleep 1
done
