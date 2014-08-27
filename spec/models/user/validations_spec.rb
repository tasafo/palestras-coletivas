require "spec_helper"

describe User, "validations", :type => :model do
  context "when valid data" do
    let!(:user) { create(:user, :paul) }
    
    it "accepts valid attribuites" do
      expect(user).to be_valid
    end
  end

  it "requires name" do
    user = User.create(:name => nil)

    expect(user.errors[:name].size).to eq(2)
  end

  it "requires email" do
    user = User.create(:email => nil)

    expect(user.errors[:email].size).to eq(1)
  end

  it "requires valid e-mail" do
    user = User.create(:email => "invalid")

    expect(user.errors[:email].size).to eq(1)
  end

  it "accepts valid e-mail" do
    user = User.create(:email => "luiz@example.org")

    expect(user.errors[:email].size).to eq(0)
  end

  it "requires password" do
    user = User.create(:password => nil)

    expect(user.errors[:password].size).to eq(1)
  end

  it "requires password confirmation" do
    user = User.create(
      :password => "testdrive",
      :password_confirmation => "invalid!"
    )

    expect(user.errors[:password].size).to eq(1)
  end

  it "set password hash when setting password" do
    user = User.create(:password => "testdrive")

    expect(user.password_hash).not_to be_blank
  end

  context "when updating attributes" do
    let!(:user) { build(:user, :paul) }

    it "validates password when password has been set" do
      user.password = "test"
      user.valid?

      expect(user.errors[:password].size).to be >= 1
    end

    it "skips password validation when not setting password" do
      user.valid?

      expect(user.errors[:password].size).to eq(0)
    end
  end
end