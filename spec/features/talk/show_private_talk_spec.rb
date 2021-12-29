require 'spec_helper'

describe 'Show private talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_talk) { create(:other_talk, users: [user], owner: user) }

  context 'when logged' do
    before do
      login_as user, talks_path

      click_link 'Minhas palestras'
      first(:link, 'Ruby praticamente falando').click
    end

    it 'displays detail talk' do
      expect(page).to have_current_path(talk_path(other_talk))
      expect(page).to have_content('Ruby praticamente falando')
    end
  end

  context 'when unlogged' do
    before do
      visit talk_path(other_talk)
    end

    it 'displays error message' do
      expect(page).to have_current_path(talks_path)
      expect(page).to have_content('Palestra não foi encontrado(a)')
    end
  end
end
