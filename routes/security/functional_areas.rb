Dir['./lib/security/functional_areas/**/*.rb'].each { |f| require f }
Dir['./lib/security/programs/**/*.rb'].each { |f| require f }
Dir['./lib/security/program_functions/**/*.rb'].each { |f| require f }
class RodaFrame < Roda
  route 'functional_areas', 'security' do |r|
    # --- see empty root plugin...
    r.on 'functional_areas' do
      r.root do
        render(inline: '<h2>functional_areas</h2>')
        # view(inline: UserRepo.new(DB.db).index.map do |c|
        #   "#{c[:id]} : #{c[:user_name]}"
        # end.inspect)
      end
      r.on 'new' do
        show_page { Security::FunctionalAreas::FunctionalAreas::New.call }
      end
      r.on 'create' do
        repo = FunctionalAreaRepo.new(DB.db)
        # changeset = repo.changeset(params[:functional_area]).map(:add_timestamps)
        changeset = repo.changeset(NewChangeset).data(params[:functional_area])
        repo.create(changeset)
        flash[:notice] = 'Created'
        redirect_to_last_grid(r)
        # view(inline: "Func.Area.create - should not be GET: RES: #{res.class} #{res.inspect} | #{changeset.to_h.inspect}")
      end
      r.on :id do |id|
        # r.get true do
        #   'SHOW'
        # end
        r.on 'edit' do
          show_page { Security::FunctionalAreas::FunctionalAreas::Edit.call(id) }
        end
        r.post do
          r.on 'update' do
            # TODO:
            # - valdate params
            # - update database
            # - redirect somewhere (list/view/next step)
            # - OR re-display edit with errors
            repo = FunctionalAreaRepo.new(DB.db)
            # obj  = repo.functional_areas.by_pk(id).one
            puts ">>> FA parmtype: #{params[:functional_area].class}, #{params[:functional_area].inspect}"
            changeset = repo.changeset(id, params[:functional_area]).map(:touch)
            # repo.update(id, params[:functional_area])
            # changeset = repo.changeset(id, UpdateChangeset).data(params[:functional_area])
            repo.update(id, changeset)
            flash[:notice] = 'Updated'
            redirect_to_last_grid(r)

            # view(inline: "Func.Area UPDATE<p>#{params[:functional_area].inspect} | #{changeset.to_h.inspect}</p>")
          end
        end
        r.delete do
          repo = FunctionalAreaRepo.new(DB.db)
          repo.delete(id)
          flash[:notice] = 'Deleted'
          redirect_to_last_grid(r)
          # view(inline: 'POST via DELETE - Func.Area DELETE')
        end
      end
    end

    r.on 'programs' do
      r.on 'create' do
        repo = ProgramRepo.new(DB.db)
        # changeset = repo.changeset(params[:functional_area]).map(:add_timestamps)
        changeset = repo.changeset(NewChangeset).data(params[:program])
        repo.create(changeset)
        flash[:notice] = 'Created'
        r.redirect '/list/menu_definitions'
      end
      r.on :id do |id|
        r.on 'new' do
          show_page { Security::FunctionalAreas::Programs::New.call(id) }
        end
        r.on 'edit' do
          show_page { Security::FunctionalAreas::Programs::Edit.call(id) }
        end
        r.post do
          r.on 'update' do
            repo = ProgramRepo.new(DB.db)
            changeset = repo.changeset(id, params[:program]).map(:touch)
            # changeset = repo.changeset(id, UpdateChangeset).data(params[:functional_area])
            repo.update(id, changeset)
            flash[:notice] = 'Updated'
            redirect_to_last_grid(r)
          end
        end
        r.delete do
          repo = ProgramRepo.new(DB.db)
          repo.delete(id)
          flash[:notice] = 'Deleted'
          redirect_to_last_grid(r)
        end
      end
    end

    r.on 'program_functions' do
      r.on 'create' do
        repo = ProgramFunctionRepo.new(DB.db)
        # changeset = repo.changeset(params[:functional_area]).map(:add_timestamps)
        changeset = repo.changeset(NewChangeset).data(params[:program_function])
        repo.create(changeset)
        flash[:notice] = 'Created'
        r.redirect '/list/menu_definitions'
      end
      r.on :id do |id|
        r.on 'new' do
          show_page { Security::FunctionalAreas::ProgramFunctions::New.call(id) }
        end
        r.on 'edit' do
          show_page { Security::FunctionalAreas::ProgramFunctions::Edit.call(id) }
        end
        r.post do
          r.on 'update' do
            repo = ProgramFunctionRepo.new(DB.db)
            changeset = repo.changeset(id, params[:program_function]).map(:touch)
            # changeset = repo.changeset(id, UpdateChangeset).data(params[:functional_area])
            repo.update(id, changeset)
            flash[:notice] = 'Updated'
            redirect_to_last_grid(r)
          end
        end
        r.delete do
          repo = ProgramFunctionRepo.new(DB.db)
          repo.delete(id)
          flash[:notice] = 'Deleted'
          redirect_to_last_grid(r)
        end
      end
    end
  end
end

