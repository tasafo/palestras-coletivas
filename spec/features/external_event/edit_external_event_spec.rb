require 'spec_helper'

describe 'Edit external event of talk' do
  let!(:user) { create(:user, :paul) }
  let!(:fisl) { build(:external_event, :fisl) }
  let!(:rubyconf) { build(:external_event, :rubyconf) }
  let!(:talk) do
    create(:talk, users: [user], owner: user, external_events: [fisl, rubyconf])
  end

  before do
    login_as user, talk_path(talk)

    click_link "external_event_id_#{fisl.id}"
  end

  context 'when valid data' do
    before do
      fill_in 'Nome', with: 'Forum Internacional de Software Livre 12'

      click_button 'Atualizar evento externo'
    end

    it 'displays success message' do
      expect(page).to have_current_path(talk_path(talk))
      expect(page).to have_content('O evento externo foi atualizado!')
    end
  end

  context 'when invalid data' do
    before do
      fill_in 'Nome', with: ''

      click_button 'Atualizar evento externo'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talk_external_event_path(talk, fisl))
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    end
  end
end
