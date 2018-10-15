class DigitaloceanDroplet < Inspec.resource(1)
  name 'digitalocean_droplet'
  desc 'Verifies digitalocean droplet'
  example "
    describe digitalocean_droplet(id: 112209628) do
      it { should exist }
    end
  "
  supports platform: 'digitalocean'

  def initialize(opts = {})
    super()
    if opts[:name]
      @id = :name
      @value = opts[:name]
    end

    if opts[:id]
      @id = :id
      @value = opts[:id]
    end
  end

  def id
    droplet[:id] unless droplet.nil?
  end

  def name
    droplet[:name] unless droplet.nil?
  end

  def region
    droplet[:region].slug unless droplet.nil?
  end

  def image
    droplet[:image].slug unless droplet.nil?
  end

  def ipv6
    droplet[:ipv6] unless droplet.nil?
  end

  def locked
    droplet[:locked] unless droplet.nil?
  end

  def size
    droplet[:size_slug] unless droplet.nil?
  end

  def disk
    droplet[:disk] unless droplet.nil?
  end

  def vcpus
    droplet[:vcpus] unless droplet.nil?
  end

  def status
    droplet[:status] unless droplet.nil?
  end

  def tags
    droplet[:tags] unless droplet.nil?
  end

  def exists?
    !droplet.nil?
  end

  def to_s
    "digitalocean droplet #{@value}"
  end

  private

  def droplet
    return @droplets if defined?(@droplets)

    droplets = inspec.backend.droplet_client.droplets.all.select { |key|
      key[@id].to_s == @value.to_s
    }
    if droplets.one?
      @droplets = droplets[0]
    else
      @droplets = nil
    end
    @droplets
  end
end
