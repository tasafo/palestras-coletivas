require 'spec_helper'

describe 'Create talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:invited_user) do
    create(:user, :luis, name: 'Luis XIV', username: '@user_luis')
  end
  let!(:other_user) do
    create(:user, :billy, name: 'Billy Boy', username: '@user_billy')
  end
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    login_as user, new_talk_path
  end

  context 'with valid data from slideshare' do
    before do
      fill_in 'Link da palestra', with: 'http://pt.slideshare.net/luizsanches/ferrramentas-e-tcnicas-para-manter-a-sanidade-em-uma-startup'
      fill_in 'Descrição', with: 'Palestra sobre processos e ferramentas'
      fill_in 'Tags', with: 'tecnologia, empreendedorismo'
      fill_in 'Link do vídeo', with: 'http://www.youtube.com/watch?v=wGe5agueUwI'
      check('Quero publicar')

      fill_autocomplete('invitee_username', with: '@us',
                                            select: 'Luis XIV (@user_luis)')
      click_button :add_user

      click_button 'Adicionar palestra'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
      expect(page).to have_content('Luis XIV')
      expect(page).to_not have_content('Billy Boy')
    end
  end

  context 'with valid data from speakerdeck' do
    before do
      fill_in 'Link da palestra', with: 'https://speakerdeck.com/luizsanches/ruby-praticamente-falando'
      fill_in 'Descrição', with: 'Indrodução à linguagem Ruby'
      fill_in 'Tags', with: 'ruby, programação'
      fill_in 'Link do vídeo', with: 'https://vimeo.com/46879129'
      check('Quero publicar')

      click_button 'Adicionar palestra'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
    end
  end

  context 'with valid data but no link' do
    before do
      fill_in 'Título', with: 'A linguagem C'
      fill_in 'Descrição', with: 'Indrodução à linguagem C'
      fill_in 'Tags', with: 'C, programação'
      fill_in 'Link do vídeo', with: 'http://www.youtube.com/invalid'
      check('Quero publicar')

      click_button 'Adicionar palestra'
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
    end
  end

  context 'with invalid data' do
    before do
      click_button 'Adicionar palestra'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talks_path)
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end

  context 'when the presentation are not found' do
    before do
      stub_request(:get, /slideshare.net/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 404, body: '', headers: {})

      fill_in 'Link da palestra', with: 'http://www.slideshare.net/luizsanches/invalid'
      fill_in 'Título', with: 'Compartilhe!'
    end

    it { expect(page).to have_content('Palestra não encontrada') }
  end

  context 'with repeated talk' do
    before do
      fill_in 'Link da palestra', with: 'http://www.slideshare.net/luizsanches/compartilhe'
      fill_in 'Descrição', with: 'Palestra duplicada'
      fill_in 'Tags', with: 'duplicada'

      click_button 'Adicionar palestra'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talks_path)
      expect(page).to have_content('Link da palestra já está em uso')
    end
  end
end
