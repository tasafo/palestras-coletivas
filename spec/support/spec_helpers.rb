module SpecHelpers
  def login_as(user)
    visit root_path
    click_link "Acessar minha conta"

    fill_in "Seu e-mail", :with => user.email
    fill_in "Sua senha", :with => "testdrive"
    click_button "Acessar minha conta"
  end
end