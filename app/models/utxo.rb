class Trade < Sequel::Model(:trade)

  PENDING = 0
  OPEN = 1
  CLOSED = 4
  FINISHED = 2
  FINALIZED = 3

end