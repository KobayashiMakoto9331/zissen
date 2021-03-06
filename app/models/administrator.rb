class Administrator < ApplicationRecord
  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password) #暗号化
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
