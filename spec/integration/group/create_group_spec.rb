require "spec_helper"

describe "Create group", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Grupos"
      click_link "Adicionar grupo"

      fill_in "Url do gravatar", :with => "http://gravatar.com/tasafo"
      fill_in "Nome", :with => "Tá safo!"
      fill_in "Tags", :with => "agilidade, gestão de projetos, engenharia de software"

      select other_user.name, :from => "user_id"
      click_button :add_user

      click_button "Adicionar grupo"
    end

    it "redirects to the group page" do
      expect(current_path).to match(%r[/groups/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("O grupo foi adicionado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Grupos"
      click_link "Adicionar grupo"
      click_button "Adicionar grupo"
    end

    it "renders form page" do
      expect(current_path).to eql(groups_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the gravatar are not found" do
    before do
      login_as(user)
      visit root_path

      click_link "Grupos"
      click_link "Adicionar grupo"

      fill_in "Url do gravatar", :with => "http://gravatar.com/00109blamrin"
      fill_in "Nome", :with => "Tá safo!"
    end

    it "displays error message" do
      expect(page).to have_content("Avatar não encontrado")
    end
  end
end