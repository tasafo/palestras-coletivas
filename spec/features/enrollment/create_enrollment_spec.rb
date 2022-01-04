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

    it 'displays success message' do
      expect(page).to have_content('Cancelar participação')
    end
  end

  context 'when the user is organizer' do
    before do
      login_as user, event_path(event)
    end

    it 'not show button I want to participate' do
      expect(page).not_to have_content('Quero participar!')
    end
  end
end
