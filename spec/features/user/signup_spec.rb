require 'spec_helper'

describe 'Signup' do
  let!(:image_path) { asset_file('without_avatar.jpg') }

  before do
    visit new_user_path
  end

  context 'with valid data' do
    before do
      fill_in 'Seu nome', with: 'Paul Young'
      fill_in 'Seu apelido', with: '@pyoung'
      fill_in 'Seu e-mail', with: 'paul@example.org'
      fill_in 'Sua senha', with: 'testdrive'
      fill_in 'Confirme sua senha', with: 'testdrive'
      attach_file('Foto', image_path)

      click_button 'Cadastre-me'
    end

    it { expect(page).to have_current_path(login_path) }
  end

  context 'with invalid data' do
    before do
      attach_file('Foto', image_path)

      click_button 'Cadastre-me'
    end

    it {
      expect(page).to have_content('Verifique o formulário antes de continuar:')
    }
  end
end
