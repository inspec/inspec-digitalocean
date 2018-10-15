class DigitaloceanTag < Inspec.resource(1)
  name 'digitalocean_tag'
  desc 'Verifies digitalocean ssh keys'
  example "
    describe digitalocean_tag(name: 'key') do
      it { should exist }
    end
  "
  supports platform: 'digitalocean'

  def initialize(opts = {})
    super()
    @name = opts[:name]
  end

  def name
    tag[:name] unless tag.nil?
  end

  def exists?
    !tag.nil?
  end

  def to_s
    "digitalocean tag #{@name}"
  end

  private

  def tag
    return @tags if defined?(@tags)
    tags = inspec.backend.droplet_client.tags.all.select { |v|
      v[:name].to_s == @name.to_s
    }
    if tags.one?
      @tags = tags[0]
    else
      @tags = nil
    end
    @tags
  end
end
