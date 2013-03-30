require "spec_helper"

describe "Show public talk" do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  context "when logged" do
    before do
      login_as(user)
      visit root_path
      click_link "Trabalhos"
      click_link "Compartilhe"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Compartilhe")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      visit talk_path(talk)
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Compartilhe")
    end
  end
end