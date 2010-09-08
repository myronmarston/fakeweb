module FakeWeb
  module Response #:nodoc:

    def read_body(*args, &block)
      if block
        old_body = @body
        @body = Net::ReadAdapter.new(block)
        @body << old_body
      end
      @body
    end

  end
end