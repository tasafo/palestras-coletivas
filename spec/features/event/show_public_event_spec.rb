require 'spec_helper'

describe 'Show public event', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:event) do
    create(
      :event, :tasafoconf,
      users: [user], owner: user, to_public: true, start_date: '2021-01-25',
      end_date: '2021-02-01'
    )
  end

  context 'when logged' do
    before do
      login_as user, events_path

      click_link 'Meus eventos'
      click_link 'Tá Safo Conf'
    end

    it 'displays detail event' do
      expect(page).to have_current_path(event_path(event))
      expect(page).to have_content('Tá Safo Conf')
    end
  end
end
