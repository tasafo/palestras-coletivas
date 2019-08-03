require 'spec_helper'

describe 'Create external event of talk' do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    login_as user, talk_path(talk)
  end

  context 'when valid data' do
    before do
      click_link 'Adicionar evento externo'

      fill_in 'Nome do evento', with: 'Ruby Conf 2011'
      fill_in 'Local', with: 'São Paulo, SP'
      fill_in_inputmask 'Data', with: '01/01/2011'
      fill_in 'Link', with: 'http://rubyconf.com/2011'

      click_button 'Adicionar evento externo'
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page).to have_content('O evento externo foi adicionado!')
    end
  end

  context 'when invalid data' do
    before do
      click_link 'Adicionar evento externo'

      click_button 'Adicionar evento externo'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talk_external_events_path(talk))
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end
end
