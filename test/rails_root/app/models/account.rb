class Account < ActiveRecord::Base
  ensures_immutability_of :username
end
