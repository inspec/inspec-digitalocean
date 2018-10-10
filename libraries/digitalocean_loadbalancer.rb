class DigitaloceanLoadbalancer < Inspec.resource(1)
  name 'digitalocean_loadbalancer'
  desc 'Verifies digitalocean firewall'
  example "
    describe digitalocean_loadbalancer(name: 'my cert') do
      it { should exist }
    end
  "

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

    @do = inspec.backend
    @lbs = @do.droplet_client.load_balancers.all.select { |lb|
      lb[@id] == @value
    }
  end

  def id
    return nil unless @lbs.one?
    @lbs[0][:id]
  end

  def name
    return nil unless @lbs.one?
    @lbs[0][:name]
  end

  def ip
    return nil unless @lbs.one?
    @lbs[0][:ip]
  end

  def algorithm
    return nil unless @lbs.one?
    @lbs[0][:algorithm]
  end

  def status
    return nil unless @lbs.one?
    @lbs[0][:status]
  end

  def exists?
    @lbs.one?
  end

  def to_s
    "digitalocean loadbalancer #{@value}"
  end
end
