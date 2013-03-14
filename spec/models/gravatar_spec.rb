require "./app/models/gravatar"
require "digest/md5"

describe Gravatar do
  it "generates MD5 fro e-mail" do
    Digest::MD5.should_receive(:hexdigest).with("paul@example.org")

    Gravatar.url("paul@example.org")
  end

  it "returns url" do
    Digest::MD5.stub :hexdigest => "abc123"

    url = Gravatar.url("paul@example.org")

    expect(url).to eql("http://gravatar.com/avatar/abc123?d=mm")
  end
end