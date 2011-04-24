" Vim plugin for Vim Regular Expression Development {{{1
" Language:    vim script
" Maintainer:  Dave Silvia <dsilvia@mchsi.com>
" Date:        9/27/2004
"
" Version 1.1
" Date:        10/12/2004
"  Fixed:
"   - Problem with UNIX type
"     systems and have a single
"     quote in the filename for
"     the usage file.  Removed
"     the single quotes.
"
" Version 1.0
" Initial Release
" Date:        10/10/2004
" Beta 7
" Date:        10/7/2004
"  New:
"   - Added 'lookaround' anchor
"     highlighting per suggestion
"     by Jon Merz
"  Fixed:
"   - Couldn't use pattern beginning
"     with double quote because of
"     comment allowance.  Now prompts.
"     pointed out by Jon Merz
"   - Only highlights one pattern in
"     top window even if it is a sub
"     pattern of another pattern in the
"     window.
"
" Beta 6
" Date:        10/4/2004
"  Possible final beta release
"
" Beta 5
" Date:        10/2/2004
" Beta 5b
" Date:        10/2/2004
"  New:
"   -  Added expanded usage message
"      in a scrollable window
" Beta 5c
" Date:        10/2/2004
"  New:
"   -  Added highlight to current
"      selected pattern in top
"      window
"

command! -nargs=0 Vimrex call vimregex#Vimrex()
command! -nargs=0 VimRegEx  if has("gui_running") | execute ':silent! :!gvim -c "let g:VimRegEx=1" -c Vimrex' | else | execute ':silent! :!vim -c "let g:VimRegEx=1" -c Vimrex' | endif

"function! s:IT_LL_NEVER_HAPPEN() "{{{1
function! s:IT_LL_NEVER_HAPPEN()
BEGIN MANUAL SECTION ONE
Uses 3 windows for developing Vim regular expressions.

The top window is used to type in the regular expression(s) or you may
optionally read in a file containing regular expressions.  There can be more
than one regular expression in the top window, as well as comment lines (lines
that begin with a double quote with optional leading whitespace).  The line
containing the cursor in this window is the line of the current regular
expression for execution and/or analysis.

The middle window shows the result of each successive execution or analysis of
the current regular expression.

The bottom window is for source text used in testing regular expressions.  You
either type in text, or read in a file for searching.

The contents of the top and bottom window are saved from one session to the
next.  When the files used to save these contents do not exist or are empty
when starting up, sample contents are placed in each to use as a self
tutorial.


END MANUAL SECTION ONE
BEGIN MANUAL SECTION TWO

The mappings for all the above are configurable in your vimrc by setting their
respective global variables (see below) to the key sequences you desire.


END MANUAL SECTION TWO
BEGIN MANUAL SECTION THREE

   +----------------------------------------------------------------------+
   |" comment line                                                        |
   |regular expression                                                    |
   |                                                                      |
   |             Build regular expressions here                           |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |----------------------------------------------------------------------|
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |       Execution/Analysis results displayed here                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |----------------------------------------------------------------------|
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |              Text to be searched goes here                           |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   +----------------------------------------------------------------------+

To use, enter a regular expression in the top window and some text to search in
the bottom window.  With the cursor on the line with the regular expression in
the top window, type

END MANUAL SECTION THREE
BEGIN MANUAL SECTION FOUR

and the analysis of the regular expression will be displayed in the center
window.  Now, type

END MANUAL SECTION FOUR
BEGIN MANUAL SECTION FIVE

the results of the search with the current regular expression will be
displayed in the center window.  Additionally,  all text that qualifies as a
match in the bottom window will be highlighted in the 'non-current'
highlighting with the matching specific token of the current search location
highlighted as appropriate to its regular expression atom(s).

NOTE:  you need to use the menu 'Execute Regular Expression' button or the key
       mapping to search and have the described results.  Using Vim's search
       commands will move to different matches, but will not effect the
       highlighting.  See : Pattern and Match Highlighting below.


END MANUAL SECTION FIVE
BEGIN MANUAL SECTION SIX

Highlighting is set by either a link or by setting the foreground and/or
background values for cterm or gui.  If the respective 'g:Vimrex...Lnk'
variable exists, the link is used, else the highlighting is set via the
cterm/gui values.

There are eight highlight groups used.  They are:

     current regex
     plain search
     capture
     non-capture
     choice
     expansion
     lookaround
     non-current

current regex is used to highlight the current regular expression in the top
window.

plain search is the default highlighting for the current match.  If no other
atom highlighting applies, this is the highlighting that is displayed.

capture is the highlighting used to delineate the portion of the current match
that is part of a capture group, i.e., results from a regular expression
enclosed in '\(...\)'.

non-capture highlighting is used to indicate the portion of the current match
that is part of a non-capture group, i.e., results from a regular expression
enclosed in '\%(...\)'.

choice highlighting indicates the portion of the current match that is the
result of a choice list atom, that is, a list of characters or character
classes enclosed in '[...]'.

expansion highlighting indicates the portion of the current match that is the
result of an expansion list, or sequence, atom, that is, a list of characters
or character classes enclosed in '\%[...]'.

lookaround highlighting results from the portion of the current match that
conforms to a lookaround anchor, e.g., '\@<=' or '\@='.  It is, of course,
only seen in the case of a positive lookaround, since the absence of the
anchor triggers the negative lookaround and an 'absence' is difficult to
highlight!;)

non-current highlighting applies to all of the bottom window text that matches
the pattern but is not the current match.


END MANUAL SECTION SIX
BEGIN MANUAL SECTION SEVEN
separately.  Files can be of HTML (.html) or TEXT (.txt) format.  There are
menu buttons and mappings to generate files for each of the windows,
individually or you can generate all but the Usage file into one file for
composite viewing.

NOTE:  HTML only works with Vim compiled with GUI support.  The gui need not
       be running, but in some systems (X11), colors may not be what you see
       when in Vim.  On my system, Windows (g)vim produce comparable colors to
       those shown in Vim.  Cygwin produces the colors as seen in a standard
       xterm window, whether Vim was run in a command prompt window with bash
       or in a special xinit xterm.  By 'standard xterm', I mean an xterm
       started with no arguments, for example, from the command line as
       'xterm &'.

See:   :h tohtml, then /Remarks: (search for 'Remarks:').



END MANUAL SECTION SEVEN
endfunction

" vim:set tw=78 et ts=2 sw=2 sts=2: {{{1
