require "spec_helper"

describe "Edit user", :type => :request do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }

  context "with valid data" do
    before do
      login_as user
      visit edit_user_path(user)

      fill_in "Seu nome", :with => "Carl Simon"
      attach_file('Foto', File.absolute_path("#{Rails.root}/app/assets/images/without_avatar.jpg"))

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
      visit edit_user_path(user)

      fill_in "Seu nome", :with => ""
      attach_file('Foto', File.absolute_path("#{Rails.root}/app/assets/images/without_avatar.jpg"))

      click_button "Atualizar dados"
    end

    it "renders form page" do
      expect(current_path).to eql(user_path(user))
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

    it "redirects to the home page" do
      expect(current_path).to eql(root_path)
    end
  end

  context "with valid password" do
    before do
      login_as user
      visit edit_user_path(user)

      fill_in "Sua senha", :with => "newpassword"
      fill_in "Confirme sua senha", :with => "newpassword"
      attach_file('Foto', File.absolute_path("#{Rails.root}/app/assets/images/without_avatar.jpg"))

      click_button "Atualizar dados"
    end

    it "redirects to the user show page" do
      expect(current_path).to match(%r[/users/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Seus dados foram atualizados!")
    end
  end

  context "with invalid password" do
    before do
      login_as user
      visit edit_user_path(user)

      fill_in "Sua senha", :with => "newpassword"
      fill_in "Confirme sua senha", :with => "otherpassword"
      attach_file('Foto', File.absolute_path("#{Rails.root}/app/assets/images/without_avatar.jpg"))

      click_button "Atualizar dados"
    end

    it "renders form page" do
      expect(current_path).to eql(user_path(user))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end
