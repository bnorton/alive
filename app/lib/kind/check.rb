module Kind
  class Check
    NOOP = 'noop'
    STATUS = 'status'
    HEADER = 'header'
    BODY = 'body'
    TIME = 'time'

    VALUES = [NOOP, STATUS, HEADER, BODY, TIME].map!(&:freeze).freeze
  end
end
