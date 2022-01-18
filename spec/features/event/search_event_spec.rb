require 'spec_helper'

describe 'Search event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }

  before do
    visit events_path
  end

  context 'with empty search' do
    before do
      fill_in :search, with: ''
      find('#search_button').trigger('click')
    end

    it 'displays access my account' do
      expect(page).to have_current_path(%r{/events.})
      expect(page).to have_content('Eventos')
    end
  end

  context 'when the search is successful' do
    before do
      fill_in :search, with: 'Tá Safo Conf'
      find('#search_button').trigger('click')
    end

    it 'shows events found' do
      expect(page).to have_current_path(%r{/events.})
      expect(page).to have_content('Tá Safo Conf')
    end
  end

  context 'when the search is not successful' do
    before do
      fill_in :search, with: 'noob'
      find('#search_button').trigger('click')
    end

    it 'not show events' do
      expect(page).to have_current_path(%r{/events.})
      expect(page).not_to have_content('Tá Safo Conf')
    end
  end
end
