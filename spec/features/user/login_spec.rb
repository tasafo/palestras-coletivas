require 'spec_helper'

describe 'Login' do
  before do
    visit login_path
  end

  context 'with valids credential' do
    let!(:user) { create(:user, :paul) }

    before do
      fill_in 'Seu e-mail', with: user.email
      fill_in 'Sua senha', with: 'testdrive'

      click_button 'Acessar minha conta'
    end

    it { expect(current_path).to eql(root_path) }
  end

  context 'with invalid credentials' do
    before do
      click_button 'Acessar minha conta'
    end

    it { expect(current_path).to eql(login_path) }
  end
end
