#!/bin/bash
echo "Running apache"
source /etc/apache2/envvars
exec apache2 -D FOREGROUND