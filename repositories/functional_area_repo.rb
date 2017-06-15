require 'rom-repository'

class FunctionalAreaRepo < ROM::Repository[:functional_areas]
  commands :create, update: :by_pk, delete: :by_pk
end
