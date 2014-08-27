require "spec_helper"

describe "Show user profile", :type => :request do
  let!(:user) { create(:user, :luis) }
  let!(:other_user) { create(:user, :billy) }

  context "when user valid" do
    before do
      visit root_path
      visit user_path(user)
    end

    it "redirects to the show user profile page" do
      expect(current_path).to eql(user_path(user))
    end

    it "displays user profile" do
      expect(page).to have_content("Luis Miguel")
    end
  end

  context "when user invalid" do
    before do
      visit root_path
      visit "/users/00000111111000000111111"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(root_path)
    end

    it "displays error message" do
      expect(page).to have_content("Usuário não cadastrado.")
    end
  end

  context "when the user does not have e-mail at Gravatar" do
    before do
      visit root_path
      visit user_path(other_user)
    end

    it "redirects to the show user profile page" do
      expect(current_path).to eql(user_path(other_user))
    end

    it "displays user profile" do
      expect(page).to have_content("Billy Paul")
    end
  end
end