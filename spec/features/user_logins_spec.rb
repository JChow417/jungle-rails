require 'rails_helper'

RSpec.feature "UserLogins", type: :feature, js: true do
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    @user = User.create(
      first_name: 'Example first name',
      last_name: 'Example last name',
      email: 'Example@email.com',
      password: '1234',
      password_confirmation: '1234'
    )
  end
  scenario "Registerd users can login" do
  # ACT
  visit root_path
  navbar = page.first('#navbar')
  navbar.click_link('Login')
  expect(page).to have_css('h1', text: "Login")
  save_screenshot

  fill_in 'email', with: 'Example@email.com'
  fill_in 'password', with: '1234'
  find('input[name="commit"]').click

  # DEBUG / VERIFY
  expect(page).to have_css('#navbar', text: "Signed in as Example first name")
  save_screenshot

  end
end
