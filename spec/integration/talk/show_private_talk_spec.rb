require "spec_helper"

describe "Show private talk", :type => :request, :js => true do
  let!(:user) { create(:user, :paul) }
  let!(:other_talk) { create(:other_talk, :users => [ user ], :owner => user) }

  context "when logged" do
    before do
      login_as(user)

      visit talks_path
      click_link "Minhas palestras"
      click_link "Ruby praticamente falando"
    end

    it "redirects to the show page" do
      expect(current_path).to eql(talk_path(other_talk))
    end

    it "displays detail talk" do
      expect(page).to have_content("Ruby praticamente falando")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      visit talk_path(other_talk)
    end

    it "redirects to the talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "displays error message" do
      expect(page).to have_content("Palestra não foi encontrado(a)")
    end
  end
end
