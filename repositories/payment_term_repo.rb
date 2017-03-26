require 'rom-repository'

class PaymentTermRepo < ROM::Repository[:payment_terms]
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
