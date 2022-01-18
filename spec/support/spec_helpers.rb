module SpecHelpers
  def login_as(user, redirect = nil)
    redirect = redirect ? "?redirect=#{redirect}" : ''

    visit "/login#{redirect}"

    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: 'testdrive'

    click_button 'Acessar minha conta'
  end

  def click_with_alert(target)
    page.accept_alert do
      page.click_link target
    end
  end
end
