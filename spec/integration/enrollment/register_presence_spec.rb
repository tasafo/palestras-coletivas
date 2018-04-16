require "spec_helper"

describe "Register presence", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:event) {
    create(
      :event,
      :tasafoconf,
      :start_date => Date.today,
      :end_date => Date.today,
      :deadline_date_enrollment => Date.today,
      :users => [ user ],
      :owner => user
    )
  }

  let!(:enrollment_billy) { create(:enrollment, :event => event, :user => other_user) }
  let!(:enrollment_luis) { create(:enrollment, :present => true, :event => event, :user => another_user) }

  context "when the user is not present" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "user_id_#{other_user.id}"
      click_button "Alterar participação"
    end

    it "redirects to the event page" do
      expect(current_path).to eql(event_path(event))
    end

    it "displays success message" do
      expect(page).to have_content("A inscrição foi alterada!")
    end
  end

  context "when the user is already present" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "user_id_#{another_user.id}"
      click_button "Alterar participação"
    end

    it "redirects to the event page" do
      expect(current_path).to eql(event_path(event))
    end

    it "displays success message" do
      expect(page).to have_content("A inscrição foi alterada!")
    end
  end

  context "when the user does not have permission" do
    before do
      login_as(other_user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      visit edit_event_enrollment_path(event, :present, enrollment_luis)
    end

    it "redirects to the event page" do
      expect(current_path).to eql(event_path(event))
    end

    it "displays error message" do
      expect(page).to have_content("Você não tem permissão para acessar esta página.")
    end
  end
end
