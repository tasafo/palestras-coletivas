require 'spec_helper'

describe 'Delete event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }

  before do
    login_as user, event_path(event)
  end

  context 'without restriction' do
    before do
      click_with_alert "delete_event_id_#{event._slugs.first}"
    end

    it 'displays success message' do
      expect(page).to have_current_path(events_path)
      expect(page).to have_content('Evento foi removido(a) com sucesso.')
    end
  end

  context 'with restriction' do
    let!(:talk) { create(:talk, users: [user], owner: user) }
    let!(:schedule_palestra) do
      create(:schedule, :palestra, event: event, talk: talk)
    end

    before do
      click_with_alert "delete_event_id_#{event._slugs.first}"
    end

    it 'displays error message' do
      expect(page).to have_current_path(event_path(event))
      expect(page).to have_content('Não é possível remover o evento')
    end
  end
end
