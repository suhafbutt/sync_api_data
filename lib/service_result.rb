class ServiceResult < Struct.new(:success?, :error, :payload)
  def success?
    self[:success?]
  end
end
