require_relative './presenter.rb'
require_relative './record_presenter.rb'

class RecordsPresenter < Presenter
  def call
    @object.map { |record| RecordPresenter.call(record) }
  end
end
