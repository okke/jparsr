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

require 'pstore'

class JParsr::Store

  attr_reader :name

  def initialize(name)
    @store = PStore.new(name)
    @name = name
  end

  def write(&block)
    @store.transaction do 
      yield JParsr::StoreWriter.new(@store) if block_given?
    end
  end

  def read(&block)
    @store.transaction(true) do 
      yield JParsr::StoreReader.new(@store) if block_given?
    end
  end

  def destroy
    File.delete(name)
  end

end

class JParsr::StoreReader
  def initialize(store)
    @store = store
  end

  def get_source(name, &block)
    retrieve "source:#{name}", &block
  end

  def get_class(name, &block)
    retrieve "class:#{name}", &block
  end

  private

  def retrieve(key, &block)
    found = @store[key]
    found = @store[found.str] if found and found.is_a?(JParsr::UID)
    yield found if block_given?
    found
  end
end

class JParsr::StoreWriter
  def initialize(store)
    @store = store
  end

  def add_source(name, source)
    add_object("source:#{name}", source)

    source.classes.each do |clazz|
      add_object("class:#{clazz.id}", clazz)
    end
  end

  private

  def add_object(key,value)
    @store[key] = value.uid
    @store[value.uid.str] = value
  end
end
