module Security
  module FunctionalAreas
    module ProgramFunctions
      class New
        def self.call(id) # TODO: handle re-display on validation error...

          rules = { fields: {
            program_id: { renderer: :hidden },
            program_function_name: { },
            group_name: { },
            url: { },
            program_function_sequence: { renderer: :number },
            restricted_user_access: { renderer: :checkbox },
            active: { renderer: :checkbox },
          }, name: 'program_function'.freeze }

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object(OpenStruct.new(program_id: id,
                                            program_function_name: nil,
                                            group_name: nil,
                                            url: nil,
                                            program_function_sequence: nil,
                                            restricted_user_access: false,
                                            active: true))
            page.form do |form|
              form.action '/security/functional_areas/program_functions/create'
              form.add_field :program_id
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
