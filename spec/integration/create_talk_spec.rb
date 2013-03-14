require "spec_helper"

describe "Create talk", :js => false do
  let!(:user) { create(:user) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Adicionar palestra"

      fill_in "Link do slideshare", :with => "http://www.slideshare.net/luizsanches/compartilhe"
      fill_in "Titulo", :with => "Compartilhe!"
      fill_in "Descrição", :with => "Palestra que fala sobre o compartilhamento de conhecimento na era da informação"
      fill_in "Tags", :with => "conhecimento, compartilhamento"
      page.check("Publicar")

      click_button "Adicionar palestra"
    end

    it "redirects to the question page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Sua palestra foi adicionada!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Adicionar palestra"
      click_button "Adicionar palestra"
    end

    it "renders form page" do
      expect(current_path).to eql(new_talk_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      click_link "Adicionar palestra"
    end

    it "redirects to login page" do
      expect(current_path).to eql(login_path)
    end
  end
end