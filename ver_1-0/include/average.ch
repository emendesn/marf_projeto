/*
Programa : AVERAGE.CH
Objetivo : Manter definicoes genericas 
Autor    : Cristiano A. Ferreira
Data/Hora: 12/04/2000
Obs      : 
*/

#ifndef _AVERAGE_H
#define _AVERAGE_H

#ifndef _AVRDM
#include "FiveWin.ch"
#endif
      
// AVSX3
#define AV_TIPO    2
#define AV_TAMANHO 3  //Posicao no AVSX3()[] que retorna tamanho de campo
#define AV_DECIMAL 4
#define AV_TITULO  5
#define AV_PICTURE 6  //PICTURE DO CAMPO
#define AV_TRIGGER 10                       
#define AV_VALID   07

//definicao para browser
#define PESQUISAR    1
#define VISUALIZAR   2
#define INCLUIR      3
#define ALTERAR      4
#define EXCLUIR      5

//definicao para MEMOS
#define INCMEMO   1   //incluir/alterar msmm
#define EXCMEMO   2   //excluir msmm
#define LERMEMO   3   //ler msmm

//Tamanho Padrao das janelas
// Dialog
//#define DLG_CHARPIX_H   15.1
//#define DLG_CHARPIX_W	 7.9

// Tamanho Microsiga
//#define DLG_LIN_INI 135  // Int(9*DLG_CHARPIX_H) 
//#define DLG_COL_INI 0
//#define DLG_LIN_FIM Int(TranslateBottom(.F.,28)*DLG_CHARPIX_H)
//#define DLG_COL_FIM 632  // 80*DLG_CHARPIX_W

// Tela Cheia
#define DLG_LIN_INI (oMainWnd:ReadClientCoords(),oMainWnd:nTop+If(SetMDIChild(),0,100))
#define DLG_COL_INI (oMainWnd:nLeft+5)
#define DLG_LIN_FIM (oMainWnd:nBottom-If(SetMDIChild(),70,60))
#define DLG_COL_FIM (oMainWnd:nRight-10)

// Macros para retornar o array de posicoes para a MsSelect/Enchoice
#xTranslate PosDlg(<oDlg>) => {15,1,(<oDlg>:nClientHeight-6)/2,(<oDlg>:nClientWidth-4)/2}

#xTranslate PosDlgUp(<oDlg>) => {15,1,(<oDlg>:nClientHeight-6)/4-1,(<oDlg>:nClientWidth-4)/2}
#xTranslate PosDlgDown(<oDlg>) => {(<oDlg>:nClientHeight-6)/4+1,1,(<oDlg>:nClientHeight-6)/2,(<oDlg>:nClientWidth-4)/2}

#define SIM "1"
#define NAO "2"

// Rdmake
#Translate User Function <cNome> => Function U_<cNome>

// Funcao AvBar 
#define ENCH_PDR 1 // EnchoiceBar padrao 
#define ENCH_PDI 2 // EnchoiceBar padrao com impressao
#define ENCH_ADD 3 // EnchoiceBar com Manutencao (Inc/Alt/Exc/Vis)
#define ENCH_ADI 4 // EnchoiceBar com Manutencao (Inc/Alt/Exc/Vis) com impressao

// Manutencao com Detalhe
#define VIS_DET 3 // Visulizacao do Detalhe
#define INC_DET 4 // Inclusao do Detalhe
#define ALT_DET 5 // Alteracao do Detalhe
#define EXC_DET 6 // Exclusao do Detalhe

#define ENTER CHR(13)+CHR(10)

//Defines da função E_INIT()
#xTranslate cSim => "1SY"
#xTranslate cNao => "2N"

/*#xTranslate _PictPrUn => ALLTRIM(X3Picture("W3_PRECO"))
#xTranslate _PictPrTot => ALLTRIM(X3Picture("W2_FOB_TOT"))
#xTranslate _PictQtde => ALLTRIM(X3Picture("W3_QTDE"))
#xTranslate _PictPO => ALLTRIM(X3Picture("W2_PO_NUM"))
#xTranslate _PictNBM => E_Tran("YD_TEC",,.T.)

#xTranslate _FirstYear => Right(Padl(Set(_SET_EPOCH),4,"0"),2)*/

#endif

//----------------------------------------------------------------------------\\
// FIM DO ARQUIVO AVERAGE.CH                                                  \\
//----------------------------------------------------------------------------\\
