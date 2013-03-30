require "spec_helper"

describe "Create talk", :js => true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Trabalhos"
      click_link "Adicionar trabalho"

      fill_in "Link do slideshare", :with => "http://www.slideshare.net/luizsanches/compartilhe"
      fill_in "Descrição", :with => "Palestra que fala sobre o compartilhamento de conhecimento na era da informação"
      fill_in "Tags", :with => "conhecimento, compartilhamento"
      check("Quero publicar")

      select other_user.name, :from => "user_id"
      click_button :add_user

      click_button "Adicionar trabalho"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("O trabalho foi adicionado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Trabalhos"
      click_link "Adicionar trabalho"
      
      click_button "Adicionar trabalho"
    end

    it "renders form page" do
      expect(current_path).to eql(new_talk_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the slides are not found" do
    before do
      login_as(user)
      visit root_path

      click_link "Trabalhos"
      click_link "Adicionar trabalho"

      fill_in "Link do slideshare", :with => "http://www.slideshare.net/luizsanches/invalid"
      fill_in "Titulo", :with => "Compartilhe!"
    end

    it "displays error message" do
      expect(page).to have_content("Trabalho não encontrado")
    end
  end
end