class AttachmentsController < ApplicationController

  before_action :set_attachment, only: [:show, :destroy]

  def index
    @attachments = Attachment.all
  end

  def show
  end

  def new
    @attachment = Attachment.new
    @attachment.project_id = params[:project_id]
  end

  def create
    @attachment = Attachment.new(attachment_params)

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to tenant_project_url(tenant_id: Tenant.current_tenant_id, id: @attachment.project_id),
        notice: 'Attachment was created successfully.' }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to tenant_project_url(tenant_id: Tenant.current_tenant_id, id: @attachment.project_id), notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    def attachment_params
      params.require(:attachment).permit(:name, :project_id, :upload)
    end
end