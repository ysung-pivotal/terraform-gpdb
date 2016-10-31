variable "gcp_region" {
	default = "us-central1"
}

variable "gcp_zone" {
	default = "us-central1-a"
}

variable "gcp_project" {
	description = "GCP Project Name"
}

variable "gce_ssh_user" {
	description = "GCE default user"
}

variable "gcp_credentials_path" {
	description = "GCP credential path"
}

variable "gcp_publickey_path" {
	description = "GCP public key"
	default = "~/.ssh/gcp_id_rsa.pub"
}

variable "gcp_privatekey_path" {
	description = "GCP private key"
	default = "~/.ssh/gcp_id_rsa"
}

variable "gcp_cluster_network" {
	description = "gcp cluster private network cidr"
	default = "10.0.0.0/24"
}

variable "gcp_image" {
	default = "centos-7"
}

variable "cluster_name" {
	description = "Cluster name"
	default = "gpdb43orca"
}

variable "master_machine_type" {
	description = "GPDB master machine type"
	default = "n1-standard-4"
}

variable "segment_machine_type" {
	description = "GPDB segmetn machine type"
	default = "n1-standard-8"
}

variable "gpdb_segment_per_node" {
	description = "GPDB segment number per machine"
	default = "4"
}

variable "gpdb_segment_size" {
	description = "GPDB segment machine number"
	default = "1"
}

variable "dpod_dir" {
	descriptioin = "Directory to hold auto provisioning scripts"
}

variable "pivotal_token" {
	description = "Pivotal Network Token"
}
