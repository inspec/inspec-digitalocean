provider "digitalocean" {
  # You need to set this in your .bashrc
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  #
}

# Create a new SSH key
resource "digitalocean_ssh_key" "key" {
  name       = "Terraform Example"
  public_key = "${file("./id_rsa.pub")}"
}

resource "digitalocean_volume" "web" {
  region                  = "${var.do_region}"
  name                    = "nginx html content"
  size                    = 100
  initial_filesystem_type = "ext4"
  description             = "web volume"
}

resource "digitalocean_droplet" "web" {
  ssh_keys           = ["${digitalocean_ssh_key.key.fingerprint}"]
  image              = "ubuntu-16-04-x64"
  region             = "${var.do_region}"
  size               = "s-1vcpu-1gb"
  private_networking = true
  backups            = true
  ipv6               = true
  name               = "nginx-web-ams3"
  tags   = ["${digitalocean_tag.web.id}"]

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
    ]

    connection {
      type     = "ssh"
      private_key = "${file("./id_rsa")}"
      user     = "root"
      timeout  = "2m"
    }
  }
  
  # installs inspec and executes the profiles
  provisioner "inspec" {
    profiles = [
      "supermarket://dev-sec/linux-baseline",
      "supermarket://dev-sec/ssh-baseline",
    ]

    reporter {
      name = "cli"
    }

    connection {
      type     = "ssh"
      private_key = "${file("./id_rsa")}"
      user     = "root"
      timeout  = "2m"
    }

    on_failure = "continue"
  }
}

resource "digitalocean_tag" "web" {
  name = "nginx"
}

# This is a bug in digitalocean terraform, we always get an error message like
#  digitalocean_floating_ip.web: Error Assigning FloatingIP to the droplet: POST https://api.digitalocean.com/v2/floating_ips/.../actions: 422 Droplet already has a pending event.
# resource "digitalocean_floating_ip" "web" {
#   droplet_id = "${digitalocean_droplet.web.id}"
#   region     = "${digitalocean_droplet.web.region}"
# }

resource "digitalocean_volume_attachment" "web" {
  droplet_id = "${digitalocean_droplet.web.id}"
  volume_id  = "${digitalocean_volume.web.id}"
}

resource "digitalocean_certificate" "web" {
  name              = "nginx"
  type              = "custom"
  private_key       = "${file("./domain.key")}"
  leaf_certificate  = "${file("./domain.crt")}"
}

resource "digitalocean_loadbalancer" "public" {
  name = "loadbalancer-1"
  region = "${var.do_region}"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port = 443
    entry_protocol = "https"

    target_port = 80
    target_protocol = "http"

    certificate_id  = "${digitalocean_certificate.web.id}"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = ["${digitalocean_droplet.web.id}"]
}