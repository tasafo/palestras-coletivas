require 'spec_helper'

describe 'Edit event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) do
    create(
      :event,
      :tasafoconf,
      users: [user, other_user],
      owner: user,
      start_date: Date.today,
      end_date: Date.today + 1.month
    )
  end

  context "when it's from the user" do
    before do
      login_as user, edit_event_path(event)
    end

    context 'with valid data' do
      before do
        fill_in 'Nome', with: 'Confraternização do Tá safo!'
        fill_in 'Tags', with: 'agilidade, gestão'

        click_button "user_id_#{other_user.id}"

        click_button 'Atualizar evento'
      end

      it 'displays success message' do
        expect(current_path).to match(%r{/events/\w+})
        expect(page).to have_content('O evento foi atualizado!')
      end
    end

    context 'with invalid data' do
      before do
        fill_in 'Nome', with: ''

        click_button 'Atualizar evento'
      end

      it 'displays error messages' do
        expect(current_path).to eql(event_path(event))
        expect(page).to have_content('Verifique o formulário antes de continuar:')
      end
    end
  end

  context 'when not from the user' do
    before do
      login_as another_user, edit_event_path(event)
    end

    it 'displays error messages' do
      expect(current_path).to eql(events_path)
      expect(page).to have_content('Você não tem permissão para acessar esta página.')
    end
  end
end
