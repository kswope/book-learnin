require 'pp'
require 'ap'


class Printer

  def self.to_proc
    Proc.new {|x| print x}
  end

end

%i{a b c d e}.each(&Printer) #=> abcde
