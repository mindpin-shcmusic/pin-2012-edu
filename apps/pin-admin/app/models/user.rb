class User < AuthAbstract
  include UserMethods
  include Student::UserMethods
  include Teacher::UserMethods
end
