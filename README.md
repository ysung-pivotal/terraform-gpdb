# terraform-gpdb
Using terraform-gcp to deploy gpdb cluster.

---
TODOs
 - check java version
 - get hosts
 - exchange keys
 - gpdb install
 - gpdb init
 - madlib/plr/pdltools/postgis
 - mirror
 - standby master
 - gphdfs
 - s3/gcs
 - disks
 - benchmarking
 - gpdb versions

---
Setup
 1. edit terraform.tfvars
    gcp_project
    gcp_crentials_path
    gcp_publickey
    gcp_privatekey
    pivotal_token
    dpod_dir
    gpdb_segment_size
    
 2. review variables.tf
    if you don't like the default variables, add them to terraform.tfvars
    ex. gcp_image default is centos-7. you can add gcp_image = "centos-6" in terraform.tfvars to change the image
    
 3. The gpdb.sh in templates will download gpdb4.3.10 from network.pivotal.io.  get your pivotal_token from network.pivotal.io.
 
 4. TODOs
