#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFEST38
//TODO Descrição Grava dados bancarios nos titulos a pagar de fornecedores pecuaristas
@author marcelo.moraes
@since 10/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function MGFEST38()

local aArea		 := getArea()
local aAreaSE2	 := SE2->(getArea())
local aAreaFIL	 := FIL->(getArea())
local _cAlias 	 := GetNextAlias() 
Local cQuery 	 := ""
Local cTpForn 	 := GetAdvFVal("SA2","A2_ZTPFORN",xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),1,"") //Busca o tipo do fornecedor
Local aRecno	 := {}
Local cFinali	 := ""
Local cBancoFor  := ""      
Local cAgeFor    := ""
Local cAgeDigFor := ""
Local cConFor 	 := ""
Local cConDigFor := ""
Local cTipoFIL	 := ""

if (SF1->F1_LOJA<>"01"  .and. Alltrim(cTpForn)=="2" .and. SF1->F1_FORMUL<>"S" ) .OR. ;
   (SF1->F1_LOJA<>"01"  .and. Alltrim(cTpForn)=="2" .and. SF1->F1_FORMUL=="S" .AND. SF1->F1_TIPO =='C' ) //Incluido para nota complementar e formulario proprio
	
	//Busca as parcelas do titulo que devem ter seus dados bancarios gravados
	cQuery := " SELECT R_E_C_N_O_ RECSE2 "+CRLF
	cQuery += " FROM "+RetSqlName("SE2")+" SE2 "+CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND E2_FILIAL = '"+SF1->F1_FILIAL+"'" + CRLF
	cQuery += "	AND E2_TIPO = 'NF' " + CRLF
	cQuery += "	AND E2_NUM = '"+SF1->F1_DOC+"'" + CRLF
	cQuery += "	AND E2_PREFIXO = '"+SF1->F1_SERIE+"'" + CRLF
	cQuery += "	AND E2_FORNECE = '"+SF1->F1_FORNECE+"'" + CRLF
	cQuery += "	AND E2_LOJA = '"+SF1->F1_LOJA+"'" + CRLF
	
	If Select(_cAlias) > 0     
		(_cAlias)->(DbCloseArea())
	EndIf 
	
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.F.)

	While (_cAlias)->(!EOF())
		AADD(aRecno,(_cAlias)->RECSE2)
		(_cAlias)->(DbSkip())
	end
	
	If Select(_cAlias) > 0     
		(_cAlias)->(DbCloseArea())
	EndIf 
	
	if len(aRecno)>0
		//Busca dados da conta do fornecedor principal (loja 01) na tabela FIL
		cTipoFIL := "1"
		cTipoFIL := PadR( cTipoFIL, TamSX3("FIL_TIPO")[1])
		FIL->(DbSetOrder(1))
		If	FIL->(DbSeek(xFilial("FIL")+SF1->F1_FORNECE+"01"+cTipoFIL))
		
			cFinali		:= IIF(FIL->FIL_TIPCTA == '1','01','11')
			cBancoFor   := FIL->FIL_BANCO 
			cAgeFor   	:= FIL->FIL_AGENCI
			cAgeDigFor	:= FIL->FIL_DVAGE
			cConFor 	:= FIL->FIL_CONTA
			cConDigFor	:= FIL->FIL_DVCTA
			
			//Atualiza os dados bancarios nas parcelas do titulo a pagar
			for Y=1 to len(aRecno)
				SE2->(dbGoTo(aRecno[Y]))
		 	    RecLock('SE2',.F.)
			 	    SE2->E2_XFINALI := cFinali
					SE2->E2_FORBCO  := cBancoFor
					SE2->E2_FORAGE  := cAgeFor
					SE2->E2_FAGEDV  := cAgeDigFor
					SE2->E2_FORCTA  := cConFor
					SE2->E2_FCTADV  := cConDigFor
				SE2->(MsUnlock())
			next
			
		else
			Help("  ",1,"MGFEST38 - DADOS BANCARIOS DO FORNECEDOR NAO CADASTRADO!!! TITULOS CONTAS A PAGAR FORAM GERADOS SEM BANCO, AGENCIA E CONTA")		
		endif
		
	endif

endif 

RestArea(aAreaFIL)
RestArea(aAreaSE2)
RestArea(aArea)

Return 
