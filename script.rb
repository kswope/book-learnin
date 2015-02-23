require 'pp'
require 'ap'


str = 'this is my string'

p str.match(/(my)/) #=> #<MatchData "my" 1:"my">
p str.match(/not my/) #=> nil
p str.match(/(my)/).begin(0) #=> 8
p str.match(/(my)/).to_a #=> ['my', 'my'] [whole string, captures...]
p str.match(/(my)/).pre_match #=> 'this is '
p str.match(/(my)/).post_match #=> ' string'

p str.match(/my/)[0] #=> my
p str.match(/my/)[1] #=> nil, whoops forgot to capture
p str.match(/(my)/)[1] #=> my


