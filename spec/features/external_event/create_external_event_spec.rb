require 'spec_helper'

describe 'Create external event of talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    login_as user, talk_path(talk)
  end

  context 'when valid data' do
    before do
      click_link 'Criar evento externo'

      fill_in 'Nome do evento', with: 'Ruby Conf 2011'
      fill_in 'Local', with: 'São Paulo, SP'
      fill_in 'Data', with: '01/01/2011'
      fill_in 'Link', with: 'https://rubyconf.com/2011'

      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page).to have_content('O evento externo foi adicionado!')
    end
  end
end
