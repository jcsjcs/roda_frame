require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers

    pgt_created_at(:users,
                   :created_at,
                   function_name: :set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:users,
                   :updated_at,
                   function_name: :set_updated_at,
                   trigger_name: :set_updated_at)

    pgt_created_at(:functional_areas,
                   :created_at,
                   function_name: :set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:functional_areas,
                   :updated_at,
                   function_name: :set_updated_at,
                   trigger_name: :set_updated_at)

    pgt_created_at(:programs,
                   :created_at,
                   function_name: :set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:programs,
                   :updated_at,
                   function_name: :set_updated_at,
                   trigger_name: :set_updated_at)

    pgt_created_at(:program_functions,
                   :created_at,
                   function_name: :set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:program_functions,
                   :updated_at,
                   function_name: :set_updated_at,
                   trigger_name: :set_updated_at)
  end

  down do
    drop_trigger(:users, :set_created_at)
    drop_trigger(:users, :set_updated_at)
    drop_trigger(:functional_areas, :set_created_at)
    drop_trigger(:functional_areas, :set_updated_at)
    drop_trigger(:programs, :set_created_at)
    drop_trigger(:programs, :set_updated_at)
    drop_trigger(:program_functions, :set_created_at)
    drop_trigger(:program_functions, :set_updated_at)
  end
end
