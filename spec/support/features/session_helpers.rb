module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit sign_up_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign up'
    end

    def sign_in
      user = Fabricate(:user)
      visit '/admin'
      within "#sign_in" do
        fill_in 'admin_email', with: user.email
        fill_in 'admin_password', with: user.password
        click_button 'Sign in'
      end
    end
  end
end
