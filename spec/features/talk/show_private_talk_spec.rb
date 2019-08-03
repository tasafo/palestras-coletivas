require 'spec_helper'

describe 'Show private talk', type: :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_talk) { create(:other_talk, users: [user], owner: user) }

  context 'when logged' do
    before do
      login_as user, talks_path

      click_link 'Minhas palestras'
      click_link 'Ruby praticamente falando'
    end

    it 'displays detail talk' do
      expect(current_path).to eql(talk_path(other_talk))
      expect(page).to have_content('Ruby praticamente falando')
    end
  end

  context 'when unlogged' do
    before do
      visit talk_path(other_talk)
    end

    it 'displays error message' do
      expect(current_path).to eql(talks_path)
      expect(page).to have_content('Palestra não foi encontrado(a)')
    end
  end
end
