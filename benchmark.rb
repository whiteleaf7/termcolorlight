# coding: utf-8

require "termcolor"
require "termcolorlight"
require "benchmark"

n = 100000
Benchmark.bm(20) do |bm|
  bm.report "TermColor.parse" do
    n.times do
      TermColor.parse("<red>red</red>")
    end
  end
  bm.report "TermColorLight.parse" do
    n.times do
      TermColorLight.parse("<red>red</red>")
    end
  end
end
