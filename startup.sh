#!/bin/bash

service nginx start

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/paraview-$PV_VERSION_MAJOR/

if [ -z "$DATASET_HID" ]
then
    Visualizer --paraview /usr/local/lib/paraview-$PV_VERSION_MAJOR/ \
        --data /input \
        --port 9777 \
        --server-only
else
    Visualizer --paraview /usr/local/lib/paraview-$PV_VERSION_MAJOR/ \
        --data /input \
        --port 9777 \
        --server-only \
        --load-file $DATASET_HID
fi

# Visualizer --paraview /usr/local/lib/paraview-$PV_VERSION_MAJOR/ --data /input --port 9777 --server-only
