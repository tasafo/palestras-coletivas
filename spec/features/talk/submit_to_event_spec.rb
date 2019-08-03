require 'spec_helper'

describe 'Submit talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:event) do
    create(:event, :tasafoconf, owner: user, start_date: Date.today,
                                end_date: Date.today + 5.days,
                                accepts_submissions: true)
  end
  let!(:schedule_abertura) { create(:schedule, :abertura, event: event) }

  context 'when valid data' do
    before do
      login_as user, talk_path(talk)

      click_link 'Submeter a um evento'

      select event.name, from: 'submit_event_event_id'

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(current_path).to eql(talk_path(talk))
      expect(page).to have_content('A palestra foi submetida ao evento!')
    end
  end
end
