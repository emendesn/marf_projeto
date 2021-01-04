#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)


/*/{Protheus.doc} MGFFAT75
//TODO Atualiza o SZ5 na exclusão do pedido de venda, documento de saida e documento de entrada no processo de triangulação de remessa de poder de 3º
@author marcelo.moraes
@since 20/04/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFAT75()

local lOK		:= .T.
local aArea		:= getArea()
local aAreaSZ5	:= SZ5->(getArea())
local _cFil     := ""
local _cDoc     := ""
local _cSerie   := ""
local _cForn    := ""
local _loja     := ""
local _Tipo     := ""
local cUpdSZ5   := ""

//Atualiza SZ5 na exclusao pedido de venda - chamado pelo PE M410STTS
If IsInCallStack('A410Deleta')
	
	SZ5->(DbSetOrder(2)) //Z5_FILIAL + Z5_NUMPV
	SZ5->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)) 
	if SZ5->(Found())
		RecLock("SZ5",.F.)
		SZ5->(dbDelete())
		SZ5->(MsUnLock())
	endif
	
endif

//Valida exclusao documento de saida - chamado pelo PE MS520VLD
If IsInCallStack('u_ms520vld')
	
	SZ5->(DbSetOrder(3)) //Z5_FILIAL + Z5_NUMNF onde Z5_NUMNF contem a chave: F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
	SZ5->(DbSeek(SF2->(F2_FILIAL+F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))  
	if SZ5->(Found()) .and. !Empty(SZ5->Z5_NUMNFEN)
		_cFil   := Substr(SZ5->Z5_NUMNFEN,1,6)
		_cDoc   := Substr(SZ5->Z5_NUMNFEN,7,9)
		_cSerie := Substr(SZ5->Z5_NUMNFEN,16,3)
		_cForn  := Substr(SZ5->Z5_NUMNFEN,19,6)
		_loja   := Substr(SZ5->Z5_NUMNFEN,25,2)
		_Tipo   := Substr(SZ5->Z5_NUMNFEN,27,1)
//   		Alert("Para excluir esta NF Remessa é preciso antes excluir a NF Entrada - Filial: "+_cFil+" - "+_cDoc+" - "+_cSerie+" - "+_cForn+" - "+_loja+" - "+_Tipo)
		Help("XXX  ",1,"Para excluir esta NF Saida é preciso antes excluir a NF Entrada - Filial: "+_cFil+" - "+_cDoc+" - "+_cSerie+" - "+_cForn+" - "+_loja+" - "+_Tipo)
		lOK := .F.
	else
		lOK := .T.
	endif
	
	RestArea(aAreaSZ5)
	RestArea(aArea)

	return(lOK)
	
endif

//Atualiza SZ5 na exclusao documento de saida - chamado pelo PE MS520DEL
If IsInCallStack('u_ms520del')

	SZ5->(DbSetOrder(3)) //Z5_FILIAL + Z5_NUMNF onde Z5_NUMNF contem a chave: F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
	SZ5->(DbSeek(SF2->(F2_FILIAL+F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))  
	if SZ5->(Found()) 
		RecLock("SZ5",.F.)
		SZ5->Z5_NUMNF := ""
		SZ5->(MsUnLock())
	endif
	
endif

//Atualiza SZ5 na exclusao documento de entrada (chamado pelo PE SF1100E) 
//Ou pre-nota de entrada (chamado pelo PE SD1140E)
If IsInCallStack('u_SF1100E') .or. IsInCallStack('u_SD1140E')      

	cUpdSZ5 := "UPDATE " + retSQLName("SZ5") + CRLF
	cUpdSZ5 += " SET " + CRLF
	cUpdSZ5 += " Z5_NUMNFEN	= '" + space(TamSX3("Z5_NUMNFEN")[1]) + "'"	+ CRLF
	cUpdSZ5 += " WHERE"	+ CRLF
	cUpdSZ5 += " Z5_NUMNFEN		=	'" + SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO) + "'"	+ CRLF
	cUpdSZ5 += " AND D_E_L_E_T_	<>	'*'" + CRLF

	tcSQLExec(cUpdSZ5)
	
endif

RestArea(aAreaSZ5)
RestArea(aArea)

Return

