" Vim syntax file
" Language:     dml
" Maintainer:   Alexander Kon-I Ho <koniho@gmail.com>

" Copyright 2012-2013 Wind River Systems, Inc. 
" Redistribution and use in any form, with or without modification,
" are permitted.
" This software is provided 'as-is', without any express or implied
" warranty. In no event will the authors be held liable for any damages
" arising from the use of this software.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let g:did_minibufexplorer_syntax_inits = 1

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
endif

syn keyword simStatement dml device import interface log loggroup bitorder interface is try except after error assert

syn keyword simStructure bank register field connect attribute event group port implement template layout
syn keyword simStorageClass local parameter data constant
syn keyword simRepeat in foreach select
syn keyword simLabel method header footer
syn keyword simConstant true false
syn keyword simType integer float string bool list reference undefined

syn match simType "\<u\?int[1-9]\d*\>"

syn keyword simParameters register_size size bitsize offset regnum signed allocate hard_reset_value soft_reset_value fields logging log_group read_logging write_logging configuration persistent internal attr_type required c_type evclass timebase
syn keyword simEventParams steps cycles seconds stacked
syn keyword simParamSpec default auto 
syn keyword simExpression delete new defined sizeof sizeoftype
syn keyword simFunctions cast
syn keyword simDeviceMethods init post_init destroy hard_reset soft_reset
syn keyword simExec call inline
syn keyword simExceptions try catch throw

hi def link simStatement Statement
hi def link simStructure Structure
hi def link simStorageClass StorageClass
hi def link simRepeat Repeat
hi def link simLabel Label
hi def link simFunctions Label
hi def link simConstant Constant
hi def link simType Type
hi def link simExceptions Exception

hi def simExpression ctermfg=Magenta guifg=Magenta
hi def simExec ctermfg=LightBlue guifg=LightBlue
hi def simParamSpec ctermfg=DarkCyan guifg=DarkCyan
