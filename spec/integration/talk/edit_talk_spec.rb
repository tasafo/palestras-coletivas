require "spec_helper"

describe "Edit talk", :js => true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  context "with valid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "Editar trabalho"

      fill_in "Titulo", :with => "Ruby praticamente falando"
      fill_in "Descrição", :with => "Palestra que fala sobre a linguagem de programação ruby"
      fill_in "Tags", :with => "ruby, programação"

      select other_user.name, :from => "user_id"
      click_button :add_user

      click_button "Atualizar trabalho"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("O trabalho foi atualizado!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "Editar trabalho"

      fill_in "Titulo", :with => ""

      click_button "Atualizar trabalho"
    end

    it "renders form page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the talk is not user" do
    before do
      login_as(other_user)
      visit edit_talk_path(talk)
    end

    it "redirects to the talks page" do
      expect(current_path).to eql(talks_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Você não tem permissão para acessar esta página.")
    end
  end
end