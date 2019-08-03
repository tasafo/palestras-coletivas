require 'spec_helper'

describe 'Add vote in schedule', js: true do
  let!(:user) { create(:user, :paul) }

  let!(:event) do
    create(:event, :tasafoconf, users: [user], owner: user,
                                start_date: Date.today,
                                end_date: Date.today + 5.days,
                                accepts_submissions: true)
  end

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  let!(:activity_abertura) { create(:activity, :abertura) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:activity_intervalo) { create(:activity, :intervalo) }

  let!(:schedule_palestra) do
    create(:schedule, :palestra, event: event, talk: talk)
  end
  let!(:schedule_palestra2) do
    create(:schedule, :palestra, event: event, talk: another_talk)
  end

  context 'with valid data' do
    before do
      login_as user, event_path(event)

      click_link "add_vote_schedule_id_#{schedule_palestra.id}"
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('Voto adicionado com sucesso!')
    end
  end
end
