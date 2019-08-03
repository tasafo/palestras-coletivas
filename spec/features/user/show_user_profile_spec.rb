require 'spec_helper'

describe 'Show user profile', type: :request do
  let!(:user) { create(:user, :luis) }
  let!(:other_user) { create(:user, :billy) }

  context 'when user valid' do
    before do
      visit user_path(user)
    end

    it 'displays user profile' do
      expect(current_path).to eql(user_path(user))
      expect(page).to have_content('Luis Miguel')
    end
  end

  context 'when user invalid' do
    before do
      visit '/users/00000111111000000111111'
    end

    it { expect(current_path).to eql(root_path) }
  end

  context 'when the user does not have e-mail at Gravatar' do
    before do
      visit user_path(other_user)
    end

    it 'displays user profile' do
      expect(current_path).to eql(user_path(other_user))
      expect(page).to have_content('Billy')
    end
  end
end
