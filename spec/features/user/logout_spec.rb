require 'spec_helper'

describe 'Logout' do
  context 'when logged in' do
    let!(:user) { create(:user, :paul) }

    before do
      login_as user, root_path

      visit logout_path
    end

    it "doesn't render name" do
      expect(page).to have_current_path(root_path)
      expect(page).not_to have_content("Olá, #{user.name}")
    end
  end

  context 'when unlogged' do
    before do
      visit logout_path
    end

    it { expect(page).to have_current_path(root_path) }
  end
end
