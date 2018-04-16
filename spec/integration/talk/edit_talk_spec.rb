require "spec_helper"

describe "Edit talk", :type => :request, :js => true do
  let!(:user)   { create(:user, :paul) }
  let!(:billy)  { create(:user, :billy, username: "@username_billy", name: "Billy Boy") }
  let!(:luis)   { create(:user, :luis, username: "@username_luis", name: "Luis XIV") }
  let!(:talk)   { create(:talk, :users => [ user, luis ], :owner => user) }

  context "with valid data" do
    before do
      login_as(user)

      click_link("Palestras", match: :first)
      click_link "Compartilhe"
      click_link "Editar palestra"

      fill_in "Título", :with => "Ruby praticamente falando"
      fill_in "Descrição", :with => "Palestra que fala sobre a linguagem de programação ruby"
      fill_in "Tags", :with => "ruby, programação"

      fill_autocomplete('invitee_username', with: '@us', select: "Billy Boy (@username_billy)")
      click_button :add_user

      click_button "user_id_#{luis.id}"

      click_button "Atualizar palestra"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A palestra foi atualizada!")
    end

    it "displays the right co-authors" do
      expect(page).to     have_content("Billy Boy")
      expect(page).to_not have_content("Luis XIV")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)

      click_link("Palestras", match: :first)
      click_link "Compartilhe"
      click_link "Editar palestra"

      fill_in "Título", :with => ""

      click_button "Atualizar palestra"
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
      login_as(billy)
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
