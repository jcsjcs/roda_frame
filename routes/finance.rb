Dir['./routes/finance/*.rb'].each { |f| puts f; require f; }

class RodaFrame < Roda
  route('finance') do |r|
    r.multi_route('finance')
  end
end
