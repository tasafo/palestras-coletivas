require "spec_helper"

describe User, "validations" do
  it "accepts valid attribuites" do
    user = User.new({
      :name => "Luiz Sanches",
      :email => "luiz@example.org",
      :password => "teste",
      :password_confirmation => "teste"
    })

    expect(user).to be_valid
  end

  it "requires name" do
    user = User.create(:name => nil)

    expect(user).to have(1).error_on(:name)
  end

  it "requires email" do
    user = User.create(:email => nil)

    expect(user).to have(1).error_on(:email)
  end

  it "requires valid e-mail" do
    user = User.create(:email => "invalid")

    expect(user).to have(1).error_on(:email)
  end

  it "accepts valid e-mail" do
    user = User.new(:email => "luiz@example.org")

    user.valid?

    expect(user).to have(:no).error_on(:email)
  end

  it "requires password" do
    user = User.new(:password => nil)

    expect(user).to have(1).error_on(:password)
  end

  it "requires password confirmation" do
    user = User.new(
      :password => "teste",
      :password_confirmation => "invalid"
    )

    expect(user).to have(1).error_on(:password)
  end

  it "set password hash when setting password" do
    user = User.new(:password => "teste")
    expect(user.password_hash).not_to be_blank
  end

  context "when updating attributes" do
    let!(:user) { build(:user) }

    it "validates password when password has been set" do
      user.password = nil
      user.valid?

      expect(user).to have_at_least(1).error_on(:password)
    end

    it "skips password validation when not setting password" do
      user.valid?
      expect(user).to have(:no).errors_on(:password)
    end
  end
end