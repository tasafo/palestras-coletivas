require 'spec_helper'

describe 'Edit external event of talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:fisl) { build(:external_event, :fisl) }
  let!(:rubyconf) { build(:external_event, :rubyconf) }
  let!(:talk) { create(:talk, users: [user], owner: user, external_events: [fisl, rubyconf]) }

  before do
    login_as user, talk_path(talk)

    click_link "external_event_id_#{fisl.id}"
  end

  context 'when valid data' do
    before do
      fill_in 'Nome', with: 'Forum Internacional de Software Livre 12'
      find('.btn-submit').trigger('click')
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page).to have_content('O evento externo foi atualizado!')
    end
  end
end
