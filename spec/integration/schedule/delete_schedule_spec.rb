require "spec_helper"

describe "Delete schedule", :type => :request, :js => true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user) }

  let!(:talk) { create(:talk, :users => [ user ], :owner => user) }
  let!(:another_talk) { create(:another_talk, :users => [ user ], :owner => user) }

  let!(:activity_lanche) { create(:activity, :lanche) }

  let!(:schedule_abertura) { create(:schedule, :abertura, :event => event) }
  let!(:schedule_intervalo) { create(:schedule, :intervalo, :event => event) }

  let!(:schedule_palestra) { create(:schedule, :palestra, :event => event, :talk => talk) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, :event => event, :talk => another_talk) }

  context "with valid data" do
    before do
      login_as(user)

      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"

      click_with_alert "delete_schedule_id_#{schedule_palestra.id}"
    end

    it "redirects to the event page" do
      expect(current_path).to match(%r[/events/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A programação foi excluída!")
    end
  end
end
