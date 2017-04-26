module Masterfiles
  module FruitAndPacking
    module Commodities
      class New
        def self.call # TODO: handle re-display on validation error...

          this_repo = CommodityRepo.new(DB.db)
          rules = { fields: {
            commodity_group_id: { renderer: :select,
                                  options:  this_repo.commodity_groups_for_select,
                                  prompt: true}, #'Select a date type'},
            short_description:  { },
            long_description:   { length: 50 },
            for_liquidation:    { renderer: :checkbox },
            percentage:         { subtype: :integer },
            days:               { subtype: :integer },
            amount_per_carton:  { subtype: :numeric },
            debtor_or_creditor: { renderer: :select,
                                  options: ['B', 'C', 'D'] }
          } }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object(OpenStruct.new(commodity_group_id: nil,
                                            short_description: nil,
                                            long_description: nil,
                                            for_liquidation: nil,
                                            percentage: nil,
                                            days: nil,
                                            amount_per_carton: nil,
                                            for_debtors_or_creditors: nil))
            page.form do |form|
              form.action '/masterfiles/fruit_and_packing/commodities/create'
              form.row do |row|
                row.column(:half) do |column|
                  column.add_field :commodity_group_id
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
end 
