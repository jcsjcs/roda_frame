module Warehouse # because in subfolder of relations
  class Books < ROM::Relation[:sql]
    gateway :warehouse
    dataset :books # otherwise the dataet would be warehouse_books...
    schema(infer: true)
  end
end
