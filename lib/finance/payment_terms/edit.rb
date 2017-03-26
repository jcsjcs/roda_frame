module Finance
  module PaymentTerms
    class Edit
      def self.call(id) # TODO: handle re-display on validation error...

        pt_repo = PaymentTermRepo.new(DB.db)

        layout = Crossbeams::Layout::Page.build do |page|
          page.form_object pt_repo.payment_terms.by_pk(id).one
          page.form do |form|
            form.action "/finance/payment_terms/payment_terms/#{id}/update"
            form.row do |row|
              row.column(:half) do |column|
                column.add_field :payment_term_date_type_id
                column.add_field :short_description
                column.add_field :long_description
                column.add_field :for_liquidation
                column.add_field :percentage
                column.add_field :days
                column.add_field :amount_per_carton
                column.add_field :debtor_or_creditor
              end
            end
          end
        end

        layout
      end
    end
  end
end



