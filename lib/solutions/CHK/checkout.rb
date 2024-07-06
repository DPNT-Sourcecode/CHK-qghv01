# noinspection RubyUnusedLocalVariable
class Checkout
  # Our price table and offers:
  # +------+-------+----------------+
  # | Item | Price | Special offers |
  # +------+-------+----------------+
  # | A    | 50    | 3A for 130     |
  # | B    | 30    | 2B for 45      |
  # | C    | 20    |                |
  # | D    | 15    |                |
  # +------+-------+----------------+
  # Invalid input: return -1

  def checkout(skus)
    case skus
    when 'A'
      50
    when 'C'
      20
    else
      -1
    end
  end

end


