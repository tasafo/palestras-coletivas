require 'spec_helper'

describe 'Send password resets' do
  let!(:user) { create(:user, :paul) }

  before do
    visit login_path

    click_link 'Esqueceu a senha?'
  end

  context 'when valid data' do
    before do
      fill_in 'Seu e-mail', with: user.email

      click_button 'Redefinir senha'
    end

    it 'displays success message' do
      expect(page).to have_current_path(new_password_reset_path)
      expect(page)
        .to have_content('E-mail enviado com as instruções de redefinição')
    end
  end

  context 'when invalid data' do
    before do
      fill_in 'Seu e-mail', with: 'notfound@mail.com'

      click_button 'Redefinir senha'
    end

    it 'displays error messages' do
      expect(page).to have_current_path(new_password_reset_path)
      expect(page).to have_content('E-mail não encontrado.')
    end
  end
end
