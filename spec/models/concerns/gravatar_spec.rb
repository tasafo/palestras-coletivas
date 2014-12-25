require "./app/models/concerns/gravatar"
require "digest/md5"

describe Gravatar, :type => :model do
  it "generates MD5 from e-mail" do
    expect(Digest::MD5).to receive(:hexdigest).with("paul@example.org")

    Gravatar.url("paul@example.org")
  end

  context "returns values" do
    before do
      allow(Digest::MD5).to receive_messages :hexdigest => "abc123"
    end

    it "returns url" do
      url = Gravatar.url("paul@example.org")

      expect(url).to eql("http://gravatar.com/avatar/abc123?d=mm")
    end

    it "returns profile" do
      profile = Gravatar.profile("paul@example.org")

      expect(profile).to eql("http://gravatar.com/abc123")
    end
  end
end