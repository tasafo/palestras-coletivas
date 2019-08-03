require 'spec_helper'

describe 'add presence', type: :request, js: true do
  let(:user) { create(:user, :paul) }
  let(:billy) { create(:user, :billy) }
  let(:event) do
    create(:event, :tasafoconf, owner: billy, start_date: Date.today,
                                end_date: Date.today)
  end

  before do
    login_as(user)
  end

  context 'when user does not presence' do
    before do
      visit event_path(event)
    end

    it {
      expect(page)
        .not_to have_content(I18n.t('show.event.btn_presence_checkin'))
    }
  end

  context 'when user is present' do
    let!(:enrollment) do
      create(:enrollment, user: user, event: event, active: true,
                          present: false)
    end

    before do
      visit event_path(event)

      click_link 'Registrar entrada'
    end

    it {
      expect(page).to have_content(I18n.t('show.event.btn_presence_checkin'))
    }
  end
end
