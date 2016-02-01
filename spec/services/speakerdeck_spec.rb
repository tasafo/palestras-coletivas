require "spec_helper"

describe Speakerdeck do
  context "returns" do
    context "speakerdeck presentation" do
      it "valid" do
        oembed = Oembed.new "https://speakerdeck.com/luizsanches/ruby-praticamente-falando"

        expect(oembed.open_presentation).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /speakerdeck.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "https://speakerdeck.com/luizsanches/nononono"

        expect(oembed.open_presentation).to be_falsey
      end
    end
  end
end
