require 'spec_helper'

describe 'Register presence' do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }

  let!(:event) do
    create(
      :event,
      :tasafoconf,
      start_date: Date.today,
      end_date: Date.today,
      deadline_date_enrollment: Date.today,
      users: [user],
      owner: user
    )
  end

  let!(:enrollment_billy) do
    create(:enrollment, event: event, user: other_user)
  end
  let!(:enrollment_luis) do
    create(:enrollment, present: true, event: event, user: another_user)
  end

  context 'when the user is' do
    before do
      login_as user, event_path(event)
    end

    context 'not present' do
      before do
        click_link "user_id_#{other_user.id}"

        click_button 'Alterar participação'
      end

      it 'displays success message' do
        expect(page).to have_current_path(event_path(event))
        expect(page).to have_content('A inscrição foi alterada!')
      end
    end

    context 'already present' do
      before do
        click_link "user_id_#{another_user.id}"

        click_button 'Alterar participação'
      end

      it 'displays success message' do
        expect(page).to have_current_path(event_path(event))
        expect(page).to have_content('A inscrição foi alterada!')
      end
    end
  end

  context 'when the user does not have permission' do
    before do
      login_as other_user, event_path(event)

      visit edit_event_enrollment_path(event, :present, enrollment_luis)
    end

    it 'displays error message' do
      expect(page).to have_current_path(event_path(event))
      expect(page)
        .to have_content('Você não tem permissão para acessar esta página.')
    end
  end
end
