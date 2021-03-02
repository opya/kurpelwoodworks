class Result < Struct
  class << self
    def with_members(*members)
      new(*members, :errors, keyword_init: true)
    end

    def success(*values)
      new(*values)
    end

    def failure(errors)
      new(errors: errors)
    end
  end

  def initialize(*args)
    super(*args)
    self.errors ||= []
  end

  def and_then
    yield(*values) if errors.none?
    self
  end

  def or_else
    yield(errors) if errors.any?
    self
  end
end
