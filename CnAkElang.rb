#!/usr/bin/env ruby
class CnAkE
  def self.slither(times, sides)
    (1..times).inject(0) { |sum, _| sum + rand(sides) + 1 }
  end

  def initialize

    @CnAkEParser = Parser.new("CnAkE") do

      # ---------------- TOKENS ----------------

      token(/([a-z]{3})(func)([a-z]+)(([a-z]{3})([a-z]+))/)
      token(/\s+/)
      token(/int|str|chr|bol|pnt|lst|if|else_if|else|for_loop|while_loop|do/) { |m| m }
      token(/[a-zA-Z_][a-zA-Z0-9_]+/) { |m| m }
      token(/\d+/) { |m| m.to_i }

      token(/\*\*=/) { '**=' }
      token(/\*\*/)  { '**' }
      token(/\+=/)   { '+=' }
      token(/-=/)    { '-=' }
      token(/\*=/)   { '*=' }
      token(/\/=/)   { '/=' }
      token(/%=/)    { '%=' }

      token(/==/)    { '==' }
      token(/!=/)    { '!=' }
      token(/>=/)    { '>=' }
      token(/<=/)    { '<=' }
      token(/>/)     { '>' }
      token(/</)     { '<' }
      token(/=/)     { '=' }
      token(/;/)     { ';' }

      token(/./)     { |m| m }
      
      # ---------------- PROGRAM STRUCTURE ----------------

      start :program do
        match(:statements) { |s| Program.new(s) }
      end

      rule :statements do
        match(:statements, :statement) { |a, b| a + [b] }
        match(:statement) { |s| [s] }
      end

      rule :statement do
        match("print", :expr, ";") { |_, e, _| PrintStmt.new(e) }
        match(:expr, ";")          { |e, _| ExprStmt.new(e) }
      end

      # ---------------- EXPRESSIONS ----------------

      rule :expr do

        # variable declaration assignment
        match(:type, :vari, '=', :expr) do |type, name, _, value|
          AssignStmt.new(type, name, value)
        end

        # list assignment
        match('lst', :vari, '=', :cage) do |_, name, _, values|
          ListAssignStmt.new(name, values)
        end

        # binary operators
        match(:expr, '+', :term)  { |a, _, b| BinaryExpr.new(a, "+", b) }
        match(:expr, '-', :term)  { |a, _, b| BinaryExpr.new(a, "-", b) }

        match(:expr, '==', :expr) { |a, _, b| BinaryExpr.new(a, "==", b) }
        match(:expr, '!=', :expr) { |a, _, b| BinaryExpr.new(a, "!=", b) }
        match(:expr, '>=', :expr) { |a, _, b| BinaryExpr.new(a, ">=", b) }
        match(:expr, '<=', :expr) { |a, _, b| BinaryExpr.new(a, "<=", b) }
        match(:expr, '>', :expr)  { |a, _, b| BinaryExpr.new(a, ">", b) }
        match(:expr, '<', :expr)  { |a, _, b| BinaryExpr.new(a, "<", b) }

        # compound assignment
        match(:vari, '+=', :term) { |name, _, value| CompoundAssignStmt.new(name, "+=", value) }
        match(:vari, '-=', :term) { |name, _, value| CompoundAssignStmt.new(name, "-=", value) }

        match(:term)
      end

      rule :term do
        match(:term, '*', :factor) { |a, _, b| BinaryExpr.new(a, "*", b) }
        match(:term, '/', :factor) { |a, _, b| BinaryExpr.new(a, "/", b) }
        match(:term, '%', :factor) { |a, _, b| BinaryExpr.new(a, "%", b) }

        match(:vari, '*=', :term)  { |name, _, value| CompoundAssignStmt.new(name, "*=", value) }
        match(:vari, '/=', :term)  { |name, _, value| CompoundAssignStmt.new(name, "/=", value) }
        match(:vari, '%=', :term)  { |name, _, value| CompoundAssignStmt.new(name, "%=", value) }

        match(:factor)
      end

      rule :factor do
        match(:factor, '**', :atom) { |a, _, b| BinaryExpr.new(a, "**", b) }
        match(:vari, '**=', :atom)  { |name, _, value| CompoundAssignStmt.new(name, "**=", value) }
        match(:atom)
      end

      rule :atom do
        match(Integer) { |n| NumberLiteral.new(n) }
        match(String)  { |name| VariableRef.new(name) }
        match('(', :expr, ')') { |_, e, _| e }
      end

      # ---------------- LISTS ----------------

      rule :cage do
        match(:list)
      end

      rule :list do
        match(:list, ',', :atom) { |a, _, b| a + [b] }
        match(:atom) { |a| [a] }
      end

      rule :vari do
        match(String)
      end

      rule :type do
        match('int')
        match('str')
        match('chr')
        match('bol')
        match('pnt')
      end
    end
  end

  def slither
    env ={}
    File.open("./test.txt", "r") do |f|
      f.each_line do |line|

        print "[CnAkE] "
        program = @CnAkEParser.parse(line)
        program.eval(env)
      end
    end
  end
end

#Regex for fucntion:^([a-z]{3}) (func) ([a-z]+)(([a-z]{3}) ([a-z]+|\w+\w+),?\s?)
# token(/([a-z]{3})\s([a-z]+)\s=\s(\d+.\d+|\d+|"[a-zA-z]+*"|[a-zA-Z]+)/) {|m| m}
