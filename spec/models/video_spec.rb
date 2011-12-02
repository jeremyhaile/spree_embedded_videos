require 'spec_helper'

describe Video do

  before do
    @v = Video.new(:url => "http://youtube.com")
  end

  describe :validation do
    it 'validates urls required' do
      @v = Video.new(:url => nil)
      @v.should_not_receive(:oembed_cached)
      @v.valid?.should be_false
    end

    it 'validates urls are found by oembed' do
      @v.should_receive(:oembed_cached).and_raise OEmbed::NotFound.new("Not found")
      @v.valid?.should be_false
    end

    it 'validates response is a video' do
      @v.should_receive(:oembed_cached).and_return OpenStruct.new(:type => 'notavideo')
      @v.valid?.should be_false
    end
  end

  describe :embed_html do
    it 'should call oembed_cached and return html' do
      meta = mock("meta")
      @v.should_receive(:oembed_cached).with(200).and_return(meta)
      meta.should_receive(:html)
      @v.embed_html(200)
    end
  end

  describe :oembed_cached do
    it 'should call provider to get response and return open struct' do
      Rails.cache.should_receive(:fetch).and_yield
      response = mock("response", :fields => {abc: 123})
      OEmbed::Providers.should_receive(:get).with("http://youtube.com", {}).and_return(response)

      oembed = @v.oembed_cached()
      oembed.abc.should eql(123)
    end

    it 'should call provider to get response and return open struct with a max width' do
      Rails.cache.should_receive(:fetch).and_yield
      response = mock("response", :fields => {abc: 123})
      OEmbed::Providers.should_receive(:get).with("http://youtube.com", {"maxwidth" => 300}).and_return(response)

      oembed = @v.oembed_cached(300)
      oembed.abc.should eql(123)
    end
  end

  describe :update_metadata do
    it 'should do nothing if no url is present' do
      @v = Video.new(:url => nil)
      @v.should_not_receive(:oembed_cached)

      @v.send(:update_metadata)
    end

    it 'should update meta_data if url is present' do
      response = mock("response", :title => "Title", :thumbnail_url => "http://thumbnail.com/thumbnail.jpg", :thumbnail_height => 50, :thumbnail_width => 75, :type => 'video')
      @v.should_receive(:oembed_cached).and_return(response)

      @v.send(:update_metadata)

      @v.title.should eql("Title")
      @v.thumbnail_url.should eql("http://thumbnail.com/thumbnail.jpg")
      @v.thumbnail_height.should eql(50)
      @v.thumbnail_width.should eql(75)
    end

    it 'should raise error if not a video' do
      response = mock("response", :title => "Title", :thumbnail_url => "http://thumbnail.com/thumbnail.jpg", :thumbnail_height => 50, :thumbnail_width => 75, :type => 'image')
      @v.should_receive(:oembed_cached).and_return(response)

      lambda {@v.send(:update_metadata)}.should raise_error
    end
  end

  describe :oembed_cache_key do
    it 'should return embed key with maxwidth if specified' do
      @v.send(:oembed_cache_key, 300).should eql("video:oembed:http://youtube.com:300")
    end

    it 'should return embed key without maxwidth if not specified' do
      @v.send(:oembed_cache_key).should eql("video:oembed:http://youtube.com")
    end
  end


end