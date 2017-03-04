class RodaFrame < Roda
  route 'fruit_and_packing', 'masterfiles' do |r|
    'From Masterfiles | Fruit AND Packing'
  end
end
