require "spec_helper"

describe "Edit event" do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:tasafo) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }
  let!(:gurupa) { create(:group, :gurupa, :users => [ user ], :owner => user.id) }

  let!(:event) {
    create(
      :event,
      :tasafoconf,
      :users => [ user, other_user ],
      :groups => [ tasafo ],
      :owner => user.id
    )
  }
    
  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "Editar evento"

      fill_in "Nome", :with => "Confraternização do Tá safo!"
      fill_in "Tags", :with => "agilidade, gestão"

      select another_user.name, :from => "user_id"
      click_button :add_user

      select gurupa.name, :from => "group_id"
      click_button :add_group

      click_button :"user_id_#{other_user.id}"

      click_button :"group_id_#{tasafo.id}"

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
      visit root_path

      click_link "Eventos"
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