#!/bin/bash

echo 'Liveness probe...'
cd /converter/misc
curl -m 5                               \
     -X POST                            \
     http://localhost:3000/convert      \
     -F file=@example.xls               \
     -F from='application/vnd.ms-excel' \
     -F to='text/csv'                   \
     -o output.csv
