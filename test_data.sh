while true; do
  chamberTemp=$(( ( RANDOM % 20 )  + 250 ))
  fanStatus=$(( ( RANDOM % 1 ) ))
  smokeLevel=$(( ( RANDOM % 30 )  + 250 ))
  meatTemp=$(( ( RANDOM % 20 )  + 100 ))

  fudgeValue=$(echo "$(( RANDOM % 10 )) * .01" | bc)
  humidityValue=$(echo ".77 + $fudgeValue" | bc )

  fudgeValue=$(echo "$(( RANDOM % 10 )) * .01" | bc)
  smokeValue=$(echo ".57 + $fudgeValue" | bc )

  curl --data "timestamp=$(date +%s)&chamberTemp=${chamberTemp}&fanStatus=${fanStatus}&smokeLevel=${smokeLevel}&meatTemp=${meatTemp}&humidityValue=${humidityValue}&smokeValue=${smokeValue}" \
  http://localhost:4567/sensor_data; echo
  sleep 1
done
