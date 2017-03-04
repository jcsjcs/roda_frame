class RodaFrame < Roda
  route 'generic_invoices', 'finance' do |r|
    'From Finance | Generic Invoices'
  end
end
