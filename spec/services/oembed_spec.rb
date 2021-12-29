require 'spec_helper'

describe Oembed do
  context 'returns' do
    context 'youtube video' do
      it 'valid' do
        oembed = Oembed.new "https://#{Oembed::YOUTUBE_DOMAIN}/watch?v=wGe5agueUwI"

        expect(oembed.show_video).to be_truthy
      end

      it 'invalid' do
        stub_request(:get, /#{Oembed::YOUTUBE_DOMAIN}/)
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(
            status: 404,
            body: '',
            headers: {}
          )

        oembed = Oembed.new "https://#{Oembed::YOUTUBE_DOMAIN}/invalid"

        expect(oembed.show_video).to be_falsey
      end
    end

    context 'vimeo video' do
      it 'valid' do
        oembed = Oembed.new "https://#{Oembed::VIMEO_DOMAIN}/46879129/"

        expect(oembed.show_video).to be_truthy
      end

      it 'invalid' do
        stub_request(:get, /#{Oembed::VIMEO_DOMAIN}/)
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(
            status: 404,
            body: '',
            headers: {}
          )

        oembed = Oembed.new "https://#{Oembed::VIMEO_DOMAIN}/invalid"

        expect(oembed.show_video).to be_falsey
      end
    end
  end
end
