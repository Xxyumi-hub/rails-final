class GroupsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  
  # before_action :require_authentication
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :authorize_group!
  after_action :verify_authorized


  # GET /groups or /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def delete_user_membership
    Membership.find_by(user_id: params[:user_id], group_id: params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to group_path(params[:id]), notice: "Member deleted" }
      format.json { head :no_content }
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :activity_type, :about_us, :avatar, :senior, :gym_required, user_ids: [])
    end

    def avatar
      @group.avatar.attach(params[:avatar])
    end

    def catch_not_found(error)
      Rails.logger.debug("Oops! We had a 'not found exception.' Redirecting to index.")
      flash.alert = error.to_s
      redirect_to groups_path
    end

    def authorize_group!
      authorize(@group || Group)
    end


end
