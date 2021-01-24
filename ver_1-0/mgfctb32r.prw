#include 'protheus.ch'
#include 'parmtype.ch'

user function MGFRCTB32()
	
	
Local oReport

Local oBreak
Local lRet := .F.

If FindFunction("TRepInUse") .And. TRepInUse()
	
	oReport := ReportDef()
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
Local aOrdem	:= {}
Local ntotal := 0

Private cPerg := "MGFRCTB32"

Public cAliasGW3 := GetNextAlias()
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Habilita as perguntas da Rotina                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

//Pergunte(cPerg,.T.)

oReport:= TReport():New("MGFRCTB32","Relatório de Documentos de Frete não integrados","MGFRCTB32", {|oReport| ReportPrint(oReport,cAliasGW3)},"")
oReport:SetLandscape()

oReport:SetTotalInLine(.F.)
Pergunte("MGFRCTB32",.F.)



oSintetico := TRSection():New(oReport,"Relatório de Título de Frete",{"GW3"}) //"Relacao de Pedidos de Compras"
oSintetico :SetTotalInLine(.F.)

                                                                                                                                            
TRCell():New(oSintetico,"GW3_FILIAL" ,"GW3", "Filial"	        	 /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)                                                                                                         
TRCell():New(oSintetico,"GU3_CDEMIT" ,"GU3", "CNPJ Emissor"	    	 /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_CDESP"  ,"GW3", "Tipo de Dcto"			 /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_NRDF"   ,"GW3", "Documento"   			 /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_SERDF"  ,"GW3", "Serie"  		    	 /*Titulo*/	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_DTEMIS" ,"GW3", "Data Emissãor"    	 /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_DTENT"  ,"GW3", "Data Entrada"			 /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_VLDF"   ,"GW3", "Valor"		         /*Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_MOTFIS" ,"GW3", "Rejeição Fiscal"       /*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSintetico,"GW3_MOTREC" ,"GW3", "Rejeição Recebimento"  /*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)


Static Function ReportPrint(oReport,cAliasGW3)
Local oSintetico := oReport:Section(1)

Local nTxMoeda	:= 1
Local lFirst    := .F.
Local nOrdem    := oReport:Section(1):GetOrder()

Local nFilters 	:= 0
Local nI
Local cProdAnt := " "

Local cOrdem := " "

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

BeginSql Alias cAliasGW3          
  
//SELECT * FROM GW3990 GW3, GU3990 GU3, GW4990 GW4
SELECT * FROM %Table:GW3% GW3 ,%Table:GU3% GU3 , %Table:GW4% GW4
         
WHERE ((GW3.GW3_SITFIS NOT IN ('4','6') AND GW4.GW4_TPDC = 'NFS' )
OR (GW3.GW3_SITREC NOT IN ('4','6') AND GW4.GW4_TPDC = 'NFE' ))
AND GW3.GW3_EMISDF = GU3.GU3_CDEMIT
AND GW3.GW3_NRDF = GW4.GW4_NRDF
AND GW3.GW3_SERDF = GW4.GW4_SERDF
AND GW3.GW3_EMISDF = GW4.GW4_EMISDF
AND GW3.GW3_FILIAL = GW4.GW4_FILIAL  

AND GW3.GW3_FILIAL >= %Exp:MV_PAR01%
AND GW3.GW3_FILIAL <= %Exp:MV_PAR02%
AND GW3.GW3_DTEMIS >= %Exp:DTOS(MV_PAR03)%
AND GW3.GW3_DTEMIS <= %Exp:DTOS(MV_PAR04)%
AND GW3.GW3_DTENT  >= %Exp:DTOS(MV_PAR05)%
AND GW3.GW3_DTENT  <= %Exp:DTOS(MV_PAR06)%
AND GW3.GW3_EMISDF >= %Exp:MV_PAR07%
AND GW3.GW3_EMISDF <= %Exp:MV_PAR08%
  
AND GW3.%notdel%
AND GU3.%notdel%                
AND GW4.%notdel%

EndSql

oReport:Section(1):EndQuery()

oSintetico:SetParentQuery()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetMeter(GW3->(LastRec()))
		    	    
		  	oSintetico:PrintLine()  
		    oSintetico:Print()    

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
Local cPerg              := "MGFRCTB32"

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Filial de:             ","","","mv_ch3" ,"C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial até:            ","","","mv_ch3" ,"C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Emissão de:       ","","","mv_ch3" ,"D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Emissão até:      ","","","mv_ch4" ,"D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Data Entrada de :      ","","","mv_ch5" ,"D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Data Entrada até:      ","","","mv_ch6" ,"D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Transportador de:      ","","","mv_ch7" ,"C",14,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})
aAdd(aRegs,{cPerg,"08","Transportador Até:     ","","","mv_ch8" ,"C",14,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","GU3","","","",""})

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
return