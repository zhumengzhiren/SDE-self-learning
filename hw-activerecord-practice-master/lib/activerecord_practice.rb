require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE '%@%'")
  end
  # etc. - see README.md for more details

  def self.with_dot_org_email
    Customer.where("email LIKE ?", '%.org')
  end

  def self.with_invalid_email
    Customer.where("email != '' AND email NOT LIKE '%@%'")
  end

  def self.with_blank_email
    Customer.where("email IS NULL OR email = ''")
  end

  def self.born_before_1980
    Customer.where("birthdate < ?", Date.new(1980, 1, 1))
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email LIKE '%@%' AND birthdate < ?", Date.new(1980, 1, 1))
  end

  def self.last_names_starting_with_b
    Customer.where("last LIKE 'B%'").order(:birthdate)
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    customer = Customer.find_by(first: 'Gussie', last: 'Murray')
    customer.update(birthdate: Date.new(2004, 2, 8)) if customer
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email NOT LIKE '%@%'").update_all(email: '')
  end

  def self.delete_meggie_herman
    customer = Customer.find_by(first: 'Meggie', last: 'Herman')
    customer.destroy if customer
  end

  def self.delete_everyone_born_before_1978
    Customer.where('birthdate < ?', Date.new(1978, 1, 1)).destroy_all
  end
end

