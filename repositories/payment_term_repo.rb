require 'rom-repository'

class PaymentTermRepo < ROM::Repository[:payment_terms]
  def date_types_for_select
    DB.base['SELECT id, type_of_date FROM payment_term_date_types ORDER BY type_of_date'].map {|r| [r[:type_of_date], r[:id]] }
  end
  # def query(conditions)
  #   payment_terms.where(conditions)
  # end
  # # A test using Sequel's SQL + first.
  # def count_them
  #   DB.base['SELECT COUNT(*) FROM payment_terms'].first
  # end
  #
  # def index
  #   payment_terms.index
  # end
end
