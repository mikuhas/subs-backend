class CommunityRepository
  def all
    Community.order(:name)
  end

  def find(id)
    Community.find(id)
  end
end
