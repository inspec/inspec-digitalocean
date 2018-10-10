class DigitaloceanSSHKey < Inspec.resource(1)
  name 'digitalocean_ssh_key'
  desc 'Verifies digitalocean ssh keys'
  example "
    describe digitalocean_ssh_key(name: 'chris-rock') do
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
    @keys = @do.droplet_client.ssh_keys.all.select { |key|
      key[@id] == @value
    }
  end

  def id
    return nil unless @keys.one?
    @keys[0][:id]
  end

  def name
    return nil unless @keys.one?
    @keys[0][:name]
  end

  def fingerprint
    return nil unless @keys.one?
    @keys[0][:fingerprint]
  end

  def public_key
    return nil unless @keys.one?
    @keys[0][:public_key]
  end

  def exists?
    @keys.one?
  end

  def to_s
    "digitalocean ssh_key #{@value}"
  end
end
