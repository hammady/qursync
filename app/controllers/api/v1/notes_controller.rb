class Api::V1::NotesController < Api::V1::ApiController

  private

  def set_attributes(note)
    note.text = params[:text]
  end

end
