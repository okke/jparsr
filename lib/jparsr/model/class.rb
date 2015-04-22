# 
# Copyright (c) 2015, Okke van 't Verlaat
#  
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be includedi
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
#

class JParsr::Class < JParsr::Base

  include JParsr::Modifiers

  # class belongs to a package
  #
  attr_reader :package 

  # class is declared in source file
  #
  attr_reader :source

  attr_reader :id
  attr_reader :name

  attr_reader :super_class_type
  attr_reader :interface_types

  attr_reader :parameters

  attr_reader :class_fields
  attr_reader :class_methods
  attr_reader :instance_fields
  attr_reader :instance_methods

  def initialize(tree, package=nil, source=nil)
    super(tree)
    self.init_modifiers(tree)

    @package = package
    @source = source

    @name = tree[:name][:id]

    @id = @name
    @id = "#{@package.name}.#{@name}" if @package and @package.name and @package.name != ""

    @parameters = []
    if tree[:name][:generic]
      [tree[:name][:generic][:class]].flatten.each do |parameter|
        @parameters << JParsr::ClassParameter.new(parameter[:parameter])
      end
    end

    @super_class_type = JParsr::Type.new(tree[:extends][:class]) if tree[:extends]

    @interface_types = []
    if tree[:implements]
      [tree[:implements]].flatten.each do |interface|
        @interface_types << JParsr::Type.new(interface[:class])
      end
    end

    @class_fields = []
    @class_methods = []
    @instance_fields = []
    @instance_methods = []
    if tree[:block] and tree[:block].respond_to?(:map)
      tree[:block].map {|b| b[:member]}.each do |member|
        if member[:modifiers].select {|m| m.has_key?(:static)}.size > 0
          if member[:member] and member[:member][:method]
            @class_methods << JParsr::Method.new(member)
          else
            @class_fields << JParsr::Field.new(member)
          end
        else
          if member[:member] and member[:member][:method]
            @instance_methods << JParsr::Method.new(member)
          else
            @instance_fields << JParsr::Field.new(member)
          end
        end
      end
    end
  end


end

class JParsr::ClassParameter < JParsr::Base
  attr_reader :name

  attr_reader :extends

  def initialize(tree)
    super(tree)

    @name = tree[:class][:id]

    @extends = []
    if(tree[:extends]) 
      [tree[:extends]].flatten.each do |e|
        @extends << JParsr::Type.new(e)
      end
    end
  end
end

class JParsr::Member < JParsr::Base

  include JParsr::Modifiers

  def initialize(tree)
    super(tree)
    self.init_modifiers(tree)
  end
end

class JParsr::Field < JParsr::Member
  def initialize(tree)
    super(tree)
  end
end

class JParsr::Method < JParsr::Member
  def initialize(tree)
    super(tree)
  end
end

