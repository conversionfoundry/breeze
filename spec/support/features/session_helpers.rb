module Features
  module SessionHelpers
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
