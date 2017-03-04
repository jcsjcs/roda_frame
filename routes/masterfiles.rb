Dir['./routes/masterfiles/*.rb'].each { |f| require f }

class RodaFrame < Roda
  route('masterfiles') do |r|
    r.multi_route('masterfiles')
  end
end
