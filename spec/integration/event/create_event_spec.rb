require 'spec_helper'

describe 'Create event', type: :request, js: true do
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
  let!(:image_path) { "#{Rails.root}/app/assets/images/video-poster.jpg" }

  context 'with valid data' do
    before do
      login_as user, events_path

      click_link 'Adicionar evento'

      fill_in 'Nome', with: 'Tá Safo Conf'
      fill_in 'Edição', with: '2012'
      page.execute_script(script)
      fill_in 'Lotação', with: 100
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in_inputmask 'Data de início', with: '05/06/2012'
      fill_in_inputmask 'Data de término', with: '06/06/2012'
      fill_in_inputmask 'Prazo para inscrição', with: '06/06/2012'
      fill_in 'Local', with: 'Centro de Convenções do Jurunas'
      fill_in 'Endereço', with: 'Rua dos Caripunas, 800'
      fill_in 'Bairro', with: 'Jurunas'
      fill_in 'Cidade', with: 'Belém'
      fill_in 'Estado', with: 'Pará'
      fill_in 'País', with: 'Brasil'
      attach_file('Imagem', File.absolute_path(image_path))
      check('Quero publicar')

      fill_autocomplete('invitee_username', with: '@us',
                                            select: 'Luis XIV (@user_luis)')
      click_button :add_user

      fill_autocomplete('invitee_username', with: '@us',
                                            select: 'Billy Boy (@user_billy)')
      click_button :add_user

      click_button "user_id_#{luis.id}"

      click_button 'Adicionar evento'
    end

    it 'redirects to the event page' do
      expect(current_path).to match(%r{/events/\w+})
    end

    it 'displays success message' do
      expect(page).to have_content('O evento foi adicionado!')
    end

    it 'invites the right organizers' do
      expect(page).to have_content('Billy Boy')
      expect(page).to_not have_content('Luis XIV')
    end
  end

  context 'with invalid data' do
    before do
      login_as user, events_path

      click_link 'Adicionar evento'
      click_button 'Adicionar evento'
    end

    it 'renders form page' do
      expect(current_path).to eql(events_path)
    end

    it 'displays error messages' do
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end

  context 'with valid data but without address' do
    before do
      login_as user, events_path

      click_link 'Adicionar evento'

      fill_in 'Nome', with: 'Tá Safo Conf'
      fill_in 'Edição', with: '2012'
      page.execute_script(script)
      fill_in 'Lotação', with: 100
      fill_in 'Tags', with: 'tecnologia, agilidade, gestão'
      fill_in_inputmask 'Data de início', with: '05/06/2012'
      fill_in_inputmask 'Data de término', with: '06/06/2012'
      fill_in_inputmask 'Prazo para inscrição', with: '06/06/2012'
      fill_in 'Local', with: 'Centro de Convenções do Jurunas'
      fill_in 'Endereço', with: '.'
      fill_in 'Bairro', with: '.'
      fill_in 'Cidade', with: '.'
      fill_in 'Estado', with: '.'
      fill_in 'País', with: '.'
      check('Quero publicar')

      click_button 'Adicionar evento'
    end

    it 'redirects to the event page' do
      expect(current_path).to match(%r{/events/\w+})
    end

    it 'displays success message' do
      expect(page).to have_content('O evento foi adicionado!')
    end
  end
end
