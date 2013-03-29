require "spec_helper"

describe "See events" do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:event) { create(:event, :tasafoconf, :users => [ user, other_user ], :owner => user.id) }

  context "with one event" do
    before do
      visit root_path
      click_link "Eventos"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(events_path)
    end

    it "displays at least one event" do
      expect(page).to have_content("Tá Safo Conf")
    end
  end
end