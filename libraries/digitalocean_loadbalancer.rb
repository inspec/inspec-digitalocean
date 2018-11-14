class DigitaloceanLoadbalancer < Inspec.resource(1)
  name 'digitalocean_loadbalancer'
  desc 'Verifies digitalocean loadbalancer'
  example "
    describe digitalocean_loadbalancer(name: 'my cert') do
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
    loadbalancer[:id] unless loadbalancer.nil?
  end

  def name
    loadbalancer[:name] unless loadbalancer.nil?
  end

  def ip
    loadbalancer[:ip] unless loadbalancer.nil?
  end

  def algorithm
    loadbalancer[:algorithm] unless loadbalancer.nil?
  end

  def status
    loadbalancer[:status] unless loadbalancer.nil?
  end

  def exists?
    !loadbalancer.nil?
  end

  def forwarding_rules
    return [] if loadbalancer.nil?

    loadbalancer.forwarding_rules
  end

  def to_s
    "digitalocean loadbalancer #{@value}"
  end

  private

  def loadbalancer
    return @lbs if defined?(@lbs)
    # for inspec check inspec.backend.droplet_client will be nil
    return nil if inspec.backend.is_a?(Train::Transports::Mock::Connection)

    lbs = inspec.backend.droplet_client.load_balancers.all.select { |lb|
      lb[@id].to_s == @value.to_s
    }
    if lbs.one?
      @lbs = lbs[0]
    else
      @lbs = nil
    end
    @lbs
  end
end
