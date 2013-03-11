require "spec_helper"

describe PasswordEncryptor do
  let(:encryptor) { mock("encryptor") }

  it "sets encryptor to BCrypt" do
    expect(PasswordEncryptor.encryptor).to eql(BCrypt::Password)
  end

  context "encrypting password" do
    it "encrypts password" do
      PasswordEncryptor.stub :encryptor => encryptor

      encryptor.should_receive(:create).with("test")

      PasswordEncryptor.encrypt("test")
    end
  end

  context "validating password" do
    before do
      PasswordEncryptor.stub :encryptor => encryptor
    end

    it "instantiates encryptor" do
      encryptor.should_receive(:new).with("some hash")
      PasswordEncryptor.valid?("some hash", "test")
    end

    it "is valid when password is correct" do
      encryptor.stub :new => "test"
      expect(PasswordEncryptor).to be_valid("some hash", "test")
    end

    it "is invalid when password is incorrect" do
      encryptor.stub :new => "test"
      expect(PasswordEncryptor).not_to be_valid("some hash", "invalid")
    end
  end
end