require 'spec_helper'

describe 'Remove vote in schedule', js: true do
  let!(:user) { create(:user, :paul) }

  let!(:event) do
    create(:event, :tasafoconf, users: [user], owner: user, start_date: Date.today,
                                end_date: Date.today + 5.days, accepts_submissions: true)
  end

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk, counter_votes: 1) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, event: event, talk: another_talk) }

  let!(:vote) { create(:vote, schedule: schedule_palestra, user: user) }

  context 'with valid data' do
    before do
      login_as user, event_path(event)

      click_link "remove_vote_schedule_id_#{schedule_palestra.id}"
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('Voto retirado com sucesso!')
    end
  end
end
