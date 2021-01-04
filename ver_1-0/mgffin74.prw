#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFFIN74
Autor....:              Marcelo Carneiro         
Data.....:              16/02/2018 
Descricao / Objetivo:   Relatorio de Adiantamento - Contas a Pagar
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              
=====================================================================================
*/

User Function MGFFIN74 
Local aRet		  := {}
Local aParambox	  := {}       
Private aSimNao   := {'Sim','Nao','Todos'}
Private aTipos  := {"PA", "NDF",'Todos'}
          
Private aRelImp := {}      
Private aSelFil := {}


AAdd(aParamBox, {1, "Fornecedor de:"    ,Space(tamSx3("A2_COD")[1])           , "@!",                           ,"SA2" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Fornecedor Ate:"   ,Space(tamSx3("A2_COD")[1])           , "@!",                           ,"SA2" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Loja de:"			,Space(tamSx3("A2_LOJA")[1])          , "@!",                           ,      ,, 020	, .F.	})
AAdd(aParamBox, {1, "Loja Ate:"      	,Space(tamSx3("A2_LOJA")[1])          , "@!",                           ,      ,, 020	, .F.	})
AAdd(aParamBox, {1, "Titulo Numero"    	,Space(tamSx3("E2_NUM")[1])           , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Natureza de:"      ,Space(tamSx3("A2_NATUREZ")[1])       , "@!",                           ,"SED" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Natureza Ate:"     ,Space(tamSx3("A2_NATUREZ")[1])       , "@!",                           ,"SED" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Dt. Emissao de:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Dt. Emissao Ate:"  ,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Venc. Real de:" 	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Venc. Real Ate:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {2, "PA/NDF com Saldo:"	,1                                   ,aSimNao                                    , 070	, , .F.	})
AAdd(aParamBox, {1, "Pedido de:"       ,Space(tamSx3("FIE_PEDIDO")[1])       , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Pedido Ate:"      ,Space(tamSx3("FIE_PEDIDO")[1])       , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Moeda:"           ,1                                    , "9",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Processo de:"    ,Space(tamSx3("E2_ZNUMPRO")[1])                             , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Processo Ate:"	  ,Space(tamSx3("E2_ZNUMPRO")[1])                             , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Prefixo de:"       	,Space(tamSx3("E2_PREFIXO")[1])        , "@!",                           , ,, 070	, .F.	})
AAdd(aParamBox, {1, "Prefixo Ate:"      	,Space(tamSx3("E2_PREFIXO")[1])        , "@!",                           , ,, 070	, .F.	})
AAdd(aParamBox, {2, "Selecao:"   	,1                                   ,aTipos                                    , 070	, , .F.	})

IF ParamBox(aParambox, "Filtro para Selecionar os Adiantamentos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		aSelFil := AdmGetFil(.F.,.T.,"SE2")
		If Len( aSelFil ) <= 0
		    MsgAlert('Filiais nao selecionadas !!')
		    Return  
		Endif
		Processa( {|| Carrega_Dados()  },'Aguarde...', 'Selecionando Registros',.F. )
EndIF
Return
***********************************************************************************************************************
Static Function Carrega_Dados
Local oReport   
Local aReg      := {}
Local cQuery    := ''
Local nCont     :=  0 
Local aTamSX3S	:= TamSX3("E5_PREFIXO")
Local aTamSX3N	:= TamSX3("E5_NUMERO")
Local aTamSX3P	:= TamSX3("E5_PARCELA")
Local aTamSX3C	:= TamSX3("E5_DOCUMEN")
Local nPos      := 0                
Local cPedido   := ''

Private nTotal01 := 0 
Private nTotal02 := 0 
Private nTotal03 := 0 
Private nTotal04 := 0 

dbSelectArea("SE2")
dbSetOrder(1)

dbSelectArea("SE5")
dbSetOrder(7)


aRelImp := {}      
cQuery += " Select E2_FILIAL,                   "
cQuery += "        E2_TIPO,                     "
cQuery += "        E2_FORNECE,                  "
cQuery += "        E2_LOJA,                     "
cQuery += "        A2_NOME,                     "
cQuery += "        E2_NUM,                      "
cQuery += "        E2_PARCELA,                  "
cQuery += "        E2_PREFIXO,E2_ZNUMPRO,       "
cQuery += "        E2_NATUREZ,E2_DATAAGE,       "
cQuery += "        E2_EMISSAO,                  "
cQuery += "        E2_VENCTO,                   "
cQuery += "        E2_VENCREA,                  "
cQuery += "        E2_DTBORDE,                  "   
cQuery += "        E2_VALOR,                    "
cQuery += "        E2_SALDO,                    "
cQuery += "        E2_HIST, (Select MAX(FIE_PEDIDO) PEDIDO              "
cQuery += "                         from "+RetSqlName('FIE')
cQuery += "                         Where D_E_L_E_T_  = ' '             "
cQuery += "                           AND FIE_FILIAL  = E2_FILIAL       "
cQuery += "                           AND FIE_PREFIX  = E2_PREFIXO      "
cQuery += "                           AND FIE_NUM     = E2_NUM          "
cQuery += "                           AND FIE_PARCEL  = E2_PARCELA      "
cQuery += "                           AND FIE_TIPO    = E2_TIPO         "
cQuery += "                           AND FIE_FORNEC  = E2_FORNECE      "
cQuery += "                           AND FIE_LOJA    = E2_LOJA) PEDIDO "
cQuery += " From "+RetSqlName('SE2')+" E2 , "+RetSqlName('SA2')+" A2          "
cQuery += " Where E2.D_E_L_E_T_ = ' '           "
cQuery += "   AND A2.D_E_L_E_T_ = ' '           "
cQuery += "   AND A2_FILIAL     = '      '      "
cQuery += "   AND A2_COD        = E2_FORNECE    "
cQuery += "   AND A2_LOJA       = E2_LOJA       "
cQuery += "   AND E2_FILIAL " + GetRngFil(aSelFil, "SE2")
//cQuery += IIF( !Empty(MV_PAR01)," AND E2_FILIAL  >= '"+MV_PAR01+"'","")
//cQuery += IIF( !Empty(MV_PAR02)," AND E2_FILIAL  <= '"+MV_PAR02+"'","")
cQuery += IIF( !Empty(MV_PAR01)," AND E2_FORNECE >= '"+MV_PAR01+"'","")
cQuery += IIF( !Empty(MV_PAR02)," AND E2_FORNECE <= '"+MV_PAR02+"'","")
cQuery += IIF( !Empty(MV_PAR03)," AND E2_LOJA    >= '"+MV_PAR03+"'","") 
cQuery += IIF( !Empty(MV_PAR04)," AND E2_LOJA    <= '"+MV_PAR04+"'","")
cQuery += IIF( !Empty(MV_PAR05)," AND E2_NUM      = '"+MV_PAR05+"'","")
cQuery += IIF( !Empty(MV_PAR06)," AND E2_NATUREZ >= '"+MV_PAR06+"'","") 
cQuery += IIF( !Empty(MV_PAR07)," AND E2_NATUREZ <= '"+MV_PAR07+"'","")
cQuery += IIF( !Empty(MV_PAR08)," AND E2_EMISSAO >= '"+DTOS(MV_PAR08)+"'","") 
cQuery += IIF( !Empty(MV_PAR09)," AND E2_EMISSAO <= '"+DTOS(MV_PAR09)+"'","")
cQuery += IIF( !Empty(MV_PAR10)," AND E2_VENCREA >= '"+DTOS(MV_PAR10)+"'","") 
cQuery += IIF( !Empty(MV_PAR11)," AND E2_VENCREA <= '"+DTOS(MV_PAR11)+"'","")  
IF VALTYPE(MV_PAR12) <> 'C'
    cQuery += IIF( MV_PAR12 == 1     ," AND E2_SALDO   > 0 ",IIF( MV_PAR12 == 2     ," AND E2_SALDO   = 0 ",""))
Else
    cQuery += IIF( MV_PAR12 == 'Sim'     ," AND E2_SALDO   > 0 ",IIF( MV_PAR12 == 'Nao'     ," AND E2_SALDO   = 0 ",""))
EndIF
cQuery += IIF( MV_PAR15 > 0 ," AND E2_MOEDA = "+STR(MV_PAR15),"") 
cQuery += IIF( !Empty(MV_PAR16)," AND E2_ZNUMPRO >= '"+MV_PAR16+"'","") 
cQuery += IIF( !Empty(MV_PAR17)," AND E2_ZNUMPRO <= '"+MV_PAR17+"'","")  
cQuery += IIF( !Empty(MV_PAR18)," AND E2_PREFIXO >= '"+MV_PAR18+"'","") 
cQuery += IIF( !Empty(MV_PAR19)," AND E2_PREFIXO <= '"+MV_PAR19+"'","")  
IF VALTYPE(MV_PAR20) <> 'C'
    cQuery += IIF( MV_PAR20 == 1     ," AND E2_TIPO = 'PA' ",IIF( MV_PAR20 == 2     ," AND E2_TIPO = 'NDF' ","   AND E2_TIPO       in ('PA','NDF') "))
Else
    cQuery += IIF( MV_PAR20 == 'PA'     ," AND E2_TIPO = 'PA' ",IIF( MV_PAR20 == 'NDF'     ," AND E2_TIPO = 'NDF' "," AND E2_TIPO in ('PA','NDF') "))
EndIF
cQuery += " ORDER BY E2_FILIAL,E2_VENCREA "

If Select("QRY_SE2") > 0
	QRY_SE2->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)                               
//memowrite('c:\temp\queryad.sql',cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SE2",.T.,.F.)
dbSelectArea("QRY_SE2")
QRY_SE2->(dbGoTop())
While QRY_SE2->(!Eof())
	IF !Empty(MV_PAR13)
		IF QRY_SE2->PEDIDO <  MV_PAR13
			QRY_SE2->(dbSKIP())
			Loop
		EndIF
	EndIF
	IF !Empty(MV_PAR14)
		IF QRY_SE2->PEDIDO >  MV_PAR14
			QRY_SE2->(dbSKIP())
			Loop
		EndIF
	EndIF     
	IF Alltrim(QRY_SE2->E2_TIPO) == 'PA' 
	      IF !Val_PAG()
	      	QRY_SE2->(dbSKIP())
			Loop
	      EndIF
	EndIF
	aReg := {}
	nCont++                   
	AADD(aReg,nCont)
	AADD(aReg,QRY_SE2->E2_FILIAL)
	AADD(aReg,QRY_SE2->E2_PREFIXO)
	AADD(aReg,QRY_SE2->E2_TIPO)
	AADD(aReg,QRY_SE2->E2_FORNECE)
	AADD(aReg,QRY_SE2->E2_LOJA)
	AADD(aReg,QRY_SE2->A2_NOME)
	AADD(aReg,QRY_SE2->E2_NUM)
	AADD(aReg,QRY_SE2->E2_PARCELA)
	AADD(aReg,QRY_SE2->E2_NATUREZ)
	AADD(aReg,STOD(QRY_SE2->E2_EMISSAO))
	AADD(aReg,STOD(QRY_SE2->E2_VENCREA))
	AADD(aReg,STOD(IIF(!Empty(QRY_SE2->E2_DATAAGE),QRY_SE2->E2_DATAAGE,QRY_SE2->E2_DTBORDE))  ) // Pagamento  
	AADD(aReg,Alltrim(Transform(QRY_SE2->E2_VALOR,'@E 99,999,999.99')))
	AADD(aReg,QRY_SE2->E2_HIST)
	AADD(aReg,QRY_SE2->PEDIDO)
	AADD(aReg,QRY_SE2->E2_ZNUMPRO) //PROCESSO
	AADD(aReg,Alltrim(Transform(QRY_SE2->E2_SALDO,'@E 99,999,999.99')))
	AADD(aRelImp,aReg)
	nPos := Len(aRelImp)
	SE5->(dbSeek(QRY_SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	While !SE5->(Eof()) .and. ;
		SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
		QRY_SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		
		cPedido   := ''
		If	(SE5->E5_RECPAG == "P" .AND. Alltrim(SE5->E5_TIPODOC) == "ES") .OR. ;
			(SE5->E5_RECPAG 	== "R" .and. Alltrim(SE5->E5_TIPODOC) != "ES" .AND. ;
			!(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
			SE5->(dbSkip())
			Loop
		EndIF
		//Movimento de inclusao do PA
		If Alltrim(SE5->E5_TIPODOC) == "PA"
			IF Empty(aRelImp[nPos,13])  // Data Pagamento
				aRelImp[nPos,13] := SE5->E5_DATA
			EndIF
			SE5->(dbSkip())
			Loop
		EndIF                   
		aReg := {}                   
		AADD(aReg,nCont)
		AADD(aReg,SE5->E5_FILIAL)
		AADD(aReg,"")
		AADD(aReg,SE5->E5_TIPODOC)
		AADD(aReg,SE5->E5_FORNECE)
		AADD(aReg,SE5->E5_LOJA)
		AADD(aReg,SE5->E5_BENEF)
		IF !Empty(SE5->E5_DOCUMEN)
			AADD(aReg,Substr(SE5->E5_DOCUMEN,                        aTamSX3S[1]+1,aTamSX3N[1]))
			AADD(aReg,Substr(SE5->E5_DOCUMEN,            aTamSX3S[1]+aTamSX3N[1]+1,aTamSX3P[1]))
		 	aReg[03] := Substr(SE5->E5_DOCUMEN,                                    1,aTamSX3S[1])
			//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                               
			IF SE2->(DbSeek(SE5->E5_FILIAL+Alltrim(SE5->E5_DOCUMEN)))
	        	AADD(aReg,SE2->E2_NATUREZ)
	        	cPedido := Ret_Pedido()
			Else
	        	AADD(aReg,SE5->E5_NATUREZ)
	   		EndIF
        Else
			AADD(aReg,SE5->E5_NUMERO)
			AADD(aReg,SE5->E5_PARCELA)
			aReg[03] := SE5->E5_PREFIXO
			AADD(aReg,SE5->E5_NATUREZ)
		EndIF
		AADD(aReg,SE5->E5_DTDIGIT)
		AADD(aReg,'')
		AADD(aReg,SE5->E5_DTDISPO) // Pagamento
		AADD(aReg,Alltrim(Transform(SE5->E5_VALOR,'@E 99,999,999.99')))
		AADD(aReg,SE5->E5_HISTOR)
		AADD(aReg,cPedido) //Pedido
		AADD(aReg,'') //PROCESSO
		AADD(aReg,'')
		AADD(aRelImp,aReg)            
		IF SE5->E5_MOTBX ='CMP'                
		   IF SE5->E5_SITUACAO == "C" .or. SE5->E5_TIPODOC == "ES"
	     	    nTotal03 -= SE5->E5_VALOR
	       Else                          
	            nTotal03 += SE5->E5_VALOR
	       EndIF
		EndIF                             
		SE5->(dbSKIP())
	EndDo       
	IF Alltrim(QRY_SE2->E2_TIPO) =='NDF'
	     nTotal01 += QRY_SE2->E2_SALDO
	EndIF
	IF Alltrim(QRY_SE2->E2_TIPO) =='PA'
	     nTotal02+= QRY_SE2->E2_VALOR
	EndIF                             
	nTotal04 += QRY_SE2->E2_SALDO
	QRY_SE2->(dbSKIP())
EndDo
                           
oReport := RelFIN74()
oReport:PrintDialog()

Return
***********************************************************************************************************************
Static Function RelFIN74

Local oReport
Local oImp
Local oFinal

oReport := TReport():New("SE2","Relatorio de Adiantamentos",,{|oReport| PrintReport(oReport)},"Relatorio de Adiantamentos")
oReport:SetLandscape()
//oReport:SetPortrait()
oIMP   := TRSection():New(oReport,"Adiantamentos","SE2")
oFinal := TRSection():New(oReport,"Totais","SE2")


TRCell():New(oIMP,"r001",,"FILIAL"       ,,TamSX3("E2_FILIAL")[1]+1,.F.,)
TRCell():New(oIMP,"r002",,"PREF"      ,,TamSX3("E2_PREFIXO")[1],.F.,)
TRCell():New(oIMP,"r003",,"TIPO"         ,,TamSX3("E2_TIPO")[1],.F.,)
TRCell():New(oIMP,"r004",,"COD FORN."    ,,TamSX3("E2_FORNECE")[1],.F.,)
TRCell():New(oIMP,"r005",,"LOJA"         ,,TamSX3("E2_LOJA")[1],.F.,)
TRCell():New(oIMP,"r006",,"RAZ.SOCIAL"   ,,TamSX3("A2_NOME")[1],.F.,)
TRCell():New(oIMP,"r007",,"TITULO"       ,,TamSX3("E2_NUM")[1],.F.,)
TRCell():New(oIMP,"r008",,"PARC"      ,,TamSX3("E2_PARCELA")[1],.F.,)
TRCell():New(oIMP,"r009",,"NAT"          ,,TamSX3("E2_NATUREZ")[1],.F.,)
TRCell():New(oIMP,"r010",,"EMISS�O"      ,,TamSX3("E2_EMISSAO")[1]+3,.F.,)
TRCell():New(oIMP,"r011",,"VENC.REAL"    ,,TamSX3("E2_VENCREA")[1]+3,.F.,)
TRCell():New(oIMP,"r012",,"DAT.MOV."    ,,TamSX3("E2_DTBORDE")[1]+3,.F.,)
TRCell():New(oIMP,"r013",,"VLR TITULO" ,,TamSX3("E2_VALOR")[1],.F.,)
TRCell():New(oIMP,"r014",,"HISTORICO"    ,,TamSX3("E2_HIST")[1],.F.,)
TRCell():New(oIMP,"r015",,"PEDIDO",,10,.F.,)
TRCell():New(oIMP,"r016",,"PROCESSO"     ,,tamSx3("E2_ZNUMPRO")[1],.F.,)
TRCell():New(oIMP,"r017",,"SALDO"        ,,TamSX3("E2_SALDO")[1],.F.,)

TRCell():New(oFinal,"texto",,""       ,,50,.F.,)
TRCell():New(oFinal,"valor",,""       ,,20,.F.,)



Return oReport

***********************************************************************************************************************
Static Function PrintReport(oReport)
Local nI   := 0
Local nX   := 0                     
Local nReg := -1

oReport:SetMeter(LEN(aRelImp))
For nI := 1 To LEN(aRelImp)
	IF oReport:Cancel()
		Exit
	Endif
	oReport:IncMeter()       
	IF nReg <> aRelImp[nI,01]
		IF nI <> 1
			oReport:ThinLine()
        	oReport:Section(1):Finish()
		EndIF
		oReport:Section(1):Init()     
		nReg := aRelImp[nI,01]
	EndIF
	oReport:Section(1):Cell("r001"):SetBlock({|| aRelImp[nI,02] })
	oReport:Section(1):Cell("r002"):SetBlock({|| aRelImp[nI,03] })
	oReport:Section(1):Cell("r003"):SetBlock({|| aRelImp[nI,04] })
	oReport:Section(1):Cell("r004"):SetBlock({|| aRelImp[nI,05] })
	oReport:Section(1):Cell("r005"):SetBlock({|| aRelImp[nI,06] })
	oReport:Section(1):Cell("r006"):SetBlock({|| aRelImp[nI,07] })
	oReport:Section(1):Cell("r007"):SetBlock({|| aRelImp[nI,08] })
	oReport:Section(1):Cell("r008"):SetBlock({|| aRelImp[nI,09] })
	oReport:Section(1):Cell("r009"):SetBlock({|| aRelImp[nI,10] })
	oReport:Section(1):Cell("r010"):SetBlock({|| aRelImp[nI,11] })
	oReport:Section(1):Cell("r011"):SetBlock({|| aRelImp[nI,12] })
	oReport:Section(1):Cell("r012"):SetBlock({|| aRelImp[nI,13] })
	oReport:Section(1):Cell("r013"):SetBlock({|| aRelImp[nI,14] })
	oReport:Section(1):Cell("r014"):SetBlock({|| aRelImp[nI,15] })
	oReport:Section(1):Cell("r015"):SetBlock({|| aRelImp[nI,16] })
	oReport:Section(1):Cell("r016"):SetBlock({|| aRelImp[nI,17] })
	oReport:Section(1):Cell("r017"):SetBlock({|| aRelImp[nI,18] })
	oReport:Section(1):PrintLine()                                 
    
NEXT
oReport:ThinLine()
oReport:Section(1):Finish()

oReport:Section(2):Init()     
oReport:ThinLine()
oReport:Section(2):Cell("texto"):SetBlock({|| 'NDF EM ABERTO' })
oReport:Section(2):Cell("valor"):SetBlock({|| Transform(nTotal01 ,'@E 99,999,999.99') })
oReport:Section(2):PrintLine()                                 
oReport:Section(2):Cell("texto"):SetBlock({|| 'VALOR TOTAL DE ADTO FEITOS ' })
oReport:Section(2):Cell("valor"):SetBlock({|| Transform(nTotal02 ,'@E 99,999,999.99') })
oReport:Section(2):PrintLine()                                 
oReport:Section(2):Cell("texto"):SetBlock({|| 'VALOR TOTAL DE ADTO COMPESADOS' })
oReport:Section(2):Cell("valor"):SetBlock({|| Transform(nTotal03 ,'@E 99,999,999.99') })
oReport:Section(2):PrintLine()                                 
oReport:Section(2):Cell("texto"):SetBlock({|| 'VALOR TOTAL DE SALDOS DE ADTO EM ABERTO/ SALDO NDF' })
oReport:Section(2):Cell("valor"):SetBlock({|| Transform(nTotal04 ,'@E 99,999,999.99') })
oReport:Section(2):PrintLine()                                 


oReport:Section(2):Finish()


Return oReport
**************************************************************************************************************************
Static Function Val_PAG
Local nRet := .T.
Local nCont := 0 

IF SE5->(!dbSeek(QRY_SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	nRet := .F.
Else
	While !SE5->(Eof()) .and. ;
		SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
		QRY_SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		If SE5->E5_TIPODOC == "PA"
			nCont++
			SE5->(dbSkip())
			Loop
		EndIF
		SE5->(dbSKIP())
	EndDo
EndIF
IF nCont/2 == INT(nCont/2)
	nRet := .F.
EndIF

Return nRet 
*************************************************************************************************************************************
Static Function Ret_Pedido()
Local cRet := ''

cQuery  := " SELECT Max(D1_PEDIDO) RETMAX "
cQuery  += " FROM "+RetSqlName('SD1')
cQuery  += " WHERE D_E_L_E_T_ = ' ' "
cQuery  += "   AND D1_FILIAL  ='"+SE2->E2_FILIAL+"'"         
cQuery  += "   AND D1_DOC     ='"+SE2->E2_NUM+"'"         
cQuery  += "   AND D1_SERIE   ='"+SE2->E2_PREFIXO+"'"         
cQuery  += "   AND D1_FORNECE ='"+SE2->E2_FORNECE+"'"         
cQuery  += "   AND D1_LOJA    ='"+SE2->E2_LOJA+"'"         

If Select("QRY_MAX") > 0
	QRY_MAX->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_MAX",.T.,.F.)
dbSelectArea("QRY_MAX")
QRY_MAX->(dbGoTop())
IF !QRY_MAX->(EOF()) .And. !Empty(QRY_MAX->RETMAX)
 	cRet    :=  QRY_MAX->RETMAX
EndIF
If Select("QRY_MAX") > 0
	QRY_MAX->(dbCloseArea())
EndIf
                
Return cRet          