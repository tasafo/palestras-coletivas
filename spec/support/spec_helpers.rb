module SpecHelpers
  def login_as(user)
    visit root_path
    click_link "Acesso"
    click_link "Minha conta"

    fill_in "Seu e-mail", :with => user.email
    fill_in "Sua senha", :with => "testdrive"
    click_button "Acessar minha conta"
  end

  def fill_in_inputmask(location, options={})
    len = options[:with].to_s.length - 1
    len.times do
      fill_in location, :with => '1'
    end
    fill_in location, options
  end
end
