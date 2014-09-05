# -*- coding: utf-8 -*-
#
# Copyright 2014 whiteleaf. All rights reserved.
#

require "strscan"

module TermColorLight
  extend self

  VERSION = "1.0.0"

  TAGS = {
    # foreground colors
    "black" => "30", "red" => "31", "green" => "32", "yellow" => "33",
    "blue" => "34", "magenta" => "35", "cyan" => "36", "white" => "37",
    "gray" => "37",
    # background colors
    "on_black" => "40", "on_red" => "41", "on_green" => "42", "on_yellow" => "43",
    "on_blue" => "44", "on_magenta" => "45", "on_cyan" => "46", "on_white" => "47",
    "on_gray" => "47",
    # decorations
    "bold" => "1", "dark" => "2", "underline" => "4", "underscore" => "4", "blink" => "5",
    "reverse" => "7", "concealed" => "8",
  }

  ENTITIES = Hash[*%w(& &amp; < &lt; > &gt; " &quot; ' &apos;)]

  class ParseError < StandardError; end

  def parse(str)
    stack = []
    current_tag = ""
    ss = StringScanner.new(str.to_s)
    buffer = ""
    until ss.eos?
      case
      when ss.scan(/[^<]+/)
        buffer.concat(ss.matched)
      when ss.scan(/<([a-z_]+?)>/i)
        tag_name = ss[1].downcase
        tag_index = TAGS[tag_name]
        unless tag_index
          raise ParseError, "Unknown tag name (got '#{tag_name}')"
        end
        stack.push(tag_index)
        buffer.concat(create_escape_sequence(tag_index))
      when ss.scan(/<\/([a-z_]+?)>/i)
        tag_name = ss[1].downcase
        expect_tag_index = stack.pop
        if TAGS[tag_name] != expect_tag_index
          expect_tag_name = tags_select_by_index(expect_tag_index)
          raise ParseError, "Missing end tag for '#{expect_tag_name}' (got '#{tag_name}')"
        end
        buffer.concat("\e[0m#{create_escape_sequence(stack)}")
      end
    end
    unless stack.empty?
      for_tag_name = tags_select_by_index(stack.pop)
      raise ParseError, "Missing end tag for '#{for_tag_name}'"
    end
    TermColorLight.unescape(buffer)
  end

  def escape(str)
    buf = str.to_s.dup
    ENTITIES.each do |entity|
      buf.gsub!(*entity)
    end
    buf
  end

  def unescape(str)
    buf = str.to_s.dup
    ENTITIES.invert.each do |entity|
      buf.gsub!(*entity)
    end
    buf
  end

  def strip_tag(str)
    TermColorLight.unescape(str.gsub(/<.+?>/, ""))
  end

  def create_escape_sequence(indexes)   # :nodoc:
    unless indexes.kind_of?(Array)
      return "\e[#{indexes}m"
    end
    result = ""
    indexes.each do |index|
      result.concat("\e[#{index}m")
    end
    result
  end

  def tags_select_by_index(index)   # :nodoc:
    TAGS.select { |_, idx|
      idx == index
    }.keys[0]
  end
end

class String
  def termcolor
    TermColorLight.parse(self)
  end

  def escape
    TermColorLight.escape(self)
  end
end
