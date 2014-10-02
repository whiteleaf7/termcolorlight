# -*- coding: utf-8 -*-
#
# Copyright 2014 whiteleaf. All rights reserved.
#

require "termcolorlight"

describe TermColorLight do
  describe ".parse" do
    context "nil" do
      it { expect(TermColorLight.parse(nil)).to eq "" }
    end

    context "give non-string" do
      it "should be string" do
        expect(TermColorLight.parse(0)).to eq "0"
      end
    end

    context "blank" do
      it { expect(TermColorLight.parse("")).to eq "" }
    end

    # memo:
    # 0:black, 1:red, 2:green, 3:yellow, 4:blue, 5:magenta, 6:cyan, 7:white

    context "color tag" do
      it "black" do
        res = TermColorLight.parse("<black>hoge</black>")
        expect(res).to eq "\e[30mhoge\e[0m"
      end
      it "red" do
        res = TermColorLight.parse("<red>hoge</red>")
        expect(res).to eq "\e[31mhoge\e[0m"
      end
      it "green" do
        res = TermColorLight.parse("<green>hoge</green>")
        expect(res).to eq "\e[32mhoge\e[0m"
      end
      it "yellow" do
        res = TermColorLight.parse("<yellow>hoge</yellow>")
        expect(res).to eq "\e[33mhoge\e[0m"
      end
      it "blue" do
        res = TermColorLight.parse("<blue>hoge</blue>")
        expect(res).to eq "\e[34mhoge\e[0m"
      end
      it "magenta" do
        res = TermColorLight.parse("<magenta>hoge</magenta>")
        expect(res).to eq "\e[35mhoge\e[0m"
      end
      it "cyan" do
        res = TermColorLight.parse("<cyan>hoge</cyan>")
        expect(res).to eq "\e[36mhoge\e[0m"
      end
      it "white" do
        res = TermColorLight.parse("<white>hoge</white>")
        expect(res).to eq "\e[37mhoge\e[0m"
      end
      it "gray is white" do
        res = TermColorLight.parse("<gray>hoge</gray>")
        expect(res).to eq "\e[37mhoge\e[0m"
      end
    end

    context "background color tag" do
      it "black" do
        res = TermColorLight.parse("<on_black>hoge</on_black>")
        expect(res).to eq "\e[40mhoge\e[0m"
      end
      it "red" do
        res = TermColorLight.parse("<on_red>hoge</on_red>")
        expect(res).to eq "\e[41mhoge\e[0m"
      end
      it "green" do
        res = TermColorLight.parse("<on_green>hoge</on_green>")
        expect(res).to eq "\e[42mhoge\e[0m"
      end
      it "yellow" do
        res = TermColorLight.parse("<on_yellow>hoge</on_yellow>")
        expect(res).to eq "\e[43mhoge\e[0m"
      end
      it "blue" do
        res = TermColorLight.parse("<on_blue>hoge</on_blue>")
        expect(res).to eq "\e[44mhoge\e[0m"
      end
      it "magenta" do
        res = TermColorLight.parse("<on_magenta>hoge</on_magenta>")
        expect(res).to eq "\e[45mhoge\e[0m"
      end
      it "cyan" do
        res = TermColorLight.parse("<on_cyan>hoge</on_cyan>")
        expect(res).to eq "\e[46mhoge\e[0m"
      end
      it "white" do
        res = TermColorLight.parse("<on_white>hoge</on_white>")
        expect(res).to eq "\e[47mhoge\e[0m"
      end
      it "gray is white" do
        res = TermColorLight.parse("<on_gray>hoge</on_gray>")
        expect(res).to eq "\e[47mhoge\e[0m"
      end
    end

    context "decoration tag" do
      context "underline" do
        it do
          res = TermColorLight.parse("<underline>hoge</underline>")
          expect(res).to eq "\e[4mhoge\e[0m"
        end

        it do
          res = TermColorLight.parse("<underline><red>hoge</red></underline>")
          expect(res).to eq "\e[4m\e[31mhoge\e[0m\e[4m\e[0m"
        end
      end

      context "bold" do
        it do
          res = TermColorLight.parse("<bold>hoge</bold>")
          expect(res).to eq "\e[1mhoge\e[0m"
        end

        context "with color tag" do
          context "when before bold" do
            it do
              res = TermColorLight.parse("<bold><red>hoge</red></bold>")
              expect(res).to eq "\e[1m\e[31mhoge\e[0m\e[1m\e[0m"
            end
          end

          context "when after bold" do
            it do
              res = TermColorLight.parse("<red><bold>hoge</bold></red>")
              expect(res).to eq "\e[31m\e[1mhoge\e[0m\e[31m\e[0m"
            end
          end
        end
      end

      context "reverse" do
        it do
          res = TermColorLight.parse("<reverse>hoge</reverse>")
          expect(res).to eq "\e[7mhoge\e[0m"
        end
      end

      context "blink" do
        it do
          expect(TermColorLight.parse("<blink>hoge</blink>")).to eq "\e[5mhoge\e[0m"
        end
      end

      context "dark" do
        it do
          expect(TermColorLight.parse("<dark>hoge</dark>")).to eq "\e[2mhoge\e[0m"
        end
      end

      context "concealed" do
        it do
          expect(TermColorLight.parse("<concealed>hoge</concealed>")).to eq "\e[8mhoge\e[0m"
        end
      end

      context "mixed decorate" do
        it do
          res = TermColorLight.parse("abc<reverse>d<bold>e<red>f" \
            "<underline>g</underline>h</red>i</bold></reverse>jk")
          expect(res).to eq "abc\e[7m\d\e[1me\e[31mf\e[4mg\e[0m" \
            "\e[7m\e[1m\e[31mh\e[0m\e[7m\e[1mi\e[0m\e[7m\e[0mjk"
        end
      end
    end

    context "ignore case" do
      it do
        expect(TermColorLight.parse("<RED>hoge</RED>")).to eq "\e[31mhoge\e[0m"
      end
    end

    context "with escaped tag" do
      it do
        res = TermColorLight.parse("&lt;red&gt;hoge&lt;/red&gt;")
        expect(res).to eq "<red>hoge</red>"
      end
    end

    describe "abnormal" do
      context "invalid tag" do
        it "raise error" do
          expect { TermColorLight.parse("<unknown>hoge</unknown>") }
            .to raise_error(TermColorLight::ParseError, "Unknown tag name (got 'unknown')")
        end
      end

      context "invalid background color" do
        it "raise error" do
          expect { TermColorLight.parse("<on_unknown>hoge</on_unknown>") }
            .to raise_error(TermColorLight::ParseError, "Unknown tag name (got 'on_unknown')")
        end
      end

      context "invalid tag order" do
        it "raise error" do
          expect { TermColorLight.parse("<bold><red>hoge</bold></red>") }
            .to raise_error(TermColorLight::ParseError, "Missing end tag for 'red' (got 'bold')")
        end
      end

      context "when unclose tag" do
        it "raise error" do
          expect { TermColorLight.parse("<red>hoge") }
            .to raise_error(TermColorLight::ParseError, "Missing end tag for 'red'")
        end
      end
    end
  end

  describe ".escape" do
    it "should be escaped string" do
      res = TermColorLight.escape("<red>&hoge</red>")
      expect(res).to eq "&lt;red&gt;&amp;hoge&lt;/red&gt;"
    end

    context "give non-string" do
      context "when nil" do
        it "should be ''" do
          expect(TermColorLight.escape(nil)).to eq ""
        end
      end
      context "when integer" do
        it "should be string" do
          expect(TermColorLight.escape(0)).to eq "0"
        end
      end
    end
  end

  describe ".unescape" do
    it do
      expect(TermColorLight.unescape("&lt;red&gt;&amp;hoge&apos;&quot;&lt;/red&gt;"))
        .to eq %!<red>&hoge'"</red>!
    end
  end

  describe ".strip_tag" do
    it "should be strop tag and unescaped entity" do
      expect(TermColorLight.strip_tag("<red>&quot;&apos;foo&amp;bar &lt;&gt;</red>"))
        .to eq %!"'foo&bar <>!
    end

    it "shoul be strip tag and NOT unescaped entity" do
      expect(TermColorLight.strip_tag("<red>&quot;&apos;foo&amp;bar &lt;&gt;</red>", false))
        .to eq "&quot;&apos;foo&amp;bar &lt;&gt;"
    end
  end
end

describe String do
  context "#termcolor" do
    it do
      expect("<red>hoge</red>".termcolor).to eq "\e[31mhoge\e[0m"
    end
  end

  context "#escape" do
    it "should be escaped string" do
      expect("<red>hoge</red>".escape).to eq "&lt;red&gt;hoge&lt;/red&gt;"
    end
  end
end
