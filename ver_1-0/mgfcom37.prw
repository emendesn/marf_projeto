#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

User Function MGFCOM37()
	local cDescSA4		:= ""
	local lRet			:= .T.
	local nPosTransp	:= aScan( aHeader, { | x | allTrim( x[ 2 ] ) == "C8_ZTRANSP" } )
	local nI			:= 0

	if c150frete == "F-FOB"
		for nI := 1 to len( aCols )
			if empty( aCols[ nI, nPosTransp ] )
				msgAlert( "Necessario informar Transportadora quando frete for igual a FOB." )
				lRet := .F.
				exit
			endif
		next
	endif

//grava sc1
	cQuery = " "	
	cQuery = " SELECT C8_FILIAL,C8_NUMSC,C8_ITEMSC "
	cQuery += " From " + RetSqlName("SC8") + " "
	cQuery += " WHERE C8_NUM='"+SC8->C8_NUM+"' AND C8_FILIAL='"+cfilant+"' "	
	cQuery += " AND D_E_L_E_T_<>'*' "
	If Select("TEMP15") > 0
		TEMP15->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP15",.T.,.F.)
	dbSelectArea("TEMP15")    
	TEMP15->(dbGoTop())

	While TEMP15->(!Eof())

	//MSGALERT("TESTE "+cNUM+cnumsc+cPRODUTO+cITEMSC)
	DbSelectArea("SC1")
	SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
	If SC1->(dbSeek(TEMP15->C8_FILIAL+TEMP15->C8_NUMSC+TEMP15->C8_ITEMSC))

	RecLock("SC1",.F.)
		SC1->C1_ZWFPC := SC8->C8_ZWFPC
	SC1->(MsUnLock())            

	ENDIF
		
	TEMP15->(dbSKIP())
	EndDo


Return lRet