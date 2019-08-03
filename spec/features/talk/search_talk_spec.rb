require 'spec_helper'

describe 'Search talk' do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    visit talks_path
  end

  context 'with empty search' do
    before do
      fill_in :search, with: ''

      click_button 'Buscar'
    end

    it 'displays access my account' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).to have_content('Palestras')
    end
  end

  context 'when the search is successful' do
    before do
      fill_in :search, with: 'compartilhe'

      click_button 'Buscar'
    end

    it 'shows talks found' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).to have_content('Compartilhe')
    end
  end

  context 'when the search is not successful' do
    before do
      fill_in :search, with: 'noob'

      click_button 'Buscar'
    end

    it 'not show talks' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).not_to have_content('Compartilhe')
    end
  end
end