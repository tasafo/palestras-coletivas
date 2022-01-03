require 'spec_helper'

describe 'Submit talk already created', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:event) do
    create(:event, :tasafoconf, owner: user, start_date: Date.today,
                                end_date: Date.today + 5.days,
                                accepts_submissions: true)
  end
  let!(:schedule_palestra) do
    create(:schedule, :palestra, event: event, talk: talk)
  end

  context 'when valid data' do
    before do
      login_as user, talk_path(talk)

      click_link 'Submeter a um evento'

      select event.name, from: 'submit_event_event_id'

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page).to have_content('A palestra já está submetida no evento')
    end
  end
end
