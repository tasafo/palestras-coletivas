require 'spec_helper'

describe 'Edit enrollment', type: :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) do
    create(:event, :tasafoconf, deadline_date_enrollment: Date.today,
                                users: [user], owner: user)
  end
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:schedule_palestra) do
    create(:schedule, :palestra, event: event, talk: talk)
  end
  let!(:enrollment_active) do
    create(:enrollment, event: event, user: other_user)
  end
  let!(:enrollment_inactive) do
    create(:enrollment, active: false, event: event, user: another_user)
  end

  context 'when the enrollment is active' do
    before do
      login_as other_user, event_path(event)

      click_link 'Cancelar minha participação'

      click_button 'Alterar participação'
    end

    it 'redirects to the event page' do
      expect(current_path).to eql(event_path(event))
    end

    it 'displays success message' do
      expect(page).to have_content('A inscrição foi alterada!')
    end
  end

  context 'when the enrollment is inactive' do
    before do
      login_as another_user, event_path(event)

      click_link 'Quero participar!'

      click_button 'Alterar participação'
    end

    it 'redirects to the event page' do
      expect(current_path).to eql(event_path(event))
    end

    it 'displays success message' do
      expect(page).to have_content('A inscrição foi alterada!')
    end
  end
end
