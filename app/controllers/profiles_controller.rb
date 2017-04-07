class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_profile_user, only: [:index, :show, :edit]
  before_action :check_profile_owner, only: [:edit, :updates]
  before_action :set_current_profile, only: [:my_profile]

  def index
    @profiles = User.all.order('created_at DESC')
  end

  def show
    @posts = User.find_by(id: params[:id]).posts.page(params[:page]).per(5)
  end

  def my_profile
    if check_myprofile_name_empty
    else
      check_myprofile_position_empty
    end
  end

  def edit
  end

  def updates
    respond_to do |format|
      if @profile.update_attributes(profile_params)
        save!
        p  current_user.errors.inspect
        format.html { redirect_to profile_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
        @profile.save
      else
        format.html { render :edit }
        p  current_user.errors.inspect
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def check_myprofile_name_empty
    @my_profile_name = current_user.name

    if @my_profile_name.blank?
      redirect_to edit_profile_path(@profile), notice: 'Name is missing from your profile. Please add your name.'
    end
  end

  def check_myprofile_position_empty
    @my_profile_position = current_user.position

    if @my_profile_position.blank?
      redirect_to edit_profile_path(@profile), notice: 'Position is missing from your profile. Please add a new position.'
    end
  end

  def profile_params
    params(:profile).permit(:name)
  end

  def set_profile_user
    @profile = User.includes(myskills: :skill).find_by(id: params[:id])
  end

  def check_profile_owner
    @profile = User.find_by(id: params[:id])
    unless @profile.id == current_user.id
      redirect_to profile_path, notice: 'You do not own this profile, please behave.'
    end
  end

  def set_current_profile
    @profile = current_user
  end
end
