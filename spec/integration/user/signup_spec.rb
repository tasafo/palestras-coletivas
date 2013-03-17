require "spec_helper"

describe "Signup" do
  context "with valid data" do
    before do
      visit root_path

      click_link "Cadastre-se"

      fill_in "Seu primeiro e último nome", :with => "Paul Young"
      fill_in "Seu e-mail", :with => "paul@example.org"
      fill_in "Sua senha", :with => "testdrive"
      fill_in "Confirme sua senha", :with => "testdrive"

      click_button "Cadastre-me"
    end

    it "redirects to the the login page" do
      expect(current_path).to eql(login_path)
    end

    it "displays sucess message" do
      expect(page).to have_content("Seu cadastro foi realizado com sucesso")
    end
  end

  context "with invalid data" do
    before do
      visit root_path
      click_link "Cadastre-se"
      click_button "Cadastre-me"
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end