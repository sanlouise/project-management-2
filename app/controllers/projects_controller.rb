class ProjectsController < ApplicationController
  
  before_action :set_project, only: [:show, :edit, :update, :destroy, :users, :add_user]
  before_action :set_tenant, except: [:index]
  before_action :verify_tenant
  respond_to :html

  def index
    @projects = Project.by_user_plan_and_tenant(params[:tenant_id], current_user)
    respond_with(@projects)
  end

  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    respond_with(@project)
  end

  def edit
  end

 def create
    @project = Project.new(project_params)
    @project.users << current_user
    respond_to do |format|
      if @project.save       
        format.html { redirect_to root_url, notice: 'The project was created successfully.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = 'Project was successfully updated.'
      respond_with(@project)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:notice] = 'Project was successfully destroyed.'
    respond_with(@project)
    redirect_to root_path
  end

  def users 
    @project_users = (@project.users + (User.where(tenant_id: @tenant.id, is_admin: true))) - [current_user]
    @other_users = @tenant.users.where(tenant_id: @tenant.id, is_admin: false) - (@project_users + [current_user])
  end

  def add_user
    @project_user = UserProject.new(user_id: params[:user_id], project_id: @project.id)
      
    respond_to do |format|
      if @project_user.save
        format.html { redirect_to users_tenant_project_url(id: @project.id, tenant_id: @project.tenant_id),
          notice: "User was successfully added to the project." }
      else
        format.html { redirect_to users_tenant_project_url(id: @project.id, tenant_id: @project.tenant_id),
          error: "User was not added to project." }
      end
    end
  end

  private

    def set_tenant
      @tenant = Tenant.find(params[:tenant_id])
    end

    def verify_tenant
      unless params[:tenant_id] == Tenant.current_tenant_id.to_s
        redirect_to :root, flash: { error: 'Oops! You can only view data within your own organization.'}
      end
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :details, :deadline, :tenant_id,)
    end
end
