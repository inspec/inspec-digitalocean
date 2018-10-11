# InSpec DigitalOcean Resource Pack

This InSpec resource pack provides InSpec resources to verify Digitialocean Cloud settings. It is designed to work hand-in-hand with Digitalocean's [terrafrom provider](https://github.com/terraform-providers/terraform-provider-digitalocean) and follows their naming convention.

## Usage

Verify a droplet:

```
describe digitalocean_droplet(id: '123456') do
  it { should exist }
  its('name') { should eq 'nginx-web-ams3' }
  its('image') { should eq 'ubuntu-16-04-x64' }
  its('region') { should eq 'ams3' }
  its('size') { should eq 's-1vcpu-1gb' }
end
```

Verify a ssh key:

```
describe digitalocean_ssh_key(name: 'Terraform Example') do
  it { should exist }
  its('fingerprint') { should eq '2c:c2:8f:6b:f0:12:f0:b2:0f:9c:f2:cd:8f:6d:24:c1'}
end
```

At this point, the following resources are implemented:

- digitalocean_certificate
- digitalocean_droplet
- digitalocean_loadbalancer
- digitalocean_ssh_key
- digitalocean_tag
- digitalocean_volume

## Precondition

- InSpec 3
- InSpec Digitalocean backend plugin [train-digitalocean](https://github.com/chris-rock/train-digitalocean)
- [Digitalocean API key](https://cloud.digitalocean.com/account/api/tokens)

You can easily verify your environment by

```bash
$ inspec version
3.0.0

$ inspec plugin list

 Plugin Name                   Version   Via     ApiVer
-------------------------------------------------------
 train-digitalocean            src       path    train-1
-------------------------------------------------------
 1 plugin(s) total

```

If the plugin is missing, just install it via InSpec's cli

```
$ inspec plugin install train-digitalocean
```

In order to use this example, you need to create a [DigitalOcean API Token](https://cloud.digitalocean.com/account/api/tokens) and export it as an environment variable.

```bash
export DIGITALOCEAN_TOKEN="Put Your Token Here" 
```

Verify the plugin and the connection to Digitalocean

```
$ inspec detect -t digitalocean://

== Platform Details

Name:      digitalocean
Families:  cloud, api
Release:   0.1.0
```

## Integration testing

The integration tests launch an Ubuntu 16.04, install nginx and connects it to a load balancer via Terraform. Once created, InSpec is executed to verify that the environment is in its expected shape.

If you just want to run the full test cycle:

```bash
rake test:integration
```

In addition you can also walk through each step individually:

```bash
cd test/integration/build

# generate private key for ssh
ssh-keygen -t rsa -b 4096 -C "digitalocean" -N '' -f ./id_rsa

# generate self-signed https certificate
openssl req \
       -newkey rsa:2048 -nodes -keyout domain.key \
       -out domain.csr \
       -subj "/C=DE/ST=Berlin/L=Berlin/O=InSpec Security/OU=IT Department/CN=example.com"

openssl req \
       -key domain.key \
       -new \
       -x509 -days 365 -out domain.crt \
       -subj "/C=DE/ST=Berlin/L=Berlin/O=InSpec Security/OU=IT Department/CN=example.com"


# run terraform
terraform init
terraform plan
terraform apply

# derive inspec attributes from the terraform state
rake test:tfstate

# run inspec
inspec exec ./verify -t digitalocean:// --attrs attributes.yml
```

# References
 - [Digitalocean API]()
 - [Terraform DigitalOcean provider](https://github.com/terraform-providers/terraform-provider-digitalocean)
 - [OpenSSL Essentials: Working with SSL Certificates, Private Keys and CSRs](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)