require "spec_helper"

describe User, "password hashing" do
  subject(:user) { User.new }

  it "generates hash" do
    PasswordEncryptor.should_receive(:encrypt).with("test")

    user.password = "test"
  end

  it "sets hash" do
    PasswordEncryptor.stub :encrypt => "hash"

    user.password = "test"

    expect(user.password_hash).to eql("hash")
  end

  it "sets password" do
    PasswordEncryptor.stub :encrypt

    user.password = "test"

    expect(user.password).to eql("test")
  end
end