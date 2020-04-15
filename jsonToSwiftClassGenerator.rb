require 'json'
require 'erb'
require 'fileutils'

class String
  def camelize(uppercase_first_letter = true)
    string = self
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
    else
      string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
  end
end

class Variable
    attr_accessor :name, :type, :value, :function

    def initialize(name, type, value,function)
      @name, @type, @value, @function = name, type, value, function
    end
end

def get_Keys()
    file = File.read('./Sources/AppKeys.json')
    data_hash = JSON.parse(file)
    variables = Array.new
    data_hash.each do |key, value|
        variable = Variable.new(key,"String",value,key.camelize())
        variables.push(variable)
    end
    return variables
end

class AppKeyGenerator
  include ERB::Util
  attr_accessor :className, :variables, :template

  def initialize(className, variables, template)
    @className = className
    @variables = variables
    @template = template
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end

end
template = File.read("./template/templateClass.swift")
className = "ApiKeys"
outputDirPath = './generated'
FileUtils.rm_rf("#{outputDirPath}/.", secure: true)
list = AppKeyGenerator.new(className, get_Keys, template)
list.save(File.join("#{outputDirPath}/.", "#{className}.swift"))