class RodaFrame < Roda
  route 'payment_terms', 'finance' do |r|
    # First check the user has read access to the programme...
    # ap r.path
    # ap r.matched_path
    # ap r.remaining_path
    # r.is '' do # THIS ==
    # r.root do   # THIS ==
    #   'Got to the base of terms' # If url ends in '/'
    # end
    # r.on :id do |id|
    #   # check for /edit/sho/delete...
    #   r.on 'edit' do
    #     "Get the term for #{id}"
    #   end
    #   r.post do
    #     "Process saved edit for #{id}"
    #   end
    #   id.inspect
    # end
    # 'From Finance | Payment Terms' # If url has no '/'
    # --- see empty root plugin...
    r.on 'payment_terms' do
      r.root do
        # 'PAYTERMS.index'
        # DB.default['select user_name from users limit 2'].to_a.inspect
        # DB.base['select user_name from users limit 2'].to_a.inspect
        UserRepo.new(DB.db).index.map do |c|
          "#{c[:id]} : #{c[:user_name]}"
        end.inspect
      end
      r.on 'new' do
        'PAYTERMS.new'
      end
      r.on 'create' do
        'PAYTERMS.create - should not be GET'
      end
      r.on :id do
        r.root do
          'SHOW'
        end
        r.on 'edit' do
          'PT EDIT'
        end
        r.on 'update' do
          'PT UPDATE - should not be GET'
        end
        r.on 'delete' do
          'PT DELETE - should not be GET'
        end
      end
    end
    r.on 'payment_term_date_types' do
      r.root do
        'DATE TYPES.index'
      end
    end
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
