class Category < BuildDatabaseAbstract
  validates :name, :presence => true, :uniqueness => true
end
