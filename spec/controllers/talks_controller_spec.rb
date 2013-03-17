require "spec_helper"

describe TalksController do
  context "POST :info_url" do
    before do
      post :info_url, :link => "http://www.slideshare.net/luizsanches/compartilhe", :format => "xml"
    end

    xit "returns status 200" do
      expect(response.status).to eql(200)
    end
  end
end