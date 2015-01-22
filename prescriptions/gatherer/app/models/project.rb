class Project < ActiveRecord::Base

  has_many :tasks



  def done?

    tasks.any? ? false : true

  end



end
