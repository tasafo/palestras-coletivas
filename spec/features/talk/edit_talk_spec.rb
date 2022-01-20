require 'spec_helper'

describe 'Edit talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:billy) { create(:user, :billy, username: '@user_billy', name: 'Billy Boy') }
  let!(:luis) { create(:user, :luis, username: '@user_luis', name: 'Luis XIV') }
  let!(:talk) { create(:talk, users: [user, luis], owner: user) }

  context "when it's from the user" do
    before do
      login_as user, edit_talk_path(talk)
    end

    context 'with valid data' do
      before do
        fill_in 'Título', with: 'Ruby praticamente falando'
        fill_in 'Tags', with: 'ruby, programação'
        find('.btn-submit').trigger('click')
      end

      it 'displays success message' do
        expect(page).to have_current_path(%r{/talks/\w+})
        expect(page).to have_content('A palestra foi atualizada!')
      end
    end
  end

  context 'when not from the user' do
    before do
      login_as billy, edit_talk_path(talk)
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talks_path)
      expect(page).to have_content('Você não tem permissão para acessar esta página.')
    end
  end
end
