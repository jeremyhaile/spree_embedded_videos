require 'spree_core'
require 'spree_embedded_videos_hooks'

module SpreeEmbeddedVideos
  module Config
    mattr_accessor :embedly_api_key
    @@embedly_api_key = nil
  end

  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      require 'oembed'
      OEmbed::Providers.unregister_all
      OEmbed::Providers.register_all

      # Add short URL form of brightcove to embedly
      OEmbed::Providers::Embedly << "http://bcove.me/*"
      OEmbed::Providers.register(OEmbed::Providers::Embedly)

      config_file = Rails.root.join("config", "spree_embedded_videos.yml")
      if config_file.file?
        config = YAML.load(ERB.new(config_file.read).result)[Rails.env]
        if config
          SpreeEmbeddedVideos::Config.embedly_api_key = config["embedly_api_key"]
        end
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
