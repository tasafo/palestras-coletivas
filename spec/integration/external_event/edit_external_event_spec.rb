require "spec_helper"

describe "Edit external event of talk" do
  let!(:user) { create(:user, :paul) }
  let!(:fisl) { build(:external_event, :fisl) }
  let!(:rubyconf) { build(:external_event, :rubyconf) }
  let!(:talk) { create(:talk, :users => [user], :owner => user.id, :external_events => [fisl, rubyconf]) }

  context "when valid data" do
    before do
      login_as user
      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "external_event_id_#{fisl.id}"

      fill_in "Nome", :with => "Forum Internacional de Software Livre 12"

      click_button "Atualizar evento externo"
    end

    it "redirects to the talk page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays success message" do
      expect(page).to have_content("O evento externo foi atualizado!")
    end
  end

  context "when invalid data" do
    before do
      login_as user
      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "external_event_id_#{fisl.id}"

      fill_in "Nome", :with => ""

      click_button "Atualizar evento externo"
    end

    it "renders form page" do
      expect(current_path).to eql(talks_external_event_path(talk, fisl))
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end
end