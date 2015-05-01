require "spec_helper"

describe "Send password resets", :type => :request do
  let!(:user) { create(:user, :paul) }

  context "when valid data" do
    before do
      visit root_path
      click_link "Acesso"
      click_link "Minha conta"
      click_link "Esqueceu a senha?"

      fill_in "Seu e-mail", :with => user.email

      click_button "Redefinir senha"
    end

    it "redirects to the home page" do
      expect(current_path).to eql(new_password_reset_path)
    end

    it "displays success message" do
      expect(page).to have_content("E-mail enviado com as instruções de redefinição de senha.")
    end
  end

  context "when invalid data" do
    before do
      visit root_path
      click_link "Acesso"
      click_link "Minha conta"
      click_link "Esqueceu a senha?"

      fill_in "Seu e-mail", :with => "notfound@mail.com"

      click_button "Redefinir senha"
    end

    it "renders form page" do
      expect(current_path).to eql(new_password_reset_path)
    end

    it "displays error messages" do
      expect(page).to have_content("E-mail não encontrado.")
    end
  end
end
