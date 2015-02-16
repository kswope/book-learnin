require 'pp'
require 'ap'


colors = %w{ red orange yellow blue indigo violet }

colors.group_by{|c| c[0]} #=> {"r"=>["red"], "o"=>["orange"], "y"=>["yellow"], "b"=>["blue"], "i"=>["indigo"], "v"=>["violet"]}

colors.group_by{|c| c.size} #=> {3=>["red"], 6=>["orange", "yellow", "indigo", "violet"], 4=>["blue"]}


