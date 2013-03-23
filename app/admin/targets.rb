ActiveAdmin.register Target do
  index do
  	selectable_column
  	column :title
  	column :first_name
  	column :middle_name
  	column :last_name
  	column :state
  	column :district
  	column :facebook_id
  	column :twitter_handle
  	column :TargetGroup

  	default_actions
  end

  # Filter only by state
  filter :TargetGroup
  filter :first_name
  filter :middle_name
  filter :last_name
  filter :title
  filter :state
  filter :district
end
