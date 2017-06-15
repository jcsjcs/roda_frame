Dir['./lib/security/functional_areas/**/*.rb'].each { |f| require f }
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
        res = repo.create(changeset)
        view(inline: "Func.Area.create - should not be GET: RES: #{res.class} #{res.inspect} | #{changeset.to_h.inspect}")
      end
      r.on :id do |id|
        # r.get true do
        #   'SHOW'
        # end
        r.on 'edit' do
          show_page { Security::FunctionalAreas::FunctionalAreas::Edit.call(id) }
        end
        r.post 'update' do
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

          view(inline: "Func.Area UPDATE<p>#{params[:functional_area].inspect} | #{changeset.to_h.inspect}</p>")
        end
        r.on 'delete' do
          view(inline: 'Func.Area DELETE')
        end
      end
    end

    r.on 'programs' do
      r.root do
        view(inline: 'programs.index')
      end
    end

    r.on 'program_functions' do
      r.root do
        view(inline: 'program_functions.index')
      end
    end
  end
end

