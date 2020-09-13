string :default_mail_from, value: "Example Company <noreply@example.com>", description: "This email will be used for all outgoing emails"
integer :default_records_per_page, value: 25
string_list :admin_emails, description: "Will receive alerts"
integer_list :lucky_numbers, description: "Prime numbers are more effective", value: [2, 3, 5, 11]
boolean :enable_user_import, value: false, description: "Enable user import from LDAP"
decimal :max_temp, value: 46.7, description: "wut?"
decimal_list :some_numbers, value: [46.7, 99.1]
