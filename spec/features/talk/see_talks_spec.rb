require 'spec_helper'

describe 'See talks' do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  context 'with two talks' do
    before do
      login_as user, talks_path
    end

    it 'displays at least one talk' do
      expect(current_path).to eql(talks_path)
      expect(page).to have_content('Compartilhe')
    end
  end
end
