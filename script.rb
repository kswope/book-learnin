#!/usr/bin/env ruby

require 'pp'



require 'set'
survey_results = [1, 2, 7, 1, 1, 5, 2, 5, 1]
distinct_answers = survey_results.to_set
pp distinct_answers # => #<Set: {5, 1, 7, 2}>
