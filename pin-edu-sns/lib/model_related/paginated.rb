require 'active_support/concern'

module Paginated
  extend ActiveSupport::Concern

  included do
    self.per_page = 20
  end

  module ClassMethods
    def paginated(page)
      paginate(:page => page)
    end
  end
end
