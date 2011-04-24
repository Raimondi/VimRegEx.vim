"function! vimregex#doGlobals() "{{{1
function! vimregex#doGlobals()
  "if !exists("g:VimrexBrowseDir")
  " let RTdirs=expand(&runtimepath)
  " if !exists("*StrListTok")
  "   runtime plugin/vsutil.vim
  " endif
  " let RTdir=StrListTok(RTdirs,'b:rtdirs')
  " while RTdir != ''
  "   if glob(RTdir) != ''
  "     let g:VimrexBrowseDir=RTdir
  "     break
  "   endif
  "   let RTdir=StrListTok('','b:rtdirs')
  " endwhile
  " while RTdir != ''
  "   let RTdir=StrListTok('','b:rtdirs')
  " endwhile
  " unlet b:rtdirs
  " unlet! RTdir RTdirs
  "endif
  for RTdir in split(expand(&runtimepath), ',')
    if glob(RTdir) != ''
      let g:VimrexBrowseDir=RTdir
    endif
  endfor

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

