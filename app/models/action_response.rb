class ActionResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :action

  def to_api

    results = {
      'id' => id,
      'type' => 'action',
      'user' => user
    }

    return results;

  end
end