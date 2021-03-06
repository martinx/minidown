require 'spec_helper'

describe Minidown do
  describe 'code_block' do
    it 'should parse correct' do
      str =<<HERE
```
should in code block

in block
```
HERE
      Minidown.render(str).should == "<pre><code>should in code block\n\nin block</code></pre>"
    end

    it 'should allow tildes as well as backquotes' do
      str =<<HERE
~~~
should in code block

in block
~~~
HERE
      Minidown.render(str).should == "<pre><code>should in code block\n\nin block</code></pre>"
    end

    it 'should allow arbitrary number of `' do
      str =<<HERE
````````````
should in code block

in block
````````````
HERE
      Minidown.render(str).should == "<pre><code>should in code block\n\nin block</code></pre>"
    end

    it 'should allow arbitrary number of tildes' do
      str =<<HERE
~~~~~~~~~~~
should in code block

in block
~~~~~~~~~~~
HERE
      Minidown.render(str).should == "<pre><code>should in code block\n\nin block</code></pre>"
    end


    it 'should ignore space' do
      str =<<HERE
  ```
should in code block
in block
    ```
HERE
      Minidown.render(str).should == "<pre><code>should in code block\nin block</code></pre>"
    end

    it 'should have lang attribute' do
      str =<<HERE
```  ruby
should in code block

in block
```
HERE
      Minidown.render(str).should == "<pre><code class=\"ruby\">should in code block\n\nin block</code></pre>"
    end

    it 'should have lang attribute with tildes' do
      str =<<HERE
~~~  ruby
should in code block

in block
~~~
HERE
      Minidown.render(str).should == "<pre><code class=\"ruby\">should in code block\n\nin block</code></pre>"
    end

    it 'should allow escape' do
      str =<<HERE
\\```
should in code block

in block
\\```
HERE
      Minidown.render(str).should == "<p>```<br>should in code block</p><p>in block<br>```</p>"
      str =<<HERE
\\~~~
should in code block

in block
\\~~~
HERE
      Minidown.render(str).should == "<p>~~~<br>should in code block</p><p>in block<br>~~~</p>"
    end

    it 'should not escape content' do
      str =<<HERE
```
\\+
\\.
\\-
\\*
<>
```
HERE
      Minidown.render(str).should == "<pre><code>\\+\n\\.\n\\-\n\\*\n&lt;&gt;</code></pre>"
      str =<<HERE
~~~
\\+
\\.
\\-
\\*
<>
~~~
HERE
      Minidown.render(str).should == "<pre><code>\\+\n\\.\n\\-\n\\*\n&lt;&gt;</code></pre>"
    end

    it 'should escape html tag' do
      str ='```
<a>hello</a>
```'
      Minidown.render(str).should == "<pre><code>&lt;a&gt;hello&lt;/a&gt;</code></pre>"
      str ='~~~
<a>hello</a>
~~~'
      Minidown.render(str).should == "<pre><code>&lt;a&gt;hello&lt;/a&gt;</code></pre>"
    end

    it 'should not auto convert' do
      str = '```
jjyruby@gmail.com
```'
      Minidown.render(str).should == '<pre><code>jjyruby@gmail.com</code></pre>'
      str = '~~~
jjyruby@gmail.com
~~~'
      Minidown.render(str).should == '<pre><code>jjyruby@gmail.com</code></pre>'
    end

    describe "work with code block handler" do
      it "work with handler" do
        str = '``` ruby
puts "We love ruby!"
```'
        handler = ->(lang, content){"`#{content}` is write in #{lang}"}
        Minidown.render(str, code_block_handler: handler).should == '`puts "We love ruby!"` is write in ruby'
      end

      it "lang should return empty if not specific language" do
        str = '```
not specific language
```'
        handler = ->(lang, content){ "#{content}, so lang is #{lang.inspect}" }
        Minidown.render(str, code_block_handler: handler).should == 'not specific language, so lang is nil'
      end

      it "handler should pass raw content" do
        str = '```
<script>
```'
        handler = ->(lang, content){ content.gsub("<", "{").gsub(">", "}") }
        Minidown.render(str, code_block_handler: handler).should == '{script}'
      end

      it "should not escape <>" do
        test_cases = %w{<script> <> < >}
        handler = ->(lang, content){ content }
        parser = Minidown::Parser.new(code_block_handler: handler)
        test_cases.each do |case_s|
          str = "```\n#{case_s}\n```"
          parser.render(str).should == case_s
        end
      end
    end
  end
end
