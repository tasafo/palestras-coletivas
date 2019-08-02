require 'spec_helper'

describe 'Delete talk', type: :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:talk) { create(:talk, users: [user], owner: user) }

  before do
    login_as user, talk_path(talk)
  end

  context 'without restriction' do
    before do
      click_with_alert "delete_talk_id_#{talk._slugs.first}"
    end

    it 'displays success message' do
      expect(current_path).to eql(talks_path)
      expect(page).to have_content('Palestra foi removido(a) com sucesso.')
    end
  end

  context 'with restriction' do
    let!(:event) { create(:event, :tasafoconf, owner: user, users: [user]) }
    let!(:talk) { create(:talk, users: [user], owner: user) }
    let!(:schedule_palestra) do
      create(:schedule, :palestra, event: event, talk: talk)
    end

    before do
      click_with_alert "delete_talk_id_#{talk._slugs.first}"
    end

    it 'displays error message' do
      expect(current_path).to eql(talk_path(talk))
      expect(page).to have_content('Não é possível remover a palestra')
    end
  end
end
