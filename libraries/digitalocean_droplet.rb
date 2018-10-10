class DigitaloceanDroplet < Inspec.resource(1)
  name 'digitalocean_droplet'
  desc 'Verifies digitalocean droplet'
  example "
    describe digitalocean_droplet(id: 112209628) do
      it { should exist }
    end
  "

  def initialize(opts = {})
    super()
    @id = opts[:id]
    @do = inspec.backend
    @droplet = @do.droplet_client.droplets.find(id: @id)
  end

  def id
    @droplet[:id]
  end

  def name
    @droplet[:name]
  end

  # should return a digitalocean_region
  def region
    # TODO: we should return a better object here
    @droplet[:region].slug
  end

  # should return a digitalocean_image resource
  def image
    @droplet[:image].slug
  end

  def ipv6
    @droplet[:ipv6]
  end

  def locked
    @droplet[:locked]
  end

  def size
    @droplet[:size_slug]
  end

  def disk
    @droplet[:disk]
  end

  def vcpus
    @droplet[:vcpus]
  end

  def status
    @droplet[:status]
  end

  def tags
    @droplet[:tags]
  end

  def exists?
    !@droplet.nil?
  end

  def to_s
    "digitalocean droplet #{name}"
  end
end
