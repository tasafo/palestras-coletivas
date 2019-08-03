require 'spec_helper'

describe 'Create enrollment', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) do
    create(:event, :tasafoconf, deadline_date_enrollment: Date.today,
                                users: [user], owner: user)
  end
  let!(:talk) { create(:talk, users: [user], owner: user) }
  let!(:schedule_palestra) do
    create(:schedule, :palestra, event: event, talk: talk)
  end
  let!(:enrollment_active) do
    create(:enrollment, event: event, user: another_user)
  end

  context 'when logged' do
    before do
      login_as other_user, event_path(event)

      click_link 'Quero participar!'
      click_button 'Quero participar'
    end

    it 'displays success message' do
      expect(page).to have_current_path(event_path(event))
      expect(page).to have_content('A inscrição foi realizada!')
    end
  end

  context 'when' do
    before do
      visit event_path(event)

      click_link 'Quero participar!'
    end

    context 'unlogged' do
      it 'displays login message' do
        expect(page).to have_current_path(%r{/login.})
        expect(page).to have_content('Entrar')
      end
    end

    context 'user do log in' do
      before do
        fill_in 'Seu e-mail', with: other_user.email
        fill_in 'Sua senha', with: 'testdrive'

        click_button 'Acessar minha conta'
      end

      it do
        expect(page)
          .to have_current_path(new_event_enrollment_path(event, :active))
      end
    end

    context 'user do log in and enrollment has held' do
      before do
        fill_in 'Seu e-mail', with: another_user.email
        fill_in 'Sua senha', with: 'testdrive'

        click_button 'Acessar minha conta'
        click_button 'Quero participar!'
      end

      it 'displays error message' do
        expect(page).to have_current_path(event_path(event))
        expect(page).to have_content('A inscrição já havia sido realizada!')
      end
    end
  end

  context 'when the user is organizer' do
    before do
      login_as user, event_path(event)
    end

    it 'not show button I want to participate' do
      expect(page).to have_current_path(event_path(event))
      expect(page).not_to have_content('Quero participar!')
    end
  end
end
