require "spec_helper"

describe "Edit talk" do
  let!(:talk) { create(:talk) }
  let(:user) { talk.user }

  context "wiht valid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Minhas palestras"
      click_link "talk_id_#{talk.id}"

      fill_in "Link do slideshare", :with => "http://www.slideshare.net/luizsanches/ruby-praticamente-falando"
      fill_in "Titulo", :with => "Ruby praticamente falando"
      fill_in "Descrição", :with => "Palestra que fala sobre a linguagem de programação ruby"
      fill_in "Tags", :with => "ruby, programação"

      click_button "Atualizar palestra"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Sua palestra foi atualizada!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path
      click_link "Minhas palestras"
      click_link "talk_id_#{talk.id}"

      fill_in "Titulo", :with => ""

      click_button "Atualizar palestra"
    end

    it "renders form page" do
      expect(current_path).to eql(edit_talk_path(talk))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end