require "spec_helper"

describe "Create enrollment", :type => :request, js: true do
  let!(:user) { create(:user, :paul) }
  let!(:other_user) { create(:user, :billy) }
  let!(:another_user) { create(:user, :luis) }
  let!(:event) { create(:event, :tasafoconf, :deadline_date_enrollment => Date.today, :users => [ user ], :owner => user) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user) }
  let!(:schedule_palestra) { create(:schedule, :palestra, :event => event, :talk => talk) }
  let!(:enrollment_active) { create(:enrollment, :event => event, :user => another_user) }

  context "when logged" do
    before do
      login_as(other_user)
      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Quero participar!"
      click_button "Quero participar"
    end

    it "redirects to the event page" do
      expect(current_path).to eql(event_path(event))
    end

    it "displays success message" do
      expect(page).to have_content("A inscrição foi realizada!")
    end
  end

  context "when unlogged" do
    before do
      visit root_path
      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
      click_link "Quero participar!"
    end

    it "redirects to the login page" do
      expect(current_path).to eql(login_path)
    end

    it "displays login message" do
      expect(page).to have_content("Entrar")
    end

    context 'when user do log in' do
      before do
        visit root_path
        click_link("Eventos", match: :first)
        click_link "Tá Safo Conf"
        click_link "Quero participar!"
        fill_in "Seu e-mail", :with => other_user.email
        fill_in "Sua senha", :with => "testdrive"
        click_button "Acessar minha conta"
      end

      it "redirects to enrollment page" do
        expect(current_path).to eql new_event_enrollment_path(event, :active)
      end
    end

    context 'when user do log in and enrollment has held' do
      before do
        visit root_path
        click_link("Eventos", match: :first)
        click_link "Tá Safo Conf"
        click_link "Quero participar!"
        fill_in "Seu e-mail", :with => another_user.email
        fill_in "Sua senha", :with => "testdrive"
        click_button "Acessar minha conta"
        click_button "Quero participar!"
      end

      it "redirects to the event page" do
        expect(current_path).to eql(event_path(event))
      end

      it "displays error message" do
        expect(page).to have_content("A inscrição já havia sido realizada!")
      end
    end
  end

  context "when the user is organizer" do
    before do
      login_as(user)
      click_link("Eventos", match: :first)
      click_link "Tá Safo Conf"
    end

    it "redirects to the event page" do
      expect(current_path).to eql(event_path(event))
    end

    it "not show button I want to participate" do
      expect(page).not_to have_content("Quero participar!")
    end
  end
end
