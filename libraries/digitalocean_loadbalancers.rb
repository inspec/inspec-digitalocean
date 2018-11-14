class DigitaloceanLoadbalancers < Inspec.resource(1)
  name 'digitalocean_loadbalancers'
  desc 'Verifies digitalocean loadbalancers'
  example "
    describe digitalocean_loadbalancers do
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
  filter.register_column(:ip)
  filter.register_column(:name)
  filter.register_column(:algorithm)
  filter.register_column(:status)
  filter.register_column(:created_at)
  filter.register_column(:tag)
  filter.register_column(:forwarding_rules)
  filter.install_filter_methods_on_resource(self, :loadbalancers)

  def to_s
    'digitalocean loadbalancers'
  end

  private

  def loadbalancers
    return @lbs if defined?(@lbs)
    # for inspec check inspec.backend.droplet_client will be nil
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'

    @lbs = inspec.backend.droplet_client.load_balancers.all.collect { |lb|
      lb
    }
  end
end
