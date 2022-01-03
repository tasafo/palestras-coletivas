require 'spec_helper'

describe 'Show private event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) do
    create(
      :event, :tasafoconf,
      users: [user], owner: user, to_public: false, start_date: Date.today,
      end_date: Date.today + 1.year
    )
  end

  context 'when logged' do
    before do
      login_as user, events_path

      click_link 'Meus eventos'
      click_link event.name_edition
    end

    it 'displays detail event' do
      expect(page).to have_current_path(event_path(event))
      expect(page).to have_content(event.name_edition)
    end
  end

  context 'when unlogged' do
    before do
      visit event_path(event)
    end

    it 'displays error message' do
      expect(page).to have_current_path(events_path)
      expect(page).to have_content('Evento não foi encontrado(a)')
    end
  end
end
