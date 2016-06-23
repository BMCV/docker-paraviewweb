#!/bin/bash

if [ "$dataset_hid" != "" ]; then
  pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
         --content /usr/local/share/paraview-5.1/www \
         --data-dir /import \
         --save-data-dir /export \
	 --load-file $dataset_hid \
         --port 8777
else
  pvpython /usr/local/lib/paraview-5.1/site-packages/paraview/web/pv_web_visualizer.py \
         --content /usr/local/share/paraview-5.1/www \
         --data-dir /import \
         --save-data-dir /export \
         --port 8777
fi


