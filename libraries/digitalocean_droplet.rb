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

  %w{
    id name locked disk vcpus 
    tags ipv6 features volumes 
    snapshot_ids
  }.each do |property|
    define_method property do
      droplet[property] unless droplet.nil?
    end
  end

  def region
    droplet[:region].slug unless droplet.nil?
  end

  def image
    droplet[:image].slug unless droplet.nil?
  end

  def size
    droplet[:size].slug unless droplet.nil?
  end

  def exists?
    !droplet.nil?
  end

  %w{
    active off
  }.each do |status|
    define_method status + '?' do
      return @state if defined?(@state)
      @_state = droplet[:status] unless droplet.nil?
      if @_state == status
        @state = true
      else
        @state = nil
      end
    end
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