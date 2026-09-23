CnAkE — Getting Started

This repository contains a small language/runtime called CnAkE implemented in Ruby.

Prerequisites
- Install Ruby (on Debian/Ubuntu):

```sh
sudo apt update
sudo apt install ruby-full
```

- Verify Ruby and IRB are available:

```sh
ruby -v
irb --version
```

Quick start

1. Open a terminal in this repository folder.
2. Start the interactive Ruby session (IRB):

```sh
irb
```

3. In the IRB prompt, load the CnAkE parser and enter the language runtime:

```ruby
require './CnAkEparse.rb'
CnAkE.new.slither
```

Testing your CnAkE code

- Write whatever CnAkE source you want to test into the file `test.txt`.
- Then start `irb`, require the parser as shown above, and call `CnAkE.new.slither` to run/parse your code.

Example IRB session (from this project)

```text
abdqa105@abdqa105-OptiPlex-3000:~/LIU/TDP019/tdp019-1$ irb
irb(main):001:0> CnAkE.new.slither
(irb):1:in `<main>': uninitialized constant CnAkE (NameError)
	from /usr/lib/ruby/gems/3.2.0/gems/irb-1.6.2/exe/irb:11:in `<top (required)>'
	from /usr/bin/irb:25:in `load'
	from /usr/bin/irb:25:in `<main>'
irb(main):002:0> require './CnAkEparse.rb'
=> true
irb(main):003:0> CnAkE.new.slither
[CnAkE] 7
2
=> 
[#<FuncDefStmt:0x0000766c2eb96980
  @body=#<Program:0x0000766c2eb96a48 @statements=[#<PrintStmt:0x0000766c2eb6fad8 @expr=(Var(a) + Var(b))>]>,
  @name="add",
  @params=["a", "b"]>,
 #<ExprStmt:0x0000766c2ea3ca80 @expr=#<FuncCallExpr:0x0000766c2ea3fa00 @args=[Number(3), Number(4)], @name="add">>,
 #<PrintStmt:0x0000766c2ea331d8 @expr=(Number(1) + Number(1))>]
irb(main):004:0>
```

Tips
- If you get "uninitialized constant CnAkE" ensure you `require './CnAkEparse.rb'` from the same directory.
- If you prefer, run IRB with the current directory on the load path: `irb -I.` then `require 'CnAkEparse'`.

Files
- `test.txt`: place example CnAkE source here to edit and experiment with.
- `CnAkEparse.rb`, `CnAkElang.rb`, `CnAkE.rb` (if present): runtime and parser sources.

If you want, I can add a small runner script to automatically load `test.txt` and invoke the parser.
