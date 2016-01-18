module SessionHelper
  def login_as(username)
    visit '?login=true'
    fill_in 'Username', with: username
    fill_in 'Password', with: 'guest'
    click_button 'Login'
  end
end
