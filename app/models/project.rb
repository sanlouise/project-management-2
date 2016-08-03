class Project < ActiveRecord::Base
  belongs_to :tenant
  has_many :attachments, dependent: :destroy
  has_many :user_projects
  has_many :users, through: :user_projects

  validates_presence_of :title
  validates_presence_of :details
  validates_presence_of :deadline
  validate :free_plan_can_only_have_five_projects

  def free_plan_can_only_have_five_projects
  	if self.new_record? && (tenant.projects.count > 5) && (tenant.plan == 'free')
  		errors.add(:base, "Free plans cannot have more than 5 projects.")
  	end
    Project.by_user_plan_and_tenant(tenant.id)
  end

  private

    def self.by_user_plan_and_tenant(tenant_id, user)
      tenant = Tenant.find(tenant_id)
      if tenant.plan == 'premium'
        if user.is_admin?
          tenant.projects
        else 
          user.projects.where(tenant_id: tenant.id)
        end
      else
        if user.is_admin?
          tenant.projects.order(:id).limit(5)
        else
          user.projects_where(tenant:id tenant_id).order(:id).limit(5)
        end
      end
    end
    
end
