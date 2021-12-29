require 'spec_helper'

describe 'Edit talk', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:billy) do
    create(:user, :billy, username: '@user_billy', name: 'Billy Boy')
  end
  let!(:luis) do
    create(:user, :luis, username: '@user_luis', name: 'Luis XIV')
  end
  let!(:talk) { create(:talk, users: [user, luis], owner: user) }

  context "when it's from the user" do
    before do
      login_as user, edit_talk_path(talk)
    end

    context 'with valid data' do
      before do
        fill_in 'Título', with: 'Ruby praticamente falando'
        fill_in 'Descrição',
                with: 'Palestra que fala sobre a linguagem de programação ruby'
        fill_in 'Tags', with: 'ruby, programação'

        fill_autocomplete('invitee_username', with: '@us',
                                              select: 'Billy Boy (@user_billy)')
        click_button :add_user

        click_button "remove_user_id_#{luis.id}"

        click_button 'Atualizar palestra'
      end

      it 'displays success message' do
        expect(page).to have_current_path(%r{/talks/\w+})
        expect(page).to have_content('A palestra foi atualizada!')
        expect(page).to have_content('Billy Boy')
        expect(page).to_not have_content('Luis XIV')
      end
    end

    context 'with invalid data' do
      before do
        fill_in 'Título', with: ''

        click_button 'Atualizar palestra'
      end

      it 'displays error messages' do
        expect(page).to have_current_path(talk_path(talk))
        expect(page)
          .to have_content('Verifique o formulário antes de continuar:')
      end
    end
  end

  context 'when not from the user' do
    before do
      login_as billy, edit_talk_path(talk)
    end

    it 'displays error messages' do
      expect(page).to have_current_path(talks_path)
      expect(page)
        .to have_content('Você não tem permissão para acessar esta página.')
    end
  end
end
