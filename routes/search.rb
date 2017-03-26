Dir['./lib/framework/search/*.rb'].each { |f| require f }

class RodaFrame < Roda
  def no_such_search(filename)
    # filename != 'users'
    !%w{users payment_terms}.include?(filename)
  end

  route('search') do |r|
    r.on :id do |id|
      r.on no_such_search(id) do
        "There is no search named #{id}"
      end

      r.is do
        presenter = Framework::Search::Filter.call(id, params)
        view('framework/search/filter', locals: {presenter: presenter})
      end

      r.on 'run' do
        show_page { Framework::Search::Run.call(id, params) }
      end

      r.on 'grid' do
        response['Content-Type'] = 'application/json'

        dmc = DataminerControl.new(search_file: id)
        dmc.search_rows(params)
      end
    end
  end
end
