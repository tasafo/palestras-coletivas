require 'spec_helper'

describe 'Register presence', js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) do
    create(:event, :tasafoconf, start_date: Date.today, end_date: Date.today,
                                deadline_date_enrollment: Date.today, users: [user], owner: user)
  end
  let!(:enrollment_billy) { create(:enrollment, event: event, user: other_user) }
  let!(:enrollment_luis) { create(:enrollment, present: true, event: event, user: another_user) }

  context 'when the user is' do
    before do
      login_as user, event_path(event)
    end

    context 'not present' do
      before do
        find("##{other_user.slug}").click
      end

      it 'displays success message' do
        expect(page).to have_content('Desfazer presença')
      end
    end

    context 'already present' do
      before do
        find("##{another_user.slug}").click
      end

      it 'displays success message' do
        expect(page).to have_content('Registrar presença')
      end
    end
  end
end
