class DigitaloceanFirewall < Inspec.resource(1)
  name 'digitalocean_firewall'
  desc 'Verifies digitalocean firewall'
  example "
    describe digitalocean_firewall(id: '3427a962-116b-4159-8411-fdde0a67c5fb') do
      it { should exist }
    end
  "
  supports platform: 'digitalocean'

  def initialize(opts = {})
    super()
    if opts[:id]
      @id = :id
      @value = opts[:id]
    end

    if opts[:name]
      @id = :name
      @value = opts[:name]
    end
  end

  def id
    firewall[:id] unless firewall.nil?
  end

  def name
    firewall[:name] unless firewall.nil?
  end

  def status
    firewall[:status] unless firewall.nil?
  end

  def tags
    firewall[:tags] unless firewall.nil?
  end

  def exists?
    !firewall.nil?
  end

  def inboundrules
    return [] if firewall.nil?

    firewall.inbound_rules
  end

  def outboundrules
    return [] if firewall.nil?

    firewall.outbound_rules
  end

  def droplet_ids
    return [] if firewall.nil?

    firewall.droplet_ids
  end

  def to_s
    "digitalocean firewall #{@value}"
  end

  private

  def firewall
    return @firewalls if defined?(@firewalls)

    firewalls = inspec.backend.droplet_client.firewalls.all.select { |key|
      key[@id].to_s == @value.to_s
    }
    if firewalls.one?
      @firewalls = firewalls[0]
    else
      @firewalls = nil
    end
    @firewalls
  end
end
