#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PRTOPDEF.CH"           

                      
/*/
==============================================================================================================================================================================
{Protheus.doc} MGFGFE62

Relatorio Taxa de Conveniencia

@description
De acordo com os parametros informados, gera relatorio (padrao Treport)
Novo relatório de TAXA DE CONVENIÊNCIA,  contemplando os campos inseridos na VIEW V_LOGIST_TAXA_CONVENIENCIA, 
Considerar os mesmo parâmetros inseridos no relatório de Contas a Pagar RCTRC.

@author Renato Vieira Bandeira Junior
@since 16/03/2020
@type Function

@table 
    GWN, GW1, GW3, GW4, SA2, SE2, GV4, GDS, DUT
	
@param

MV_PAR01 ,"Data Romaneio de :     "
MV_PAR02 ,"Data Romaneio até:     "
MV_PAR03 ,"Data Vencimento de :   "
MV_PAR04 ,"Data Vencimento até:   "
MV_PAR05 ,"Transportador de:      "
MV_PAR06 ,"Transportador Até:     "
MV_PAR07 ,"Romaneio de:           "
MV_PAR08 ,"Romaneio Até:          "
MV_PAR09 ,"Documento de Frete de: "
MV_PAR10 ,"Documento de Frete Até:"


@return
 	NIL

@menu
    Gestao Frete Embarcador \ Atualizacoes \ MARFRIF \  Rel Taxa Conveniencia
	
@history
/*/   

User Function MGFGFE62()

Local oReport

Local oBreak
Local lRet := .F.

If FindFunction("TRepInUse") .And. TRepInUse()
	
	oReport:=ReportDef()
	oReport:PrintDialog()
	
EndIf

Return

Static Function ReportDef(nReg)

Local oReport
Local oSintetico
Local oSintetico2
Local oSection3
Local oSection4
Local oSection5
Local oCell
Local aOrdem := {}        
Local ntotal := 0

Private cPerg := "MGFGFE62"

Public cAliasGWN := GetNextAlias()
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Habilita as perguntas da Rotina                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

oReport:= TReport():New("MGFGFE62","Relatório Taxa de Conveniência","MGFGFE62", {|oReport| ReportPrint(oReport)},"")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Pergunte("MGFGFE62",.T.)

oSintetico := TRSection():New(oReport,"Relatório Taxa de Conveniência",{"cAliasGWN"})
oSintetico :SetTotalInLine(.F.)

TRCell():New(oSintetico,"FILIAL"	       ,"cAliasGWN" , "Filial"	            /*Titulo*/	,/*Picture*/,06/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"NUM_ROMANEIO"     ,"cAliasGWN" , "Romaneio"	            /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
// RVBJ
TRCell():New(oSintetico,"TIPO_OPERACAO"			,"cAliasGWN" , "Tp Operação"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESCRICAO_TIPO_OPERACAO"	,"cAliasGWN" , "Descr.Tp Oper"	        /*Titulo*/	,/*Picture*/,35/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSintetico,"COD_TIPO_VEICULO" ,"cAliasGWN" , "Tp Veículo"	        /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_TIPO_VEICULO","cAliasGWN" , "Descr.Tp Veículo"      /*Titulo*/	,/*Picture*/,35/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"NUM_TITULO"       ,"cAliasGWN" , "Título"				/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DT_EMISSAO"	   ,"cAliasGWN" , "Emissão"   			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_EMISSAO,7,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,5,2)+"/"+SUBS(cAliasGWN->DT_EMISSAO,1,4)})
TRCell():New(oSintetico,"DT_VENCIMENTO"    ,"cAliasGWN" , "Vencimento"  			/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->DT_VENCIMENTO,7,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,5,2)+"/"+SUBS(cAliasGWN->DT_VENCIMENTO,1,4)})
TRCell():New(oSintetico,"DESCONTO_GERAL"   ,"cAliasGWN",  "Vlr Titulo"			/*Titulo*/	,"@E 999,999.99"/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DECRESCIMO"	   ,"cAliasGWN",  "Desc Total"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"FORNECEDOR"	   ,"cAliasGWN",  "Fornecedor"      		/*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"DESC_DESCONTO"	   ,"cAliasGWN",  "Descr Desconto"   		/*Titulo*/	,/*Picture*/,30/*Tamanho*/,/*lPixel*/,{||ALLTRIM(cAliasGWN->DESC_DESCONTO)})
TRCell():New(oSintetico,"DESCONTO_RCTRC"   ,"cAliasGWN",  "Desc Tx C"     		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GWN_DTIMPL"	   ,"cAliasGWN",  "Data Implant"   		/*Titulo*/	,/*Picture*/,12/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->GWN_DTIMPL,7,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,5,2)+"/"+SUBS(cAliasGWN->GWN_DTIMPL,1,4)})
TRCell():New(oSintetico,"E2_VENCTO_FILTRO" ,"cAliasGWN",  "Vencto Filtro"  		/*Titulo*/	,/*Picture*/,15/*Tamanho*/,/*lPixel*/,{||SUBS(cAliasGWN->E2_VENCTO_FILTRO,7,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,5,2)+"/"+SUBS(cAliasGWN->E2_VENCTO_FILTRO,1,4)})
TRCell():New(oSintetico,"GW3_EMISDF"	   ,"cAliasGWN",  "Emitente"	    	    /*Titulo*/	,/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_NRDF"	       ,"cAliasGWN",  "Número DF"	    	    /*Titulo*/	,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Return(oReport)

Static Function ReportPrint(oReport)
Local oSintetico := oReport:Section(1)

Local nTxMoeda	:= 1
Local lFirst    := .F.
Local nOrdem    := oReport:Section(1):GetOrder()

Local nFilters 	:= 0
Local nI
Local cProdAnt := " "
Local cOrdem := " "

Local nAtual := 0
Local nTotal := 0

Local oSectDad := Nil

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere := ""
	Local cFrom := "%%"
#ENDIF

Local lFilUsr	:= oSintetico:GetAdvplExp() <> ""

MakeSqlExpr(oReport:uParam)
oReport:Section(1):BeginQuery()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Todos os campos que serão impressos no relatórioÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BeginSql Alias cAliasGWN

cQuery := ' '
cQuery += "SELECT * FROM " + U_IF_BIMFR( "IF_BIMFR", "V_LOGIST_TAXA_CONVENIENCIA" )

cQuery += " WHERE FILIAL =  '"+xFilial("GWN")+"'"
If ! Empty( DTOS(MV_PAR02))
	cQuery += " AND GWN_DTIMPL       BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
Endif
If ! Empty( DTOS(MV_PAR04))
	cQuery += " AND E2_VENCTO_FILTRO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
Endif
If ! Empty( MV_PAR06)
	cQuery += " AND GW3_EMISDF   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
ENDIF
If ! Empty( MV_PAR08)
	cQuery += " AND NUM_ROMANEIO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
Endif
If ! Empty( MV_PAR10)
	cQuery += " AND GW3_NRDF     BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
Endif

cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "cAliasGWN"

Count To nTotal 

oReport:SetMeter(nTotal)
oSintetico:Init()
cAliasGWN->(DbGoTop())
While ! cAliasGWN->(Eof())
    nAtual++
    oReport:SetMsgPrint("Imprimindo registro "+cValtoChar(nAtual)+" de "+cValToChar(ntotal)+"...")
    oReport:IncMeter()
    oSintetico:PrintLine()  
    cAliasGWN->(DbSkip())
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cAliasGWN->(DbCloseArea())

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ Flávio Dentello    º Data ³  07/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aPerguntas := {}
Local aRegs := {}
Local i,j
Local cPerg              := "MGFGFE62"
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Data Romaneio de :     ","","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Romaneio até:     ","","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Vencimento de :   ","","","mv_ch3" ,"D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Vencimento até:   ","","","mv_ch4" ,"D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Transportador de:      ","","","mv_ch5" ,"C",14,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"06","Transportador Até:     ","","","mv_ch6" ,"C",14,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"07","Romaneio de:           ","","","mv_ch7" ,"C",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"08","Romaneio Até:          ","","","mv_ch8" ,"C",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","GWN","","","",""})
aAdd(aRegs,{cPerg,"09","Documento de Frete de: ","","","mv_ch9" ,"C",09,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Documento de Frete Até:","","","mv_ch10","C",09,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])//2
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return()

            