require "spec_helper"

describe "Search event" do
  let!(:user) { create(:user, :paul) }
  let!(:tasafo) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }

  let!(:event) {
    create(
      :event,
      :tasafoconf,
      :users => [ user ],
      :groups => [ tasafo ],
      :owner => user.id
    )
  }
  
  context "without seeking" do
    before do
      visit root_path
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end

    it "displays access my account" do
      expect(page).to have_content("Eventos")
    end
  end

  context "with empty search" do
    before do
      visit root_path
      click_link "Eventos"
      fill_in :event_search, :with => ""
      click_button "Buscar"
    end

    it "redirects to events page" do
      expect(current_path).to eql(events_path)
    end

    it "displays access my account" do
      expect(page).to have_content("Eventos")
    end
  end

  context "when the search is successful" do
    before do
      visit root_path
      click_link "Eventos"
      fill_in :event_search, :with => "Tá Safo Conf"
      click_button "Buscar"
    end

    it "redirects to events page" do
      expect(current_path).to eql(events_path)
    end

    it "shows events found" do
      expect(page).to have_content("Tá Safo Conf")
    end
  end

  context "when the search is not successful" do
    before do
      visit root_path
      click_link "Eventos"
      fill_in :event_search, :with => "noob"
      click_button "Buscar"
    end

    it "redirects to events page" do
      expect(current_path).to eql(events_path)
    end

    it "shows events found" do
      expect(page).not_to have_content("Tá Safo Conf")
    end
  end

  context "when logged" do
    before do
      login_as(user)
      click_link "Eventos"
      click_link "Meus eventos"
    end

    it "redirects to the events page" do
      expect(current_path).to eql(events_path)
    end

    it "shows events found" do
      expect(page).to have_content("Tá Safo Conf")
    end
  end
end