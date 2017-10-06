require "spec_helper"

describe "See events", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:event) { create(:event, :tasafoconf, :users => [ user, other_user ], :owner => user) }

  context "public events" do
    before do
      visit root_path
      find(".event-link").click
    end

    it "redirects to the home page" do
      expect(current_path).to eql(events_path)
    end

    it "displays at least one event" do
      expect(page).to have_content("Tá Safo Conf")
    end
  end

  context "user events" do
    before do
      login_as(user)
      find(".event-link").click
      click_link "Meus eventos"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(events_path)
    end

    it "displays at least one event" do
      expect(page).to have_content("Tá Safo Conf")
    end
  end
end
