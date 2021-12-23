require 'spec_helper'

describe Slideshare do
  context 'returns' do
    context 'slideshare presentation' do
      it 'valid' do
        oembed = Oembed.new "#{Slideshare::URL}/luizsanches/ruby-praticamente-falando"

        expect(oembed.open_presentation).to be_truthy
      end

      it 'invalid' do
        stub_request(:get, /#{Slideshare::DOMAIN}/)
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(
            status: 404,
            body: '',
            headers: {}
          )

        oembed = Oembed.new "#{Slideshare::URL}/luizsanches/nononono"

        expect(oembed.open_presentation).to be_falsey
      end
    end
  end
end
