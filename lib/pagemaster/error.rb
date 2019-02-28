module Pagemaster
  module Error
    class MissingArgs < StandardError ; end
    class InvalidCollection < StandardError ; end
    class InvalidArgument < StandardError ; end
  end
end
