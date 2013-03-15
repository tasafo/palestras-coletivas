require "./app/models/gravatar"
require "digest/md5"

describe Gravatar do
  it "generates MD5 from e-mail" do
    Digest::MD5.should_receive(:hexdigest).with("paul@example.org")

    Gravatar.url("paul@example.org")
  end

  context "returns values" do
    before do
      Digest::MD5.stub :hexdigest => "abc123"
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