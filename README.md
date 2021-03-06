# vim-easytest

## About

EasyTest is a utility plugin which allows you to run unit tests easier
avoiding the need to write the name of the specific test, class or file
you want to run.

## Features

- Run your tests Asynchronously
- See results on your quickfix
- Run tests on your terminal right away if needed (i.e. for debugging with pdb)

## Installation

You need the amazing plugin [dispatch](https://github.com/tpope/vim-dispatch) for vim-easytest to run.
Vim needs to be compiled with python

## Supported Syntax

- Python
  - django (Default)
  - django-nose
  - pytest
- Ruby
  - ruby stand alone

To change the default syntax for a specific language just set `let easytest_{syntax_name}_syntax = 1` in your `.vimrc` file

## Quick Start

Just place your cursor inside the function, class or file you want to run your tests from and execute the script.

### Place your cursor inside the function and run the script.
![Example1](assets/vim-easytest.gif?raw=true)

### Or run the entire file if you want to.
![Example2](assets/vim-easytest2.gif?raw=true)

## Mapping

Currently there is no default mapping so everyone can just map it however they want. But here is a good recommendation for a default:

    nmap <S-t> :py run_current_test()<CR>
    nmap <leader>t :py run_current_test_on_terminal()<CR>
    nmap <leader>c :py run_current_class()<CR>
    nmap <D-t> :py run_current_file()<CR>

These are all possible functions to execute. I hope the names are self explanatory enough:

    run_current_test()
    run_current_test_on_terminal()
    run_current_class()
    run_current_class_on_terminal()
    run_current_file()
    run_current_file_on_terminal()
    run_current_package()
    run_current_package_on_terminal()
    run_all_tests()
    run_all_tests_on_terminal()
    run_last_test()

### Parallel test

Parallelization is currently supported for easytest_django_syntax and easytest_pytest_syntax. 

You can set the test level where parallelization is enabled using:

  let g:easytest_parallel_levels = ["all", "package"]

will enable parallelization for run_all_tests() and run_current_package(), but
run serially on run_current_file(), run_current_class(), and
run_current_test().

vim-easytest will try to automatically detect if you set breakpoints using pdb,
pudb, rpudb, or IPython and will automatically disable parallel test. Not all
dispatch handler supports interactive breakpoint.

## Tips & Tricks

### different projects

If you have different projects, you can use this neat vim configuration trick, put a `.vimrc` inside your project to change specific configurations, i.e.:
```
autocmd FileType python let easytest_django_syntax=0
autocmd FileType python let easytest_pytest_syntax=1
```

It will override the default at `~/.vimrc` just for that project.

This feature is turned off by default, so you will need to add at `~/.vimrc` this to activate it:

```
set exrc
set secure
```

The last command is not required but is recommended.

## Known Issues

- Vim needs to be opened where the `./manage.py` file exists for django/django-nose to run tests correctly

## Contributing
There are still many issues to be resolved. Patches, suggestions and new language/framework syntax are always welcome!
A list of open feature requests can be found [here](../../issues?labels=enhancement&state=open).

### Contributors

- Tomas Henriquez
- Lie Ryan
