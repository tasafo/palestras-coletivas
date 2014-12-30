require "spec_helper"

describe PasswordEncryptor do
  let(:encryptor) { double("encryptor") }

  it "sets encryptor to BCrypt" do
    expect(PasswordEncryptor.encryptor).to eql(BCrypt::Password)
  end

  context "encrypting password" do
    it "encrypts password" do
      allow(PasswordEncryptor).to receive_messages :encryptor => encryptor

      expect(encryptor).to receive(:create).with("test")

      PasswordEncryptor.encrypt("test")
    end
  end

  context "validating password" do
    before do
      allow(PasswordEncryptor).to receive_messages :encryptor => encryptor
    end

    it "instantiates encryptor" do
      expect(encryptor).to receive(:new).with("some hash")
      PasswordEncryptor.valid?("some hash", "test")
    end

    it "is valid when password is correct" do
      allow(encryptor).to receive_messages :new => "test"
      expect(PasswordEncryptor).to be_valid("some hash", "test")
    end

    it "is invalid when password is incorrect" do
      allow(encryptor).to receive_messages :new => "test"
      expect(PasswordEncryptor).not_to be_valid("some hash", "invalid")
    end
  end
end
