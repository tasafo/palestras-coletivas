require "./app/services/gravatar"
require "digest/md5"

describe Gravatar do
  it "generates MD5 from e-mail" do
    expect(Digest::MD5).to receive(:hexdigest).with("paul@example.org")

    Gravatar.new("paul@example.org")
  end

  context "returns values" do
    before do
      allow(Digest::MD5).to receive_messages :hexdigest => "abc123"
    end

    it "returns url" do
      url = Gravatar.new("paul@example.org").url

      expect(url).to eql("http://gravatar.com/avatar/abc123?d=mm")
    end

    it "returns profile" do
      profile = Gravatar.new("paul@example.org").profile

      expect(profile).to eql("http://gravatar.com/abc123")
    end
  end
end