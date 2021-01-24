#INCLUDE "rwmake.ch"
#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
#define DMPAPER_A4 9                                     
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFFIN83
Autor....:              Marcelo Carneiro         
Data.....:              16/02/2018 
Descricao / Objetivo:   Autorização Débito em Conta
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
=====================================================================================
*/

User Function MGFFIN83 
Local aRet		  := {}
Local aParambox	  := {}       
Private aSelFil   := {}

//AAdd(aParamBox, {1, "Filial de:"       	,Space(tamSx3("A2_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
//AAdd(aParamBox, {1, "Filial Até:"      	,Space(tamSx3("A2_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Fornecedor de:"    ,Space(tamSx3("A2_COD")[1])           , "@!",                           ,"SA2" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Fornecedor Até:"   ,Space(tamSx3("A2_COD")[1])           , "@!",                           ,"SA2" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Loja de:"			,Space(tamSx3("A2_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Loja Até:"      	,Space(tamSx3("A2_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Tipo:(Use ; p/Separar)"    ,Space(50)                             , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Prefixo:(Use ; p/Separar)" ,Space(50)                             , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Dt. da Baixa:"  	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .T.	})
AAdd(aParamBox, {1, "Banco :"        	,Space(tamSx3("A6_COD")[1])           , "@!",                           ,"SA6" ,, 070	, .T.	})
AAdd(aParamBox, {1, "Agência:"      	,Space(tamSx3("A6_AGENCIA")[1])       , "@!",                           ,      ,, 070	, .T.	})
AAdd(aParamBox, {1, "Cta Corrente:"     ,Space(tamSx3("A6_NUMCON")[1])        , "@!",                           ,      ,, 070	, .T.	})
IF ParamBox(aParambox, "Filtro para Selecionar os Titulos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	aSelFil := AdmGetFil(.F.,.T.,"SE2")
	If Len( aSelFil ) <= 0
		MsgAlert('Filiais não selecionadas !!')
		Return
	Endif
	
	Processa( {|| Carrega_Dados()  },'Aguarde...', 'Selecionando Registros',.F. )
EndIF

Return
***********************************************************************************************************************
Static Function Carrega_Dados
Local cQuery   := ''                              
Local aTipo    := StrTokArr(MV_PAR05,';')
Local aPrefixo := StrTokArr(MV_PAR06,';')
Local cTipo    := ''
Local cPrefixo := ''
Local nI       := 0 
Private cTitulo    := "Autorização de Debito em Conta Bancaria"
Private oPrn      := NIL                  
Private oFonte01  := TFont():New('Courier New',,09,,.T.,,,,,.F.,.F.) 
Private oFonte02  := TFont():New('Courier New',,10,,.F.,,,,,.F.,.F.) 
Private oFonte03  := TFont():New('Courier New',,12,,.F.,,,,,.F.,.F.) 
Private oFonte04  := TFont():New('Courier New',,14,,.F.,,,,,.F.,.F.) 

For nI :=  1 To Len(aTipo)
     cTipo += IIF(nI == 1,"",",")+"'"+aTipo[nI]+"'"
Next
For nI :=  1 To Len(aPrefixo)
     cPrefixo += IIF(nI == 1,"",",")+"'"+aPrefixo[nI]+"'"
Next

cQuery += " SELECT *                                     "+CRLF
cQuery += " FROM "+RetSqlName('SE2')+" E2 ,"+RetSqlName('SE5')+" E5, "+RetSqlName('SA2')+" A2         "+CRLF
cQuery += " WHERE E2.D_E_L_E_T_ = ' '                    "+CRLF
cQuery += "   AND A2.D_E_L_E_T_ = ' '                    "+CRLF
cQuery += "   AND E5.D_E_L_E_T_ = ' '                    "+CRLF
cQuery += "   AND E5_FILIAL     = E2_FILIAL              "+CRLF
cQuery += "   AND E5_PREFIXO    = E2_PREFIXO             "+CRLF
cQuery += "   AND E5_NUMERO     = E2_NUM                 "+CRLF
cQuery += "   AND E5_PARCELA    = E2_PARCELA             "+CRLF
cQuery += "   AND E5_TIPO       = E2_TIPO                "+CRLF
cQuery += "   AND E5_CLIFOR     = E2_FORNECE             "+CRLF
cQuery += "   AND E5_LOJA       = E2_LOJA                "+CRLF
cQuery += "   AND A2_FILIAL     = '      '               "+CRLF
cQuery += "   AND A2_COD        = E2_FORNECE             "+CRLF
cQuery += "   AND A2_LOJA       = E2_LOJA                "+CRLF
cQuery += "   AND E5_DATA       = '"+DTOS(MV_PAR07)+"'   "+CRLF
cQuery += "   AND E5_BANCO	    = '"+MV_PAR08+"'         "+CRLF
cQuery += "   AND E5_AGENCIA	= '"+MV_PAR09+"'         "+CRLF
cQuery += "   AND E5_CONTA      = '"+MV_PAR10+"'         "+CRLF
cQuery += "   AND E5_DTCANBX    = ' '                    "+CRLF
cQuery += "   AND E5_RECPAG     = 'P'                    "+CRLF
cQuery += "   AND E2_FILIAL " + GetRngFil(aSelFil, "SE2")
//cQuery += IIF( !Empty(MV_PAR01)," AND E2_FILIAL  >= '"+MV_PAR01+"'","")
//cQuery += IIF( !Empty(MV_PAR02)," AND E2_FILIAL  <= '"+MV_PAR02+"'","")
cQuery += IIF( !Empty(MV_PAR01)," AND E2_FORNECE >= '"+MV_PAR01+"'","")
cQuery += IIF( !Empty(MV_PAR02)," AND E2_FORNECE <= '"+MV_PAR02+"'","")
cQuery += IIF( !Empty(MV_PAR03)," AND E2_LOJA    >= '"+MV_PAR03+"'","") 
cQuery += IIF( !Empty(MV_PAR04)," AND E2_LOJA    <= '"+MV_PAR04+"'","")
cQuery += IIF( !Empty(MV_PAR05) ," AND E2_TIPO    IN("+cTipo+")","")
cQuery += IIF( !Empty(MV_PAR06)," AND E2_PREFIXO IN("+cPrefixo+")","")


If Select("QRY_SE2") > 0
	QRY_SE2->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)                               
//memowrite('c:\temp\queryad.sql',cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SE2",.T.,.F.)
dbSelectArea("QRY_SE2")

QRY_SE2->(dbGoTop())
IF QRY_SE2->(EOF())
     msgAlert('Não há dados para emitir o relatorio !!')
     Return
EndIF
dbSelectArea('SA6')
SA6->(dbSetOrder(1))

cQuery := " SELECT R_E_C_N_O_ RECA6   "+CRLF
cQuery += " FROM "+RetSqlName('SA6')
cQuery += " WHERE D_E_L_E_T_ = ' '                    "+CRLF
cQuery += "   AND A6_COD        = '"+MV_PAR08+"'         "+CRLF
cQuery += "   AND A6_AGENCIA	= '"+MV_PAR09+"'         "+CRLF
cQuery += "   AND A6_NUMCON     = '"+MV_PAR10+"'         "+CRLF
If Select("QRY_SA6") > 0
	QRY_SA6->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)                               
//memowrite('c:\temp\queryad.sql',cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SA6",.T.,.F.)
dbSelectArea("QRY_SA6")
QRY_SA6->(dbGoTop())
IF QRY_SA6->(!EOF())
     SA6->(dbGoTo(QRY_SA6->RECA6))
Else
     msgAlert('Não encontrado o Banco/Agencia/Conta !!!')
     Return
EndIF

oPrn:=FWMSPrinter():New('MGFFIN83',6,,,.T.,) 
oPrn:SetPortrait()
oPrn:SetPaperSize(DMPAPER_A4) 

Gera_REL()

oPrn:Preview() 

FreeObj(oPrn) 
oPrn := Nil

Return
******************************************************************************************************************************************************
Static Function Gera_REL
Local nTam      := 0 
Local cTexto    := ''
//Local oBrush    := TBrush():New( , CLR_HGRAY )                      
                                                                 
Private nTotal   := 0 
Private nLin     := 700                       
Private nFolha   := 1 
Private nCont    := 1 

QRY_SE2->(dbGoTop())
While QRY_SE2->(!EOF())
	IF nCont == 1
		IMP_CAB(.T.)
	EndIF
	
	Q_E5_FILIAL 	:= QRY_SE2->E5_FILIAL
	Q_E2_NUM		:= QRY_SE2->E2_NUM
	Q_A2_TIPO		:= QRY_SE2->A2_TIPO
	Q_A2_CGC		:= QRY_SE2->A2_CGC
	Q_A2_NOME		:= QRY_SE2->A2_NOME 
	Q_E2_VENCREA	:= QRY_SE2->E2_VENCREA
	Q_E2_VALOR		:= QRY_SE2->E2_VALOR
	Q_E5_VALOR		:= QRY_SE2->E5_VALOR
    _cChave        	:= QRY_SE2->E5_FILIAL+QRY_SE2->E5_PREFIXO+QRY_SE2->E5_NUMERO+QRY_SE2->E5_PARCELA+QRY_SE2->E5_TIPO+QRY_SE2->E5_CLIFOR+QRY_SE2->E5_LOJA
	_nSomaE5       	:= 0
	
	
	// Inserido este laço pois o mesmo título pode apresentar diversas SE5 - Ajuste em 07/11/18 - Andy e Eric
	While QRY_SE2->(!EOF()) .And.    _cChave == QRY_SE2->E5_FILIAL+QRY_SE2->E5_PREFIXO+QRY_SE2->E5_NUMERO+QRY_SE2->E5_PARCELA+QRY_SE2->E5_TIPO+QRY_SE2->E5_CLIFOR+QRY_SE2->E5_LOJA
		If AllTrim(QRY_SE2->E5_TIPO) == 'PA' .And. AllTrim(QRY_SE2->E5_TIPODOC) == 'PA'
			_nSomaE5 += QRY_SE2->E5_VALOR
		Else
			If AllTrim(QRY_SE2->E5_TIPODOC) == 'VL'  
				_nSomaE5 += QRY_SE2->E5_VALOR
			EndIf
		EndiF
		QRY_SE2->(dbSkip())
	EndDo
	
	If _nSomaE5 <> 0

		oPrn:Say(nLin,0050,Q_E5_FILIAL  ,oFonte02)
		oPrn:Say(nLin,0160,Q_E2_NUM     ,oFonte02)  
		
		IF QRY_SE2->A2_TIPO == 'F' 
		    oPrn:Say(nLin,0345,Transform(Q_A2_CGC,"@R 999.999.999-47") ,oFonte02)
		Else 
			oPrn:Say(nLin,0345,Transform(Substr(Q_A2_CGC,1,9),"@R 999.999.999")+"/"+Transform(Substr(Q_A2_CGC,9,6),"@R 9999-99"),oFonte02)
		EndIF
		
		oPrn:Say(nLin,0665,Q_A2_NOME,oFonte02)
		oPrn:Say(nLin,1287,DTOC(STOD(Q_E2_VENCREA)) ,oFonte02)
		oPrn:SayAlign( nLin-23,1500,Alltrim(Transform(Q_E2_VALOR 				,'@E 99,999,999.99'))	,oFonte02,220,0, , 1)
		oPrn:SayAlign( nLin-23,1775,Alltrim(Transform(Q_E2_VALOR - _nSomaE5  	,'@E 99,999,999.99')) 	,oFonte02,175,0, , 1)
		oPrn:SayAlign( nLin-23,1960,Alltrim(Transform(_nSomaE5 					,'@E 99,999,999.99'))  	,oFonte02,220,0, , 1)	
		
		nLin += 50
		nTotal    += _nSomaE5 
		nCont     += 1
		//SQRY_SE2->(dbSkip())
	
	EndIf
	
    IF nLin > 3000 .And. QRY_SE2->(!Eof())
    	nFolha += 1 
    	IMP_CAB(.T.)
	EndIF
End
nLin += 30
oPrn:Line(nLin,50,nLin,2180)
nLin += 30

oPrn:Say(nLin,1700,'Total Geral :',oFonte02)
oPrn:SayAlign( nLin-23,1960,Alltrim(Transform(nTotal ,'@E 99,999,999.99')) ,oFonte02,220,,,1)
nLin += 50
nCont:=nCont-1
oPrn:Say(nLin,1700,'Total Compromissos : '+STRZERO(nCont,3),oFonte02)    
    
IF nLin > 2700 
	nFolha += 1
	IMP_CAB(.F.)
EndIF
Imp_Texto()

IF nLin > 2600 
	nFolha += 1
	IMP_CAB(.F.)
EndIF
nLin +=350               

oPrn:Line(nLin,300,nLin,800)
oPrn:SayAlign( nLin+30,300,'Emitente',oFonte03,500,,,2)

oPrn:Line(nLin,1300,nLin,1800)
oPrn:SayAlign( nLin+30,1300,'Emitente',oFonte03,500,,,2)


oPrn:EndPage()

Return
*************************************************************************************************
Static Function Ret_Tam(cTexto,oFontText)
Local nRet := 0

nRet:= ROUND(oPrn:GetTextWidth(cTexto, oFontText )+10 ,0)

Return nRet
**************************************************************************************************
Static function ConvTexto(nValor)

Local cTexto := Extenso(nValor,0,1)
Local aRet   := {'','',''}
Local nI     := 0                                   
Local bTem   := .T.

cTexto :=  '('+Alltrim(cTexto)+')'

nTam := Len(cTexto)

For nI := 100 To 1 STEP -1
    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem   
         bTem   := .F.
         aRet[01] := SUBSTR(cTexto,1,nI-1)   
         cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
    EndIF
Next nI

bTem   := .T.
IF nTam <= 100 
	aRet[01] += ' '+cTexto 
Else
	bTem   := .T.
	For nI := 100 To 1 STEP -1
	    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem   
	         bTem   := .F.
	         aRet[02] := SUBSTR(cTexto,1,nI-1)                                     '
	         IF Len(aRet[02]) >= 99
	            cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
	         Else   
	            aRet[02] := cTexto
	         EndIF   
	    EndIF
	Next nI
	IF nTam > 200 
		bTem   := .T.
		For nI := 100 To 1 STEP -1
		    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem   
		         bTem   := .F.
		         aRet[03] := SUBSTR(cTexto,1,nI-1)   
		         cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
		    EndIF
		Next nI
	EndIF                	
EndIF
IF Empty(aRet[02]) 
	aRet[01] := PADR(aRet[01],100,'*')
	aRet[02] := ''
	aRet[03] := ''
Else
	aRet[01] := PADC(aRet[01],100)
	IF Empty(aRet[03])
	   	aRet[02] := PADR(aRet[02],100,'*')
		aRet[03] := ''
	Else
		aRet[02] := PADC(aRet[02],85)
		aRet[03] := PADR(aRet[03],100,'*')
    EndIF
EndIF

Return aRet
*******************************************************************************************************************************************************
Static Function IMP_CAB(bTit)                                          

IF nCont <> 1 
	oPrn:EndPage()
EndIF
oPrn:StartPage()           
oPrn:Say(070,0050,'MARFRIG GLOBAL FODS S/A', oFonte02)
oPrn:Say(070,2100,'FL. '+Alltrim(STR(nFolha)), oFonte02)
oPrn:SayAlign( 200,050,cTitulo,oFonte04,2200,,,2)
oPrn:Say(330,100,'Data de Pagamento : '+DTOC(MV_PAR07),oFonte03)

nTam := Ret_Tam('Banco :',oFonte03)
oPrn:Say(330,1250-nTam,'Banco :',oFonte03)
nTam := Ret_Tam('Agência :',oFonte03)
oPrn:Say(430,1250-nTam,'Agência :',oFonte03)
nTam := Ret_Tam('Conta Bancária :',oFonte03)
oPrn:Say(530,1250-nTam,'Conta Bancária :',oFonte03)

oPrn:Say(330,1250,Alltrim(SA6->A6_COD)+' - '+SA6->A6_NOME,oFonte03)
oPrn:Say(430,1250,Alltrim(SA6->A6_AGENCIA)+IIF(!Empty(SA6->A6_DVAGE),'-'+SA6->A6_DVAGE,'')+' - '+SA6->A6_NOMEAGE,oFonte03)
oPrn:Say(530,1250,Alltrim(SA6->A6_NUMCON)+IIF(!Empty(SA6->A6_DVCTA),'-'+SA6->A6_DVCTA,''),oFonte03)

IF bTit      
	oPrn:Say(650,0050,'Filial',oFonte03)
	oPrn:Say(650,0160,'No. Título',oFonte03)
	oPrn:Say(650,0345,'CNPJ/CPF',oFonte03)
	oPrn:Say(650,0665,'Razão Social',oFonte03)
	oPrn:Say(650,1287,'Vencto.Real',oFonte03)
	oPrn:Say(650,1500,'Valor Bruto',oFonte03)
	oPrn:Say(650,1775,'Ajuste',oFonte03)
	oPrn:Say(650,1960,'Valor Liquido',oFonte03)
	oPrn:Line(670,50,670,2180)
	oPrn:Line(672,50,672,2180)
	nLin := 710
Else           
    nLin := 650
EndIF
	
Return
***************************************************************************************************************************************************
Static Function Imp_Texto
Local aVExtenso := {}
Local cTexto    := ''      

nLin +=100               
cTexto    := 'AUTORIZAMOS DÉBITO NA CONTA CORRENTE NÚMERO '+Alltrim(SA6->A6_NUMCON)+IIF(!Empty(SA6->A6_DVCTA),'-'+SA6->A6_DVCTA,'')+;
			 ' DA AGÊNCIA '+Alltrim(SA6->A6_AGENCIA)+Alltrim(IIF(!Empty(SA6->A6_DVAGE),'-'+SA6->A6_DVAGE,''))+' NA IMPORTÂNCIA DE'+;
			 ' R$ '+Alltrim(Transform(nTotal ,'@E 99,999,999.99'))

oPrn:Say(nLin,0600,cTexto,oFonte01)           
nLin+=70
aVExtenso := ConvTexto(nTotal)
oPrn:Say(nLin,600,aVExtenso[01],oFonte01)
IF !Empty(aVExtenso[02])
	 nLin +=70
	 oPrn:Say(nLin,600,aVExtenso[02],oFonte01)
EndIF
IF !Empty(aVExtenso[03])
	nLin +=70
	oPrn:Say(nLin,600,aVExtenso[03],oFonte01)
EndIF
nLin+=70
cTexto    := 'EM '+DTOC(MV_PAR07)+', E CREDITO NAS CTAS CONRRENTES OU QUITACÇÃO DOS TÍTULOS, CONFORME RELAÇÃO ACIMA'
oPrn:Say(nLin,0600,cTexto,oFonte01)


Return