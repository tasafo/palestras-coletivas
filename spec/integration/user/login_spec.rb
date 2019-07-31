require 'spec_helper'

describe 'Login', type: :request do
  context 'with valids credential' do
    let!(:user) { create(:user, :paul) }

    before do
      visit login_path

      fill_in 'Seu e-mail', with: user.email
      fill_in 'Sua senha', with: 'testdrive'

      click_button 'Acessar minha conta'
    end

    it 'redirects to home page' do
      expect(current_path).to eql(root_path)
    end
  end

  context 'with invalid credentials' do
    before do
      visit login_path
      click_button 'Acessar minha conta'
    end

    it 'displays login page' do
      expect(current_path).to eql(login_path)
    end
  end
end
