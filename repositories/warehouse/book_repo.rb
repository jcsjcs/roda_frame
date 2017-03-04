require 'rom-repository'

class BookRepo < ROM::Repository[:books]
  def query(conditions)
    books.where(conditions)
  end
end
