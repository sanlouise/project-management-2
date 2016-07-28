class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_tenant, except: [:index]
  before_action :verify_tenant
  respond_to :html

  def index
    @projects = Project.all
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
    flash[:notice] = 'Project was successfully created.' if @project.save
    respond_with(@project)
  end

  def update
    flash[:notice] = 'Project was successfully updated.' if @project.update(project_params)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
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
      params.require(:project).permit(:title, :details, :deadline, :tenant_id)
    end
end
