require 'pp'
require 'ap'




class Printer

  def self.to_proc
    Proc.new {|x| print x}
  end

end

myproc = Printer.to_proc
%i{a b c d e}.each(&myproc.to_proc.to_proc.to_proc) #=> abcde
