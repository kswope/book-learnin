#!/usr/bin/env ruby

require 'pp'

require 'erb'


template = %q{
  Contents:
    <% array.each do |element| -%>
      <%= element %>
    <% end -%>
}

template = ERB.new template, nil, '-'

array = %w{one two three four five}
puts template.run(binding)


