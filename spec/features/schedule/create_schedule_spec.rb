require 'spec_helper'

describe 'Create schedule', type: :request, js: true do
  let!(:user) { create(:user, :paul) }

  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }

  let!(:activity_abertura) { create(:activity, :abertura) }
  let!(:activity_palestra) { create(:activity, :palestra) }
  let!(:activity_intervalo) { create(:activity, :intervalo) }

  before do
    login_as user, event_path(event)

    click_link 'Adicionar programação'
  end

  context 'with valid interval' do
    before do
      select '05/06/2012', from: 'schedule_day'

      fill_in_inputmask 'Horário', with: '08:00'

      select activity_abertura.description, from: 'schedule_activity_id'

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(current_path).to match(%r{/events/\w+})
      expect(page).to have_content('A programação foi adicionada!')
    end
  end

  context 'with invalid interval' do
    before do
      click_button 'Adicionar programação'
    end

    it 'displays error messages' do
      expect(current_path).to eql(event_schedules_path(event))
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end

  context 'with valid talk' do
    before do
      select '05/06/2012', from: 'schedule_day'

      fill_in_inputmask 'Horário', with: '08:00'

      select activity_palestra.description, from: 'schedule_activity_id'

      fill_in :search_text, with: 'tecnologia'

      click_button 'Buscar'

      click_button talk.id.to_s

      click_button 'Adicionar programação'
    end

    it 'displays success message' do
      expect(current_path).to match(%r{/events/\w+})
      expect(page).to have_content('A programação foi adicionada!')
    end
  end
end
