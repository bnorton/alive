module Kind
  class Check
    NOOP = 'noop'
    STATUS = 'status'
    HEADER = 'header'
    BODY = 'body'
    TIME = 'time'
    VISIT = 'visit'
    FILL = 'fill'
    ACTION = 'action'

    VALUES = [NOOP, STATUS, HEADER, BODY, TIME, VISIT, FILL, ACTION].map!(&:freeze).freeze
  end
end
