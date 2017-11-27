require "spec_helper"

describe User, "validations", :type => :model do
  let!(:user) { create(:user, :paul) }

  context "when valid data" do
    it "accepts valid attribuites" do
      expect(user).to be_valid
    end
  end

  it "requires name" do
    user = User.create(:name => nil)

    expect(user.errors[:name].size).to eq(2)
  end

  it "requires username" do
    expect {user.username = nil}.to change { user.valid? }
  end

  it "uniquiness of username" do
    duplicated_user = create(:user, :random)
    expect {duplicated_user.username = user.username}.to change { duplicated_user.valid? }
  end

  it "format of username is valid if it looks like twitter username" do
    user.username = "@user"
    expect(user).to be_valid

    user.username = "@user12"
    expect(user).to be_valid

    user.username = "@u12ser"
    expect(user).to be_valid

    user.username = "@user_name21"
    expect(user).to be_valid

    user.username = "@Username"
    expect(user).to be_invalid

    user.username = "@user_name*"
    expect(user).to be_invalid

    user.username = "@12user"
    expect(user).to be_invalid

    user.username = "@"
    expect(user).to be_invalid

    user.username = "@1111"
    expect(user).to be_invalid

    user.username = "@user name"
    expect(user).to be_invalid

    user.username = "@use" # 3 digits
    expect(user).to be_invalid
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

    expect(user.errors[:password_confirmation].size).to eq(1)
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

      expect(user.errors[:password_confirmation].size).to be >= 1
    end

    it "skips password validation when not setting password" do
      user.valid?

      expect(user.errors[:password].size).to eq(0)
    end
  end

  context "when you have" do
    let!(:paul) { build(:user, :paul) }
    let!(:billy) { build(:user, :billy) }
    let!(:luis) { build(:user, :luis) }

    it "gravatar photo" do
      expect(paul.thumbnail).to eq("/assets/without_avatar.jpg")
    end

    it "no photo" do
      expect(luis.thumbnail).to eq("without_avatar.jpg")
    end
  end
end
