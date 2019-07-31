require 'spec_helper'

describe User, 'password hashing' do
  subject(:user) { User.new }

  it 'generates hash' do
    expect(PasswordEncryptor).to receive(:encrypt).with('test')

    user.password = 'test'
  end

  it 'sets hash' do
    allow(PasswordEncryptor).to receive_messages encrypt: 'hash'

    user.password = 'test'

    expect(user.password_hash).to eql('hash')
  end

  it 'sets password' do
    allow(PasswordEncryptor).to receive :encrypt

    user.password = 'test'

    expect(user.password).to eql('test')
  end
end
