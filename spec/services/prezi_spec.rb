require 'spec_helper'

describe Prezi do
  context 'returns' do
    context 'prezi presentation' do
      it 'valid' do
        oembed = Oembed.new "#{Prezi::URL}/ggblugsq5p7h/soa-introducao/"

        expect(oembed.open_presentation).to be_truthy
      end

      it 'invalid' do
        stub_request(:get, /#{Prezi::DOMAIN}/)
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(
            status: 404,
            body: '',
            headers: {}
          )

        oembed = Oembed.new "#{Prezi::URL}/nononononono/nonononono/"

        expect(oembed.open_presentation).to be_falsey
      end
    end
  end
end
