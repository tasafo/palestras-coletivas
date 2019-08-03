require 'spec_helper'

describe UserMailer do
  let!(:user) { create(:user, :paul) }
  let(:mail) { UserMailer.password_reset(user.id.to_s) }
  let(:body) { mail.body }

  describe 'password_reset' do
    it 'sets subject' do
      expect(mail.subject).to eql('Redefinir senha')
    end

    it 'sets to recipient' do
      expect(mail.to).to include('paul@example.org')
    end

    it 'sets from recipient' do
      expect(mail.from).to include("no-reply@#{ENV['DEFAULT_URL']}")
    end
  end
end
