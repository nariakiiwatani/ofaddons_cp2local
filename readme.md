# ofaddons_cp2local
This script copies addons in addons.make from OF/addons to somewhere and updates addons.make.  
About local_addons, see [here](https://forum.openframeworks.cc/t/local-addons-in-of-0-9-0-projects/21445)

Tested on...

- Mac OSX 10.10.5  
- [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) by robbyrussell  

## Usage
```
$ ofaddons_cp2local.sh [OPTIONS]

Options:
  -h, --help
  -g, --git				include git directories(default : exclude)
  -e, --example			include examples(default : exclude)
  -p, --path <dir>		project directory(default : [currentdir])
  -s, --src <dir>		overwrite addons directory(default : PROJ_ROOT/../../../addons)
  -d, --dst <dir>		overwrite destination directory(default : PROJ_ROOT/addons)
  -a, --abs				update addons.make by absolute path(default : relative)
  -i, --interactive		interactive mode
```

### Normal mode
```
$ cd path/to/your/projectdir # make sure your addons.make file is here
$ ofaddons_cp2local.sh
```
or
```
$ ofaddons_cp2local.sh -p path/to/your/projectdir
```

### Interactive mode
```
$ ofaddons_cp2local.sh -i # other options also available
Enter addon name with or without 'ofx'. blank to exit.
:
```

## Notice
- This script doesn't update your project file.  
So you may have to do it by yourself or with ProjectGenerator.  

## Change log
1/29/2016 asking for cloning from github repo when an addon is not found on local
1/29/2016 initial commit

## LICENSE
The MIT License (MIT)

Copyright (c) 2016 nariakiiwatani

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Notice] pathlib.bash is modified a bit but originally licensed to [omochimetaru](https://github.com/omochi/bash-pathlib/blob/master/LICENSE)

