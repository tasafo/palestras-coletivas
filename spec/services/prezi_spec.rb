require "spec_helper"

describe Prezi do
  context "returns" do
    context "prezi presentation" do
      it "valid" do
        oembed = Oembed.new "https://prezi.com/ggblugsq5p7h/soa-introducao/"

        expect(oembed.open_presentation).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /prezi.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "https://prezi.com/nononononono/nonononono/"

        expect(oembed.open_presentation).to be_falsey
      end
    end
  end
end
