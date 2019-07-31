require 'spec_helper'

describe 'See talks', type: :request do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  context 'with two talks' do
    before do
      login_as(user)

      visit talks_path
    end

    it 'redirects to the home page' do
      expect(current_path).to eql(talks_path)
    end

    it 'displays at least one talk' do
      expect(page).to have_content('Compartilhe')
    end
  end
end
