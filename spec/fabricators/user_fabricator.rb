Fabricator(:user, class_name: Breeze::Admin::User) do
  first_name "Theodore"
  last_name	"Sturgeon"
  email "ted@example.com"
  password "logmein"
  password_confirmation "logmein"
  roles [:admin]
end