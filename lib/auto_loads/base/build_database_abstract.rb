class BuildDatabaseAbstract < ActiveRecord::Base
  self.abstract_class = true
  build_database_connection('pin-edu-sns')
end

