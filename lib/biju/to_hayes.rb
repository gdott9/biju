class Object
  def to_hayes; "\"#{to_s}\""; end
end

class Fixnum
  def to_hayes; to_s; end
end

class TrueClass
  def to_hayes; '1'; end
end

class FalseClass
  def to_hayes; '0'; end
end

class Array
  def to_hayes; map(&:to_hayes).join(','); end
end
