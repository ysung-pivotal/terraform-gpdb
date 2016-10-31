#! /usr/bin/env bash

error_exit() {
	echo "$1" >> ${dpod_dir}/gpdb.log
	exit 1
}

curl --request POST --url https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/eula_acceptance --header 'accept: application/json' --header 'authorization: Token ${pivotal_token}' --header 'cache-control: no-cache' --header 'content-type: application/json'

wget -O "${dpod_dir}"/src/greenplum-db-4.3.10.0-build-1-rhel5-x86_64.tar.gz --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/8431/download || error_exit 'Failed to download gpdb.tar.gz'

wget -O "${dpod_dir}"/src/postgis-ossv2.0.3_pv2.0.1_gpdb4.3orca-rhel5-x86_64.gppkg --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/1750/download || error_exit 'Failed to download postgis.gppkg'

wget -O "${dpod_dir}"/src/madlib-ossv1.9.1_pv1.9.6_gpdb4.3orca-rhel5-x86_64.tar.gz --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/8380/download || error_exit 'Failed to download madlib.ta.gz'

wget -O "${dpod_dir}"/src/plr-oss8.3.0.15_pv2.1_gphd4.3orca-rhel5-x86_64.gppkg --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/5559/download || error_exit 'Failed to download plr.gppkg'

wget -O "${dpod_dir}"/src/pljava-ossv1.4.0_pv1.3_gpdb4.3orca-rhel5-x86_64.gppkg --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/5560/download || error_exit 'Failed to download pljava.gppkg'

wget -O "${dpod_dir}"/src/greenplum-cc-web-2.5.0-RHEL5-x86_64.zip --post-data "" --header='Authorization: Token ${pivotal_token}' https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2684/product_files/8282/download || error_exit 'Failed to download greenplum-cc-web.zip'
