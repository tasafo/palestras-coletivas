require "spec_helper"

describe Gravatar do
  context "generates" do
    it "MD5 from e-mail" do
      expect(Digest::MD5).to receive(:hexdigest).with("paul@example.org")

      Gravatar.new("paul@example.org").get_fields
    end
  end

  context "returns values" do
    before do
      allow(Digest::MD5).to receive_messages :hexdigest => "abc123"
    end

    it "url" do
      url = Gravatar.new("paul@example.org").url

      expect(url).to eql("http://gravatar.com/avatar/abc123?d=mm")
    end

    it "profile" do
      profile = Gravatar.new("paul@example.org").profile

      expect(profile).to eql("http://gravatar.com/abc123")
    end

    it "invalid gravatar" do
      stub_request(:get, /gravatar.com/).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 404,
          :body => '',
          :headers => {}
        )

      gravatar = Gravatar.new("invalid").get_fields

      expect(gravatar.has_profile).to be_falsey
    end
  end

  context "returns facebook photo" do
    it "valid" do
      photo_url = Gravatar.get_facebook_photo("https://facebook.com/luizgrsanches")

      expect(photo_url).to be_truthy
    end

    it "invalid" do
      stub_request(:get, /graph.facebook.com/).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 404,
          :body => '',
          :headers => {}
        )

      photo_url = Gravatar.get_facebook_photo("https://facebook.com/1")

      expect(photo_url).to be_falsey
    end
  end
end