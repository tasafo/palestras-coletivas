require 'spec_helper'

describe 'Search talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    visit talks_path
  end

  context 'with empty search' do
    before do
      fill_in :search, with: ''
      find('#search_button').trigger('click')
    end

    it 'displays access my account' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).to have_content('Palestras')
    end
  end

  context 'when the search is successful' do
    before do
      fill_in :search, with: 'compartilhe'
      find('#search_button').trigger('click')
    end

    it 'shows talks found' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).to have_content('Compartilhe')
    end
  end

  context 'when the search is not successful' do
    before do
      fill_in :search, with: 'noob'
      find('#search_button').trigger('click')
    end

    it 'not show talks' do
      expect(page).to have_current_path(%r{/talks.})
      expect(page).not_to have_content('Compartilhe')
    end
  end
end
