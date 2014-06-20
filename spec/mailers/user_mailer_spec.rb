require "spec_helper"

describe UserMailer, :type => :mailer do
  describe "password_reset" do
    let!(:user) { create(:user, :paul) }
    let(:mail) { UserMailer.password_reset(user) }

    it "sets subject" do
      expect(mail.subject).to eql("Redefinir senha")
    end

    it "sets to recipient" do
      expect(mail.to).to include("paul@example.org")
    end

    it "sets from recipient" do
      expect(mail.from).to include("no-reply@palestrascoletivas.com")
    end

    context "text format" do
      let(:body) { mail.body }

      it_behaves_like "password reset email"
    end
  end
end
