# -*- coding: utf-8 -*-
#
# Copyright 2014 whiteleaf. All rights reserved.
#

require "termcolorlight/html"

describe TermColorLight do
  describe ".to_html" do
    context "give color tag" do
      it do
        expect(TermColorLight.to_html("<red>red</red>"))
          .to eq '<span style="color:indianred">red</span>'
      end

      it "white is not white" do
        expect(TermColorLight.to_html("<white>white?</white>"))
          .to eq '<span style="color:#bbb">white?</span>'
      end
    end

    context "give bold tag" do
      it do
        expect(TermColorLight.to_html("<bold>bold</bold>"))
          .to eq '<span style="font-weight:bold">bold</span>'
      end

      it "should be bold when double bold" do
        expect(TermColorLight.to_html("<bold><bold>bold</bold>bold</bold>"))
          .to eq '<span style="font-weight:bold"><span style="font-weight:bold">bold</span>bold</span>'
      end
    end

    context "give bold and color tag" do
      it do
        expect(TermColorLight.to_html("<bold><red>str</red>bold</bold>"))
          .to eq '<span style="font-weight:bold"><span style="color:red">str</span>bold</span>'
      end

      it do
        expect(TermColorLight.to_html("<red><bold>BOLD RED</bold> NORMAL RED</red>"))
          .to eq '<span style="color:indianred"><span style="color:red;font-weight:bold">BOLD RED</span> NORMAL RED</span>'
      end
    end

    context "give underline" do
      it do
        expect(TermColorLight.to_html("<underline>str</underline>"))
          .to eq '<span style="text-decoration:underline">str</span>'
      end
    end

    context "give background color" do
      it do
        expect(TermColorLight.to_html("<on_red>str</on_red>"))
          .to eq '<span style="background:indianred">str</span>'
      end

      it "with bold" do
        expect(TermColorLight.to_html("<bold><on_green>str</on_green></bold>"))
          .to eq '<span style="font-weight:bold"><span style="background:green">str</span></span>'
      end

      it "with bold" do
        expect(TermColorLight.to_html("<on_green><bold>str</bold> non bold</on_green>"))
          .to eq '<span style="background:green"><span style="font-weight:bold">str</span> non bold</span>'
      end

      it "with color tag" do
        expect(TermColorLight.to_html("<on_cyan>bgcyan <yellow>yellow</yellow> bgcyan</on_cyan>"))
          .to eq '<span style="background:darkcyan">bgcyan <span style="color:goldenrod">yellow</span> bgcyan</span>'
      end
    end

    context "give reverse" do
      it do
        expect(TermColorLight.to_html("<reverse>str</reverse>"))
          .to eq '<span style="color:#333;background:white">str</span>'
      end

      it "do nothing when double reverse" do
        expect(TermColorLight.to_html("<reverse><reverse>foo</reverse>bar</reverse>"))
          .to eq '<span style="color:#333;background:white"><span style="">foo</span>bar</span>'
      end

      context "with color tag" do
        it do
          expect(TermColorLight.to_html("<reverse><white>str</white></reverse>"))
            .to eq '<span style="color:#333;background:white"><span style="background:#bbb">str</span></span>'
        end

        it do
          expect(TermColorLight.to_html("<reverse><blue>str</blue> foo</reverse>"))
           .to eq '<span style="color:#333;background:white"><span style="background:#33c">str</span> foo</span>'
        end

        it do
          expect(TermColorLight.to_html("<blue><reverse>str</reverse></blue>"))
            .to eq '<span style="color:#33c"><span style="color:#333;background:#33c">str</span></span>'
        end
      end

      context "with background tag" do
        it do
          expect(TermColorLight.to_html("<reverse><on_red>str</on_red></reverse>"))
            .to eq '<span style="color:#333;background:white"><span style="color:indianred">str</span></span>'
        end
      end

      context "with bold tag" do
        it do
          expect(TermColorLight.to_html("<reverse><bold>str</bold></reverse>"))
            .to eq '<span style="color:#333;background:white"><span style="font-weight:bold">str</span></span>'
        end

        it do
          expect(TermColorLight.to_html("<reverse><bold><red>str</red></bold></reverse>"))
            .to eq '<span style="color:#333;background:white"><span style="font-weight:bold"><span style="background:red">str</span></span></span>'
        end

        it do
          expect(TermColorLight.to_html("<reverse><red><bold>str</bold></red></reverse>"))
            .to eq '<span style="color:#333;background:white"><span style="background:indianred"><span style="background:red;font-weight:bold">str</span></span></span>'
        end

        it do
          expect(TermColorLight.to_html("<bold><green><reverse>str</reverse></green></bold>"))
            .to eq '<span style="font-weight:bold"><span style="color:lime"><span style="color:#333;background:lime">str</span></span></span>'
        end
      end

      it do
        expect(TermColorLight.to_html("(e.g. `narou <bold><yellow>d</yellow></bold> n4259s', `narou <bold><yellow>fr</yellow></bold> musyoku')"))
          .to eq '(e.g. `narou <span style="font-weight:bold"><span style="color:yellow">d</span></span> n4259s\', `narou <span style="font-weight:bold"><span style="color:yellow">fr</span></span> musyoku\')'
      end
    end

    context "give entities" do
      it "should be keep entities" do
        expect(TermColorLight.to_html("&lt;&gt;&amp;%apos;&nbsp;")).to eq "&lt;&gt;&amp;%apos;&nbsp;"
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
end

