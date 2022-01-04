require 'spec_helper'

describe 'Edit enrollment', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) { create(:event, :tasafoconf, deadline_date_enrollment: Date.today, users: [user], owner: user) }
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:enrollment_active) { create(:enrollment, event: event, user: other_user) }
  let!(:enrollment_inactive) { create(:enrollment, active: false, event: event, user: another_user) }

  context 'when the enrollment is active' do
    before do
      login_as other_user, event_path(event)

      click_link 'Cancelar participação'
    end

    it 'displays success message' do
      expect(page).to have_content('Quero participar!')
    end
  end

  context 'when the enrollment is inactive' do
    before do
      login_as another_user, event_path(event)

      click_link 'Quero participar!'
    end

    it 'displays success message' do
      expect(page).to have_content('Cancelar participação')
    end
  end
end
