require 'spec_helper'

describe 'Create schedule', js: true do
  let!(:user) { create(:user, :paul) }

  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  before do
    login_as user, event_path(event)

    click_link 'Adicionar programação'
  end

  context 'with valid interval' do
    before do
      select '05/06/2012', from: 'schedule_day'

      fill_in_inputmask 'Horário', '08:00'

      fill_in 'Descrição', with: 'Abertura'

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('A programação foi adicionada!')
    end
  end

  context 'with invalid interval' do
    before do
      click_button 'Adicionar programação'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(event_schedules_path(event))
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end

  context 'with valid talk' do
    before do
      select '05/06/2012', from: 'schedule_day'

      fill_in_inputmask 'Horário', '08:00'

      fill_in 'Descrição', with: 'Palestra'

      check('Anexar uma palestra existente')

      fill_in :search_text, with: 'tecnologia'

      click_button 'Buscar'

      click_button talk.id.to_s

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('A programação foi adicionada!')
    end
  end
end
