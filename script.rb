



# MyApp.index(rails)
# 
#   rails.export(:user) = User.find(rails.session[:uid])
# 
#   fldrid = rails.params[:fdrid]
#   
#   rails.export(:render) = :login 
# 
# end


class MyClass

  attr_accessor :ivar

  def initialize
    @ivar = {}
  end

  def method_missing(method, *args)
    puts "#{method} missing #{args}"
  end

  def []=(key, value)
    puts "#{key} #{value}"
  end

end


rails = MyClass.new

rails[:userid] = 123
rails[:render] = :index


