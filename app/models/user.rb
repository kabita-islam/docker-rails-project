class User < ApplicationRecord
  has_secure_password
  # SAFE_ATTRIBUTES = [
  #   :name,
  #   :email,
  #   :password
  # ]
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  # def safe_assign(attributes)
  #   assign_attributes(attributes.slice(*SAFE_ATTRIBUTES))
  # end
end
