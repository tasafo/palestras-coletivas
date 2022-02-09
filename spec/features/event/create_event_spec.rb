require 'spec_helper'

describe 'Create event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:billy) { create(:user, :billy, username: '@user_billy', name: 'Billy Boy') }
  let!(:luis) { create(:user, :luis, username: '@user_luis', name: 'Luis XIV') }
  let!(:image_path) { ImageFile.asset('video-poster.jpg') }

  before do
    login_as user, new_event_path
  end

  context 'with valid data' do
    before do
      fill_in 'Nome', with: 'Tá Safo Conf 2012'
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in 'Data de início', with: '05/06/2012'
      fill_in 'Data de término', with: '06/06/2012'
      fill_in 'Prazo para inscrição', with: '06/06/2012'
      fill_in 'Lotação', with: 100
      fill_in 'Carga horária', with: 16
      fill_in 'Local', with: 'Centro de Convenções do Jurunas'
      fill_in 'Endereço', with: 'Rua dos Caripunas, 800'
      fill_in 'Bairro', with: 'Jurunas'
      fill_in 'Cidade', with: 'Belém'
      fill_in 'Estado', with: 'Pará'
      fill_in 'País', with: 'Brasil'
      attach_file('Imagem', image_path)
      find('#event_to_public').trigger('check')
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('O evento foi adicionado!')
    end
  end

  context 'with valid data but without address' do
    before do
      fill_in 'Nome', with: 'Tá Safo Conf 2012'
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in 'Data de início', with: '05/06/2012'
      fill_in 'Data de término', with: '06/06/2012'
      fill_in 'Prazo para inscrição', with: '06/06/2012'
      fill_in 'Lotação', with: 100
      fill_in 'Carga horária', with: 16
      fill_in 'Local', with: 'Algum lugar na Internet'
      find('#event_online').trigger('check')
      find('#event_to_public').trigger('check')
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('O evento foi adicionado!')
    end
  end
end
