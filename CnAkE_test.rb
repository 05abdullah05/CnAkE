require "minitest/autorun"
require "minitest/spec"
require "./CnAkEparse.rb"
describe CnAkE do

  def run_test(code)
    CnAkE.new.slither(code)
  end

  describe "statements" do
    it "evaluates print statements" do
      value = run_test("print 1+1;")
      _(value).must_equal value
    end
    it "evaluates variable assignment and reference" do
      value = run_test("x = 5; print x;")
      _(value).must_equal value
    end
    it "evaluates compound assignment" do
      value = run_test("x = 5; x += 3; print x;")
      _(value).must_equal value
    end
    it "evaluates operator precedence" do
      value = run_test("x = 2 + 3 * 4; print x;")
      _(value).must_equal value
    end
    it "evaluates functions" do
      value = run_test("func add ( a b ): print a + b; ; add ( 3 , 4 ) ;")
      _(value).must_equal value
    end
    it "evaluates if statements" do
      value = run_test("if (1 > 2) print 5; else print 9;")
      _(value).must_equal value
    end
    it "evaluates for loops" do
      value = run_test("int y = 5; for_loop ( x = 1; x < y ; x += 1 ) print x;")
      _(value).must_equal value
    end
  end
end