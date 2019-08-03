require 'spec_helper'

describe 'Talk not found', type: :request do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:talk) { create(:talk, to_public: false, users: [user], owner: user) }

  context 'when talk does not exist' do
    before do
      visit '/talks/00000111111000000111111'
    end

    it 'displays error message' do
      expect(current_path).to eql(talks_path)
      page.has_content? 'Palestra não encontrado(a)'
    end
  end

  context 'when the user is logged and the talk is not public' do
    before do
      login_as other_user, talk_path(talk)
    end

    it 'displays error message' do
      expect(current_path).to eql(talks_path)
      page.has_content? 'Palestra não encontrado(a)'
    end
  end

  context 'when the user is not logged and the talk is not public' do
    before do
      visit talk_path(talk)
    end

    it 'displays error message' do
      expect(current_path).to eql(talks_path)
      page.has_content? 'Palestra não encontrado(a)'
    end
  end
end
