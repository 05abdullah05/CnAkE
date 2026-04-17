#!/usr/bin/env ruby
#smile
class ASTNode
end

class Stmt
end

class IfStmt < Stmt
  def initialize(condition, then_branch, else_branch = nil)
    @condition = condition
    @then_branch = then_branch
    @else_branch = else_branch
  end

  def eval(env)
    if @condition.eval(env)
      @then_branch.eval(env)
    elsif @else_branch
      @else_branch.eval(env)
    end
  end
end

class AssignStmt < ASTNode
  attr_reader :type, :name, :value

  def initialize(type, name, value)
    @type = type      
    @name = name
    @value = value
  end
  def eval(env)
    env[@name] = @value.eval(env)
  end

end


class CompoundAssignStmt < ASTNode
  attr_reader :name, :op, :value

  def initialize(name, op, value)
    @name = name
    @op = op
    @value = value
  end

  def eval(env)
    current = env[@name]
    value = @value.eval(env)

    env[@name] = case @op
                 when "+=" then current + value
                 when "-=" then current - value
                 when "*=" then current * value
                 when "/=" then current / value
                 when "%=" then current % value
                 when "**=" then current ** value
                 end
  end
end

class ListAssignStmt < ASTNode
  attr_reader :name, :values

  def initialize(name, values)
    @name = name
    @values = values
  end

  def eval(env)
    env[@name] = @values.map { |value| value.eval(env) }
  end
end


class PrintStmt < Stmt
  def initialize(expr)
    @expr = expr
  end

  def eval(env)

    value = @expr.eval(env)
    puts value

    nil
  end
end

class ExprStmt < Stmt
  def initialize(expr)
    @expr = expr
  end

  def eval(env)
    @expr.eval(env)
  end
end

class Program
  def initialize(statements)
    @statements = statements
  end
  def eval(env)
    @statements.each { |s| s.eval(env) }
  end
end


class NumberLiteral < ASTNode
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def eval(env)
    @value
  end

  def inspect
    "Number(#{@value})"
  end
end

class VariableRef < ASTNode
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def eval(env)
    env[@name]
  end

  def inspect
    "Var(#{@name})"
  end
end

class BinaryExpr < ASTNode
  attr_reader :left, :op, :right

  def initialize(left, op, right)
    @left = left
    @op = op
    @right = right
  end

  def eval(env)
    l = @left.eval(env)
    r = @right.eval(env)

    case @op
    when "+" then l + r
    when "-" then l - r
    when "*" then l * r
    when "/" then l / r
    when "%" then l % r
    when "**" then l ** r

    when "==" then l == r
    when "!=" then l != r
    when ">" then l > r
    when "<" then l < r
    when ">=" then l >= r
    when "<=" then l <= r
    end
  end

  def inspect
    "(#{left.inspect} #{op} #{right.inspect})"
  end
end
