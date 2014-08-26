require "spec_helper"

describe "Create attach event of talk without event", :type => :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  context "when valid data" do
    before do
      login_as user

      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "Anexar a um evento"
    end

    it "redirects to the talk page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays success message" do
      expect(page).to have_content("Não existem eventos disponíveis para essa operação")
    end
  end
end