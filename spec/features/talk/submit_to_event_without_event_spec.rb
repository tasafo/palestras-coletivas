require 'spec_helper'

describe 'Submit talk without event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  context 'when valid data' do
    before do
      login_as user, talks_path

      click_link talk.title.to_s
      click_link 'Submeter a um evento'
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page)
        .to have_content('Não existem eventos disponíveis para essa operação')
    end
  end
end
