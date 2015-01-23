class Project < ActiveRecord::Base

  has_many :tasks




  def self.velocity_length_in_days
    21
  end

  def incomplete_tasks 
    tasks.reject(&:complete?)
  end

  def done? 
    incomplete_tasks.empty?
  end

  def total_size 
    tasks.to_a.sum(&:size)
  end

  def remaining_size 
    incomplete_tasks.sum(&:size)
  end

  def completed_velocity 
    tasks.to_a.sum(&:points_toward_velocity)
  end

  def current_rate
    completed_velocity * 1.0 / Project.velocity_length_in_days
  end

  def projected_days_remaining 
    remaining_size / current_rate
  end

  def on_schedule?
    return false if projected_days_remaining.nan? 
    (Date.today + projected_days_remaining) <= due_date
  end




end
