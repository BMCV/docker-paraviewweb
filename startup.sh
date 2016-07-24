#!/bin/bash

if [ -z "$DATASET_HID" ]; then
    pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
        --content /usr/local/share/paraview-5.1/www \
        --data-dir /input \
        --save-data-dir /export \
        --port 8777 \
        --host 0.0.0.0 \
        -d
else
    pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
        --content /usr/local/share/paraview-5.1/www \
        --data-dir /input \
        --save-data-dir /export \
        --load-file input.tiff \
        --port 8777 \
        --host 0.0.0.0 \
        -d
fi
