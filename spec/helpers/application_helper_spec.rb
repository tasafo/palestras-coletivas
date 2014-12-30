require "spec_helper"

describe ApplicationHelper, :type => :helper do
  describe "#gravatar_image" do
    let(:image) do
      helper.gravatar_image("paul@example.org", "Paul Young")
    end

    context "with regular expressions" do
      it "returns image" do
        expect(image).to match(%r[<img.*?])
      end

      it "sets url" do
        expect(image).to match(/[efac3492328ff47a6c761063c7cf794a?d=mm]/)
      end

      it "sets alternative text" do
        expect(image).to match(%r[alt="Paul Young"])
      end
    end

    context "with nokogiri" do
      let(:html) { Nokogiri::HTML(image).css("img").first }

      it "returns image" do
        expect(html).not_to be_nil
      end

      it "sets url" do
        expect(html["src"]).to eql("http://gravatar.com/avatar/efac3492328ff47a6c761063c7cf794a?d=mm")
      end

      it "sets alternative text" do
        expect(html["alt"]).to eql("Paul Young")
      end
    end
  end
end