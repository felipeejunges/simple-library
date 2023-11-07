# frozen_string_literal: true

class BorrowedsController < ApplicationController
  before_action :set_borrowed

  # GET /borroweds/1 or /borroweds/1.json
  def show; end

  # GET /borroweds/new
  def new
    authorize Borrowed
    @borrowed = Borrowed.new
  end

  # POST /borroweds or /borroweds.json
  def create
    @borrowed = Borrowed.new(borrowed_params)
    @borrowed = Time.current

    respond_to do |format|
      if @borrowed.save
        format.html do
          flash[:success] = 'Borrowed was successfully created.'
          redirect_to borrowed_url(@borrowed)
        end
        format.json { render :show, status: :created, location: @borrowed }
      else
        format.html do
          flash[:error] = 'Borrowed not created'
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @borrowed.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @borrowed.update(borrowed_params)
        format.html do
          flash[:success] = 'Borrowed was successfully updated.'
          redirect_to borrowed_url(@borrowed)
        end
        format.json { render :show, status: :ok, location: @borrowed }
      else
        format.html do
          flash[:error] = 'Borrowed not updated'
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: @borrowed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /borroweds/1 or /borroweds/1.json
  def destroy
    respond_to do |format|
      if @borrowed.destroy
        format.html do
          flash[:success] = 'Borrowed was successfully destroyed.'
          redirect_to borroweds_url
        end
        format.json { head :no_content }
      else
        format.html do
          flash[:error] = 'Borrowed not deleted'
          redirect_to borroweds_url
        end
        format.json { render json: @borrowed.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_borrowed
    @borrowed = Borrowed.find(params[:id])
    authorize @borrowed
  end

  # Only allow a list of trusted parameters through.
  def borrowed_params
    params.require(:borrowed).permit(:user_id, :book_id)
  end
end
