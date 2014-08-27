require "spec_helper"

describe "Add vote in schedule", :type => :request, :js => true do
  let!(:user) { create(:user, :paul) }
  
  let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user.id, start_date: Date.today, end_date: Date.today + 5.days, accepts_dynamic_programming: true) }
  
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }
  let!(:another_talk) { create(:another_talk, :users => [ user ], :owner => user.id) }
  
  let!(:activity_abertura) { create(:activity, :abertura) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:activity_intervalo) { create(:activity, :intervalo) }

  let!(:schedule_palestra) { create(:schedule, :palestra, :event => event, :talk => talk) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, :event => event, :talk => another_talk) }

  context "with valid data" do
    before do
      login_as(user)

      click_link "Eventos"
      click_link "Tá Safo Conf"
      click_link "add_vote_schedule_id_#{schedule_palestra.id}"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("Voto adicionado com sucesso!")
    end
  end
end