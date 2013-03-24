require "spec_helper"

describe "Edit group", :js => true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:group) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Grupos"
      click_link "Tá safo!"
      click_link "Editar"

      fill_in "Nome", :with => "Tá safo!"
      fill_in "Tags", :with => "agilidade"

      click_button "Atualizar grupo"
    end

    it "redirects to the group page" do
      expect(current_path).to match(%r[/groups/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Seu grupo foi atualizado!")
    end
  end

  context "when members add" do
    before do
      login_as(user)
      visit root_path

      click_link "Grupos"
      click_link "Tá safo!"
      click_link "Editar"

      fill_in "Nome", :with => "Tá safo!"
      fill_in "Tags", :with => "agilidade"

      select other_user.name, :from => "user_id"
      click_button :add_member

      click_button "Atualizar grupo"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/groups/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Seu grupo foi atualizado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Grupos"
      click_link "Tá safo!"
      click_link "Editar"

      fill_in "Nome", :with => ""

      click_button "Atualizar grupo"
    end

    it "renders form page" do
      expect(current_path).to eql(edit_group_path(group))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the group is not user" do
    before do
      login_as(other_user)
      visit edit_group_path(group)
    end

    it "redirects to the groups page" do
      expect(current_path).to eql(groups_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Você não tem permissão para acessar esta página.")
    end
  end
end