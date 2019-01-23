" EasyTests - the genki dama to run your tests
"
" Author: Tomás Henríquez <tchenriquez@gmail.com>
" Source repository: https://github.com/hassek/EasyTest

" Script initialization {{{
	if exists('g:Easy_test_loaded') || &compatible || version < 702
		finish
	endif

	let g:Easy_test_loaded = 1

  " Supported syntaxes
  " let g:easytest_django_nose_syntax = 0
  " let g:easytest_pytest_syntax = 0
  " let g:easytest_django_syntax = 0
  " let g:easytest_ruby_syntax = 0
" }}}

pythonx << endpython
import subprocess

def run_current_test():
  run_test('test')

def run_current_class():
  run_test('class')

def run_current_file():
  run_test('file')

def run_current_package():
  run_test('package')

def run_current_test_on_terminal():
  run_test('test', on_terminal=True)

def run_current_class_on_terminal():
  run_test('class', on_terminal=True)

def run_current_file_on_terminal():
  run_test('file', on_terminal=True)

def run_current_package_on_terminal():
  run_test('package', on_terminal=True)

def run_all_tests():
  run_test('all')

def run_all_tests_on_terminal():
  run_test('all', on_terminal=True)

def run_last_test(on_terminal=False):
  command = vim.vars.get("easytest_last_command")
  if command:
    if isinstance(command, bytes):
      command = command.decode()
    if on_terminal:
      vim.command('Start ' + command)
    else:
      vim.command("Dispatch " + command)
  else:
    vim.command("echo 'no saved test run'")

def is_breakpoint_enabled():
  cmd = ['grep', 'from \\(IPython\\|pdb\\|pudb\\|rpudb\\) import', '--binary-file=without-match', '--line-number', '--recursive', '.']
  return subprocess.call(cmd, stdout=subprocess.PIPE) == 0

def run_test(level, on_terminal=False, runcov=False):
  import vim

  def easytest_django_syntax(cls_name, def_name):
    base = "./manage.py test "
    if level in parallel_levels and not has_breakpoint:
      base += '--parallel '
    if level == 'all':
      return base

    base += '-- ' # separator between options and test names

    file_path = vim.eval("@%").replace('.py', '').replace("/", '.')
    if level == 'package':
      file_path = file_path.rpartition('.')[0]

    # filter null values
    names = [nn for nn in [cls_name, def_name] if nn]

    if names:
      return base + file_path + "." + ".".join(names)
    return base + file_path

  def easytest_django_nose_syntax(cls_name, def_name):
    base = "./manage.py test %"
    # filter null values
    names = [nn for nn in [cls_name, def_name] if nn]

    if names:
      return base + "\:" + ".".join(names)
    return base

  def easytest_pytest_syntax(cls_name, def_name):
    file_path = vim.eval("@%")
    base = "pytest "
    if level in parallel_levels and not has_breakpoint:
      base += '--numprocesses=auto --dist=loadfile '
    else:
      base += '--numprocesses=0 --dist=no '
    if level != 'all':
      if level == 'package':
        file_path = file_path.rpartition('/')[0]
      base += file_path
    if level == 'file':
      return base
    names = [nn for nn in [cls_name, def_name] if nn]

    if names:
      return base + "::" + "::".join(names)
    return base

  def easytest_ruby_syntax(cls_name, def_name):
    path_name = vim.eval("@%")
    base = "ruby -I\"lib:test\" " + path_name

    if cls_name:
      base += " -t " + cls_name
    if def_name:
      base += " -n " + def_name

    return base

  parallel_levels = vim.vars.get("easytest_parallel_levels", [])

  cb = vim.current.buffer
  cw = vim.current.window
  original_position = vim.current.window.cursor

  for syntype in ["easytest_django_syntax", "easytest_django_nose_syntax", "easytest_pytest_syntax", "easytest_ruby_syntax"]:
    if vim.vars.get(syntype) == 1:
      func = locals()[syntype]
      break
  else:
      func = locals()['easytest_django_syntax']

  try:
    vim.command("?\<def\>")
    def_name = cb[vim.current.window.cursor[0] - 1].split()[1].split('(')[0].strip(":")
  except vim.error:
    def_name = None
  try:
    vim.command("?\<class\>")
    cls_name = cb[vim.current.window.cursor[0] - 1].split()[1].split('(')[0].strip(":")
  except vim.error:
    cls_name = None

  if level == 'class' or level == 'file':
    def_name = None

  if level == 'file':
    cls_name = None

  if level == 'package' or level == 'all':
    cls_name = None
    def_name = None

  has_breakpoint = is_breakpoint_enabled()
  command = func(cls_name, def_name)
  vim.command(f"let g:easytest_last_command = '{command}'")

  cw.cursor = original_position
  vim.command("let @/ = ''")  # clears search
  if on_terminal:
    vim.command('Start ' + command)
  else:
    vim.command("Dispatch " + command)
endpython
