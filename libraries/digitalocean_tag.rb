class DigitaloceanTag < Inspec.resource(1)
  name 'digitalocean_tag'
  desc 'Verifies digitalocean ssh keys'
  example "
    describe digitalocean_tag(name: 'key') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    super()
    @name = opts[:name]

    @do = inspec.backend
    @tags = @do.droplet_client.tags.all.select { |v|
      v[:name] == @name
    }
  end

  def name
    return nil unless @tags.one?
    @tags[0][:name]
  end

  def exists?
    @tags.one?
  end

  def to_s
    "digitalocean tag #{@name}"
  end
end
