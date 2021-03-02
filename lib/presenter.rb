class Presenter
  def initialize(object)
    @object = object
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end
end
