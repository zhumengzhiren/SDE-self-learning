require 'rspec'
require './lib/activerecord_practice'
require 'byebug'

ALL_CUSTOMERS = [nil] + Customer.all.order('id')

def check(actual, expected_ids)
  actual ||= []
  expected = ALL_CUSTOMERS.values_at(*expected_ids)
  missing = expected - actual
  raise "Result should have contained these, but it did not:\n#{missing.join("\n")}" unless missing.empty?

  extra = actual - expected
  return if extra.empty?

  raise "Result should NOT have contained these, but it did:\n#{extra.join("\n")}"
end

describe 'ActiveRecord practice' do
  around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  describe 'to find' do
    before do
      # disable methods we don't want you to use...
      expect(Customer).not_to receive(:find)
      expect(Customer).not_to receive(:expect)
    end

    describe 'using .where:' do
      # all of the examples in this describe block should be made
      # to pass by using one or more calls to ActiveRecord's "where()"
      before do
        expect(Customer).to receive(:where).at_least(:once).and_call_original
      end

      specify 'anyone with first name Candice' do
        check Customer.any_candice, [24]
      end

      specify 'with valid email (email addr contains "@") (HINT: look up SQL LIKE operator)' do
        check Customer.with_valid_email, [1, 2, 4, 5, 7, 8, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 23, 26, 29, 30]
      end

      specify 'with .org emails' do
        check Customer.with_dot_org_email, [5, 7, 8, 12, 23, 26, 29]
      end

      specify 'with invalid but nonblank email (does not contain "@")' do
        check Customer.with_invalid_email, [3, 6, 9, 16, 22, 25, 27, 28]
      end

      specify 'with blank email' do
        check  Customer.with_blank_email, [21, 24]
      end

      specify 'born before 1 Jan 1980' do
        check Customer.born_before_1980, [3, 8, 9, 11, 15, 16, 17, 19, 20, 24, 25, 27]
      end

      specify 'with valid email AND born before 1/1/1980' do
        check Customer.with_valid_email_and_born_before_1980, [8, 11, 15, 17, 19, 20]
      end

      specify 'with last names starting with "B", sorted by birthdate' do
        expect(Customer.last_names_starting_with_b.map(&:id)).to eq([25, 23, 4, 28, 18, 21, 29, 1])
      end
    end

    describe 'without needing .where' do
      specify '20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)' do
        check Customer.twenty_youngest, [7, 5, 6, 30, 1, 10, 29, 21, 18, 13, 14, 28, 26, 4, 2, 22, 23, 12, 11, 9]
      end
    end
  end

  describe 'to update' do
    before do
      expect(Customer).not_to receive(:find)
    end

    specify 'the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)' do
      Customer.update_gussie_murray_birthdate
      expect(Customer.find_by(first: 'Gussie').birthdate.to_date).to eq(Date.new(2004, 2, 8))
    end

    specify 'all invalid emails to be blank' do
      Customer.change_all_invalid_emails_to_blank
      expect(Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").count).to be_zero
    end

    specify 'database by deleting customer Meggie Herman' do
      Customer.delete_meggie_herman
      expect(Customer.find_by(first: 'Meggie', last: 'Herman')).to be_nil
    end

    specify 'database by deleting all customers born on or before 31 Dec 1977' do
      Customer.delete_everyone_born_before_1978
      expect(Customer.where('birthdate < ?', Date.new(1977, 12, 31))).to be_empty
    end
  end
end
