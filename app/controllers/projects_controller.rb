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
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      respond_with(@project)
      redirect_to root_path
    else
      render :new
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
