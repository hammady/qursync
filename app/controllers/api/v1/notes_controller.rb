class Api::V1::NotesController < Api::V1::ApiController
  respond_to :json

  # GET /notes
  def index
    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    save @note
  end

  # PUT /notes/1
  def update
    save @note
  end

  # DELETE /notes/1
  def destroy
    if @note.destroy
      head :no_content
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  private

  def save(note)
    note.text = params[:text]
    super
  end

end
