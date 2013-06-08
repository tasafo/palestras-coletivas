require "spec_helper"

describe "Create event" do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:group) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }
  let!(:other_group) { create(:group, :gurupa, :users => [ user ], :owner => user.id) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Eventos"
      click_link "Adicionar evento"

      fill_in "Nome", :with => "Tá Safo Conf"
      fill_in "Edição", :with => "2012"
      fill_in "Descrição", :with => "Evento de tecnologia que vem com sua 1ª edição na região"
      fill_in "Lotação", :with => 100
      fill_in "Tags", :with => "tecnologia, agilidade, gestão"
      fill_in_inputmask "Data de início", :with => "05/06/2012"
      fill_in_inputmask "Data de término", :with => "06/06/2012"
      fill_in_inputmask "Prazo para inscrição", :with => "06/06/2012"
      fill_in "Local", :with => "Centro de Convenções do Jurunas"
      fill_in "Endereço", :with => "Rua dos Caripunas, 800"
      fill_in "Bairro", :with => "Jurunas"
      fill_in "Cidade", :with => "Belém"
      fill_in "Estado", :with => "Pará"
      fill_in "País", :with => "Brasil"
      check("Quero publicar")

      select other_user.name, :from => "user_id"
      click_button :add_user

      select another_user.name, :from => "user_id"
      click_button :add_user

      select group.name, :from => "group_id"
      click_button :add_group

      click_button "Adicionar evento"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("O evento foi adicionado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Eventos"
      click_link "Adicionar evento"
      click_button "Adicionar evento"
    end

    it "renders form page" do
      expect(current_path).to eql(events_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end
