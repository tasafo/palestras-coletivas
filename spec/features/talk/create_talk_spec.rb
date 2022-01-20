require 'spec_helper'

describe 'Create talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:invited_user) { create(:user, :luis, name: 'Luis XIV', username: '@user_luis') }
  let!(:other_user) { create(:user, :billy, name: 'Billy Boy', username: '@user_billy') }

  before do
    login_as user, new_talk_path
  end

  context 'with valid data from slideshare' do
    before do
      fill_in 'Link da palestra', with: 'https://slideshare.net/luizsanches/ruby-praticamente-falando'
      fill_in 'Título', with: 'Ruby praticamente falando'
      fill_in 'Tags', with: 'tecnologia, programação'
      fill_in 'Link do vídeo', with: 'https://youtube.com/watch?v=PcqUTGFgHa4'
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
    end
  end

  context 'with valid data from speakerdeck' do
    before do
      fill_in 'Link da palestra', with: 'https://speakerdeck.com/luizsanches/ruby-praticamente-falando'
      fill_in 'Título', with: 'Ruby praticamente falando'
      fill_in 'Tags', with: 'ruby, programação'
      fill_in 'Link do vídeo', with: 'https://vimeo.com/46879129'
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
    end
  end

  context 'with valid data but no link' do
    before do
      fill_in 'Título', with: 'A linguagem C'
      fill_in 'Tags', with: 'C, programação'
      fill_in 'Link do vídeo', with: 'https://www.youtube.com/invalid'
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(%r{/talks/\w+})
      expect(page).to have_content('A palestra foi adicionada!')
    end
  end

  context 'when the presentation are not found' do
    before do
      stub_request(:get, /slideshare.net/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 404, body: '', headers: {})

      fill_in 'Link da palestra', with: 'https://slideshare.net/luizsanches/invalid'
      fill_in 'Título', with: 'Compartilhe!'
    end

    it { expect(page).to have_content('Palestra não encontrada') }
  end

  context 'with repeated talk' do
    let!(:talk) { create(:talk, users: [user], owner: user) }

    before do
      fill_in 'Link da palestra', with: 'https://slideshare.net/luizsanches/compartilhe'
      fill_in 'Título', with: 'Compartilhe!'
      fill_in 'Tags', with: 'duplicada'
      find('.btn-submit').trigger('click')
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talks_path)
      expect(page).to have_content('Link da palestra já está em uso')
    end
  end
end
