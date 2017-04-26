Dir['./lib/finance/payment_terms/*.rb'].each { |f| require f }
class RodaFrame < Roda
  route 'payment_terms', 'finance' do |r|
    # # 'From Finance | Payment Terms' # If url has no '/'
    # # --- see empty root plugin...
    # r.on 'payment_terms' do
    #   r.root do
    #     view(inline: UserRepo.new(DB.db).index.map do |c|
    #       "#{c[:id]} : #{c[:user_name]}"
    #     end.inspect)
    #   end
    #   r.on 'new' do
    #     show_page { Finance::PaymentTerms::New.call }
    #   end
    #   r.on 'create' do
    #     view(inline: 'PAYTERMS.create - should not be GET')
    #   end
    #   r.on :id do |id|
    #     r.root do
    #       'SHOW'
    #     end
    #     r.on 'edit' do
    #       show_page { Finance::PaymentTerms::Edit.call(id) }
    #     end
    #     r.on 'update' do
    #       view(inline: 'PT UPDATE - should not be GET')
    #     end
    #     r.on 'delete' do
    #       view(inline: 'PT DELETE - should not be GET')
    #     end
    #   end
    # end
    # r.on 'payment_term_date_types' do
    #   r.root do
    #     view(inline: 'DATE TYPES.index')
    #   end
    # end
  end
end
__END__
URLs
G list_payment_terms
G new_payment_term
P create
G edi_pt
T update
D delete
G list_pt_date_types

finance/payment_terms/payment_terms/
finance/payment_terms/payment_terms/new
finance/payment_terms/payment_terms/create
finance/payment_terms/payment_terms/:id/edit
finance/payment_terms/payment_terms/:id/update
finance/payment_terms/payment_terms/:id/delete

finance/payment_terms/payment_term_date_types/
