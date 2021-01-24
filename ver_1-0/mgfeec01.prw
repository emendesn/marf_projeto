#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
#include "totvs.ch"
#DEFINE ENTER chr(13)+chr(10)

/*
==========================================================================================
Programa.:              MGFEEC01
Autor....:              Francis Oliveira
Data.....:              Out/2016
Descricao / Objetivo:   MarkBrowse com os Documentos para serem incluidos ao clientes  
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ja filtra os documentos relacionados no cliente 
						Leo - Alteração para gravar os campos corretamente.
==========================================================================================
*/

//=============================== Relação das Functions =================================
// 01 - Função Principal - MGFEEC01()
// 02 - Grava os documentos marcados na tabela de Docs X Cliente - MBrowEEC() 
//=======================================================================================

User Function MGFEEC01()

Local aArqTrab := {}
Private cMarca   := GetMark()
Private aRotina2  := IIF(VALTYPE(aRotina)=='A',aRotina,{})
Private cCadastro2 := cCadastro    
Private cAlias2 := "ZZ2"
Private cFiltro := ""
Private bFiltraBrw := {|| Nil}

aRotina := {}

cAlias   := 'SZZ'
cCampo   := 'ZZ_MARK'
   
aCampos  :={{'ZZ_MARK'   ,,'Marcado'},; // Configuração do campo C,2 para qualquer mark campo .
            {'ZZ_CODDOC' ,,'Documento'},;
            {'ZZ_DESCR'  ,,'Descrição'},;
            {'ZZ_TIPO'   ,,'Tipo'},;
            {'ZZ_DATA'   ,,'Data'},;
            {'ZZ_DIAS'   ,,'Dias'}}                           
   
cCadastro := 'Doc/Ativ Exportação'

aAdd( aRotina, {"Confirmar" ,'ExecBlock("MBrowEEC",.F.,.F.,4), CloseBrowse()' , 0 , 4 } )

cCodCli := SA1->A1_COD
cLojCli := SA1->A1_LOJA

aAdd(aArqTrab,{"ZZ_MARK"        ,"C",2,0})
aAdd(aArqTrab,{"ZZ_CODDOC"      ,"C",3,0}) 
aAdd(aArqTrab,{"ZZ_DESCR"       ,"C",40,0})
aAdd(aArqTrab,{"ZZ_TIPO"        ,"C",1,0})
aAdd(aArqTrab,{"ZZ_DIAS"        ,"N",2,0})
aAdd(aArqTrab,{"ZZ_DATA"        ,"C",1,0})
aAdd(aArqTrab,{"ZZ_OBRIG"       ,"C",1,0})

cTabAux := CriaTrab(aArqTrab, .T.)
DbCreate(cTabAux, aArqTrab)
cInd := LEFT(cTabAux, 7) + "1"

If(Select('TRB') > 0, TRB->(DbCloseArea()),)
DbUseArea(.T., , cTabAux, 'TRB', .F., .F.)
	
IndRegua('TRB', cInd, "ZZ_CODDOC")    //Indice de organização do relatório
TRB->(DbClearIndex())
DbSetIndex(cInd + OrdBagExt())

//Leo - Alteração na query para trazer todos os documentos que não existe no cadastro do cliente.
                                                                   
cQuery := " SELECT "+ENTER
cQuery += "  ' ' ZZ_MARK, "+ENTER
cQuery += "  SZZ.ZZ_CODDOC, SZZ.ZZ_DESCR, SZZ.ZZ_TIPO, SZZ.ZZ_DIAS, "+ENTER 
cQuery += "  SZZ.ZZ_OBRIG, SZZ.ZZ_DATA "+ENTER
cQuery += "  FROM " +RetSqlName("SZZ")+ " SZZ "+ENTER
cQuery += "  WHERE SZZ.D_E_L_E_T_ = ' ' AND "+ENTER
cQuery += "  NOT EXISTS ( SELECT '*' FROM " +RetSqlName("ZZ2")+ " ZZ2 "+ENTER
cQuery += "  WHERE  ZZ2.ZZ2_CODCLI = '" + cCodCli + "' "+ENTER
cQuery += "  AND ZZ2.ZZ2_LOJCLI = '" + cLojCli + "' "+ENTER
cQuery += "  AND ZZ2.ZZ2_CODDOC = SZZ.ZZ_CODDOC "+ENTER
cQuery += "  AND ZZ2.D_E_L_E_T_ = ' ' )"+ENTER

TCQUERY Changequery(cQuery) New Alias "TMPSZZ"  // oracle 
//TCQUERY cQuery New Alias "TMPSZZ" // sql
  
 While !TMPSZZ->(Eof()) 
      RecLock("TRB",.T.) 
      TRB->ZZ_MARK   := TMPSZZ->ZZ_MARK
      TRB->ZZ_CODDOC := TMPSZZ->ZZ_CODDOC
      TRB->ZZ_DESCR  := TMPSZZ->ZZ_DESCR
      TRB->ZZ_TIPO   := TMPSZZ->ZZ_TIPO
      TRB->ZZ_DATA   := TMPSZZ->ZZ_DATA
      TRB->ZZ_DIAS   := TMPSZZ->ZZ_DIAS
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
User Function MBrowEEC()

Local aLista := {}

// Grava no array os documentos selecionados 
TRB->(dbGoTop())
While !TRB->(Eof())
	If IsMark(cCampo)// &(cTab+"->"+cCAMPO) == cMarca	
			
		aAdd(aLista,{TRB->ZZ_CODDOC,;
				   TRB->ZZ_OBRIG,;
				   SA1->A1_COD,;   
				   SA1->A1_LOJA ,; 
				   TRB->ZZ_DATA ,; 
				   TRB->ZZ_DIAS }) 
					   
	EndIf
	TRB->(DbSkip())
EndDo		

// Grava os documentos para o cliente
For nA := 1 To Len(aLista)
			RecLock("ZZ2",.T.)
			ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
			ZZ2->ZZ2_COD 	:= GetSx8Num("ZZ2", "ZZ2_COD")
			ZZ2->ZZ2_CODDOC := aLista[nA,1]
			ZZ2->ZZ2_OBRIG  := aLista[nA,2]
			ZZ2->ZZ2_CODCLI := aLista[nA,3]
			ZZ2->ZZ2_LOJCLI := aLista[nA,4]
			ZZ2->ZZ2_DATA	  := aLista[nA,5]
			ZZ2->ZZ2_DIAS	  := aLista[nA,6]
			MsUnlock()
Next

MSGINFO("Inclusão Efetuada Com Sucesso !!","Marfrig")

Return 