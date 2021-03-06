" Load guard {{{1
if v:version < 700
  echohl ErrorMsg
  echom 'VimRegEx requires Vim 7.0 or later.'
  echohl None
  finish
endif
if exists('g:loaded_vimregex_autoload') && !exists('g:testing_vimregex')
  finish
endif
let g:loaded_vimregex_autoload = 1

" Variables {{{1
let s:thisScript=expand("<sfile>:p:h:h").'/plugin/'.expand('<sfile>:t')
let s:myName=fnamemodify(s:thisScript,":t")
let s:inlegend=0

let s:grp=''
let s:capgrp=''
let s:choice=''
let s:expansion=''
let s:class=''
let s:grpOpen='\\(\|\\%(\|\\%[\|[:\@!'
let s:grpClose='\\)\|]'

let s:hit=0
let s:lline=1
let s:lpat=''
let s:rline=0

let s:VimRegExTokBS1stChar='%|&+<=>?@ACDFHIKLMOPSUVWXZ_abcdefhiklmnoprstuvwxz()\'

let s:ingroup=0
let s:inChoice=0
let s:inExpansion=0
let s:charClass=
\"
\[:alnum:]\<NL>
\letters and decimal digits\<NL>
\[:alpha:]\<NL>
\letters\<NL>
\[:blank:]\<NL>
\space and tab\<NL>
\[:cntrl:]\<NL>
\control\<NL>
\[:digit:]\<NL>
\decimal digits\<NL>
\[:graph:]\<NL>
\printable except space\<NL>
\[:lower:]\<NL>
\lowercase\<NL>
\[:print:]\<NL>
\printable including space\<NL>
\[:punct:]\<NL>
\punctuation\<NL>
\[:space:]\<NL>
\whitespace\<NL>
\[:upper:]\<NL>
\uppercase\<NL>
\[:xdigit:]\<NL>
\hexadecimal digits\<NL>
\[:return:]\<NL>
\carriage return (non-POSIX)\<NL>
\[:tab:]\<NL>
\tab (non-POSIX)\<NL>
\[:escape:]\<NL>
\esc (non-POSIX)\<NL>
\[:backspace:]\<NL>
\bs (non-POSIX)"

let s:VimRegExTokOpen='$\\~^*.[]'
let s:VimRegExTokDesc="
      \$\<NL>
      \end of line\<NL>
      \*\<NL>
      \0 or more of previous atom\<NL>
      \.\<NL>
      \any but newline\<NL>
      \]\<NL>
      \end choice list or expansion sequence\<NL>
      \\\%[\<NL>
      \begin expansion sequence\<NL>
      \\\%$\<NL>
      \end of file or string\<NL>
      \\\&\<NL>
      \previous atom and next atom are required together ('and')\<NL>
      \\\|\<NL>
      \previous atom and next atom are alternate choices ('or')\<NL>
      \\\(\<NL>
      \begin capture group\<NL>
      \\\)\<NL>
      \end group\<NL>
      \\\%(\<NL>
      \begin non-capture group\<NL>
      \\\)\<NL>
      \end group\<NL>
      \\\%^\<NL>
      \start of file or string\<NL>
      \\\+\<NL>
      \1 or more of previous atom\<NL>
      \\\<\<NL>
      \begin word boundary\<NL>
      \\\=\<NL>
      \0 or 1 of previous atom\<NL>
      \\\>\<NL>
      \end word boundary\<NL>
      \\\?\<NL>
      \0 or 1 of previous atom\<NL>
      \\\@!\<NL>
      \negative lookahead== previous atom present ? no match : match\<NL>
      \\\@<!\<NL>
      \negative lookbehind== previous atom present ? no match : match\<NL>
      \\\@<=\<NL>
      \positive lookbehind== previous atom present ? match : no match\<NL>
      \\\@=\<NL>
      \positive lookahead== previous atom present ? match : no match\<NL>
      \\\@>\<NL>
      \'grab all' independent subexpression\<NL>
      \\\A\<NL>
      \non-alpha\<NL>
      \\\C\<NL>
      \match case\<NL>
      \\\D\<NL>
      \non-digit (decimal)\<NL>
      \\\F\<NL>
      \non-filename non-digit (decimal)\<NL>
      \\\H\<NL>
      \non-head of word (alpha or _)\<NL>
      \\\I\<NL>
      \non-identifier non-digit (decimal)\<NL>
      \\\K\<NL>
      \non-keyword non-digit (decimal)\<NL>
      \\\L\<NL>
      \non-lowercase\<NL>
      \\\M\<NL>
      \magic off for following\<NL>
      \\\O\<NL>
      \non-digit (octal)\<NL>
      \\\P\<NL>
      \printable non-digit (decimal)\<NL>
      \\\S\<NL>
      \non-whitespace\<NL>
      \\\U\<NL>
      \non-uppercase\<NL>
      \\\V\<NL>
      \very magic off for following\<NL>
      \\\W\<NL>
      \non-word (alpha or decimal or _)\<NL>
      \\\X\<NL>
      \non-digit (hex)\<NL>
      \\\Z\<NL>
      \ignore Unicode combine diff\<NL>
      \\\_\<NL>
      \following and newline\<NL>
      \\\_$\<NL>
      \end of line (anywhere)\<NL>
      \\\_.\<NL>
      \single char or end of line\<NL>
      \\\_^\<NL>
      \start of line (anywhere)\<NL>
      \\\a\<NL>
      \alpha\<NL>
      \\\b\<NL>
      \backspace <BS>\<NL>
      \\\c\<NL>
      \ignore case\<NL>
      \\\d\<NL>
      \digit (decimal)\<NL>
      \\\e\<NL>
      \escape <Esc>\<NL>
      \\\f\<NL>
      \filename\<NL>
      \\\h\<NL>
      \head of word (alpha or _)\<NL>
      \\\i\<NL>
      \identifier\<NL>
      \\\k\<NL>
      \keyword\<NL>
      \\\l\<NL>
      \lowercase\<NL>
      \\\m\<NL>
      \magic on for following\<NL>
      \\\n\<NL>
      \newline (possibly combination)\<NL>
      \\\o\<NL>
      \digit (octal)\<NL>
      \\\p\<NL>
      \printable\<NL>
      \\\r\<NL>
      \carriage return <CR>\<NL>
      \\\s\<NL>
      \whitespace <Space> or <Tab>\<NL>
      \\\t\<NL>
      \tab <Tab>\<NL>
      \\\u\<NL>
      \uppercase\<NL>
      \\\v\<NL>
      \very magic on for following\<NL>
      \\\w\<NL>
      \word (alpha or decimal or _)\<NL>
      \\\x\<NL>
      \digit (hex)\<NL>
      \\\ze\<NL>
      \previous atom is end of whole match\<NL>
      \\\zs\<NL>
      \following is start of whole match\<NL>
      \~\<NL>
      \last given substitute
      \"

let s:sampleRegex1='\w\+'
let s:sampleRegex2='[[:punct:]]\+'
let s:sampleRegex3='\%(ABC\|abc\)\@<=\(DEF\|def\)\%(GHIJ\|ghij\)\@='
let s:sampleRegex4='\%(ABC\|abc\)\@<=\%(DEF\|def\)\%(GHIJ\|ghij\)\@='
let s:sampleRegex5='\%(ABC\|abc\)\@<=DEF\|def\%(GHIJ\|ghij\)\@='
let s:sampleRegex6='" Any alpha sequence as long as it is followed by a non-vowel'
let s:sampleRegex7='[[:alpha:]]\+\([^aeiouAEIOU]\)\@='
let s:sampleRegex8='" A regex for email address'
let s:sampleRegex9='\<[A-Za-z0-9._%-]\+@[A-Za-z0-9._%-]\+\.[A-Za-z]\{2,4}\>'
let s:sampleRegex10='" Another regex for email address'
let s:sampleRegex11='\<[[:alnum:]._%-]\+@[._%\-[:alnum:]]\+\.[[:alpha:]]\{2,4}\>'
let s:sampleRegex12='" Yet another regex for email address'
let s:sampleRegex13='\<\%(\w\|[.%-]\)\+@\%(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex14='\<\(\w\|[.%-]\)\+@\(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex15='\<\%(\w\|[.%-]\)\+@\(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex16='\<\(\w\|[.%-]\)\+@\%(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex17='" RTFM or Read The Fine Manual'
let s:sampleRegex18='R\%[ead\s]T\%[he\s]F\%[ine\s]M\%[anual]'
let s:sampleRegex19='" This allows anything printable after the "F"; or even unprintable!;)'
let s:sampleRegex20='R\%[ead]\s*T\%[he]\s*F\p\{-}\s*M\%[anual]'
let s:sampleRegex21='" Even more flexibility'
let s:sampleRegex22='R\%[ea[[:alpha:]]]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex23='R\%[ea\a]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex24='R\%[ea\a\a]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex25='" Hmm...'
let s:sampleRegex26='\%(\<\)\@<=\%([A-Za-z0-9._%-]\+\)\%(@[A-Za-z0-9._%-]\+\.[A-Za-z]\{2,4}\>\)\@='
let s:sampleRegex27='\%(\<[A-Za-z0-9._%-]\+@\)\@<=\%([A-Za-z0-9._%-]\+\)\%(\.[A-Za-z]\{2,4}\>\)\@='
let s:sampleRegex28='\%(\<[A-Za-z0-9._%-]\+@[A-Za-z0-9._%-]\+\.\)\@<=\%([A-Za-z]\{2,4}\)\%(\>\)\@='

let s:sampleSrc1='1 2 3 4 five six seven 8910'
let s:sampleSrc2=" !\"#$%&'()*+,-./0123456789:;<=>?"
let s:sampleSrc3='@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'
let s:sampleSrc4='`abcdefghijklmnopqrstuvwxyz{|}'
let s:sampleSrc5=' ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿'
let s:sampleSrc6='ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß'
let s:sampleSrc7='àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ'
let s:sampleSrc8='JoeValachi@crime.org'
let s:sampleSrc9='LegsDiamond@crime.org'
let s:sampleSrc10='BillGates@crime.org'
let s:sampleSrc11='RTFM'
let s:sampleSrc12='Read The Fine Manual'
let s:sampleSrc13='Read The Formidable Manual'
let s:sampleSrc14='Read The Facinating Manual'
let s:sampleSrc15='Read The Finished Manuscript'
let s:sampleSrc16='Reap The Future Manufacturing Benefits'
let s:sampleSrc17='Reach The Final Manufacture Phase'

if exists('g:VimrexDebug')
  command! -nargs=1 VimrexDBG :if g:VimrexDebug | call append(line('$'),<args>) | endif
else
  command! -nargs=1 VimrexDBG :
endif

"function! vimregex#doGlobals() "{{{1
function! vimregex#doGlobals()
  if !exists('g:VimRegexBrowseDir')
    let g:VimRegexBrowseDir = filter(split(expand(&rtp),','), 'v:val != ""')[0]
  endif

  " File paths {{{2
  if !exists("g:VimrexFileDir")
    let g:VimrexFileDir=fnamemodify(expand("~"),":p:h")
  endif
  if !exists("g:VimrexFile")
    let g:VimrexFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Specification"),":p")
  endif
  if !exists("g:VimrexRsltFile")
    let g:VimrexRsltFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Result"),":p")
  endif
  if !exists("g:VimrexSrcFile")
    let g:VimrexSrcFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Search Source"),":p")
  endif
  if !exists("g:VimrexUsageFile")
    let g:VimrexUsageFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression The Fine Manual"),":p")
  endif

  " Mappings {{{2
  if !exists("g:VimrexExec")
    let g:VimrexExec="ze"
  endif
  if !exists("g:VimrexAnlz")
    let g:VimrexAnlz="za"
  endif
  if !exists("g:VimrexTop")
    let g:VimrexTop="gt"
  endif
  if !exists("g:VimrexBtm")
    let g:VimrexBtm="gb"
  endif
  if !exists("g:VimrexCtr")
    let g:VimrexCtr="gc"
  endif
  if !exists("g:VimrexDSrc")
    let g:VimrexDSrc="zs"
  endif
  if !exists("g:VimrexDRslt")
    let g:VimrexDRslt="zr"
  endif
  if !exists("g:VimrexCLS")
    let g:VimrexCLS="zv"
  endif
  if !exists("g:VimrexRdSrc")
    let g:VimrexRdSrc="zS"
  endif
  if !exists("g:VimrexRdRex")
    let g:VimrexRdRex="zR"
  endif
  if !exists("g:VimrexExit")
    let g:VimrexExit="zx"
  endif
  if !exists("g:VimrexQQ")
    let g:VimrexQQ='z?'
  endif
  if !exists("g:VimrexQC")
    let g:VimrexQC='zc'
  endif
  if !exists("g:VimrexQP")
    let g:VimrexQP='zp'
  endif
  if !exists("g:VimrexQL")
    let g:VimrexQL='zl'
  endif
  if !exists("g:VimrexZHV")
    let g:VimrexZHV='zhv'
  endif
  if !exists("g:VimrexZHS")
    let g:VimrexZHS='zhs'
  endif
  if !exists("g:VimrexZHU")
    let g:VimrexZHU='zhu'
  endif
  if !exists("g:VimrexZHR")
    let g:VimrexZHR='zhr'
  endif
  if !exists("g:VimrexZHA")
    let g:VimrexZHA='zha'
  endif
  if !exists("g:VimrexZTV")
    let g:VimrexZTV='ztv'
  endif
  if !exists("g:VimrexZTS")
    let g:VimrexZTS='zts'
  endif
  if !exists("g:VimrexZTU")
    let g:VimrexZTU='ztu'
  endif
  if !exists("g:VimrexZTR")
    let g:VimrexZTR='ztr'
  endif
  if !exists("g:VimrexZTA")
    let g:VimrexZTA='zta'
  endif

  " Syntax colors {{{2
  if !exists("g:VimrexSrchPatLnk")
    if !exists("g:VimrexSrchPatCFG")
      let g:VimrexSrchPatCFG='black'
    endif
    if !exists("g:VimrexSrchPatCBG")
      let g:VimrexSrchPatCBG='DarkMagenta'
    endif
    if !exists("g:VimrexSrchPatGFG")
      let g:VimrexSrchPatGFG='black'
    endif
    if !exists("g:VimrexSrchPatGBG")
      let g:VimrexSrchPatGBG='DarkMagenta'
    endif
  endif

  if !exists("g:VimrexSrchAncLnk")
    if !exists("g:VimrexSrchAncCFG")
      let g:VimrexSrchAncCFG='DarkRed'
    endif
    if !exists("g:VimrexSrchAncCBG")
      let g:VimrexSrchAncCBG='gray'
    endif
    if !exists("g:VimrexSrchAncGFG")
      let g:VimrexSrchAncGFG='DarkRed'
    endif
    if !exists("g:VimrexSrchAncGBG")
      let g:VimrexSrchAncGBG='gray'
    endif
  endif

  if !exists("g:VimrexSrchTokLnk")
    if !exists("g:VimrexSrchTokCBG")
      let g:VimrexSrchTokCBG='LightCyan'
    endif
    if !exists("g:VimrexSrchTokCFG")
      let g:VimrexSrchTokCFG='black'
    endif
    if !exists("g:VimrexSrchTokGBG")
      let g:VimrexSrchTokGBG='LightCyan'
    endif
    if !exists("g:VimrexSrchTokGFG")
      let g:VimrexSrchTokGFG='black'
    endif
  endif

  if !exists("g:VimrexSrchCgpLnk")
    if !exists("g:VimrexSrchCgpCFG")
      let g:VimrexSrchCgpCFG='blue'
    endif
    if !exists("g:VimrexSrchCgpCBG")
      let g:VimrexSrchCgpCBG='red'
    endif
    if !exists("g:VimrexSrchCgpGFG")
      let g:VimrexSrchCgpGFG='blue'
    endif
    if !exists("g:VimrexSrchCgpGBG")
      let g:VimrexSrchCgpGBG='red'
    endif
  endif

  if !exists("g:VimrexSrchGrpLnk")
    if !exists("g:VimrexSrchGrpCFG")
      let g:VimrexSrchGrpCFG='red'
    endif
    if !exists("g:VimrexSrchGrpCBG")
      let g:VimrexSrchGrpCBG='blue'
    endif
    if !exists("g:VimrexSrchGrpGFG")
      let g:VimrexSrchGrpGFG='red'
    endif
    if !exists("g:VimrexSrchGrpGBG")
      let g:VimrexSrchGrpGBG='blue'
    endif
  endif

  if !exists("g:VimrexSrchChcLnk")
    if !exists("g:VimrexSrchChcCFG")
      let g:VimrexSrchChcCFG='black'
    endif
    if !exists("g:VimrexSrchChcCBG")
      let g:VimrexSrchChcCBG='LightBlue'
    endif
    if !exists("g:VimrexSrchChcGFG")
      let g:VimrexSrchChcGFG='black'
    endif
    if !exists("g:VimrexSrchChcGBG")
      let g:VimrexSrchChcGBG='LightBlue'
    endif
  endif

  if !exists("g:VimrexSrchExpLnk")
    if !exists("g:VimrexSrchExpCFG")
      let g:VimrexSrchExpCFG='black'
    endif
    if !exists("g:VimrexSrchExpCBG")
      let g:VimrexSrchExpCBG='LightGreen'
    endif
    if !exists("g:VimrexSrchExpGFG")
      let g:VimrexSrchExpGFG='black'
    endif
    if !exists("g:VimrexSrchExpGBG")
      let g:VimrexSrchExpGBG='LightGreen'
    endif
  endif

  if !exists("g:VimrexFilePatLnk")
    if !exists("g:VimrexFilePatCFG")
      let g:VimrexFilePatCFG='cyan'
    endif
    if !exists("g:VimrexFilePatCBG")
      let g:VimrexFilePatCBG='brown'
    endif
    if !exists("g:VimrexFilePatGFG")
      let g:VimrexFilePatGFG='cyan'
    endif
    if !exists("g:VimrexFilePatGBG")
      let g:VimrexFilePatGBG='brown'
    endif
  endif
endfunction " vimregex#doGlobals()

"function! vimregex#undoGlobals() "{{{1
function! vimregex#undoGlobals()
  unlet! g:VimrexBrowseDir g:VimrexFileDir g:VimrexFile g:VimrexRsltFile g:VimrexSrcFile g:VimrexUsageFile
  unlet! g:VimrexExec g:VimrexAnlz g:VimrexTop g:VimrexBtm g:VimrexCtr g:VimrexDSrc g:VimrexDRslt g:VimrexCLS
  unlet! g:VimrexRdSrc g:VimrexRdRex g:VimrexExit g:VimrexQQ g:VimrexQC g:VimrexQP g:VimrexQL g:VimrexZHV
  unlet! g:VimrexZHS g:VimrexZHU g:VimrexZHR g:VimrexZHA g:VimrexZTV g:VimrexZTS g:VimrexZTU g:VimrexZTR
  unlet! g:VimrexZTA g:VimrexSrchPatLnk g:VimrexSrchPatCFG g:VimrexSrchPatCBG g:VimrexSrchPatGFG
  unlet! g:VimrexSrchPatGBG g:VimrexSrchAncLnk g:VimrexSrchAncCFG g:VimrexSrchAncCBG g:VimrexSrchAncGFG
  unlet! g:VimrexSrchAncGBG g:VimrexSrchTokLnk g:VimrexSrchTokCBG g:VimrexSrchTokCFG g:VimrexSrchTokGBG
  unlet! g:VimrexSrchTokGFG g:VimrexSrchCgpLnk g:VimrexSrchCgpCFG g:VimrexSrchCgpCBG g:VimrexSrchCgpGFG
  unlet! g:VimrexSrchCgpGBG g:VimrexSrchGrpLnk g:VimrexSrchGrpCFG g:VimrexSrchGrpCBG g:VimrexSrchGrpGFG
  unlet! g:VimrexSrchGrpGBG g:VimrexSrchChcLnk g:VimrexSrchChcCFG g:VimrexSrchChcCBG g:VimrexSrchChcGFG
  unlet! g:VimrexSrchChcGBG g:VimrexSrchExpLnk g:VimrexSrchExpCFG g:VimrexSrchExpCBG g:VimrexSrchExpGFG
  unlet! g:VimrexSrchExpGBG g:VimrexFilePatLnk g:VimrexFilePatCFG g:VimrexFilePatCBG g:VimrexFilePatGFG
  unlet! g:VimrexFilePatGBG
endfunction " vimregex#undoGlobals()


"function! vimregex#gotoWin(which) "{{{1
function! vimregex#gotoWin(which)
  execute bufwinnr(a:which).'wincmd w'
endfunction
"function! vimregex#browser(which) "{{{1
function! vimregex#browser(which)
  if has("gui_running") && has("browse")
    let fullname=browse(0,'Read File Into '.a:which,g:VimrexBrowseDir,'')
  else
    let fname=input("File name: ")
    let fullname=glob(fname)
    if fullname == ''
      let fullname=g:VimrexBrowseDir.'/'.fname
      if glob(fullname) == ''
        echohl Errormsg
        echomsg "Cannot find ".fname
        edhohl None
      endif
    endif
  endif
  if fullname == ''
    return
  endif
  call vimregex#saveCurrent()
  execute bufwinnr(a:which).'wincmd w'
  let lnr=line('.')
  if lnr == 1
    let ans=input("This is the buffer's first line, insert Above or Below? : ","A")
    if tolower(ans[0]) == 'a'
      let lnr=0
    endif
  endif
  execute ':'.lnr.'r '.fullname
  set nomodified
  call vimregex#restoreCurrent()
endfunction

"function! vimregex#generate(which,type) "{{{1
function! vimregex#generate(which,type)
  if a:which == 'ALLBUTUSAGE'
    call vimregex#saveCurrent()
    call vimregex#generate(g:VimrexFile,a:type)
    call vimregex#generate(g:VimrexRsltFile,a:type)
    call vimregex#generate(g:VimrexSrcFile,a:type)
    let tmpFile=fnamemodify(expand(g:VimrexFileDir.'/.Vim Regular Expression All'),":p")
    new
    if a:type == 'HTML'
      execute 'silent! edit! '.g:VimrexFile.'.html'
      execute line('$').'r '.g:VimrexRsltFile.'.html'
      execute line('$').'r '.g:VimrexSrcFile.'.html'
      execute 'silent! :w! '.tmpFile.'.html'
    else
      execute 'silent! edit! '.g:VimrexFile.'.txt'
      execute line('$').'r '.g:VimrexRsltFile.'.txt'
      call append(line('$'),' ')
      execute line('$').'r '.g:VimrexSrcFile.'.txt'
      execute 'silent! :w! '.tmpFile.'.txt'
    endif
    bd
    call vimregex#restoreCurrent()
    return
  endif
  let whichBufNr=bufwinnr(a:which)
  if whichBufNr == -1
    echohl Errormsg
    echomsg "No open window for ".a:which
    echohl None
    return
  endif
  call vimregex#saveCurrent()
  execute whichBufNr.'wincmd w'
  if a:type == 'HTML'
    runtime syntax/2html.vim
    silent! :w!
    bd
  else
    silent! :w! %.txt
  endif
  call vimregex#restoreCurrent()
endfunction

"function! vimregex#adjustWin(which,how) "{{{1
function! vimregex#adjustWin(which,how)
  let whichBufNr=bufwinnr(a:which)
  if whichBufNr == -1
    return
  endif
  if a:how == 'p'
    execute whichBufNr.'wincmd w'
    execute 'resize '.&lines
    return
  endif
  let usageBuf=bufwinnr(g:VimrexUsageFile)
  let tot=&lines-&ch
  let winNr=1
  execute 'let winexists=winwidth('.winNr.')'
  while winexists != -1
    let winNr=winNr+1
    execute 'let winexists=winwidth('.winNr.')'
  endwhile
  let winNr=winNr-1
  let tot=tot-winNr
  if usageBuf != -1
    let tot=tot-2
    let fullWins=winNr-2
    let thisWin=2
  else
    let tot=tot-1
    let fullWins=winNr-1
    let thisWin=1
  endif
  let size=tot/fullWins
  wincmd =
  if usageBuf != -1
    1wincmd w
    resize 1
  endif
  while thisWin < winNr
    execute thisWin.'wincmd w'
    execute 'resize '.size
    let thisWin=thisWin+1
  endwhile
  execute winNr.'wincmd w'
  resize 1
endfunction

"function! vimregex#closeUsage() "{{{1
function! vimregex#closeUsage()
  let usageBuf=bufwinnr(g:VimrexUsageFile)
  if usageBuf != -1
    execute usageBuf."wincmd w"
    close
  endif
endfunction

"function! vimregex#legend() "{{{1
function! vimregex#legend()
  if s:inlegend
    return
  else
    let s:inlegend=1
  endif
  call vimregex#saveCurrent()
  let legendWinNr=bufwinnr('Legend')
  if legendWinNr == -1
    new
    edit Legend
    set noreadonly modifiable
    call append(0,"plain search  capture  non-capture  choice  expansion  lookaround  non-current")
    syntax match VimrexSearchCgp "capture"
    syntax match VimrexSearchGrp "non-capture"
    syntax match VimrexSearchChc "choice"
    syntax match VimrexSearchExp "expansion"
    syntax match VimrexSearchAnchor "lookaround"
    syntax match VimrexSearchToken "plain search"
    syntax match VimrexSearchPattern "non-current"
    normal dd
  endif
  let winNr=1
  execute 'let winExists=winheight('.winNr.') != -1'
  while winExists
    let winNr=winNr+1
    execute 'let winExists=winheight('.winNr.') != -1'
  endwhile
  let winNr=winNr-1
  if winNr == legendWinNr && winheight(legendWinNr) == 1
    let s:inlegend=0
    return
  endif
  execute legendWinNr.'wincmd w'
  wincmd J
  call vimregex#adjustWin('Legend','c')
  set nomodified noswapfile nonumber readonly modifiable
  call vimregex#restoreCurrent()
  let s:inlegend=0
endfunction

"function! vimregex#doGvimMenu() "{{{1
function! vimregex#doGvimMenu()
  execute 'amenu <silent> &Vimrex.&Execute\ Regular\ Expression<TAB>'.g:VimrexExec.' :call vimregex#execRegex()<CR>'
  execute 'amenu <silent> &Vimrex.&Analyze\ Regular\ Expression<TAB>'.g:VimrexAnlz.' :call vimregex#translate()<CR>'
  execute 'amenu <silent> &Vimrex.&Window.Goto.(&Top)\ Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexTop.' :call vimregex#gotoWin(g:VimrexFile)<CR>'
  execute 'amenu <silent> &Vimrex.&Window.Goto.(&Bottom)\ Regular\ Expression\ Search\ Source\ Window<TAB>'.g:VimrexBtm.' :call vimregex#gotoWin(g:VimrexSrcFile)<CR>'
  execute 'amenu <silent> &Vimrex.&Window.Goto.(&Center)\ Regular\ Expression\ Result\ Window<TAB>'.g:VimrexCtr.' :call vimregex#gotoWin(g:VimrexRsltFile)<CR>'
  execute 'amenu <silent> &Vimrex.&Window.&Clear.\.&Vim\ Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexCLS.' :call vimregex#cls(g:VimrexFile)<CR>'
  execute 'amenu <silent> &Vimrex.&Window.&Clear.\.Vim\ Regular\ Expression\ &Result\ Window<TAB>'.g:VimrexDRslt.' :call vimregex#cls(g:VimrexRsltFile)<CR>'
  execute 'amenu <silent> &Vimrex.&Window.&Clear.\.Vim\ Regular\ Expression\ Search\ &Source\ Window<TAB>'.g:VimrexDSrc.' :call vimregex#cls(g:VimrexSrcFile)<CR>'
  if has("browse")
    execute 'amenu <silent> &Vimrex.&Window.&Read\ File\ Into.\.Vim\ Regular\ Expression\ Search\ &Source\ Window<TAB>'.g:VimrexRdSrc.' :call vimregex#browser(g:VimrexSrcFile)<CR>'
    execute 'amenu <silent> &Vimrex.&Window.&Read\ File\ Into.\.Vim\ &Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexRdRex.' :call vimregex#browser(g:VimrexFile)<CR>'
  endif
  execute 'amenu <silent> &Vimrex.&Usage.&Open<TAB>'.g:VimrexQQ.' :call vimregex#usage()<CR>'
  execute 'amenu <silent> &Vimrex.&Usage.C&lose<TAB>'.g:VimrexQL.' :call vimregex#closeUsage()<CR>'
  execute 'amenu <silent> &Vimrex.&Usage.&Collapse<TAB>'.g:VimrexQC.' :call vimregex#adjustWin(g:VimrexUsageFile,"c")<CR>'
  execute 'amenu <silent> &Vimrex.&Usage.Ex&pand<TAB>'.g:VimrexQP.' :call vimregex#adjustWin(g:VimrexUsageFile,"p")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Regular\ Expressions<TAB>'.g:VimrexZHV.' :call vimregex#generate(g:VimrexFile,"HTML")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Search\ Source<TAB>'.g:VimrexZHS.' :call vimregex#generate(g:VimrexSrcFile,"HTML")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Usage<TAB>'.g:VimrexZHU.' :call vimregex#generate(g:VimrexUsageFile,"HTML")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Results<TAB>'.g:VimrexZHR.' :call vimregex#generate(g:VimrexRsltFile,"HTML")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&All\ But\ Usage<TAB>'.g:VimrexZHA.' :call vimregex#generate("ALLBUTUSAGE","HTML")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Regular\ Expressions<TAB>'.g:VimrexZTV.' :call vimregex#generate(g:VimrexFile,"TEXT")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Search\ Source<TAB>'.g:VimrexZTS.' :call vimregex#generate(g:VimrexSrcFile,"TEXT")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Usage<TAB>'.g:VimrexZTU.' :call vimregex#generate(g:VimrexUsageFile,"TEXT")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Results<TAB>'.g:VimrexZTR.' :call vimregex#generate(g:VimrexRsltFile,"TEXT")<CR>'
  execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&All\ But\ Usage<TAB>'.g:VimrexZTA.' :call vimregex#generate("ALLBUTUSAGE","TEXT")<CR>'
  execute 'amenu <silent> &Vimrex.E&xit<TAB>'.g:VimrexExit.' :call vimregex#isVimrexRunning(g:VimRexUserCalled)<CR>'
endfunction

"function! vimregex#doMap(name,val) "{{{1
function! vimregex#doMap(name,val)
  let sname='s:prev'.a:name
  let siname='s:iprev'.a:name
  let gname='g:Vimrex'.a:name
  let {sname}=maparg({gname})
  let {siname}=maparg({gname},'i')
  execute 'map <silent> '.{gname}.' '.a:val.'<CR>'
  execute 'imap <silent> '.{gname}.' <Esc>'.a:val.'<CR>'
endfunction

"function! vimregex#doUnMap(name) "{{{1
function! vimregex#doUnMap(name)
  let sname='s:prev'.a:name
  let siname='s:iprev'.a:name
  let gname='g:Vimrex'.a:name
  execute 'unmap '.{gname}
  execute 'iunmap '.{gname}
  if {sname} != ''
    let {sname}=substitute({sname},'|','|','g')
    execute 'map '.{gname}.' '.{sname}
  endif
  if {siname} != ''
    let {siname}=substitute({siname},'|','|','g')
    execute 'imap '.{gname}.' '.{siname}
  endif
endfunction

"function! vimregex#isVimrexRunning(file) "{{{1
function! vimregex#isVimrexRunning(file)
  if !exists("g:VimrexRunning")
    return
  endif
  if a:file != g:VimrexFile && a:file != g:VimrexRsltFile && a:file != g:VimrexSrcFile && a:file != g:VimRexUserCalled
    return
  endif
  unlet g:VimrexRunning g:VimRexUserCalled
augroup Vimrex
  autocmd!
augroup END
  if has("gui_running")
    aunmenu &Vimrex
  endif
  let winNr=bufwinnr(g:VimrexFile)
  execute winNr.'wincmd w'
  silent! :w
  execute 'bwipeout '.bufnr(g:VimrexFile)
  let winNr=bufwinnr(g:VimrexRsltFile)
  execute winNr.'wincmd w'
  set nomodified
  execute 'bwipeout '.bufnr(g:VimrexRsltFile)
  call vimregex#delFile(g:VimrexRsltFile)
  let winNr=bufwinnr(g:VimrexSrcFile)
  execute winNr.'wincmd w'
  silent! :w
  execute 'bwipeout '.bufnr(g:VimrexSrcFile)
  let winNr=bufwinnr(g:VimrexUsageFile)
  if winNr != -1
    execute winNr.'wincmd w'
    set nomodified
    execute 'bwipeout '.bufnr(g:VimrexUsageFile)
    call vimregex#delFile(g:VimrexUsageFile)
  endif
  let winNr=bufwinnr('Legend')
  execute winNr.'wincmd w'
  set nomodified
  execute 'bwipeout '.bufnr('Legend')
  let @/=s:pattern
  let &hlsearch=s:saveHLS
  let &ch=s:saveCH
  let &syntax=s:saveSyn
  let &cpoptions=s:saveCPO
  call vimregex#doUnMap('DRslt')
  call vimregex#doUnMap('DSrc')
  call vimregex#doUnMap('CLS')
  call vimregex#doUnMap('QQ')
  call vimregex#doUnMap('QC')
  call vimregex#doUnMap('QP')
  call vimregex#doUnMap('QL')
  call vimregex#doUnMap('ZHV')
  call vimregex#doUnMap('ZHS')
  call vimregex#doUnMap('ZHU')
  call vimregex#doUnMap('ZHR')
  call vimregex#doUnMap('ZHA')
  call vimregex#doUnMap('ZTV')
  call vimregex#doUnMap('ZTS')
  call vimregex#doUnMap('ZTU')
  call vimregex#doUnMap('ZTR')
  call vimregex#doUnMap('ZTA')
  call vimregex#doUnMap('Exec')
  call vimregex#doUnMap('Anlz')
  call vimregex#doUnMap('Top')
  call vimregex#doUnMap('Btm')
  call vimregex#doUnMap('Ctr')
  call vimregex#doUnMap('RdSrc')
  call vimregex#doUnMap('RdRex')
  call vimregex#doUnMap('Exit')
  highlight clear VimrexSearchAnchor
  highlight clear VimrexSearchPattern
  highlight clear VimrexSearchToken
  highlight clear VimrexFilePattern
  syntax clear VimrexSearchAnchor
  syntax clear VimrexSearchPattern
  syntax clear VimrexSearchToken
  if exists("g:VimRegEx")
    call vimregex#undoGlobals()
    :qa!
  endif
  call vimregex#undoGlobals()
endfunction

"vimregex#Vimrex() initialization function {{{1
function! vimregex#Vimrex()
  call vimregex#doGlobals()
augroup Vimrex
  autocmd!
  autocmd VimLeavePre,VimLeave,BufDelete * call vimregex#isVimrexRunning(expand("<afile>"))
  autocmd WinLeave,WinEnter,BufDelete,BufWinEnter,BufWinLeave * call vimregex#legend()
augroup END
  let s:saveSyn=&syntax
  let s:pattern=@/
  let s:saveHLS=&hlsearch
  let s:saveCH=&ch
  let s:saveCPO=&cpoptions
  let s:AanchorPat=''
  let s:BanchorPat=''
  set cpoptions-=C
  set ch=3
  set nohlsearch
  let @/=''
  let g:VimrexRunning=1
  let g:VimRexUserCalled=nr2char(21).nr2char(19).nr2char(5).nr2char(18).nr2char(3).nr2char(1).nr2char(12).nr2char(12).nr2char(5).nr2char(4)
  if getline(1) !~ '^\%$'
    new
  endif
  if has("gui_running")
    call vimregex#doGvimMenu()
    if has("gui_win32")
      tearoff &Vimrex
    elseif has("gui_gtk")
      popup &Vimrex
    endif
  endif
  execute 'edit! '.escape(g:VimrexSrcFile,' ')
  if getline(1) =~ '^\%$'
    call vimregex#doSampleSrc()
  endif
  setlocal nomodified noswapfile nobackup nowritebackup nonumber syntax= filetype=
  call vimregex#delFile(g:VimrexRsltFile)
  execute 'split '.escape(g:VimrexRsltFile,' ')
  setlocal noswapfile nobackup nowritebackup nonumber syntax= filetype=
  execute 'split! '.escape(g:VimrexFile,' ')
  if getline(1) =~ '^\%$'
    call vimregex#doSampleRegex()
  endif
  setlocal nomodified noswapfile nobackup nowritebackup nonumber syntax=vim filetype=vim
  if exists("g:VimrexSrchPatLnk")
    execute 'highlight link VimrexSearchPattern '.g:VimrexSrchPatLnk
  else
    execute 'highlight VimrexSearchPattern ctermfg='.g:VimrexSrchPatCFG.' ctermbg='.g:VimrexSrchPatCBG.' guifg='.g:VimrexSrchPatGFG.' guibg='.g:VimrexSrchPatGBG
  endif
  if exists("g:VimrexSrchAncLnk")
    execute 'highlight link VimrexSearchAnchor '.g:VimrexSrchAncLnk
  else
    execute 'highlight VimrexSearchAnchor ctermfg='.g:VimrexSrchAncCFG.' ctermbg='.g:VimrexSrchAncCBG.' guifg='.g:VimrexSrchAncGFG.' guibg='.g:VimrexSrchAncGBG
  endif
  if exists("g:VimrexSrchTokLnk")
    execute 'highlight link VimrexSearchToken '.g:VimrexSrchTokLnk
  else
    execute 'highlight VimrexSearchToken ctermfg='.g:VimrexSrchTokCFG.' ctermbg='.g:VimrexSrchTokCBG.' guifg='.g:VimrexSrchTokGFG.' guibg='.g:VimrexSrchTokGBG
  endif
  if exists("g:VimrexSrchCgpLnk")
    execute 'highlight link VimrexSearchCgp '.g:VimrexSrchCgpLnk
  else
    execute 'highlight VimrexSearchCgp ctermfg='.g:VimrexSrchCgpCFG.' ctermbg='.g:VimrexSrchCgpCBG.' guifg='.g:VimrexSrchCgpGFG.' guibg='.g:VimrexSrchCgpGBG
  endif
  if exists("g:VimrexSrchGrpLnk")
    execute 'highlight link VimrexSearchGrp '.g:VimrexSrchGrpLnk
  else
    execute 'highlight VimrexSearchGrp ctermfg='.g:VimrexSrchGrpCFG.' ctermbg='.g:VimrexSrchGrpCBG.' guifg='.g:VimrexSrchGrpGFG.' guibg='.g:VimrexSrchGrpGBG
  endif
  if exists("g:VimrexSrchChcLnk")
    execute 'highlight link VimrexSearchChc '.g:VimrexSrchChcLnk
  else
    execute 'highlight VimrexSearchChc ctermfg='.g:VimrexSrchChcCFG.' ctermbg='.g:VimrexSrchChcCBG.' guifg='.g:VimrexSrchChcGFG.' guibg='.g:VimrexSrchChcGBG
  endif
  if exists("g:VimrexSrchExpLnk")
    execute 'highlight link VimrexSearchExp '.g:VimrexSrchExpLnk
  else
    execute 'highlight VimrexSearchExp ctermfg='.g:VimrexSrchExpCFG.' ctermbg='.g:VimrexSrchExpCBG.' guifg='.g:VimrexSrchExpGFG.' guibg='.g:VimrexSrchExpGBG
  endif
  if exists("g:VimrexFilePatLnk")
    execute 'highlight link VimrexFilePattern '.g:VimrexFilePatLnk
  else
    execute 'highlight VimrexFilePattern ctermfg='.g:VimrexFilePatCFG.' ctermbg='.g:VimrexFilePatCBG.' guifg='.g:VimrexFilePatGFG.' guibg='.g:VimrexFilePatGBG
  endif
  call vimregex#doMap('Exec',':call vimregex#execRegex()')
  call vimregex#doMap('Anlz',':call vimregex#translate()')
  call vimregex#doMap('Top',':call vimregex#gotoWin(g:VimrexFile)')
  call vimregex#doMap('Btm',':call vimregex#gotoWin(g:VimrexSrcFile)')
  call vimregex#doMap('Ctr',':call vimregex#gotoWin(g:VimrexRsltFile)')
  call vimregex#doMap('CLS',':call vimregex#cls(g:VimrexFile)')
  call vimregex#doMap('DSrc',':call vimregex#cls(g:VimrexSrcFile)')
  call vimregex#doMap('DRslt',':call vimregex#cls(g:VimrexRsltFile)')
  call vimregex#doMap('RdSrc',':call vimregex#browser(g:VimrexSrcFile)')
  call vimregex#doMap('RdRex',':call vimregex#browser(g:VimrexFile)')
  call vimregex#doMap('QQ',':call vimregex#usage()')
  call vimregex#doMap('QC',':call vimregex#adjustWin(g:VimrexUsageFile,"c")')
  call vimregex#doMap('QP',':call vimregex#adjustWin(g:VimrexUsageFile,"p")')
  call vimregex#doMap('QL',':call vimregex#closeUsage()')
  call vimregex#doMap('ZHV',':call vimregex#generate(g:VimrexFile,"HTML")')
  call vimregex#doMap('ZHS',':call vimregex#generate(g:VimrexSrcFile,"HTML")')
  call vimregex#doMap('ZHU',':call vimregex#generate(g:VimrexUsageFile,"HTML")')
  call vimregex#doMap('ZHR',':call vimregex#generate(g:VimrexUsageFile,"HTML")')
  call vimregex#doMap('ZHA',':call vimregex#generate("ALLBUTUSAGE","HTML")')
  call vimregex#doMap('ZTV',':call vimregex#generate(g:VimrexFile,"TEXT")')
  call vimregex#doMap('ZTS',':call vimregex#generate(g:VimrexSrcFile,"TEXT")')
  call vimregex#doMap('ZTU',':call vimregex#generate(g:VimrexUsageFile,"TEXT")')
  call vimregex#doMap('ZTR',':call vimregex#generate(g:VimrexUsageFile,"TEXT")')
  call vimregex#doMap('ZTA',':call vimregex#generate("ALLBUTUSAGE","TEXT")')
  call vimregex#doMap('Exit',':call vimregex#isVimrexRunning(g:VimRexUserCalled)')
endfunction

"function! vimregex#doSampleRegex() "{{{1
function! vimregex#doSampleRegex()
  call append(0,s:sampleRegex1)
  let nr=2
  normal G
  normal dd
  while nr < 29
    call append('$',s:sampleRegex{nr})
    let nr=nr+1
  endwhile
endfunction

"function! vimregex#doSampleSrc() "{{{1
function! vimregex#doSampleSrc()
  call append(0,s:sampleSrc1)
  let nr=2
  normal G
  normal dd
  while nr < 18
    call append('$',s:sampleSrc{nr})
    let nr=nr+1
  endwhile
endfunction

"function! vimregex#patHilite(pat,grp,...) "{{{1
function! vimregex#patHilite(pat,grp,...)
  let thePat=''
  if a:0
    let thePat='\%'.a:1.'l'
    if a:0 > 1
      let thePat=thePat.'\&\%'.a:2.'c'
    endif
  endif
  let thePat=thePat.'\%('.escape(a:pat[0],'\[^*$~"').'\)'
  let idx=1
  let lidx=strlen(a:pat)
  while idx < lidx
    let theGrp='\%('.escape(a:pat[idx],'\[^*$~"').'\)'
    let thePat=thePat.theGrp.'\@='.theGrp
    let idx=idx+1
  endwhile
  execute 'syntax match '.a:grp.' "'.thePat.'"'
  syntax sync fromstart
endfunction

"function! vimregex#getAnchors(pat) "{{{1
function! vimregex#getAnchors(pat)
  let pat=a:pat
  let s:BanchorPat=''
  let s:AanchorPat=''
  let matchPos=match(pat,'\\@\%[<][=!]')
  let anchorStr=matchstr(pat,'\\@\%[<][=!]')
  while matchPos != -1
    let idx=matchPos-1
    let found=0
    while idx >= 0 && !found
      if pat[idx] == '\*' && pat[idx-1] != '\'
        let idx=idx-1
        continue
      endif
      if pat[idx] == '}' && pat[idx-1] != '\'
        let idx=idx-1
        let tmpPat=strpart(pat,idx)
        while match(tmpPat,'\{') != 0
          let idx=idx-1
          let tmpPat=strpart(pat,idx)
        endwhile
        if match(tmpPat,'\{') == 0
          let idx=idx-1
          continue
        endif
      endif
      if pat[idx] =~ ')' && pat[idx-1] == '\'
        let idx=idx-2
        while pat[idx] != '('
          let idx=idx-1
        endwhile
        if pat[idx] =~ '(' && pat[idx-1] == '\' && pat[idx-2] != '\'
          let idx=idx-1
          let found=1
        endif
        if pat[idx] == '(' && pat[idx-1] == '%' && pat[idx-2] == '\' && pat[idx-3] != '\'
          let idx=idx-2
          let found=1
        endif
      endif
      let found=1
    endwhile
    if match(anchorStr,'<') != -1
      if s:BanchorPat == ''
        let s:BanchorPat=strpart(pat,idx,matchPos-idx)
      else
        let s:BanchorPat=s:BanchorPat."\<NL>".strpart(pat,idx,matchPos-idx)
      endif
    else
      if s:AanchorPat == ''
        let s:AanchorPat=strpart(pat,idx,matchPos-idx)
      else
        let s:AanchorPat=s:AanchorPat."\<NL>".strpart(pat,idx,matchPos-idx)
      endif
    endif
    let pat=strpart(pat,matchPos+2)
    let matchPos=match(pat,'\\@')
    let anchorStr=matchstr(pat,'\\@\%[<][=!]')
  endwhile
endfunction

"function! vimregex#parsePat(pat) "{{{1
function! vimregex#parsePat(pat)
  let s:grp=''
  let s:capgrp=''
  let s:choice=''
  let s:expansion=''
  let idx=0
  let lidx=strlen(a:pat)
  while idx < lidx
    let restPat=strpart(a:pat,idx)
    let firstPat=strpart(a:pat,0,idx)
    let atomIdx=0
    if match(restPat,s:grpOpen) == 0
      let opengrp=matchstr(restPat,s:grpOpen)
      let atomIdx=strlen(matchstr(restPat,s:grpOpen))
      let ingroup=1
      while ingroup && restPat[atomIdx] != ''
        let tmpPat=strpart(restPat,atomIdx)
        if match(tmpPat,s:grpOpen) == 0 && restPat[atomIdx-1] != '\'
          let atomIdx=strlen(matchstr(tmpPat,s:grpOpen))+atomIdx
          let ingroup=ingroup+1
        elseif match(tmpPat,s:grpClose) == 0 && restPat[atomIdx-1] != '\'
          if tmpPat[0] == ']'
            if restPat[atomIdx-1] == ':' && restPat[atomIdx-2] != '\'
              let atomIdx=atomIdx+1
              continue
            endif
          endif
          let closegrp=matchstr(tmpPat,s:grpClose)
          let closepos=atomIdx
          let atomIdx=strlen(matchstr(tmpPat,s:grpClose))+atomIdx
          let afterpos=atomIdx
          let ingroup=ingroup-1
        else
          let atomIdx=atomIdx+1
        endif
      endwhile
      if !ingroup
        let tmpPat=strpart(restPat,atomIdx)
        let modMatch=match(tmpPat,'\*\|\\[+?=]\|\\@\%[<][!=]\|\\{\%[-]\%[+]\d*\%[,]\d*}')
        if modMatch == 0
          let modStr=matchstr(tmpPat,'\*\|\\[+?=]\|\\@\%[<][!=]\|\\{\%[-]\%[+]\d*\%[,]\d*}')
          let atomIdx=atomIdx+strlen(modStr)
        endif
      endif
      let theGrp=strpart(restPat,0,atomIdx)
      let restPat=strpart(restPat,atomIdx)
      if firstPat != ''
        let theGrp='\%('.firstPat.'\)\@<=\%('.theGrp.'\)'
      else
        let theGrp='\%('.theGrp.'\)'
      endif
      if restPat != ''
        let theGrp=theGrp.'\%('.restPat.'\)\@='
      endif
      if opengrp == '\('
        let targetGrp='s:capgrp'
      elseif opengrp == '\%('
        let targetGrp='s:grp'
      elseif opengrp == '\%['
        let targetGrp='s:expansion'
      else
        let targetGrp='s:choice'
      endif
      let found = 0
      for thisGrp in split({targetGrp}, "\<NL>")
        if thisGrp ==# theGrp
          let found = 1
          break
        endif
      endfor
      if !found
        let {targetGrp}={targetGrp}.theGrp."\<NL>"
      endif
    endif
    if atomIdx
      let idx=idx+atomIdx-1
    else
      let idx=idx+1
    endif
  endwhile
endfunction

"function! vimregex#execRegex() "{{{1
function! vimregex#execRegex()
  " Where are we now?
  let caller=winnr()
  " Switch to regex window.
  execute bufwinnr(g:VimrexFile).'wincmd w'
  let pattern=getline('.')
  if pattern == ''
    echohl Errormsg
    echomsg "No search pattern specified"
    echohl None
    execute caller.'wincmd w'
    return
  endif
  let sameregex=(s:rline == line('.') && s:lpat ==# pattern)
  if !sameregex
    if match(pattern,'\s*"') == 0
      echohl Warningmsg
      let ans=input("This could be a comment line, execute? ","n")
      echohl None
      if tolower(ans[0]) == 'n'
        " Go back to initial window and abort.
        execute caller.'wincmd w'
        return
      endif
    endif
    syntax clear VimrexFilePattern
    let s:rline=line('.')
    let s:lpat=pattern
    call vimregex#patHilite(pattern,'VimrexFilePattern',s:rline)
    let @/=pattern
    call vimregex#parsePat(pattern)
    if match(pattern,'\\@') != -1
      call vimregex#getAnchors(pattern)
    else
      let s:BanchorPat=''
      let s:AanchorPat=''
    endif
  endif
  execute bufwinnr(g:VimrexSrcFile).'wincmd w'
  let v:errmsg=''
  silent! normal n
  if v:errmsg != ''
    execute bufwinnr(g:VimrexRsltFile).'wincmd w'
    normal gg
    call append(line('.'),">>".pattern."<< search error: ".v:errmsg)
    setlocal nomodified
    echohl Errormsg
    echomsg ">>".pattern."<< search error: ".v:errmsg
    echohl None
    execute bufwinnr(g:VimrexSrcFile).'wincmd w'
    execute caller.'wincmd w'
    return
  endif
  syntax clear VimrexSearchAnchor
  syntax clear VimrexSearchPattern
  syntax clear VimrexSearchToken
  syntax clear VimrexSearchCgp
  syntax clear VimrexSearchGrp
  syntax clear VimrexSearchChc
  syntax clear VimrexSearchExp
  let lnum=line('.')
  let cnum=col('.')
  let sline=getline('.')
  let matchPos=cnum-1
  if cnum == 1
    if lnum == 1
      call cursor(line('$'),col('$'))
      call cursor(line('$'),col('$'))
    else
      call cursor(lnum-1,col('$'))
      call cursor(lnum-1,col('$'))
    endif
  else
    call cursor(lnum,cnum-1)
  endif
  execute "silent! normal //e\<CR>"
  let matchEnd=col('.')
  let s:hit=s:hit+1
  if lnum < s:lline
    let s:hit=1
  endif
  let s:lline=lnum
  let token=strpart(sline,matchPos,matchEnd-matchPos)
  if s:BanchorPat != ''
    for thisAnchor in split(s:BanchorPat, "\<NL>")
      let matchAnchor = match(sline, thisAnchor)
      while matchAnchor != -1
        let matchAnchorEnd = matchend(sline, thisAnchor, matchAnchor)
        if matchAnchorEnd == matchPos
          let cnum = matchAnchor + 1
          execute 'syntax match VimrexSearchAnchor  "\%'.lnum.'l\&\%'.cnum.'c'.escape(thisAnchor,'"').'"'
          break
        endif
        let matchAnchor = match(sline, thisAnchor, matchAnchor)
      endwhile
    endfor
  endif
  if s:AanchorPat != ''
    for thisAnchor in split(s:AanchorPat, "\<NL>")
      let tokenLen = strlen(token)
      let matchAnchor = match(strpart(sline, (matchPos + tokenLen)), thisAnchor)
      if matchAnchor != -1
        let cnum = matchAnchor + matchPos + tokenLen + 1
        if cnum == (matchEnd + 1)
          execute 'syntax match VimrexSearchAnchor  "\%'.lnum.'l\&\%'.cnum.'c'.escape(thisAnchor,'"').'"'
        endif
      endif
    endfor
  endif
  execute 'syntax match VimrexSearchPattern "'.escape(pattern,'"').'" contains=VimrexSearchToken'
  let cnum=matchPos+1
  execute 'syntax match VimrexSearchToken "\%'.lnum.'l\&\%'.cnum.'c'.escape(token,'~"\[]*').'" contained contains=VimrexSearchCgp,VimrexSearchGrp,VimrexSearchChc,VimrexSearchExp'
  call vimregex#hiliteGrp(s:capgrp,'VimrexSearchCgp',lnum,matchPos)
  call vimregex#hiliteGrp(s:grp,'VimrexSearchGrp',lnum,matchPos)
  call vimregex#hiliteGrp(s:choice,'VimrexSearchChc',lnum,matchPos)
  call vimregex#hiliteGrp(s:expansion,'VimrexSearchExp',lnum,matchPos)
  syntax sync fromstart
  execute bufwinnr(g:VimrexRsltFile).'wincmd w'
  normal gg
  call append(line('.'),s:hit.": Length=".strlen(token).", at line #".lnum.", column #".cnum)
  call append(line('.'),s:hit.": Token: >>".token."<<")
  call append(line('.'),s:hit.": Found: >>".pattern."<<")
  setlocal nomodified
  execute bufwinnr(g:VimrexSrcFile).'wincmd w'
  call cursor(lnum,cnum)
  execute caller.'wincmd w'
endfunction

"function! vimregex#hiliteGrp(which,synGrp,lnum,matchPos) "{{{1
function! vimregex#hiliteGrp(which,synGrp,lnum,matchPos)
  let sline=getline(a:lnum)
  for grp in split(a:which, "\<NL>")
    let strt = 0
    let grpTokStrt = match(sline, grp, strt)
    while grpTokStrt != -1
      let grpTok = matchstr(sline, grp, strt)
      if grpTok != ''
        let grpTokEnd = strlen(grpTok) + grpTokStrt
        let grpCnum = 1 + grpTokStrt
        execute 'syntax match '.a:synGrp.'  "\%'.a:lnum.'l\&\%'.grpCnum.'c'.escape(grpTok,'~"\[]*').'" contained'
      else
        let grpTokEnd = grpTokStrt + 1
      endif
      let strt = grpTokEnd
      let grpTokStrt = match(sline, grp, strt)
    endwhile
  endfor
endfunction

"function! vimregex#saveCurrent() "{{{1
function! vimregex#saveCurrent()
  let s:cWin=winnr()
  let s:cBuf=bufnr('')
  let s:clnum=line('.')
  let s:ccnum=col('.')
endfunction

"function! vimregex#restoreCurrent() "{{{1
function! vimregex#restoreCurrent()
  if winnr() != s:cWin
    execute s:cWin.'wincmd w'
  endif
  execute 'b'.s:cBuf
  call cursor(s:clnum,s:ccnum)
endfunction

"function! vimregex#cls(which) "{{{1
function! vimregex#cls(which)
  if a:which == g:VimrexFile || a:which == g:VimrexSrcFile
    let ans=confirm("Clear ".a:which,"&Ok\n&Cancel",1)
    if ans == 0 || ans == 2
      return
    endif
  endif
  call vimregex#saveCurrent()
  execute bufwinnr(a:which).'wincmd w'
  normal gg
  normal ma
  normal G
  silent normal d'a
  set nomodified
  call vimregex#restoreCurrent()
  if a:which == g:VimrexFile
    let @/=''
  endif
endfunction

"function! vimregex#delFile(fname) "{{{1
function! vimregex#delFile(fname)
  let fname=glob(a:fname)
  if fname == ''
    return
  endif
  let failure=delete(fname)
  if !failure
    return
  endif
  echohl Warningmsg
  echomsg expand("<sfile>").": Could not delete <".fname.">"
  echomsg "Reason: ".v:errmsg
  echohl Cursor
  echomsg "        Press a key to continue"
  echohl None
  call getchar()
endfunction

"function! vimregex#translate(...) "{{{1
function! vimregex#translate(...)
  let doLocal=!a:0
  if doLocal
    execute bufwinnr(g:VimrexFile).'wincmd w'
    let s:pat=getline('.')
    if s:pat == ''
      echohl Errormsg
      echomsg "No search pattern specified"
      echohl None
      return
    endif
    let sameregex=(s:rline == line('.') && s:lpat ==# s:pat)
    if !sameregex
      if match(s:pat,'\s*"') == 0
        echohl Warningmsg
        let ans=input("This could be a comment line, execute? ","n")
        echohl None
        if tolower(ans[0]) == 'n'
          return
        endif
      endif
      syntax clear VimrexFilePattern
      let s:rline=line('.')
      let s:lpat=s:pat
      call vimregex#patHilite(s:pat,'VimrexFilePattern',s:rline)
      let @/=s:pat
      call vimregex#parsePat(s:pat)
      if match(s:pat,'\\@') != -1
        call vimregex#getAnchors(s:pat)
      else
        let s:BanchorPat=''
        let s:AanchorPat=''
      endif
      execute bufwinnr(g:VimrexSrcFile).'wincmd w'
      syntax clear VimrexSearchAnchor
      syntax clear VimrexSearchPattern
      syntax clear VimrexSearchToken
      syntax clear VimrexSearchCgp
      syntax clear VimrexSearchGrp
      syntax clear VimrexSearchChc
      syntax clear VimrexSearchExp
    endif
    execute bufwinnr(g:VimrexRsltFile).'wincmd w'
    let b:pat=s:pat
    unlet s:pat
    normal G
    call append(line('$'),'Analyzing pattern: '.b:pat)
    setlocal nomodified
    normal j
    execute "normal z\<CR>"
  else
    let b:pat=a:1
    echomsg 'Analyzing pattern: '.b:pat
  endif
  while b:pat != ''
    let desc=vimregex#getTokDesc(b:pat,'b:foundPat','b:pat')
    let pad=''
    if s:ingroup
      let indents=s:ingroup
      if match(b:foundPat,'^\%(\\(\|\\%(\|[\|\\%[\):\@!') != -1
        let indents=indents-1
      endif
      while indents
        let spaces=&sw
        while spaces
          let pad=pad.' '
          let spaces=spaces-1
        endwhile
        let indents=indents-1
      endwhile
    endif
    if doLocal
      call append(line('$'),pad.b:foundPat.'  >>:'.desc)
      setlocal nomodified
    else
      echomsg pad.b:foundPat.'  >>:'.desc
    endif
  endwhile
  unlet! b:pat b:foundPat
  if doLocal
    execute bufwinnr(g:VimrexFile).'wincmd w'
  endif
endfunction

"function! vimregex#repeatAtomDesc(qualifier) "{{{1
function! vimregex#repeatAtomDesc(qualifier)
  let qualifier=a:qualifier
  if qualifier == '' || match(qualifier,'\d*,\d*') != -1 || match(qualifier,'\%(+\|-\)') != -1
    let qualify=match(qualifier,'-') != -1 ? 'few as possible "lazy"' : 'all possible "greedy"'
    if qualify[0] == 'f'
      let qualifier=strpart(qualifier,1)
    endif
    let theDesc=qualify.' match'
    if qualifier != ''
      let commaPos=match(qualifier,',')
      let low=strpart(qualifier,0,commaPos)
      let high=strpart(qualifier,commaPos+1)
      if low != ''
        let theDesc=theDesc.' from '.low
      else
        let theDesc=theDesc.' from 0'
      endif
      if high != ''
        let theDesc=theDesc.' to '.high.' of previous atom'
      else
        let theDesc=theDesc.' to maximum of previous atom'
      endif
    else
      let theDesc=theDesc.' of 0 or more of previous atom'
    endif
  else
    let theDesc='exactly '.qualifier.' of previous atom'
  endif
  return theDesc
endfunction

"function! vimregex#charClassDesc(class) "{{{1
function! vimregex#charClassDesc(class)
  let classList = split(s:charClass, "\<NL>")
  let i = 1
  let found = 0
  let theClass = classList[0]
  while theClass != '' && !found
    if theClass ==# a:class
      let theDesc = classList[i]
      let found = 1
      break
    endif
    let theClass = classList[i]
    let i += 1
  endwhile
  if !found
    let theDesc='Unknown class'
  endif
  return theDesc
endfunction

"function! vimregex#getTokDesc(pat,thePat,retPat) "{{{1
function! vimregex#getTokDesc(pat,thePat,retPat)
  let idx=0
  let lidx=strlen(a:pat)
  let found=0
  let opener=matchstr(a:pat,'^\%(\\(\|\\%(\|[\|\\%[\):\@!')
  if opener != ''
    let s:ingroup=s:ingroup+1
  endif
  let closer=matchstr(a:pat,'^\%(\\)\|]\):\@!')
  if closer != ''
    let s:ingroup=s:ingroup-1
    if closer == ']'
      if s:inChoice
        let s:inChoice=0
      elseif s:inExpansion
        let s:inExpansion=0
      endif
    endif
  endif
  let matchPos=match(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)')
  if matchPos == 2
    let matchEnd=matchend(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)')
    let qualifier='[:'.matchstr(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)').':]'
    let {a:retPat}=strpart(a:pat,matchEnd+2)
    let {a:thePat}=strpart(a:pat,0,matchEnd+2)
    return vimregex#charClassDesc(qualifier)
  endif
  if s:inExpansion && a:pat[0] != ']' && a:pat[0] != '[' && a:pat[0] != '\'
    let matchPos=match(a:pat,'\%(]\|[\|\\\)')
    if a:pat[matchPos] == ']'
      let s:inExpansion=0
    endif
    let {a:retPat}=strpart(a:pat,matchPos)
    let thePat=strpart(a:pat,0,matchPos)
    let {a:thePat}=thePat
    return 'literal character(s): >>'.substitute(thePat,'\%(\\\)\%(\\\|-\)\@=','','g').'<<'
  endif
  if s:inChoice && a:pat[0] != ']'
    let matchPos=match(a:pat,'\%(]\|\[:\)')
    if a:pat[matchPos] == ']'
      let s:inChoice=0
    endif
    let {a:retPat}=strpart(a:pat,matchPos)
    let thePat=strpart(a:pat,0,matchPos)
    let {a:thePat}=thePat
    return 'literal character(s): >>'.substitute(thePat,'\%(\\\)\%(\\\|-\)\@=','','g').'<<'
  endif
  let matchPos=match(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
  if matchPos == 2
    let matchEnd=matchend(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
    let qualifier=matchstr(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
    let {a:retPat}=strpart(a:pat,matchEnd+1)
    let {a:thePat}=strpart(a:pat,0,matchEnd+1)
    return vimregex#repeatAtomDesc(qualifier)
  endif
  if a:pat[0] == '\' && a:pat[1] =~ '\d'
    let matchBeg=match(a:pat,'\d\+',1)
    let matchEnd=matchend(a:pat,'\d\+',1)
    let {a:retPat}=strpart(a:pat,matchEnd)
    let theNum=strpart(a:pat,1,matchEnd)
    let {a:thePat}='\'.theNum
    let theDesc="back reference to capture group ".theNum." in this pattern"
    return theDesc
  endif
  if a:pat[0] == '\'
    if match(s:VimRegExTokBS1stChar,a:pat[1]) == -1 || a:pat[1] == '.'
      let idx=2
      while match(s:VimRegExTokOpen,escape(a:pat[idx],'$~.^')) == -1
        let idx=idx+1
      endwhile
      let {a:retPat}=strpart(a:pat,idx)
      let {a:thePat}=strpart(a:pat,0,idx)
      return 'literal character(s): >>'.strpart(a:pat,1,idx-1).'<<'
    endif
  endif
  if match(s:VimRegExTokOpen,escape(a:pat[0],'$~^*.')) == -1
    let idx=idx+1
    while match(s:VimRegExTokOpen,escape(a:pat[idx],'$~.^')) == -1
      let idx=idx+1
    endwhile
    let {a:retPat}=strpart(a:pat,idx)
    let {a:thePat}=strpart(a:pat,0,idx)
    return 'literal character(s): >>'.strpart(a:pat,0,idx).'<<'
  endif
  if match(a:pat,'^\\%[') != -1
    let s:inExpansion=1
  endif
  if a:pat[0] == '['
    let s:inChoice=1
    if a:pat[1] == '^'
      let {a:retPat}=strpart(a:pat,2)
      let {a:thePat}='[^'
      return 'begin disallowed choice list'
    else
      let {a:retPat}=strpart(a:pat,1)
      let {a:thePat}='['
      return 'begin allowed choice list'
    endif
  endif
  while idx < lidx && !found
    let matchPat = strpart(a:pat, 0, (idx + 1))
    let thesePats = split(s:VimRegExTokDesc, "\<NL>")
    let i = 1
    let thisPat = thesePats[0]
    while i < len(thesePats)
      let theDesc = get(thesePats, i, '')
      let i += 1
      if matchPat ==# '^'
        let thisPat = '^'
        let theDesc = 'begin line'
        let found = 1
        break
      endif
      if matchPat ==# thisPat
        let found = 1
        break
      endif
      let thisPat = get(thesePats, i, '')
      let i += 1
    endwhile
    let idx=idx+1
  endwhile
  if thisPat == ''
    let {a:retPat}=''
    let {a:thePat}=a:pat
    unlet! b:thisTokDescList
    return 'literal character(s): >>'.a:pat.'<<'
  endif
  let {a:retPat}=strpart(a:pat,idx)
  let {a:thePat}=thisPat
  unlet! b:thisTokDescList
  return theDesc
endfunction

"function! vimregex#doUsageSyntax() "{{{1
function! vimregex#doUsageSyntax()
  syntax match VimrexUsageDesc '\p*' contains=VimrexUsageTitle,VimrexUsageSketch,VimrexUsageEmph,VimrexUsageHotkey,VimrexSearchPattern,VimrexFilePattern,VimrexSearchToken,VimrexSearchCgp,VimrexSearchGrp,VimrexSearchChc,VimrexSearchAnchor,VimrexSearchExp
  syntax match VimrexFilePattern "current regex"
  syntax match VimrexSearchToken "plain search"
  syntax match VimrexSearchCgp "capture"
  syntax match VimrexSearchGrp "non-capture"
  syntax match VimrexSearchChc "choice"
  syntax match VimrexSearchExp "expansion"
  syntax match VimrexSearchAnchor "lookaround"
  syntax match VimrexSearchPattern "non-current"
  syntax match VimrexUsageTitle ": Vim Regular Expression Developer Plugin"
  syntax match VimrexUsageTitle ": Synopsis of Use"
  syntax match VimrexUsageTitle ": Command Summary"
  syntax match VimrexUsageTitle ": Global Variables"
  syntax match VimrexUsageTitle ": Pattern and Match Highlighting"
  syntax match VimrexUsageTitle ": Generating Files"
  syntax match VimrexUsageTitle ": Contact Information"
  syntax match VimrexUsageSketch '+\|-\||'
  syntax match VimrexUsageEmph '[Rr]egular [Ee]xpression\%[s]'
  syntax match VimrexUsageEmph '[Ss]earch\%[e[sd]]'
  syntax match VimrexUsageEmph '[Ee]xecut\%(e\%[d]\|ion\|ing\)'
  syntax match VimrexUsageEmph '[Aa]nalys[ei]s'
  syntax match VimrexUsageEmph '[Aa]nalyze\%[[ds]]'
  syntax match VimrexUsageEmph '[Aa]nalyzing'
  syntax match VimrexUsageEmph '[Rr]esult\%[s]'
  syntax match VimrexUsageEmph '[Tt]ext'
  syntax match VimrexUsageEmph '[Mm]atch\%[ing]'
  syntax match VimrexUsageEmph '[Mm]atche[ds]'
  syntax match VimrexUsageEmph '\%[reverse ][Hh]ighlight\%(s\|ed\|ing\)'
  syntax match VimrexUsageEmph '[Tt]oken\%[s]'
  syntax match VimrexUsageEmph 'NOTE:'
  syntax match VimrexUsageEmph 'See:'
  syntax match VimrexUsageHotkey 'g:VimrexExec'
  syntax match VimrexUsageHotkey 'g:VimrexAnlz'
  syntax match VimrexUsageHotkey 'g:VimrexTop'
  syntax match VimrexUsageHotkey 'g:VimrexBtm'
  syntax match VimrexUsageHotkey 'g:VimrexCtr'
  syntax match VimrexUsageHotkey 'g:VimrexCLS'
  syntax match VimrexUsageHotkey 'g:VimrexDRslt'
  syntax match VimrexUsageHotkey 'g:VimrexDSrc'
  syntax match VimrexUsageHotkey 'g:VimrexRdSrc'
  syntax match VimrexUsageHotkey 'g:VimrexRdRex'
  syntax match VimrexUsageHotkey 'g:VimrexQQ'
  syntax match VimrexUsageHotkey 'g:VimrexQC'
  syntax match VimrexUsageHotkey 'g:VimrexQP'
  syntax match VimrexUsageHotkey 'g:VimrexQL'
  syntax match VimrexUsageHotkey 'g:VimrexZHV'
  syntax match VimrexUsageHotkey 'g:VimrexZHS'
  syntax match VimrexUsageHotkey 'g:VimrexZHU'
  syntax match VimrexUsageHotkey 'g:VimrexZHR'
  syntax match VimrexUsageHotkey 'g:VimrexZHA'
  syntax match VimrexUsageHotkey 'g:VimrexZTV'
  syntax match VimrexUsageHotkey 'g:VimrexZTS'
  syntax match VimrexUsageHotkey 'g:VimrexZTU'
  syntax match VimrexUsageHotkey 'g:VimrexZTR'
  syntax match VimrexUsageHotkey 'g:VimrexZTA'
  syntax match VimrexUsageHotkey 'g:VimrexExit'
  syntax match VimrexUsageHotkey 'g:VimrexBrowseDir'
  syntax match VimrexUsageHotkey 'g:VimrexFile\%[Dir]'
  syntax match VimrexUsageHotkey 'g:VimrexRsltFile'
  syntax match VimrexUsageHotkey 'g:VimrexSrcFile'
  syntax match VimrexUsageHotkey 'g:VimrexUsageFile'
  syntax match VimrexUsageHotkey 'g:VimrexSrchPatLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchPatCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchPatCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchPatGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchPatGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchAncLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchAncCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchAncCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchAncGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchAncGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchTokLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchTokCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchTokCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchTokGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchTokGFG'
  syntax match VimrexUsageHotkey 'g:VimrexFilePatLnk'
  syntax match VimrexUsageHotkey 'g:VimrexFilePatCFG'
  syntax match VimrexUsageHotkey 'g:VimrexFilePatCBG'
  syntax match VimrexUsageHotkey 'g:VimrexFilePatGFG'
  syntax match VimrexUsageHotkey 'g:VimrexFilePatGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchCgpLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchCgpCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchCgpCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchCgpGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchCgpGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchGrpLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchGrpCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchGrpCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchGrpGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchGrpGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchChcLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchChcCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchChcCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchChcGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchChcGBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchExpLnk'
  syntax match VimrexUsageHotkey 'g:VimrexSrchExpCFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchExpCBG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchExpGFG'
  syntax match VimrexUsageHotkey 'g:VimrexSrchExpGBG'
  syntax match VimrexUsageHotkey ':h tohtml'
  syntax match VimrexUsageHotkey '/Remarks:'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexExec.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexAnlz.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexTop.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexBtm.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexCtr.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexCLS.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexDRslt.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexDSrc.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexRdSrc.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexRdRex.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexQQ.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexQC.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexQP.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexQL.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHV.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHS.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHU.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHR.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHA.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTV.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTS.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTU.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTR.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTA.'"'
  execute 'syntax match VimrexUsageHotkey "'.g:VimrexExit.'"'
  execute 'syntax match VimrexUsageHotkey "'.s:myName.'"'
  highlight link VimrexUsageTitle Title
  highlight link VimrexUsageDesc Identifier
  highlight link VimrexUsageSketch StatusLine
  highlight link VimrexUsageEmph NonText
  highlight link VimrexUsageHotkey Statement
endfunction

"function! vimregex#usage() "{{{1
function! vimregex#usage()
  if bufwinnr(g:VimrexUsageFile) != -1
    return
  endif
  if !exists('s:thisScriptContent')
    let s:thisScriptContent = readfile(s:thisScript)
  endif
  echohl WarningMsg
  echomsg 'Generating Usage Document...'
  echohl None
  let Exec=vimregex#padField('l','12',g:VimrexExec)
  let Anlz=vimregex#padField('l','12',g:VimrexAnlz)
  let Top=vimregex#padField('l','12',g:VimrexTop)
  let Btm=vimregex#padField('l','12',g:VimrexBtm)
  let Ctr=vimregex#padField('l','12',g:VimrexCtr)
  let CLS=vimregex#padField('l','12',g:VimrexCLS)
  let DRslt=vimregex#padField('l','12',g:VimrexDRslt)
  let DSrc=vimregex#padField('l','12',g:VimrexDSrc)
  let RdSrc=vimregex#padField('l','12',g:VimrexRdSrc)
  let RdRex=vimregex#padField('l','12',g:VimrexRdRex)
  let QQ=vimregex#padField('l','12',g:VimrexQQ)
  let QC=vimregex#padField('l','12',g:VimrexQC)
  let QP=vimregex#padField('l','12',g:VimrexQP)
  let QL=vimregex#padField('l','12',g:VimrexQL)
  let ZHV=vimregex#padField('l','12',g:VimrexZHV)
  let ZHS=vimregex#padField('l','12',g:VimrexZHS)
  let ZHU=vimregex#padField('l','12',g:VimrexZHU)
  let ZHR=vimregex#padField('l','12',g:VimrexZHR)
  let ZHA=vimregex#padField('l','12',g:VimrexZHA)
  let ZTV=vimregex#padField('l','12',g:VimrexZTV)
  let ZTS=vimregex#padField('l','12',g:VimrexZTS)
  let ZTU=vimregex#padField('l','12',g:VimrexZTU)
  let ZTR=vimregex#padField('l','12',g:VimrexZTR)
  let ZTA=vimregex#padField('l','12',g:VimrexZTA)
  let Exit=vimregex#padField('l','12',g:VimrexExit)
  wincmd t
  "call vimregex#delFile(g:VimrexUsageFile)
  new
  execute 'silent edit! '.escape(g:VimrexUsageFile,' ')
  setlocal noreadonly modifiable nonumber noswapfile
  %d _
  execute 'resize '.&lines
  execute 'vertical resize '.&columns
  let lines = []
  call add(lines,vimregex#padField('c',76,s:myName.": Vim Regular Expression Developer Plugin"))
  call add(lines,"")
  let lines = lines + vimregex#doUsageSection('ONE')
  call add(lines,vimregex#padField('c',76,s:myName.": Command Summary"))
  call add(lines,"")
  call add(lines,Exec."Execute Regular Expression")
  call add(lines,Anlz."Analyze Regular Expression")
  call add(lines,Top."Changes to .Vim Regular Expression Specification Window")
  call add(lines,Btm."Changes to .Vim Regular Expression Search Source Window")
  call add(lines,Ctr."Changes to .Vim Regular Expression Result Window")
  call add(lines,CLS."Clear .Vim Regular Expression Specification Window")
  call add(lines,DRslt."Clear .Vim Regular Expression Result Window")
  call add(lines,DSrc."Clear .Vim Regular Expression Search Source Window")
  call add(lines,RdSrc."Read File into .Vim Regular Expression Search Source Window")
  call add(lines,RdRex."Read File into .Vim Regular Expression Specification Window")
  call add(lines,QQ."Open Usage Window (display this file)")
  call add(lines,QL."Close Usage Window")
  call add(lines,QC."Collapse Usage Window")
  call add(lines,QP."Expand Usage Window")
  call add(lines,ZHV."Generate HTML File of Regular Expression Window")
  call add(lines,ZHS."Generate HTML File of Search Source Window")
  call add(lines,ZHU."Generate HTML File of Usage Window")
  call add(lines,ZHR."Generate HTML File of Results Window")
  call add(lines,ZHA."Generate HTML File of All But Usage Window")
  call add(lines,ZTV."Generate TEXT (.txt) File of Regular Expression Window")
  call add(lines,ZTS."Generate TEXT (.txt) File of Search Source Window")
  call add(lines,ZTU."Generate TEXT (.txt) File of Usage Window")
  call add(lines,ZTR."Generate TEXT (.txt) File of Results Window")
  call add(lines,ZTA."Generate TEXT (.txt) File of All But Usage Window")
  call add(lines,Exit."Exit ".s:myName." (close all windows)")
  let lines = lines + vimregex#doUsageSection('TWO')
  call add(lines,vimregex#padField('c',76,s:myName.": Synopsis of Use"))
  let lines = lines + vimregex#doUsageSection('THREE')
  call add(lines,vimregex#padField('c',76,g:VimrexAnlz))
  let lines = lines + vimregex#doUsageSection('FOUR')
  call add(lines,vimregex#padField('c',76,g:VimrexExec))
  let lines= lines+ vimregex#doUsageSection('FIVE')
  call add(lines,vimregex#padField('c',76,s:myName.": Global Variables"))
  call add(lines," ")
  call add(lines,vimregex#padField('l',20,'g:VimrexExec')."mapping sequence for executing regular expression")
  call add(lines,vimregex#padField('l',20,'g:VimrexAnlz')."mapping sequence for analyzing regular expression")
  call add(lines,vimregex#padField('l',20,'g:VimrexTop')."mapping sequence for goto top window")
  call add(lines,vimregex#padField('l',20,'g:VimrexBtm')."mapping sequence for goto bottom window")
  call add(lines,vimregex#padField('l',20,'g:VimrexCtr')."mapping sequence for goto center window")
  call add(lines,vimregex#padField('l',20,'g:VimrexCLS')."mapping sequence for clearing top window")
  call add(lines,vimregex#padField('l',20,'g:VimrexDSrc')."mapping sequence for clearing bottom window")
  call add(lines,vimregex#padField('l',20,'g:VimrexDRslt')."mapping sequence for clearing center window")
  call add(lines,vimregex#padField('l',20,'g:VimrexRdSrc')."mapping sequence to read file into bottom window")
  call add(lines,vimregex#padField('l',20,'g:VimrexRdRex')."mapping sequence to read file into top window")
  call add(lines,vimregex#padField('l',20,'g:VimrexQQ')."mapping sequence to open display of this file")
  call add(lines,vimregex#padField('l',20,'g:VimrexQL')."mapping sequence to close display of this file")
  call add(lines,vimregex#padField('l',20,'g:VimrexQC')."mapping sequence to collapse display of this file")
  call add(lines,vimregex#padField('l',20,'g:VimrexQP')."mapping sequence to expand display of this file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZHV')."mapping sequence to generate Regular Expression HTML file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZHS')."mapping sequence to generate Source Search HTML file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZHU')."mapping sequence to generate Usage HTML file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZHR')."mapping sequence to generate Results HTML file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZHA')."mapping sequence to generate All But Usage HTML file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZTV')."mapping sequence to generate Regular Expression TEXT file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZTS')."mapping sequence to generate Source Search TEXT file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZTU')."mapping sequence to generate Usage TEXT file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZTR')."mapping sequence to generate Results TEXT file")
  call add(lines,vimregex#padField('l',20,'g:VimrexZTA')."mapping sequence to generate All But Usage TEXT file")
  call add(lines,vimregex#padField('l',20,'g:VimrexExit')."mapping sequence to exit ".s:myName)
  call add(lines,vimregex#padField('l',20,"g:VimrexBrowseDir")."directory to browse for read files")
  call add(lines,vimregex#padField('l',20,"g:VimrexFileDir")."directory to create files ('~')")
  call add(lines,vimregex#padField('l',20,"g:VimrexFile")."regular expression file")
  call add(lines,vimregex#padField('l',20,"g:VimrexRsltFile")."result file")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrcFile")."search source file")
  call add(lines,vimregex#padField('l',20,"g:VimrexUsageFile")."usage file")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchPatLnk")."highlight link for non-current highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchPatCFG")."ctermfg= value for non-current highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchPatCBG")."ctermbg= value for non-current highlighting ('DarkMagenta')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchPatGFG")."guifg= value for non-current highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchPatGBG")."guibg= value for non-current highlighting ('DarkMagenta')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchAncLnk")."highlight link for lookaround highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchAncCFG")."ctermfg= value for lookaround highlighting ('DarkRed')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchAncCBG")."ctermbg= value for lookaround highlighting ('gray')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchAncGFG")."guifg= value for lookaround highlighting ('DarkRed')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchAncGBG")."guibg= value for lookaround highlighting ('gray')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchTokLnk")."highlight link for plain search highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchTokCBG")."ctermfg= value for plain search highlighting ('LightCyan')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchTokCFG")."ctermbg= value for plain search highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchTokGBG")."guifg= value for plain search highlighting ('LightCyan')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchTokGFG")."guibg= value for plain search highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexFilePatLnk")."highlight link for current regex highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexFilePatCFG")."ctermfg= value for current regex highlighting ('cyan')")
  call add(lines,vimregex#padField('l',20,"g:VimrexFilePatCBG")."ctermfg= value for current regex highlighting ('brown')")
  call add(lines,vimregex#padField('l',20,"g:VimrexFilePatGFG")."guifg= value for current regex highlighting ('cyan')")
  call add(lines,vimregex#padField('l',20,"g:VimrexFilePatGBG")."guifg= value for current regex highlighting ('brown')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchCgpLnk")."highlight link for capture group highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchCgpCFG")."ctermfg= value for capture group highlighting ('blue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchCgpCBG")."ctermfg= value for capture group highlighting ('red')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchCgpGFG")."guifg= value for capture group highlighting ('blue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchCgpGBG")."guifg= value for capture group highlighting ('red')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchGrpLnk")."highlight link for non-capture group highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchGrpCFG")."ctermfg= value for non-capture group highlighting ('red')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchGrpCBG")."ctermfg= value for non-capture group highlighting ('blue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchGrpGFG")."guifg= value for non-capture group highlighting ('red')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchGrpGBG")."guifg= value for non-capture group highlighting ('blue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchChcLnk")."highlight link for choice list highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchChcCFG")."ctermfg= value for choice list highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchChcCBG")."ctermfg= value for choice list highlighting ('LightBlue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchChcGFG")."guifg= value for choice list highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchChcGBG")."guifg= value for choice list highlighting ('LightBlue')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchExpLnk")."highlight link for expansion seq highlighting")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchExpCFG")."ctermfg= value for expansion seq highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchExpCBG")."ctermfg= value for expansion seq highlighting ('LightGreen')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchExpGFG")."guifg= value for expansion seq highlighting ('black')")
  call add(lines,vimregex#padField('l',20,"g:VimrexSrchExpGBG")."guifg= value for expansion seq highlighting ('LightGreen')")
  call add(lines," ")
  call add(lines," ")
  call add(lines,vimregex#padField('c',76,s:myName.": Pattern and Match Highlighting"))
  let lines = lines + vimregex#doUsageSection('SIX')
  call add(lines,vimregex#padField('c',76,s:myName.": Generating Files"))
  call add(lines," ")
  call add(lines,s:myName." will generate files of the current windows for you to view")
  let lines = lines + vimregex#doUsageSection('SEVEN')
  call add(lines,vimregex#padField('c',76,s:myName.": Contact Information"))
  call add(lines," ")
  call add(lines,"If you find bugs, have suggestions, or just want to chat:")
  call add(lines,"http://www.vim.org/account/profile.php?user_id=5397")
  call add(lines,"You'll find my current email address there.")
  call append(0, lines)
  let g:lines = lines
  $d _
  1
  call vimregex#doUsageSyntax()
  syntax sync fromstart
  setlocal nomodified readonly nomodifiable
  echohl Question
  echon 'Done.'
  echohl None
endfunction

"function! vimregex#doUsageSection(sect) "{{{1
function! vimregex#doUsageSection(sect)
  silent :w
  let strtStr='BEGIN MANUAL SECTION '.a:sect
  let endStr='END MANUAL SECTION '.a:sect
  let lnum=index(s:thisScriptContent,strtStr)+1
  let elnum=index(s:thisScriptContent,endStr)-1
  let usageLines = s:thisScriptContent[lnum : elnum]
  return usageLines
endfunction


function! vimregex#padField( just, size, str, ... ) "{{{
  let pad = a:0 ? a:1 : ' '
  let len = strlen(a:str)
  if len >= a:size
    return ''
  endif
  if a:just ==# 'l'
    return a:str.repeat(pad, (a:size - len))
  elseif a:just ==# 'r'
    return repeat(pad, (a:size - len)).a:str
  else
    let result = repeat(pad, ((a:size - len)/2)).a:str.repeat(pad, (a:size - len)/2)
    return strlen(result) < a:size ? pad.result : result
  endif
endfunction "vimregex#padField }}}
