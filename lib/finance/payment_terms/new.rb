module Finance
  module PaymentTerms
    class New
      def self.call # TODO: handle re-display on validation error...

        pt_repo = PaymentTermRepo.new(DB.db)
        #obj     = pt_repo.payment_terms.by_pk(id).one
        rules = { fields: {
          payment_term_date_type_id: { renderer: :select,
                                       # selected: obj.payment_term_date_type_id,
                                       options:  pt_repo.date_types_for_select,
                                       prompt: true}, #'Select a date type'},
          short_description:         { },
          long_description:          { length: 50 },
          for_liquidation:           { renderer: :checkbox },
          percentage:                { subtype: :integer },
          days:                      { subtype: :integer },
          amount_per_carton:         { subtype: :numeric },
          debtor_or_creditor:        { renderer: :select,
                                       options: ['B', 'C', 'D'] }
        } }

        layout = Crossbeams::Layout::Page.build(rules) do |page|
          page.form_object(OpenStruct.new(payment_term_date_type_id: nil,
                short_description: nil,
                long_description: nil,
                for_liquidation: nil,
                percentage: nil,
                days: nil,
                amount_per_carton: nil,
                for_debtors_or_creditors: nil))
          page.form do |form|
            form.action '/finance/payment_terms/payment_terms/create'
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


