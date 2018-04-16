require "spec_helper"

describe "Create schedule", :type => :request, :js => true do
  let!(:user) { create(:user, :paul) }

  let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user) }

  let!(:talk) { create(:talk, :users => [ user ], :owner => user) }
  let!(:another_talk) { create(:another_talk, :users => [ user ], :owner => user) }

  let!(:activity_abertura) { create(:activity, :abertura) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:activity_intervalo) { create(:activity, :intervalo) }

  context "with valid interval" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Adicionar programação"

      select "05/06/2012", :from => "schedule_day"

      fill_in_inputmask "Horário", :with => "08:00"

      select activity_abertura.description, :from => "schedule_activity_id"

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

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Adicionar programação"
      click_button "Adicionar programação"
    end

    it "renders form page" do
      expect(current_path).to eql(event_schedules_path(event))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "with valid talk" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Adicionar programação"

      select "05/06/2012", :from => "schedule_day"

      fill_in_inputmask "Horário", :with => "08:00"

      select activity_palestra.description, :from => "schedule_activity_id"

      fill_in :search_text, :with => "tecnologia"

      click_button "Buscar"

      click_button talk.id

      click_button "Adicionar programação"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A programação foi adicionada!")
    end
  end
end
