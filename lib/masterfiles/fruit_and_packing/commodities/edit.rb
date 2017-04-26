module Masterfiles
  module FruitAndPacking
    module Commodities
      class Edit
        def self.call(id) # TODO: handle re-display on validation error...

# commodities.id
# commodity_code
# commodity_description_short
# commodity_description_long
# commodity_group_id
# commodities.commodity_group_code
# commodity_groups.commodity_group_description
# carton_fruit_standard_mass
# rebins_default_size
# bin_fruit_standard_mass
# ps_standard_mass
# grower_commitment_required

          this_repo = CommodityRepo.new(DB.db)
          obj     = this_repo.commodities.by_pk(id).one
          rules = { fields: {
            commodity_group_id:         { renderer: :select,
                                          selected: obj.commodity_group_id,
                                          options:  this_repo.commodity_groups_for_select },
            commodity_code:             { },
            commodity_description_short:          { },
            commodity_description_long:           { length: 50 },
            rebins_default_size:        { subtype: :integer },
            carton_fruit_standard_mass: { subtype: :numeric },
            bin_fruit_standard_mass:    { subtype: :numeric },
            ps_standard_mass:           { subtype: :numeric },
            grower_commitment_required: { renderer: :checkbox },
          } }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object this_repo.commodities.by_pk(id).one
            page.form do |form|
              form.action "/masterfiles/fruit_and_packing/commodities/#{id}/update"
              form.row do |row|
                row.column(:half) do |column|
                  column.add_field :commodity_group_id
                  column.add_field :commodity_code
                  column.add_field :commodity_description_short
                  column.add_field :commodity_description_long
                  column.add_field :rebins_default_size
                end
                row.column(:half) do |column|
                  column.add_field :carton_fruit_standard_mass
                  column.add_field :bin_fruit_standard_mass
                  column.add_field :ps_standard_mass
                  column.add_field :grower_commitment_required
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
