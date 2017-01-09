#!/bin/bash

service nginx start

if [ -z "$DATASET_HID" ]
then
    pvpython /usr/local/lib/node_modules/pvw-visualizer/server/pvw-visualizer.py \
	--paraview $CONDA/lib/paraview-5.2/
        --data /input \
        --port 8777 \
	--server-only
else
    pvpython /usr/local/lib/node_modules/pvw-visualizer/server/pvw-visualizer.py \
	--paraview $CONDA/lib/paraview-5.2/
        --data /input \
        --port 8777 \
	--server-only \
        --load-file $DATASET_HID
fi

libvtkPVServerManagerRendering-pv5.2.so
