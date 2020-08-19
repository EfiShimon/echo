#!/bin/bash

opened=0

while ! nc -z localhost 3000; do   
  sleep 1 # wait for 1 second before check again
done

echo "tedsearch live"

status=`curl -s -o /dev/null -w "%{http_code}" localhost:3000`
echo "curl to tedsearch returned:"
echo $status

if [  $status -eq 200 ] 
then 
    exit 0    
  else 
    exit 1
fi