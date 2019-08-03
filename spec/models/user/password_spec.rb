require 'spec_helper'

describe User, 'password' do
  subject(:user) { create(:user, :paul) }

  it 'cleans password after saving user' do
    user.save!
    expect(user.password).to be_nil
  end

  it 'cleans password confirmation after saving user' do
    user.save!
    expect(user.password_confirmation).to be_nil
  end
end
