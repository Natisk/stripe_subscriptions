# frozen_string_literal: true

class BaseService
  def self.call(name)
    new(name).call
  end
end
