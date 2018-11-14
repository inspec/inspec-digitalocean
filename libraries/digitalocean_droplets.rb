class DigitaloceanDroplets < Inspec.resource(1)
  name 'digitalocean_droplets'
  desc 'Verifies digitalocean droplets'
  example "
    describe digitalocean_droplets do
      it { should exist }
    end
  "
  supports platform: 'digitalocean'

  def initialize
  end

  # Underlying FilterTable implementation.
  filter = FilterTable.create
  filter.register_custom_matcher(:exists?) { |x| !x.entries.empty? }
  filter.register_column(:id)
  filter.register_column(:ipv6)
  filter.register_column(:name)
  filter.register_column(:status)
  filter.register_column(:tags)
  filter.install_filter_methods_on_resource(self, :droplets)

  def to_s
    'digitalocean droplets'
  end

  private

  def droplets
    return @droplets if defined?(@droplets)
    # for inspec check inspec.backend.droplet_client will be nil
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'

    @droplets = inspec.backend.droplet_client.droplets.all.select { |droplet|
      droplet
    }
  end
end
