require 'pp'



Person = Struct.new(:first, :last)


person = Person.new

p person


class MyActions

  def index(in, out)

    out.vars.name = 'asfd'
    out.render = '404'

  end

end


# test actions in isolation

describe index do

  let(in){ {session:{}, params:{}}
  let(out){ {session:{}}
  let(index){MyActions.new(in, out))

  it 'should return 404' do
    expect(index.render).to eql '404'
  end

end
