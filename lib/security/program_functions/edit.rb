module Security
  module FunctionalAreas
    module ProgramFunctions
      class Edit
        def self.call(id, form_values = nil, form_errors = nil)

          this_repo = ProgramFunctionRepo.new(DB.db)
          obj     = this_repo.program_functions.by_pk(id).one
          rules = { fields: {
            program_function_name: { },
            group_name: { },
            url: { },
            program_function_sequence: { renderer: :number },
            restricted_user_access: { renderer: :checkbox },
            active: { renderer: :checkbox },
          } }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object obj
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.action "/security/functional_areas/program_functions/#{id}/update"
              form.add_field :program_function_name
              form.add_field :group_name
              form.add_field :url
              form.add_field :program_function_sequence
              form.add_field :restricted_user_access
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
