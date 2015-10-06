#!/usr/bin/env ruby
# encoding: utf-8

# File: extensions.rb
# Created: 29/03/12
#
# (c) Michel Demazure <michel@demazure.com>

# reopening Array
class Array
  # @param indx_a [Integer] index to be swapped
  # @param indx_b [Integer] index to be swapped
  # @return [Array] array with the values swapped
  def swap(indx_a, indx_b)
    arr = dup
    arr[indx_a] = self[indx_b]
    arr[indx_b] = self[indx_a]
    arr
  end

  # @param indx [Integer] index
  # @return [Array] array with the position moved towards the beginning
  def up(indx)
    indx == 0 ? self : swap(indx, indx - 1)
  end

  # @param indx [Integer] index
  # @return [Array] array with the position moved towards the end
  def down(indx)
    indx == size - 1 ? self : swap(indx, indx + 1)
  end
end

# reopening Hash
class Hash
  # @param indx [Integer] index
  # @return [Hash] hash with the position moved towards the beginning
  # noinspection RubyHashKeysTypesInspection
  def up(indx)
    Hash[to_a.up(indx)]
  end

  # @param indx [Integer] index
  # @return [Hash] hash with the position moved towards the end
  # noinspection RubyHashKeysTypesInspection
  def down(indx)
    Hash[to_a.down(indx)]
  end
end
