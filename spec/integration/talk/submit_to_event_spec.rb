require "spec_helper"

describe "Submit talk", :type => :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:event) { create(:event, :tasafoconf, owner: user, start_date: Date.today, end_date: Date.today + 5.days, accepts_submissions: true) }

  context "when valid data" do
    before do
      login_as user

      click_link "Trabalhos"
      click_link "Compartilhe"
      click_link "Submeter a um evento"

      select event.name_and_edition, :from => "submit_event_event_id"

      click_button "Adicionar programação"
    end

    it "redirects to the talk page" do
      expect(current_path).to eql(talk_path(talk))
    end

    it "displays success message" do
      expect(page).to have_content("O trabalho foi submetido ao evento!")
    end
  end
end