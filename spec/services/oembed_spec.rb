require "./app/services/oembed"

describe Oembed do
  context "returns" do
    it "valid slideshsare presentation" do
      oembed = Oembed.new "http://pt.slideshare.net/luizsanches/ruby-praticamente-falando"

      expect(oembed.open_presentation).to be_truthy
    end

    it "invalid slideshare presentation" do
      oembed = Oembed.new "http://pt.slideshare.net/luizsanches/nononono"

      expect(oembed.open_presentation).to be_falsey
    end

    it "valid speakerdeck presentation" do
      oembed = Oembed.new "https://speakerdeck.com/luizsanches/ruby-praticamente-falando"

      expect(oembed.open_presentation).to be_truthy
    end

    it "invalid speakerdeck presentation" do
      oembed = Oembed.new "https://speakerdeck.com/luizsanches/nononono"

      expect(oembed.open_presentation).to be_falsey
    end

    it "valid prezi presentation" do
      oembed = Oembed.new "https://prezi.com/ggblugsq5p7h/soa-introducao/"

      expect(oembed.open_presentation).to be_truthy
    end

    it "invalid prezi presentation" do
      oembed = Oembed.new "https://prezi.com/nononononono/nonononono/"

      expect(oembed.open_presentation).to be_falsey
    end
  end
end