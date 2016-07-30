class Tenant < ActiveRecord::Base
  
  acts_as_universal_and_determines_tenant
  has_many :members, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_one :payment
  accepts_nested_attributes_for :payment

  validates_uniqueness_of :name
  validates_presence_of :name
  
  def can_create_projects?
    (plan == 'free' && projects.count < 6) || (plan == 'premium')  
  end
  
  def self.create_new_tenant(tenant_params, user_params, coupon_params)
    tenant = Tenant.new(tenant_params)
    if new_signups_not_permitted?(coupon_params)
      raise ::Milia::Control::MaxTenantExceeded, "Sorry, new accounts not permitted at this time" 
    else 
      tenant.save
    end
    return tenant
  end

  def self.new_signups_not_permitted?(params)
    return false
  end

  def self.tenant_signup(user, tenant, other = nil)
    Member.create_org_admin(user)
  end

   
end