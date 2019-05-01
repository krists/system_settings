string :default_mail_from, value: "Example Company <noreply@example.com>", description: "This email will be used for all outgoing emails"
integer :articles_per_page, value: 50
integer :init_at, value: -> { Time.now.to_i }
string_list :admin_emails, description: "Will receive alerts"
integer_list :lucky_numbers, description: "Prime numbers are more effective"
