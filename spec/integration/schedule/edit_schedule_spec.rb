require "spec_helper"

describe "Edit schedule" do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user.id) }

  let!(:session_lanche) { create(:session, :lanche) }

  let!(:schedule_abertura) { create(:schedule, :abertura, :event => event) }
  let!(:schedule_palestra) { create(:schedule, :palestra, :event => event) }
  let!(:schedule_intervalo) { create(:schedule, :intervalo, :event => event) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, :event => event) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "schedule_id_#{schedule_palestra2.id}"

      select "06/06/2012", :from => "schedule_date"

      fill_in "Hora", :with => "08:00"

      click_button "Atualizar programação"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A programação foi atualizada!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "schedule_id_#{schedule_palestra2.id}"
      
      fill_in "Hora", :with => ""
      
      click_button "Atualizar programação"
    end

    it "renders form page" do
      expect(current_path).to eql(edit_schedule_path(event, schedule_palestra2))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end