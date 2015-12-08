class Amount < ActiveRecord::Base
  def self.default
    10_00
  end
end
