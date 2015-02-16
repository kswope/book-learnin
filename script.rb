require 'pp'
require 'ap'



a = [1,2,3].to_enum
b = [:a, :b, :c].to_enum

loop do

  puts "#{a.next} #{b.next}"

end


delegate_actions all,    MyApp, 
delegate_actions only,   MyApp, :index => :index, :welcome => :welcome
delegate_actions except, MyApp, :index => :index, :welcome => :welcome

class MyApp
  def index(state)
    state
  end
end

let(app){ MyApp.new }
let(state){ Hash.new[render:index] }

expect(app.index(state).render).to == 'index'
expect(app.index(state).vars.users).to == 

