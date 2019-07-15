import os
import ycm_core

flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
'-std=c++11',
'-x',
'c++',
'-I',
'/usr/include',
'-isystem',
'/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include',
'-isystem'
'/usr/include/c++/4.8.2',
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', ]

def FlagsForFile( filename, **kwargs ):
  return {
  'flags': flags,
  'do_cache': True
  }
