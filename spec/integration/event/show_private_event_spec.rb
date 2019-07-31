require 'spec_helper'

describe 'Show private event', type: :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) do
    create(
      :event,
      :tasafoconf,
      users: [user],
      owner: user,
      to_public: false,
      start_date: Date.today,
      end_date: Date.today + 1.year
    )
  end

  context 'when logged' do
    before do
      login_as(user)

      visit events_path
      click_link 'Meus eventos'
      click_link 'Tá Safo Conf'
    end

    it 'redirects to the show page' do
      expect(current_path).to eql(event_path(event))
    end

    it 'displays detail event' do
      expect(page).to have_content('Tá Safo Conf')
    end
  end

  context 'when unlogged' do
    before do
      visit root_path
      visit event_path(event)
    end

    it 'redirects to the events page' do
      expect(current_path).to eql(events_path)
    end

    it 'displays error message' do
      expect(page).to have_content('Evento não foi encontrado(a)')
    end
  end
end
