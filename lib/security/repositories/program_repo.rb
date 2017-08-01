class ProgramRepo < RepoBase
  def initialize
    set_main_table :programs
    set_wrapper Program
  end

  def authorise?(user, programs, sought_permission)
    query = <<-EOQ
    SELECT security_permissions.id
    FROM security_groups_security_permissions
    JOIN security_groups ON security_groups.id = security_groups_security_permissions.security_group_id 
    JOIN security_permissions ON security_permissions.id = security_groups_security_permissions.security_permission_id
    JOIN program_users ON program_users.security_group_id = security_groups.id
    JOIN programs ON programs.id = program_users.program_id
    WHERE program_users.user_id = #{user.id}
    AND security_permissions.security_permission = '#{sought_permission}'
    AND programs.program_name IN ( '#{programs.map { |prog| prog.to_s }.join("','")}')
    EOQ
    !DB.base[query].first.nil?
  end

  def program_functions_for_select(id)
    query = <<-EOQ
    SELECT id, program_function_name
    FROM program_functions
    WHERE program_id = #{id}
    ORDER BY program_function_sequence
    EOQ
    DB.base[query].map { |rec| [rec[:program_function_name], rec[:id]] }
  end

  def re_order_program_functions(sorted_ids)
    upd = []
    sorted_ids.split(',').each_with_index do |id, index|
      upd << "UPDATE program_functions SET program_function_sequence = #{index+1} WHERE id = #{id};"
    end
    DB.base[upd.join].update
  end
end
