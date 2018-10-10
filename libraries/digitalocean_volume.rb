class DigitaloceanVolume < Inspec.resource(1)
  name 'digitalocean_volume'
  desc 'Verifies digitalocean volume'
  example "
    describe digitalocean_volume(name: 'my cert') do
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
    @vols = @do.droplet_client.volumes.all.select { |key|
      key[@id] == @value
    }
  end

  def id
    return nil unless @vols.one?
    @vols[0][:id]
  end

  def name
    return nil unless @vols.one?
    @vols[0][:name]
  end

  def description
    return nil unless @vols.one?
    @vols[0][:description]
  end

  def size
    return nil unless @vols.one?
    @vols[0][:size_gigabytes]
  end

  def region
    # TODO: we should return a better object here
    @vols[:region].slug
  end

  def droplet_ids
    return nil unless @vols.one?
    @vols[0][:droplet_ids]
  end

  def exists?
    @vols.one?
  end

  def to_s
    "digitalocean volume #{@id}"
  end
end
