/
Serves the sounds database and allows for searching. Most of the other methods are not used and can be removed.
/
class SoundsController < ApplicationController
  before_action :set_sound, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user

  # GET /sounds
  # GET /sounds.json
  def index
    @sounds = Sound.all
  end

  def search
    filter = search_params
    if filter[:search].empty? && filter[:letter].nil? && filter[:rating].nil?
      flash[:alert] = "Search terms included all sounds!"
      redirect_to sounds_path
    else
      # Check for proper search parameters
      if filter[:letter].nil? && !filter[:rating].nil?
        flash[:alert] = "You must select a letter to search by rating!"
        redirect_to sounds_path
        return
      end
      if !filter[:letter].nil? && filter[:rating].nil?
        flash[:alert] = "You must select a rating to search by letter!"
        redirect_to sounds_path
        return
      end
      @sounds =  Sound.search filter[:search], filter[:letter], filter[:rating]
      @num_responses = Response.get_num_responses(@sounds, @current_user.id)
      if @sounds.empty?
        flash[:alert] = "No sounds found!"
        redirect_to sounds_path
      else
        flash[:notice] = "Found " + @sounds.length.to_s + " sounds!"
        render search_sounds_path
      end
    end
  end

  # GET /sounds/1
  # GET /sounds/1.json
  def show
  end

  # GET /sounds/new
  def new
    @sound = Sound.new
  end

  # GET /sounds/1/edit
  def edit
  end

  # POST /sounds
  # POST /sounds.json
  def create
    @sound = Sound.new()

    respond_to do |format|
      if @sound.save
        format.html { redirect_to @sound, notice: 'Sound was successfully created.' }
        format.json { render :show, status: :created, location: @sound }
      else
        format.html { render :new }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sounds/1
  # PATCH/PUT /sounds/1.json
  def update
    respond_to do |format|
      if @sound.update(sound_params)
        format.html { redirect_to @sound, notice: 'Sound was successfully updated.' }
        format.json { render :show, status: :ok, location: @sound }
      else
        format.html { render :edit }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sounds/1
  # DELETE /sounds/1.json
  def destroy
    @sound.destroy
    respond_to do |format|
      format.html { redirect_to sounds_url, notice: 'Sound was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def audio
    path = Rails.root.join('app', 'assets', 'data', 'audio', params[:filename])
    send_file path, type: 'audio/wav', disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sound
      @sound = Sound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sound_params
      params.fetch(:sound, {})
    end

    def search_params
      params.permit(:search, :letter, :rating)
    end
end
