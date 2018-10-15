class DigitaloceanSSHKey < Inspec.resource(1)
  name 'digitalocean_ssh_key'
  desc 'Verifies digitalocean ssh keys'
  example "
    describe digitalocean_ssh_key(name: 'chris-rock') do
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
    key[:id] unless key.nil?
  end

  def name
    key[:name] unless key.nil?
  end

  def fingerprint
    key[:fingerprint] unless key.nil?
  end

  def public_key
    key[:public_key] unless key.nil?
  end

  def exists?
    !key.nil?
  end

  def to_s
    "digitalocean ssh_key #{@value}"
  end

  private

  def key
    return @keys if defined?(@keys)

    keys = inspec.backend.droplet_client.ssh_keys.all.select { |key|
      key[@id].to_s == @value.to_s
    }
    if keys.one?
      @keys = keys[0]
    else
      @keys = nil
    end
    @keys
  end
end
