module CommonHelpers
  # Show a Crossbeams::Layout page
  # - The block must return a Crossbeams::Layout::Page
  def show_page(&block)
    @layout = block.yield
    @layout.add_csrf_tag(csrf_tag)
    view('crossbeams_layout_page')
  end

  def make_options(ar)
    ar.map do |a|
      if a.kind_of?(Array)
        "<option value=\"#{a.last}\">#{a.first}</option>"
      else
        "<option value=\"#{a}\">#{a}</option>"
      end
    end.join("\n")
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= UserRepo.new(DB.db).users.by_pk(session[:user_id]).one
  end

  def authorised?(programs, sought_permission)
    return true # JUST FOR TESTING....
    return false unless current_user
    prog_repo = ProgramRepo.new(DB.db)
    prog_repo.authorise?(current_user, Array(programs), sought_permission)
  end

  def can_do_dataminer_admin?
    # TODO: what decides that user can do admin? security role on dm program?
    # program + user -> program_users -> security_group -> security_permissions
    current_user && authorised?(:data_miner, :admin)
    # current_user # && current_user[:department_name] == 'IT'
  end

  def redirect_to_last_grid(r)
    r.redirect session[:last_grid_url]
  end

end
