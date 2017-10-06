require "spec_helper"

describe "Logout", :type => :request do
  context "when logged in" do
    let!(:user) { create(:user, :paul) }

    before do
      login_as user

      visit root_path
      first(".link-logout").click
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end

    it "doesn't render name" do
      expect(page).not_to have_content("Olá, #{user.name}")
    end
  end

  context "when unlogged" do
    before do
      visit logout_path
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end
  end
end
