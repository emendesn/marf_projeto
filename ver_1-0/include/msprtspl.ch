/*BEGINDOC
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefine um objeto para exibiГЦo de pАginas de relatСrios, com um layout semelhante a uma pАgina realЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ENDDOC*/

#ifndef _MSPRTSPOOL_CH
#define _MSPRTSPOOL_CH

#xcommand @ <nRow>, <nCol> PRINTERSPOOL [ <oPrnSpool> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;     
     [ TEXTPAGE <cTextPage> ] ;
     [ <lPortrait: PORTRAIT> ] ;
     [ PAGESIZE <nWidthPage>, <nHeightPage> ] ;
    => ;
  [ <oPrnSpool> := ] tMSPrinterSpool():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <oWnd>, <cTextPage>, <.lPortrait.>, [ <nHeightPage> ], [ <nWidthPage> ] )
     
#endif