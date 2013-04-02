module Features
  module SessionHelpers
    rspec type: :feature

    def sign_in
      user = Fabricate(:user)
      visit new_admin_session_path
      within "#sign_in" do
        fill_in 'admin_email', with: user.email
        fill_in 'admin_password', with: 'logmein'
        click_button 'Sign in'
      end
    end
  end
end
