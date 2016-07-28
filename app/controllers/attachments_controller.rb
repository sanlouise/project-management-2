class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @attachments = Attachment.all
    respond_with(@attachments)
  end

  def show
    respond_with(@attachment)
  end

  def new
    @attachment = Attachment.new
    respond_with(@attachment)
  end

  def edit
  end

  def create
    @attachment = Attachment.new(attachment_params)
    flash[:notice] = 'Attachment was successfully created.' if @attachment.save
    respond_with(@attachment)
  end

  def update
    flash[:notice] = 'Attachment was successfully updated.' if @attachment.update(attachment_params)
    respond_with(@attachment)
  end

  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    def attachment_params
      params.require(:attachment).permit(:name, :key, :project_id)
    end
end
