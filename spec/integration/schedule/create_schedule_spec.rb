require "spec_helper"

describe "Create schedule" do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user.id) }
  let!(:session_abertura) { create(:session, :abertura) }
  let!(:session_palestra) { create(:session, :palestra) }
  let!(:session_intervalo) { create(:session, :intervalo) }

  context "with valid interval" do
    before do
      login_as(user)
      visit root_path

      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "Adicionar programação"

      select "05/06/2012", :from => "schedule_date"

      fill_in "Hora", :with => "08:00"

      select session_abertura.description, :from => "schedule_session_id"

      click_button "Adicionar programação"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A programação foi adicionada!")
    end
  end

  context "with invalid interval" do
    before do
      login_as(user)
      visit root_path
      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "Adicionar programação"
      click_button "Adicionar programação"
    end

    it "renders form page" do
      expect(current_path).to eql(new_schedule_path(event))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end