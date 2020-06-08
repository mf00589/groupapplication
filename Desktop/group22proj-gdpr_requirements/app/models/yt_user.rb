class YtUser < ApplicationRecord
  class << self
    def from_omniauth(auth)
      user1 = YtUser.find_or_initialize_by(uid: auth['uid'])
      user1.name = auth['info']['name']
      user1.token = auth['credentials']['token']
      user1.save!
      user1
    end
  end
end
