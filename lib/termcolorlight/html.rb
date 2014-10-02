# -*- coding: utf-8 -*-
#
# Copyright 2014 whiteleaf. All rights reserved.
#

require_relative "../termcolorlight"

#
# TermColorLight.to_html 実装用エクステンション
#
module TermColorLight
  module_function

  # 色定義
  # フォーマット: "name" => ["暗い色", "明るい色"]
  @@colors = {
    "black" => %w(black #888), "white" => %w(#bbb white),
    "red" => %w(indianred red), "green" => %w(green lime),
    "yellow" => %w(goldenrod yellow), "blue" => %w(#33c #33f),
    "magenta" => %w(darkmagenta magenta), "cyan" => %w(darkcyan cyan),
    "fg_default" => %w(white white),
    "bg_default" => %w(#333 #333)
  }
  @@decoration_styles = {
    "underline" => "text-decoration:underline",
    "underscore" => "text-decoration:underline",
    "bold" => "font-weight:bold",
    "blink" => "text-decoration:blink",
    "concealed" => "visibility:hidden",
  }

  def set_colors(hash)
    @@colors.merge!(hash)
  end

  def set_styles(hash)
    @@decoration_styles.merge!(hash)
  end

  def default_foreground_color=(color)
    @@colors["fg_default"] = [color, color]
  end

  def default_background_color=(color)
    @@colors["bg_default"] = [color, color]
  end

  def to_html(str)
    @@before_fg_color = @@before_bg_color = nil
    ss = StringScanner.new(str.to_s)
    result = parse_for_html(ss)
  end

  def parse_for_html(ss, fgcolor = "fg_default", bgcolor = "bg_default",
                     intensity = false, reverse = false, parent = nil)
    buffer = ""
    until ss.eos?
      case
      when ss.scan(/[^<]+/)
        buffer.concat(ss.matched)
      when ss.scan(/<([a-z_]+?)>/i)
        tag = ss[1].downcase
        unless valid_tag?(tag)
          raise ParseError, "Unknown tag name (got '#{tag}')"
        end
        tmp_fg = fgcolor
        tmp_bg = bgcolor
        tmp_intensity = intensity
        tmp_reverse = reverse
        influence_of_color = false
        styles = []
        case
        when color_tag?(tag)
          tmp_fg = tag
          influence_of_color = true
        when tag =~ /^on_(.+)$/
          tmp_bg = $1
          unless valid_tag?(tmp_bg)
            raise ParseError, "Unknown tag name (got '#{tag}')"
          end
          influence_of_color = true
        when tag == "bold"
          tmp_intensity = true
          influence_of_color = true
        when tag == "reverse"
          tmp_reverse = true
          influence_of_color = true
        end
        if influence_of_color
          styles += build_color(tmp_fg, tmp_bg, tmp_intensity, tmp_reverse)
        end
        decoration = @@decoration_styles[tag]
        styles << decoration if decoration
        buffer.concat("<span style=\"#{styles.join(";")}\">")
        buffer.concat(parse_for_html(ss, tmp_fg, tmp_bg, tmp_intensity, tmp_reverse, tag))
        unless parent
          @@before_fg_color = @@before_bg_color = nil
        end
      when ss.scan(/<\/([a-z_]+?)>/i)
        tag = ss[1].downcase
        if tag != parent
          raise ParseError, "Missing end tag for '#{parent}' (got '#{tag}')"
        end
        return buffer.concat("</span>")
      end
    end
    if parent
      raise ParseError, "Missing end tag for '#{parent}'"
    end
    buffer
  end

  def valid_tag?(tag)
    TAGS.include?(tag)
  end

  def color_tag?(tag)
    @@colors.include?(tag)
  end

  def influence_of_color?(tag)
    TAGS_INFLUENCE_OF_COLOR.include?(tag)
  end

  def build_color(fgcolor, bgcolor, intensity, reverse)
    style = []
    if reverse
      fg_intensity = 0
      bg_intensity = intensity ? 1 : 0
      tmp = fgcolor
      fgcolor = bgcolor
      bgcolor = tmp
    else
      fg_intensity = intensity ? 1 : 0
      bg_intensity = 0
    end
    if fgcolor != "fg_default"
      color = @@colors[fgcolor][fg_intensity]
      if @@before_fg_color != color
        style << "color:#{color}"
        @@before_fg_color = color
      end
    end
    if bgcolor != "bg_default"
      color = @@colors[bgcolor][bg_intensity]
      if @@before_bg_color != color
        style << "background:#{color}"
        @@before_bg_color = color
      end
    end
    style
  end

  def output_test_sheets
    puts <<-HTML
<html><head>
<style>body{color:#{@@colors["fg_default"][0]};background:#{@@colors["bg_default"][0]}}</style>
</head><body><table>
    HTML
    @@colors.each_key do |color|
      next if color =~ /default/
      puts "<tr><td>"
      puts to_html("<#{color}>#{color}</#{color}>")
      puts "</td><td>"
      puts to_html("<bold><#{color}>#{color}</#{color}></bold>")
      puts "</td><td>"
      puts to_html("<on_#{color}>on_#{color}</on_#{color}>")
      puts "</td><td>"
      puts to_html("<reverse><bold><#{color}>#{color}</#{color}></bold></reverse>")
      puts "</td></tr>"
    end
    puts "</table></body></html>"
  end
end

if $0 == __FILE__
  TermColorLight.output_test_sheets
end

