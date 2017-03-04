class RodaFrame < Roda
  route 'finance', 'masterfiles' do |r|
    'From Masterfiles | Finance'
  end
end
