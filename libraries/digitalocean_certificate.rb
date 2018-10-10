class DigitaloceanCertificate < Inspec.resource(1)
  name 'digitalocean_certificate'
  desc 'Verifies digitalocean certificate'
  example "
    describe digitalocean_droplet(id: 112209628) do
      it { should exist }
    end
  "

  def initialize(opts = {})
    super()
    if opts[:name]
      id = :name
      value = opts[:name]
    end

    if opts[:id]
      id = :id
      value = opts[:id]
    end

    @do = inspec.backend
    @certs = @do.droplet_client.certificates.all.select { |cert|
      cert[id] == value
    }
  end

  def id
    return nil unless @certs.one?
    @certs[0][:id]
  end

  def name
    return nil unless @certs.one?
    @certs[0][:name]
  end

  def type
    return nil unless @certs.one?
    @certs[0][:type]
  end

  def state
    return nil unless @certs.one?
    @certs[0][:state]
  end

  def not_after
    return nil unless @certs.one?
    @certs[0][:not_after]
  end

  def sha1_fingerprint
    return nil unless @certs.one?
    @certs[0][:sha1_fingerprint]
  end

  def exists?
    @certs.one?
  end

  def to_s
    "digitalocean certificate #{@id}"
  end
end
