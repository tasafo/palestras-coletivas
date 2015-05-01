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
end