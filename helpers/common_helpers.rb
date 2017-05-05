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

  # def current_user
  #   @user ||= User[ session[:user_id] ]
  # end

  def current_user
    return {} unless session[:user_id]
    UserRepo.new(DB.db).users.by_pk(session[:user_id]).one
  end

  def can_do_dataminer_admin?
    current_user[:department_name] == 'IT'
  end

end
