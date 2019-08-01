require 'spec_helper'

describe 'Delete event', type: :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }

  context 'without restriction' do
    before do
      login_as user, events_path

      click_link 'Tá Safo Conf'

      click_with_alert "delete_event_id_#{event._slugs.first}"
    end

    it 'redirects to the events page' do
      expect(current_path).to eql(events_path)
    end

    it 'displays success message' do
      expect(page).to have_content('Evento foi removido(a) com sucesso.')
    end
  end

  context 'with restriction' do
    let!(:talk) { create(:talk, users: [user], owner: user) }
    let!(:schedule_palestra) do
      create(:schedule, :palestra, event: event, talk: talk)
    end

    before do
      login_as user, event_path(event)

      click_with_alert "delete_event_id_#{event._slugs.first}"
    end

    it 'redirects to the event page' do
      expect(current_path).to eql(event_path(event))
    end

    it 'displays error message' do
      expect(page).to have_content('Não é possível remover o evento')
    end
  end
end
