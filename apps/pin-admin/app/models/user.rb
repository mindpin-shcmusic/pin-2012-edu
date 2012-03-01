class User < AuthAbstract
  include UserMethods
  has_one :teacher
end
