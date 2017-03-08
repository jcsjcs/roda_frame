Dir['./lib/framework/list/*.rb'].each { |f| require f }

class RodaFrame < Roda
  route('list') do |r|
    r.on :id do |id|
      r.is do
        show_page { Framework::List::List.call(id, params) }
      end

      # r.on 'run' do
      #   show_page { Framework::Search::Run.call(id, params) }
      # end

      r.on 'grid' do
        response['Content-Type'] = 'application/json'

        dmc = DataminerControl.new(list_file: id)
        dmc.list_rows(params)
      end
    end
  end
end

