require "spec_helper"

describe "Show private talk" do
  let!(:other_talk) { create(:other_talk) }
  let(:user) { other_talk.user }

  context "when logged" do
    before do
      login_as(user)
      visit root_path
      click_link "Minhas palestras"
      click_link "Compartilhe"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(other_talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Compartilhe")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      visit talk_path(other_talk)
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(other_talk))
    end

    it "displays error message" do
      expect(page).to have_content("A palestra ainda não está publicada")
    end
  end
end