require "spec_helper"

describe User, "password" do
  subject(:user) {
    User.new({
      :name => "Paul Young",
      :email => "paul@example.org",
      :password => "testdrive",
      :password_confirmation => "testdrive"
    })
  }

  it "cleans password after saving user" do
    user.save!
    expect(user.password).to be_nil
  end

  it "cleans password confirmation after saving user" do
    user.save!
    expect(user.password_confirmation).to be_nil
  end
end