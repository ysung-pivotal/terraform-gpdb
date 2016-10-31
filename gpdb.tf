provider "google" {
	region = "${var.gcp_region}"
	project = "${var.gcp_project}"
	credentials = "${file(var.gcp_credentials_path)}"
}

#project metadata
resource "google_compute_project_metadata" "default" {
	metadata {
		sshKeys = "${var.gce_ssh_user}:${file("${var.gcp_publickey_path}")}"
	}
}

data "template_file" "gpdb" {
	template = "${file("${path.module}/templates/gpdb.sh.tpl")}"
	vars {
		pivotal_token = "${var.pivotal_token}"
		dpod_dir = "${var.dpod_dir}"
	}
}

#Networking
resource "google_compute_network" "cluster-global-net" {
	name = "${var.cluster_name}-global-net"
	auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cluster-net" {
	name = "${var.cluster_name}-net"
	ip_cidr_range = "${var.gcp_cluster_network}"
	network = "${google_compute_network.cluster-global-net.self_link}"
	region = "${var.gcp_region}"
}

#Servers
resource "google_compute_instance" "master" {
	name = "${var.cluster_name}-master"
	machine_type = "${var.master_machine_type}"
	zone = "${var.gcp_zone}"
	tags = ["master", "ssh"]

	disk {
		image = "${var.gcp_image}"
		size = "100"
	}
	
	network_interface {
		subnetwork = "${google_compute_subnetwork.cluster-net.name}"
		access_config {
			#Ephemeral IP
		}
	}
	
	metadata_startup_script = "${file("${path.module}/scripts/metadata_script.sh")}"
	
	connection {
		type = "ssh"
		user = "${var.gce_ssh_user}"
		private_key = "${file("${var.gcp_privatekey_path}")}"
		agent = false
	}

	provisioner "remote-exec" {
		inline = [
			"mkdir -p ${var.dpod_dir}"
		]
	}
	
	provisioner "file" {
		content = "${data.template_file.gpdb.rendered}"
		destination = "${var.dpod_dir}/gpdb.sh"
	}
	
	provisioner "remote-exec" {
		inline= [
			"chmod +x ${var.dpod_dir}/*.sh",
			"mkdir ${var.dpod_dir}/src",
			"bash ${var.dpod_dir}/gpdb.sh"	
		]
	}	
}

resource "google_compute_instance" "gpdb-segments" {
	count = "${var.gpdb_segment_size}"
	name = "${var.cluster_name}-segment-${count.index + 1}"
	machine_type = "${var.segment_machine_type}"
	zone = "${var.gcp_zone}"
	tags = ["segment", "ssh"]
	
	disk {
		image = "${var.gcp_image}"
		size = "500"
	}
	
	network_interface {
		subnetwork = "${google_compute_subnetwork.cluster-net.name}"
		access_config {
			#Ephemeral IP
		}
	}	

        metadata_startup_script = "${file("${path.module}/scripts/metadata_script.sh")}"

}

#Firewall
resource "google_compute_firewall" "cluster-internal" {
	name = "${var.cluster_name}-internal"
	network = "${google_compute_network.cluster-global-net.name}"
	allow {
		protocol = "tcp"
		ports = ["1-65535"]
	}
	
	allow {
		protocol = "udp"
		ports = ["1-65535"]
	}
	
	allow {
		protocol = "icmp"
	}

	source_ranges = ["${google_compute_subnetwork.cluster-net.ip_cidr_range}"]
}

resource "google_compute_firewall" "cluster-public" {
	name = "${var.cluster_name}-public"
	network = "${google_compute_network.cluster-global-net.name}"
	allow {
		protocol = "tcp"
		ports = ["22", "5432"]
	}
	target_tags = ["master","ssh"]
	source_ranges = ["0.0.0.0/0"]
}

