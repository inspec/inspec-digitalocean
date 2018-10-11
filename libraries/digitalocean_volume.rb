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
  end

  def id
    volume[:id] unless volume.nil?
  end

  def name
    volume[:name] unless volume.nil?
  end

  def description
    volume[:description] unless volume.nil?
  end

  def size
    volume[:size_gigabytes] unless volume.nil?
  end

  def region
    volume[:region].slug unless volume.nil?
  end

  def droplet_ids
    volume[:droplet_ids] unless volume.nil?
  end

  def exists?
    !volume.nil?
  end

  def to_s
    "digitalocean volume #{@id}"
  end

  private

  def volume
    return @vols if defined?(@vols)
    vols = inspec.backend.droplet_client.volumes.all.select { |key|
      key[@id].to_s == @value.to_s
    }
    if vols.one?
      @vols = vols[0]
    else
      @vols = nil
    end
    @vols
  end
end
