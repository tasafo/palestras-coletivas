require 'spec_helper'

describe 'Edit password resets' do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }

  context 'when the password has not yet expired' do
    before do
      visit edit_password_reset_url(user.password_reset_token)
    end

    context 'when valid data' do
      before do
        fill_in 'Sua senha', with: 'newpassword'
        fill_in 'Confirme sua senha', with: 'newpassword'

        click_button 'Atualizar senha'
      end

      it 'displays success message' do
        expect(current_path).to eql(new_password_reset_path)
        expect(page).to have_content('A senha foi redefinida.')
      end
    end

    context 'when invalid data' do
      before do
        fill_in 'Sua senha', with: 'newpassword'
        fill_in 'Confirme sua senha', with: 'otherpassword'

        click_button 'Atualizar senha'
      end

      it {
        expect(current_path)
          .to eql(password_reset_path(user.password_reset_token))
      }
    end
  end

  context 'when the password has expired' do
    before do
      visit edit_password_reset_url(other_user.password_reset_token)

      fill_in 'Sua senha', with: 'newpassword'
      fill_in 'Confirme sua senha', with: 'newpassword'

      click_button 'Atualizar senha'
    end

    it 'displays error message' do
      expect(current_path).to eql(new_password_reset_path)
      expect(page).to have_content('A redefinição de senha expirou.')
    end
  end
end
