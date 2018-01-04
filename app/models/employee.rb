class Employee < ApplicationRecord
    mount_uploader :image, ImageUploader
    attr_accessor :remember_token
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 } 
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    number_regex = /\A([0-9]+){10}\z/
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates_processing_of :image
    validate :image_size_validation
    validates :password, presence: true, length: { minimum: 6 },allow_nil: true
    validates :phone,format: { with: number_regex },uniqueness:true

    # Returns the hash digest of the given string.
    def Employee.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def Employee.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = Employee.new_token
        update_attribute(:remember_digest, Employee.digest(remember_token))
    end 

    # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
        return false if remember_digest.nil?        
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a user.
    def forget
        update_attribute(:remember_digest, nil)
    end

    private
    
    def image_size_validation
        errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
    end
end 
