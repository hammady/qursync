class ColorValidator < ActiveModel::Validator
  def validate(record)
    unless record.color.match(/\A#[0-9A-Fa-f]{6}\z/) || record.color.blank?
      record.errors[:color] << "if set, must be in RGB hex form: #XXXXXX, where X is a hex digit from 0 to f/F"
    end
  end
end
