require "spec_helper"

describe "Login" do
  context "with valids credential" do
    let!(:user) { create(:user, :paul) }

    before do
      visit root_path

      click_link "Minha conta"

      fill_in "Seu e-mail", :with => user.email
      fill_in "Sua senha", :with => "testdrive"

      click_button "Acessar minha conta"
    end

    it "redirects to home page" do
      expect(current_path).to eql(root_path)
    end

    it "displays greeting message" do
      expect(page).to have_content("Olá, Paul Young")
    end
  end

  context "with invalid credentials" do
    before do
      visit root_path
      click_link "Minha conta"
      click_button "Acessar minha conta"
    end

    it "displays error message" do
      expect(page).to have_content("E-mail/senha inválidos.")
    end

    it "displays login page" do
      expect(current_path).to eql(login_path)
    end
  end
end
