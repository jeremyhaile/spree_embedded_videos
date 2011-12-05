require 'ostruct'

class Video < ActiveRecord::Base
  belongs_to :viewable, :polymorphic => true

  before_save :update_metadata

  validates :url, :presence => true
  validates_each :url do |model, attr, value|
    if value.present?
      begin
        oembed_response = model.oembed_cached()
        unless oembed_response.type == 'video'
          model.errors.add(attr, I18n.t("video_invalid_url"))
        end
      rescue OEmbed::UnknownResponse
        model.errors.add(attr, I18n.t("video_unknown_response"))
      rescue OEmbed::NotFound
        model.errors.add(attr, I18n.t("video_invalid_url"))
      end
    end
  end

  def embed_html(maxwidth = nil)
    oembed_cached(maxwidth).html
  end

  def oembed_cached(maxwidth = nil)
    Rails.cache.fetch(oembed_cache_key(maxwidth), :expires_in => 1.hour) do
      options = {}
      options["maxwidth"] = maxwidth if maxwidth

      provider = OEmbed::Providers.find(url)

      # If embedly is the chosen provider and is configured, set an api key in the options
      if provider && provider.endpoint.include?("embed.ly") && SpreeEmbeddedVideos::Config.embedly_api_key
        options["key"] = SpreeEmbeddedVideos::Config.embedly_api_key
      end

      response = nil
      if provider
        response = provider.get(url, options)
      end
      response.nil? ? nil : OpenStruct.new(response.fields).freeze
    end
  end

  private
  def update_metadata
    if url.present?
      oembed_response = oembed_cached

      Rails.logger.info(oembed_response.inspect)

      if oembed_response.type == 'video'
        self.title = oembed_response.title
        self.thumbnail_url = oembed_response.thumbnail_url
        self.thumbnail_width = oembed_response.thumbnail_width
        self.thumbnail_height = oembed_response.thumbnail_height
      else
        raise "Error updating metadata - URL is not a video URL."
      end
    end
  end

  def oembed_cache_key(maxwidth = nil)
    if maxwidth
      "video:oembed:#{url}:#{maxwidth}"
    else
      "video:oembed:#{url}"
    end
  end

end