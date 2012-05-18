class Admin::Invite < ActiveRecord::Base
  attr_protected :token

  belongs_to :inviter, :class_name => "User"

  validates :inviter_id, :foreign_key, :uniqueness => true, :presence => true
  validates :token, presence: true
  validates :email, presence: true

  before_validation :create_invite_token

  private
    def create_invite_token
      self.token = SecureRandom.urlsafe_base64
    end
end
