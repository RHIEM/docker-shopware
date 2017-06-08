#!/bin/bash

if [ ! -e /var/www/html/shopware.php ]; then
    echo -n "Shopware not found, installing..."
    rm -f /var/www/html/index.html
	git clone $SHOPWAREBUILD_GIT_REPO /var/www/html
    echo -n "Configuring Build properties..."
	cat > /var/www/html/build/build.properties << EOF
db.host=$SHOPWAREBUILD_DB_HOST
db.name=$SHOPWAREBUILD_DB_NAME
db.user=$SHOPWAREBUILD_DB_USER
db.password=$SHOPWAREBUILD_DB_PASSWORD
db.port=$SHOPWAREBUILD_DB_PORT
app.path=$SHOPWAREBUILD_APP_PATH
app.host=$SHOPWAREBUILD_APP_HOST
EOF
	ant -f /var/www/html/build/build.xml  $SHOPWAREBUILD_ANT_TARGET
	
	if [ $SHOPWAREBUILD_DEMO_ZIP = "" ]; then
		echo "Loading Demo-Data"
		curl -Lo /var/www/html/demo_data.zip http://releases.s3.shopware.com/test_images.zip #$SHOPWAREBUILD_DEMO_ZIP
		unzip /var/www/html/demo_data.zip
		rm /var/www/html/demo_data.zip
	fi
    echo "done building"
fi

echo -n "Setting permissions..."
	chown www-data:www-data /var/www/html/*
done
echo "done"

echo "Running apache"
source /etc/apache2/envvars
exec apache2 -D FOREGROUND