feature 'Full test drive', :feature do

  scenario 'user logins, use dashboard, and logs out' do
    driver_session = build(:driver_session, :authenticable)

    # login with invalid password
    visit login_path
    expect(page).to have_content 'Login'
    puts '    visits login'

    fill_in 'Email', :with => driver_session.email
    fill_in 'Password', :with => 'worng password'
    click_button 'Sign in'

    expect(page).to have_content 'Email found but password is wrong'
    puts '    logins with invalid password'

    # login with valid credentials
    fill_in 'Email', :with => driver_session.email
    fill_in 'Password', :with => driver_session.password
    click_button 'Sign in'
    puts '    logins with valid credentials'


    # authenticated and redirected to dashboard
    expect(page).to have_content 'Driver session was successfully authenticated.'
    puts '    authenticated and redirected to dashboard'

    # fill in from, to dates filter, and filter
    fill_in 'from', :with => '2016-01-20'
    fill_in 'to', :with => '2016-05-20'
    click_button 'Filter'

    expect(page).to have_selector("input[value='2016-01-20']")
    expect(page).to have_selector("input[value='2016-05-20']")
    puts '    fills in date inputs, and filter schedule'

    # already authenticated, should be redirected
    visit login_path
    expect(page).to have_content 'You are already authenticated!'
    expect(page).to have_content 'Logout'
    puts '    tries to login again, but get redirected'


    click_on 'Logout'
    expect(page).to have_content 'Driver session was successfully destroyed.'
    puts '    logs out'

    visit dashboard_path
    expect(page).to have_content 'Sorry! You need to login first.'
    expect(page).to have_content 'Login'
    puts '    tries to visit dashboard, but gets redirected'

  end
end
