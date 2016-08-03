class UserProjectsController < ApplicationController
  before_action :set_user_project, only: [:show, :edit, :update, :destroy]

  def index
    @user_projects = UserProject.all
  end

  def show
  end

  def new
    @user_project = UserProject.new
  end

  def edit
  end

  def create
    @user_project = UserProject.new(user_project_params)

    respond_to do |format|
      if @user_project.save
        format.html { redirect_to @user_project, notice: 'User project was successfully created.' }
        format.json { render :show, status: :created, location: @user_project }
      else
        format.html { render :new }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_project.update(user_project_params)
        format.html { redirect_to @user_project, notice: 'User project was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_project }
      else
        format.html { render :edit }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user_project.destroy
    respond_to do |format|
      format.html { redirect_to users_tenant_project_url(id: @user_project.project_id,
      tenant_id: @user_project.project.tenant_id),
      notice: 'User was removed from the project.' }
      format.json { head :no_content }
    end
  end

  private

    def set_user_project
      @user_project = UserProject.find(params[:id])
    end

    def user_project_params
      params.require(:user_project).permit(:project_id, :user_id)
    end
    
end