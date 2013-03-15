require "spec_helper"

describe "Show user profile" do
  let!(:user) { create(:user, :email => "luizgrsanches@gmail.com") }
  let!(:user_no_gravatar) { create(:user, :name => "Billy Paul") }

  context "when user valid" do
    before do
      visit root_path
      visit user_path(user)
    end

    it "redirects to the show user profile page" do
      expect(current_path).to eql(user_path(user))
    end

    it "displays user profile" do
      expect(page).to have_content("Paul Young")
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
  end

  context "when the user does not have e-mail at Gravatar" do
    before do
      visit root_path
      visit user_path(user_no_gravatar)
    end

    it "redirects to the show user profile page" do
      expect(current_path).to eql(root_path)
    end
  end
end