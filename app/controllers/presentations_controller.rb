class PresentationsController < ApplicationController
  include SessionsHelper
  before_action :set_presentation, only: %i[show edit update destroy]

  # GET /presentations or /presentations.json
  def index
    @presentations = Presentation.all
  end

  # GET /presentations/1 or /presentations/1.json
  def show; end

  # GET /presentations/new
  def new
    @presentation = Presentation.new
  end

  # GET /presentations/1/edit
  def edit; end

  # POST /presentations or /presentations.json
  def create
    @presentation = Presentation.new(name: params[:presentation][:name], date: params[:presentation][:date])

    respond_to do |format|
      if @presentation.save
        unless params[:presentation][:user_ids].nil?
          params[:presentation][:user_ids].each do |user_id|
            @presentation.users << User.find_by(id: user_id) if user_id != ''
          end
        end
        format.html { redirect_to presentation_url(@presentation), notice: 'Presentation was successfully created.' }
        format.json { render :show, status: :created, location: @presentation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /presentations/1 or /presentations/1.json
  def update
    respond_to do |format|
      if @presentation.update(presentation_params)
        format.html { redirect_to presentation_url(@presentation), notice: 'Presentation was successfully updated.' }
        format.json { render :show, status: :ok, location: @presentation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1 or /presentations/1.json
  def destroy
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to presentations_url, notice: 'Presentation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_presentation
    @presentation = Presentation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def presentation_params
    params.require(:presentation).permit(:name, :date, :user_ids)
  end
end
