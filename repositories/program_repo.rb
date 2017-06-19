require 'rom-repository'

class ProgramRepo < ROM::Repository[:programs]
  commands :create, update: :by_pk, delete: :by_pk

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
end
