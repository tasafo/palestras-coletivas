require 'spec_helper'

describe 'Create event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:billy) do
    create(:user, :billy, username: '@user_billy', name: 'Billy Boy')
  end
  let!(:luis) do
    create(:user, :luis, username: '@user_luis', name: 'Luis XIV')
  end
  let!(:script) do
    "$('tinymce').html('Evento de tecnologia com sua 1ª edição na região')"
  end
  let!(:image_path) { ImageFile.asset('video-poster.jpg') }

  before do
    login_as user, new_event_path
  end

  context 'with valid data' do
    before do
      fill_in 'Nome', with: 'Tá Safo Conf'
      fill_in 'Edição', with: '2012'
      page.execute_script(script)
      fill_in 'Lotação', with: 100
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in_inputmask 'Data de início', '05/06/2012'
      fill_in_inputmask 'Data de término', '06/06/2012'
      fill_in_inputmask 'Prazo para inscrição', '06/06/2012'
      fill_in 'Local', with: 'Centro de Convenções do Jurunas'
      fill_in 'Endereço', with: 'Rua dos Caripunas, 800'
      fill_in 'Bairro', with: 'Jurunas'
      fill_in 'Cidade', with: 'Belém'
      fill_in 'Estado', with: 'Pará'
      fill_in 'País', with: 'Brasil'
      attach_file('Imagem', image_path)
      check('Quero publicar')

      fill_autocomplete('invitee_username', with: '@us',
                                            select: 'Luis XIV (@user_luis)')
      click_button :add_user

      fill_autocomplete('invitee_username', with: '@us',
                                            select: 'Billy Boy (@user_billy)')
      click_button :add_user

      click_button "remove_user_id_#{luis.id}"

      click_button 'Adicionar evento'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('O evento foi adicionado!')
      expect(page).to have_content('Billy Boy')
      expect(page).to_not have_content('Luis XIV')
    end
  end

  context 'with invalid data' do
    before do
      click_button 'Adicionar evento'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(events_path)
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end

  context 'with valid data but without address' do
    before do
      fill_in 'Nome', with: 'Tá Safo Conf'
      fill_in 'Edição', with: '2012'
      page.execute_script(script)
      fill_in 'Lotação', with: 100
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in_inputmask 'Data de início', '05/06/2012'
      fill_in_inputmask 'Data de término', '06/06/2012'
      fill_in_inputmask 'Prazo para inscrição', '06/06/2012'
      fill_in 'Local', with: 'Centro de Convenções do Jurunas'
      fill_in 'Endereço', with: '.'
      fill_in 'Bairro', with: '.'
      fill_in 'Cidade', with: '.'
      fill_in 'Estado', with: '.'
      fill_in 'País', with: '.'
      check('Quero publicar')

      click_button 'Adicionar evento'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/events/\w+})
      expect(page).to have_content('O evento foi adicionado!')
    end
  end
end
