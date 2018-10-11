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
      @id = :name
      @value = opts[:name]
    end

    if opts[:id]
      @id = :id
      @value = opts[:id]
    end
  end

  def id
    certificate[:id] unless certificate.nil?
  end

  def name
    certificate[:name] unless certificate.nil?
  end

  def type
    certificate[:type] unless certificate.nil?
  end

  def state
    certificate[:state] unless certificate.nil?
  end

  def not_after
    certificate[:not_after] unless certificate.nil?
  end

  def sha1_fingerprint
    certificate[:sha1_fingerprint] unless certificate.nil?
  end

  def exists?
    !certificate.nil?
  end

  def to_s
    "digitalocean certificate #{@id}"
  end

  private

  def certificate
    return @certs if defined?(@certs)
    certs = inspec.backend.droplet_client.certificates.all.select { |key|
      key[@id].to_s == @value.to_s
    }
    if certs.one?
      @certs = certs[0]
    else
      @certs = nil
    end
    @certs
  end
end
