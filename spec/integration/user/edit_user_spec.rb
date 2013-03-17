require "spec_helper"

describe "Edit user" do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  context "with valid data" do
    before do
      login_as user
      visit root_path
      click_link "Meus dados"

      fill_in "Seu primeiro e último nome", :with => "Carl Simon"

      click_button "Atualizar dados"
    end

    it "redirects to the user show page" do
      expect(current_path).to match(%r[/users/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Seus dados foram atualizados!")
    end
  end

  context "with invalid data" do
    before do
      login_as user
      visit root_path
      click_link "Meus dados"

      fill_in "Seu primeiro e último nome", :with => ""

      click_button "Atualizar dados"
    end

    it "renders form page" do
      expect(current_path).to eql(edit_user_path(user))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the current user is not user" do
    before do
      login_as(other_user)
      visit edit_user_path(user)
    end

    it "redirects to the talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Você não tem permissão para acessar esta página.")
    end
  end
end