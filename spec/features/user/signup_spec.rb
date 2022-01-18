require 'spec_helper'

describe 'Signup' do
  let!(:image_path) { ImageFile.asset('avatar.jpg') }

  before do
    visit new_user_path
  end

  context 'with valid data' do
    before do
      fill_in 'Nome', with: 'Paul Young'
      fill_in 'Apelido', with: '@pyoung'
      fill_in 'E-mail', with: 'paul@example.org'
      fill_in 'Senha', with: 'testdrive'
      fill_in 'Confirmação da senha', with: 'testdrive'
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
