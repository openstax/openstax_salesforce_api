class RemoveUnneededFieldsOnContact < ActiveRecord::Migration[6.1]
  def change
    # We do not want people using SFAPI to get user email addresses so we are going to remove this fields so they don't raise up in the API
    # If we decide we need to start creating contact (therefore, needing their email address), that should be fetched from accounts, not SF
    # So we have the most up to date information
    column_exists?(:contacts, :email_alt) ? remove_column(:contacts, :email_alt) : nil
    column_exists?(:contacts, :all_emails) ? remove_column(:contacts, :all_emails) : nil
    column_exists?(:contacts, :email) ? remove_column(:contacts, :email) : nil
    column_exists?(:contacts, :confirmed_emails) ? remove_column(:contacts, :confirmed_emails) : nil
    column_exists?(:contacts, :send_faculty_verification_to) ? remove_column(:contacts, :send_faculty_verification_to) : nil
  end
end
