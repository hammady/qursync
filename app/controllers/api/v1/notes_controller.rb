class Api::V1::NotesController < Api::V1::ApiController

  private

  def set_attributes(note)
    note.text = params[:text]
    note.color = params[:color]
  end

end
