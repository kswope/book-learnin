#!/usr/bin/env ruby

require 'pp'

require('set')


def get_resource

  resource = Resource.get

  if block_given?
    yield(resource)
  end

rescue
  # nothing special
ensure

  if block_given?
    resource.release
  end

end


