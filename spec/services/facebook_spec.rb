require "spec_helper"

describe Facebook do
  context "returns thumbnail url" do
    it "valid" do
      thumbnail_url = Facebook.thumbnail("https://facebook.com/luizgrsanches")

      expect(thumbnail_url).to be_truthy
    end

    it "invalid" do
      stub_request(:get, /graph.facebook.com/).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 404,
          :body => '',
          :headers => {}
        )

      thumbnail_url = Facebook.thumbnail("https://facebook.com/1")

      expect(thumbnail_url).to be_falsey
    end
  end
end
