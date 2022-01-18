require 'spec_helper'

describe 'Edit event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:random_user) { create(:user, :random) }
  let!(:event) do
    create(:event, :tasafoconf, users: [user, other_user, another_user],
                                owner: user, start_date: Date.today,
                                end_date: Date.today + 1.month)
  end

  context "when it's from the user" do
    before do
      login_as user, edit_event_path(event)
    end

    context 'with valid data' do
      before do
        fill_in 'Nome', with: 'Confraternização do Tá safo!'
        fill_in 'Tags', with: 'agilidade, gestão'
        find('.btn-submit').trigger('click')
      end

      it 'displays success message' do
        expect(page).to have_current_path(%r{/events/\w+})
        expect(page).to have_content('O evento foi atualizado!')
      end
    end
  end

  context 'when not from the user' do
    before do
      login_as random_user, edit_event_path(event)
    end

    it 'displays error messages' do
      expect(page).to have_current_path(events_path)
      expect(page).to have_content('Você não tem permissão para acessar')
    end
  end

  context 'unlogged' do
    before do
      visit edit_event_path(event)
    end

    it 'displays login message' do
      expect(page).to have_current_path(%r{/login.})
      expect(page).to have_content('Entre')
    end
  end
end
