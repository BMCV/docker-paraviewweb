#!/bin/bash

service nginx start

if [ -z "$DATASET_HID" ]
then
    Visualizer --data /input \
        --port 8777 \
	--server-only
else
    Visualizer --data /input \
        --port 8777 \
	--server-only \
        --load-file $DATASET_HID
fi
