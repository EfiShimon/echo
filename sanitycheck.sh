#!/bin/bash

opened=0

while ! nc -z localhost 300$1; do   
  sleep 1 # wait for 1 second before check again
done

echo "echo-app is live"

status=`curl -s -o /dev/null -w "%{http_code}" localhost:300$1`
echo "curl to echo-app returned:"
echo $status

if [  $status -eq 200 ] 
then 
    exit 0    
  else 
    exit 1
fi