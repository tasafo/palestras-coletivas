require "spec_helper"

describe "Event not found" do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:event) {
    create(
      :event,
      :tasafoconf,
      :to_public => false,
      :users => [ user ],
      :owner => user.id
    )
  }

  context "when event does not exist" do
    before do
      visit root_path
      visit "/events/00000111111000000111111"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(root_path)
    end
  end

  context "when the user is logged and the event is not public" do
    before do
      login_as other_user
      visit event_path(event)
    end

    it "redirects to the home page" do
      expect(current_path).to eql(event_path(event))
    end
    
    it "displays error message" do
      expect(page).to have_content("Evento não encontrado")
    end
  end

  context "when the user is not logged and the event is not public" do
    before do
      visit event_path(event)
    end

    it "redirects to the home page" do
      expect(current_path).to eql(event_path(event))
    end
    
    it "displays error message" do
      expect(page).to have_content("Evento não encontrado")
    end
  end
end