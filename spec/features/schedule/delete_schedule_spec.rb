require 'spec_helper'

describe 'Delete schedule', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  let!(:schedule_abertura) { create(:schedule, :abertura, event: event) }
  let!(:schedule_intervalo) { create(:schedule, :intervalo, event: event) }

  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, event: event, talk: another_talk) }

  context 'with valid data' do
    before do
      login_as user, event_path(event)

      click_with_alert "delete_schedule_id_#{schedule_palestra.id}"
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('A programação foi excluída!')
    end
  end
end
