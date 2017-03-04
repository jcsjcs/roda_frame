require 'rom-repository'

class SupplierInvoiceRepo < ROM::Repository[:supplier_invoices]
  def query(conditions)
    supplier_invoices.where(conditions)
  end
  # A test using Sequel's SQL + first.
  # def count_them
  #   DB.base['SELECT COUNT(*) FROM users'].first
  # end
end
