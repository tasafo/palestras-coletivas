require 'spec_helper'

describe 'Create enrollment', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) do
    create(:event, :tasafoconf, deadline_date_enrollment: Date.today,
                                users: [user], owner: user)
  end
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:enrollment_active) { create(:enrollment, event: event, user: another_user) }

  context 'when logged' do
    before do
      login_as other_user, event_path(event)

      click_link 'Quero participar!'
    end

    it 'show button cancel participation' do
      expect(page).to have_content('Cancelar participação'.upcase)
    end
  end

  context 'when not logged' do
    before do
      visit event_path(event)
    end

    it 'show button I want to participate' do
      expect(page).to have_content('Quero participar!'.upcase)
    end

    it 'redirect to event page' do
      click_link 'Quero participar!'
      expect(page).to have_current_path(%r{/events/\w+})
    end
  end
end
