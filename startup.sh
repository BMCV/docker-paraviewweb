#!/bin/bash

service nginx start

if [ -z "$DATASET_HID" ]; then
    pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
        --content /usr/local/share/paraview-5.1/www \
        --data-dir /input \
        --save-data-dir /export \
        --port 9777 \
	--host 0.0.0.0
else
    pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
        --content /usr/local/share/paraview-5.1/www \
        --data-dir /input \
        --save-data-dir /export \
        --port 9777 \
	--host 0.0.0.0 \
        --load-file $DATASET_HID
fi
