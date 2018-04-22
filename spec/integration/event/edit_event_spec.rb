require "spec_helper"

describe "Edit event", :type => :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:event) {
    create(
      :event,
      :tasafoconf,
      users: [ user, other_user ],
      owner: user,
      start_date: Date.today,
      end_date: Date.today + 1.month
    )
  }

  context "with valid data" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Editar evento"

      fill_in "Nome", :with => "Confraternização do Tá safo!"
      fill_in "Tags", :with => "agilidade, gestão"

      click_button :"user_id_#{other_user.id}"

      click_button "Atualizar evento"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("O evento foi atualizado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Editar evento"

      fill_in "Nome", :with => ""

      click_button "Atualizar evento"
    end

    it "renders form page" do
      expect(current_path).to eql(event_path(event))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the event is not user" do
    before do
      login_as(another_user)
      visit edit_event_path(event)
    end

    it "redirects to the events page" do
      expect(current_path).to eql(events_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Você não tem permissão para acessar esta página.")
    end
  end
end
