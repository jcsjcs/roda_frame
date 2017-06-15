module Security
  module FunctionalAreas
    module FunctionalAreas
      class Edit
        def self.call(id) # TODO: handle re-display on validation error...

          this_repo = FunctionalAreaRepo.new(DB.db)
          obj     = this_repo.functional_areas.by_pk(id).one
          rules = { fields: {
            functional_area_name: { },
            active: { renderer: :checkbox },
          } }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object obj # this_repo.commodities.by_pk(id).one
            page.form do |form|
              form.action "/security/functional_areas/functional_areas/#{id}/update"
              form.add_field :functional_area_name
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end

