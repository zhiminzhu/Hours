# == Schema Information
#
# Table name: public.accounts
#
#  id         :integer          not null, primary key
#  subdomain  :string           default(""), not null
#  owner_id   :integer          default("0"), not null
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  RESTRICTED_SUBDOMAINS = %w(www admin)

  before_validation :downcase_subdomain

  validates :owner, presence: true
  validates :subdomain, presence: true,
                        uniqueness: { case_sensitive: false },
                        format:
                        {
                          with: /\A[\w\-]+\Z/i,
                          message: :invalid_characters
                        },
                        exclusion:
                        {
                          in: RESTRICTED_SUBDOMAINS,
                          message: :restricted
                        }

  belongs_to :owner, class_name: "User"

  has_many :users, inverse_of: :organization

  private

  def downcase_subdomain
    self.subdomain = subdomain.try(:downcase)
  end
end
