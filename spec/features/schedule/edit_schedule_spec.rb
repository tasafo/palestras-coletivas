require 'spec_helper'

describe 'Edit schedule', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }
  let!(:ruby_talk) { create(:speakerdeck_talk, users: [user], owner: user) }

  let!(:schedule_abertura) { create(:schedule, :abertura, event: event) }
  let!(:schedule_intervalo) { create(:schedule, :intervalo, event: event) }

  let!(:schedule_palestra) { create(:schedule, :palestra, event: event, talk: talk) }
  let!(:schedule_palestra2) { create(:schedule, :palestra, event: event, talk: another_talk) }

  before do
    login_as user, event_path(event)
  end

  context 'with valid data' do
    before do
      click_link "edit_schedule_id_#{schedule_palestra.id}"

      select '06/06/2012', from: 'schedule_day'
      fill_in 'Descrição', with: 'Palestra'
      check('Anexar uma palestra existente')
      fill_in :search_text, with: 'Ruby'
      find('#search_button').trigger('click')
      find('.btn-select-talk').trigger('click')
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(event_path(event))
      expect(page).to have_content('A programação foi atualizada!')
    end
  end
end
