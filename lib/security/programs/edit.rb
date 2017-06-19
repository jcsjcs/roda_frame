module Security
  module FunctionalAreas
    module Programs
      class Edit
        def self.call(id) # TODO: handle re-display on validation error...

          this_repo = ProgramRepo.new(DB.db)
          obj     = this_repo.programs.by_pk(id).one
          rules = { fields: {
            program_name: { },
            active: { renderer: :checkbox },
          } }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object obj
            page.form do |form|
              form.action "/security/functional_areas/programs/#{id}/update"
              form.add_field :program_name
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
