Dir['./lib/masterfiles/fruit_and_packing/**/*.rb'].each { |f| require f }
class RodaFrame < Roda
  route 'fruit_and_packing', 'masterfiles' do |r|
    # --- see empty root plugin...
    r.on 'commodities' do
      r.root do
        render(inline: '<h2>Commodities</h2>')
        # view(inline: UserRepo.new(DB.db).index.map do |c|
        #   "#{c[:id]} : #{c[:user_name]}"
        # end.inspect)
      end
      r.on 'new' do
        show_page { Masterfiles::FruitAndPacking::Commodities::New.call }
      end
      r.on 'create' do
        view(inline: 'COMM.create - should not be GET')
      end
      r.on :id do |id|
        # r.get true do
        #   'SHOW'
        # end
        r.on 'edit' do
          show_page { Masterfiles::FruitAndPacking::Commodities::Edit.call(id) }
        end
        r.post 'update' do
          view(inline: 'COMM UPDATE')
        end
        r.on 'delete' do
          view(inline: 'COMM DELETE')
        end
      end
    end

    r.on 'varieties' do
      r.root do
        view(inline: 'VARIETIES.index')
      end
    end
  end
end
