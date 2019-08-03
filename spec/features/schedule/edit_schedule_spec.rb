require 'spec_helper'

describe 'Edit schedule', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:another_talk) { create(:another_talk, users: [user], owner: user) }
  let!(:ruby_talk) { create(:speakerdeck_talk, users: [user], owner: user) }

  let!(:schedule_abertura) { create(:schedule, :abertura, event: event) }
  let!(:schedule_intervalo) { create(:schedule, :intervalo, event: event) }

  let!(:schedule_palestra) do
    create(:schedule, :palestra, event: event, talk: talk)
  end
  let!(:schedule_palestra2) do
    create(:schedule, :palestra, event: event, talk: another_talk)
  end

  before do
    login_as user, event_path(event)
  end

  context 'with valid data' do
    before do
      click_link "edit_schedule_id_#{schedule_palestra.id}"

      select '06/06/2012', from: 'schedule_day'

      fill_in_inputmask 'Horário', with: '08:00'

      fill_in :search_text, with: 'Ruby'

      click_button 'Buscar'

      click_button ruby_talk.id.to_s

      click_button 'Atualizar programação'
    end

    it 'displays success message' do
      expect(current_path).to eq(event_path(event))
      expect(page).to have_content('A programação foi atualizada!')
    end
  end

  context 'with invalid data' do
    before do
      click_link "edit_schedule_id_#{schedule_palestra2.id}"

      fill_in_inputmask 'Horário', with: '24:00'

      click_button 'Atualizar programação'
    end

    it 'displays error messages' do
      expect(current_path)
        .to eql(event_schedule_path(event, schedule_palestra2))
      expect(page).to have_content('Horário não é válido')
    end
  end
end
