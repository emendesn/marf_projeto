#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
#DEFINE ENTER chr(13)+chr(10)

/*
==========================================================================================
Programa.:              MGFEEC16
Autor....:              Leo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   MarkBrowse com os Documentos para serem incluidos ao pedido  
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ja filtra os documentos relacionados ao pedido 
==========================================================================================
*/

//=============================== Relação das Functions =================================
// 01 - Função Principal - MGFEEC01()
// 02 - Grava os documentos marcados na tabela de Docs X Cliente - MBrowEEC() 
//=======================================================================================

User Function MGFEEC16(cResp,cFilPar)

	Local aArqTrab := {}
	

	Private cOrcam 	:= IIF(IsInCallStack("EECAE100"),EEC->EEC_ZEXP+EEC->EEC_ZANOEX+EEC->EEC_ZSUBEX,"") //EEC_PREEMB //EE7_PEDIDO
	Private cPedEcc := IIF(IsInCallStack("u_MGFEEC24"),ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP,IIF(IsInCallStack("EECAP100"),EE7->EE7_ZEXP+EE7->EE7_ZANOEX+EE7->EE7_ZSUBEX,cOrcam)) //EEC_PREEMB //EE7_PEDIDO
	Private cFilAtu := cFilPar
	Private cMarca   := GetMark()
	Private aRotina2  := iif(Type("aRotina") <> "U",aRotina,"")
	Private cCadastro2 := iif(Type("cCadastro") <> "U",cCadastro,"")
	Private cAlias2 := "ZZJ"
	Private cFiltro := ""
	Private bFiltraBrw := {|| Nil}
	Private cRespon := 	iif(!Empty(cResp),cResp, GetAdvFVal("ZZJ","ZZJ_RESPON",xFilial("ZZJ")+cPedEcc,2,"")) 


	aRotina := {}

	cAlias   := 'SZZ'
	cCampo   := 'ZZ_MARK'

	aCampos  :={{'ZZ_MARK'   ,,'Marcado'},; // Configuração do campo C,2 para qualquer mark campo .
	{'ZZ_CODDOC' ,,'Doc/Ativ'},;
	{'ZZ_DESCR'  ,,'Descrição'},;
	{'ZZ_TIPO'   ,,'Tipo'},;
	{'ZZ_DIAS'   ,,'Dias'}}                           

	cCadastro := 'Doc/Ativ de Importação'

	aAdd( aRotina, {"Confirmar" ,'ExecBlock("MBREEC16",.F.,.F.,4), CloseBrowse()', 0 , 4 } )

//"U_MBREEC16('"+cResp+"')"

	DbSelectArea("ZZ2")
	DbSetOrder(2)

	aAdd(aArqTrab,{"ZZ_MARK"        ,"C",2,0})
	aAdd(aArqTrab,{"ZZ_CODDOC"      ,"C",3,0}) 
	aAdd(aArqTrab,{"ZZ_DESCR"       ,"C",40,0})
	aAdd(aArqTrab,{"ZZ_TIPO"        ,"C",1,0})
	aAdd(aArqTrab,{"ZZ_DIAS"        ,"N",2,0})
	aAdd(aArqTrab,{"ZZ_OBRIG"       ,"C",1,0})
	aAdd(aArqTrab,{"ZZJ_DTBASE"     ,"D",8,0})

	cTabAux := CriaTrab(aArqTrab, .T.)
	DbCreate(cTabAux, aArqTrab)
	cInd := LEFT(cTabAux, 7) + "1"

	If(Select('TRB') > 0, TRB->(DbCloseArea()),)
	DbUseArea(.T., , cTabAux, 'TRB', .F., .F.)

	IndRegua('TRB', cInd, "ZZ_CODDOC")    //Indice de organização do relatório
	TRB->(DbClearIndex())
	DbSetIndex(cInd + OrdBagExt())


	cQuery := " SELECT "+ENTER
	cQuery += "  ' ' ZZ_MARK, "+ENTER
	cQuery += "  SZZ.ZZ_CODDOC, SZZ.ZZ_DESCR, SZZ.ZZ_TIPO, SZZ.ZZ_DIAS, "+ENTER 
	cQuery += "	 SZZ.ZZ_OBRIG "+ENTER
	cQuery += "  FROM " +RetSqlName("SZZ")+ " SZZ "+ENTER
	cQuery += "  WHERE SZZ.D_E_L_E_T_ = ' ' AND "+ENTER
	cQuery += "  NOT EXISTS ( SELECT '*' FROM " +RetSqlName("ZZJ")+ " ZZJ "+ENTER
	cQuery += "  WHERE  ZZJ.ZZJ_FILIAL = '" + cFilAtu + "' "+ENTER
	cQuery += "  AND  ZZJ.ZZJ_PEDIDO = '" + cPedEcc + "' "+ENTER
	cQuery += "  AND ZZJ.ZZJ_CODDOC = SZZ.ZZ_CODDOC "+ENTER
	cQuery += "  AND ZZJ.D_E_L_E_T_ = ' ' )"+ENTER
	cQuery += "  AND  SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "+ENTER

	TCQUERY Changequery(cQuery) New Alias "TMPSZZ"  // oracle 
	//TCQUERY cQuery New Alias "TMPSZZ" // sql


	While !TMPSZZ->(Eof()) 

		ZZ2->(DbSeek(XFILIAL("ZZ2")+ZZC->ZZC_IMPORT+ZZC->ZZC_IMLOJA+TMPSZZ->ZZ_CODDOC))	
		RecLock("TRB",.T.) 
		TRB->ZZ_MARK   := TMPSZZ->ZZ_MARK
		TRB->ZZ_CODDOC := TMPSZZ->ZZ_CODDOC
		TRB->ZZ_DESCR  := GetAdvFVal("SZZ","ZZ_DESCR",xFilial("SZZ")+TMPSZZ->ZZ_CODDOC,1,"")
		TRB->ZZ_TIPO   := TMPSZZ->ZZ_TIPO
		TRB->ZZ_DIAS   := TMPSZZ->ZZ_DIAS
		TRB->ZZJ_DTBASE	:= U_DATEEC15(Substr(cPedEcc,1,13),Substr(cPedEcc,14,2),Substr(cPedEcc,16,3))
		TRB->ZZ_OBRIG  := TMPSZZ->ZZ_OBRIG
		TRB->(MSUnLock()) 
		TMPSZZ->(DBSkip()) 
		
		
	EndDo 
	TMPSZZ->(DBCloseArea()) 

	DbSelectArea('TRB')       
	cAlias := 'TRB'                    

	DbSelectArea(cAlias)
	bFiltraBrw  := {|| FilBrowse(cAlias,,) }
	MarkBrow(cAlias,cCampo,"",aCampos,.F.,cMarca)          

	// Retorna as variaveis do MGFEEC02 
	aRotina   := aRotina2            
	cCadastro := cCadastro2    
	cAlias    := cAlias2

Return

// 02 - Grava os documentos marcados na tabela de Docs X Cliente
User Function MBREEC16()

	Local aLista := {}
	Local dBase := STOD("")
	

	// Grava no array os documentos selecionados 
	TRB->(dbGoTop())
	While !TRB->(Eof())
		If IsMark(cCampo)// &(cTab+"->"+cCAMPO) == cMarca	

			aAdd(aLista,{TRB->ZZ_CODDOC,;
			cPedEcc ,; 
			cRespon,;
			TRB->ZZ_DIAS }) 

		EndIf
		TRB->(DbSkip())
	EndDo	
	
	DbSelectArea("ZZ2")
	DbSetOrder(2)	

	// Grava os documentos para o cliente
	For nA := 1 To Len(aLista)
	
		ZZ2->(DbSeek(XFILIAL("ZZ2")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA+aLista[nA,1]))
	
		dBase := U_DATEEC15(Substr(cPedEcc,1,13),Substr(cPedEcc,14,2),Substr(cPedEcc,16,3))
		RecLock("ZZJ",.T.)
		ZZJ->ZZJ_FILIAL := cFilAtu
		ZZJ->ZZJ_COD 	:= GetSx8Num("ZZJ", "ZZJ_COD")
		ZZJ->ZZJ_CODDOC := aLista[nA,1]
		ZZJ->ZZJ_PEDIDO := aLista[nA,2]
		ZZJ->ZZJ_RESPON	:= aLista[nA,3]
		ZZJ->ZZJ_FINALI	:= "N"
		ZZJ->ZZJ_NECESS	:= ZZ2->ZZ2_OBRIG
		ZZJ->ZZJ_QTDIAS	:= aLista[nA,4]
		ZZJ->ZZJ_DTBASE	:= dBase
		ZZJ->ZZJ_PRVCON	:= IIF(!Empty(dBase),dBase+aLista[nA,4],STOD(""))		   		
		MsUnlock()
	Next

	MSGINFO("Inclusão Efetuada Com Sucesso !!","Marfrig")

Return 


