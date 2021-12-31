require 'spec_helper'

describe 'Edit user' do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:image_path) { ImageFile.asset('without_avatar.jpg') }

  context 'when the current user owns the account' do
    before do
      login_as user, edit_user_path(user)
    end

    context 'with valid data' do
      before do
        fill_in 'Seu nome', with: 'Carl Simon'
        attach_file('Foto', image_path)

        click_button 'Atualizar dados'
      end

      it 'displays success message' do
        expect(page).to have_current_path(%r{/users/\w+})
        expect(page).to have_content('Seus dados foram atualizados!')
      end
    end

    context 'with invalid data' do
      before do
        fill_in 'Seu nome', with: ''
        attach_file('Foto', image_path)

        click_button 'Atualizar dados'
      end

      it 'displays error messages' do
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content('Verifique o formulário antes')
      end
    end

    context 'with valid password' do
      before do
        fill_in 'Sua senha', with: 'newpassword'
        fill_in 'Confirme sua senha', with: 'newpassword'
        attach_file('Foto', image_path)

        click_button 'Atualizar dados'
      end

      it 'displays success message' do
        expect(page).to have_current_path(%r{/users/\w+})
        expect(page).to have_content('Seus dados foram atualizados!')
      end
    end

    context 'with invalid password' do
      before do
        fill_in 'Sua senha', with: 'newpassword'
        fill_in 'Confirme sua senha', with: 'otherpassword'
        attach_file('Foto', image_path)

        click_button 'Atualizar dados'
      end

      it 'displays error messages' do
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content('Verifique o formulário antes')
      end
    end
  end

  context 'when the current user is not the owner of the account' do
    before do
      login_as other_user, edit_user_path(user)
    end

    it { expect(page).to have_current_path(root_path) }
  end
end
