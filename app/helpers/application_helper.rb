module ApplicationHelper

	def tenant_name(tenant_id)
		Tenant.find(tenant_id).name
	end
  
  def s3_link(tenant_id, attachment_key)
    link_to attachment_key, "#{attachment_key}", class: "main-link", target: 'new'
  end

end
