class SettingsController < ApplicationController
  before_action :set_setting
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    redirect_to edit_setting_path(@setting)
  end

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to sections_path, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:current_term, :graduate_enrollment_threshold, :undergraduate_enrollment_threshold, :email_delivery)
    end
end
