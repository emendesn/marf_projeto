#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER chr(13)+chr(10)

STATIC cCodFav	  := ""	//Codigo do Favorecido 
STATIC cLojFav	  := ""	//Codigo da Loja
STATIC cNomFav	  := ""	//Nome do Favorecido
STATIC cCodPec	  := ""	//Codigo do Pecuarista                                                 
STATIC cLojPec    := "" //Loja do Pecuarista
STATIC cNomPec    := "" //Nome do Pecuarista
STATIC cBcoPec    := "" //Banco
STATIC cAgePec    := "" //Agencia
STATIC cCtaPec    := "" //Conta
STATIC cTipFilPec := "" //Tipo FIL Pecuarista 
STATIC cTipCtaPec := "" //Tipo CTA Pecurarista
                                              
/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para cadastro de fornecedor x favorecido
=====================================================================================
*/

User Function MGFFIN02() 
Local aArea		:= GetArea()
Local aIndex 	:= {} 
Local cFiltro 	:= "ZA_CODFORN == '" + SA2->A2_COD + "' " 

//Expressao do Filtro 
Private aRotina := {	{ "Pesquisar" 	, "PesqBrw" 	, 0 , 1 },; 
						{ "Visualizar" 	, "AxVisual" 	, 0 , 2 },; 
						{ "Incluir" 	, "u_F02Inclui"	, 0 , 3 },; 
						{ "Alterar" 	, "AxAltera"	, 0 , 4 },; 						
						{ "Excluir" 	, "u_uAxDel" 	, 0 , 5 }} 

Private bFiltraBrw 	:= { || FilBrowse( "SZA" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro 	:= "Cadastro de Favorecido" 

Eval( bFiltraBrw ) 							//Efetiva o Filtro antes da Chamada a 

mBrowse( 6 , 1 , 22 , 75 , "SZA" ) 

EndFilBrw( "SZA" , @aIndex ) 				

//Finaliza o Filtro         
RestArea(aArea)

Return( NIL )


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de inclusao de favorecidos
=====================================================================================
*/

User Function F02Inclui (cAlias, nReg, nOpc) 
Local aArea		:= GetArea()      
Local nRegA2	:= SA2->(Recno())

AxInclui(cAlias,nReg,nOpc,,,,)
                
SA2->(DbGoto(nRegA2))
 
RestArea(aArea)
                        
Return
  

/*
=========================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina para retorno da descrição de campos no inicializador mbrowse
==========================================================================================
*/
User Function F02RetNom (cCampo) 
Local aArea		:= GetArea()      
Local cRet		:= ""
Local nRegA2	:= SA2->(Recno()) 

                                                                                   
If cCampo 	  == "A2_NOME"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_NOME")                                 
ElseIf cCampo == "A2_BANCO"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_BANCO")                                 
ElseIf cCampo == "A2_AGENCIA"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_AGENCIA")                                 
ElseIf cCampo == "A2_NUMCON"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_NUMCON")                                 
ElseIf cCampo == "A2_DVAGE"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_DVAGE")
ElseIf cCampo == "A2_DVCTA"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_DVCTA")
ElseIf cCampo == "A2_CGC"
	cRet		:=POSICIONE("SA2",1,XFILIAL("SA2")+SZA->ZA_CODFAV+SZA->ZA_LOJFAV,"A2_CGC")
Endif
 
RestArea(aArea)

SA2->(DbGoto(nRegA2))
                        
Return(cRet)


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona opcao no menu de fornecedores
=====================================================================================
*/
User Function FIN02Menu(aRotina)
Local aRotina	:= {}

aAdd(aRotina,{"MGF-Cad.Favorecido"			,"u_MGFFIN02"	, 0, 3, 0, .F. }) 	//"Legenda"

Return(aRotina)


User Function uAxDel()
Local aArea	:= GetArea()

	If U_FIN02Exc(SZA->ZA_CODFORN, SZA->ZA_LOJFORN ,SZA->ZA_CODFAV,SZA->ZA_LOJFAV) 
		RecLock("SZA")        
			SZA->(DbDelete())
		SZA->(MsUnlock())
		
	Endif
	                    
RestArea(aArea)

Return


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Gatilho para retorno das informacoes do fornecedor
=====================================================================================
*/
User Function FIN02Gatilho(xCod, xLoja)
Local aArea		:= GetArea()
Local cChave 	:= ""

DEFAULT xCod	:= ""
DEFAULT xLoja	:= "" 

cChave := xCod

If !Empty(xLoja)
	cChave += xLoja
Endif

DbSelectArea("SA2")
DbSetOrder(1)

If DbSeek(xFilial("SA2")+cChave)
     
	M->ZA_NOMFAV	:= SA2->A2_NOME
	M->ZA_BANCO		:= SA2->A2_BANCO
	M->ZA_AGENCIA	:= SA2->A2_AGENCIA
	M->ZA_DVAGE 	:= SA2->A2_DVAGE
	M->ZA_CONTA		:= SA2->A2_NUMCON
	M->ZA_DVCTA 	:= SA2->A2_DVCTA
	M->ZA_CGC	 	:= SA2->A2_CGC

Endif
                            
RestArea(aArea)

Return(M->ZA_NOMFAV)   


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina validacao da digitacao do favorecido
=====================================================================================
*/
User Function FIN02Valid(xCod, xLoja, xCodFav, xLojFav)
Local aArea		:= {SA2->(GetArea()),SZA->(GetArea()),GetArea()}
Local cChave 	:= ""
Local lRet		:= .T.

cChave :=  xLojFav

If !Empty(xLojFav)
	
	cChave := xCod+ xLoja+ xCodFav+ xLojFav

	DbSelectArea("SZA")
	DbSetOrder(1)

	If DbSeek(xFilial("SZA")+cChave)
  		Alert("Favorecido cadastrado para este fornecedor!")  
		lRet	:= .F.
    Endif 
	
	If lRet
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+xCodFav+ xLojFav))
			If SA2->A2_MSBLQL == "1"
				lRet := .F.
				Alert("Fornecedor bloqueado para uso.")
			Endif
		Endif
	Endif			
Endif       

aEval(aArea,{|x| RestArea(x)})

Return(lRet) 

/*
=========================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina que valida o preenchimento do fornecedor antes do favorecido
=========================================================================================
*/

User Function ValidFav(xCod, xLoja, xCodFav, xLojFav)
Local aArea		:= GetArea()
Local cChave 	:= ""
Local lRet		:= .T.
LOCAL cQuery	:= ""
DEFAULT xCod	:= ""
DEFAULT xLoja	:= "" 
DEFAULT xCodFav	:= ""
DEFAULT xLojFav	:= ""

If !IsInCallStack('U_MGFCOM15')
	If Empty(xcod) .OR. Empty(xLoja) 
		Alert("Para preencher o campo é necessário informar primeiro o Código/Loja do fornecedor!")
		M->E2_ZCODFAV 	:= space(6)
		M->E2_ZLOJFAV	:= space(2)
		M->E2_ZNOMFAV	:= space(60)
		M->E2_ZBCOFAV	:= Space(Len("E2_ZBCOFAV"))
		M->E2_ZAGEFAV	:= Space(Len("E2_ZAGEFAV"))
		M->E2_ZDVAFAV	:= Space(Len("E2_ZDVAFAV"))
		M->E2_ZCTAFAV	:= Space(Len("E2_ZCTAFAV"))
		M->E2_ZDVCFAV	:= Space(Len("E2_ZDVCFAV"))
		M->E2_ZCGCFAV	:= Space(Len("E2_ZCGCFAV"))
	ElseIf Empty(xCodFav)
		M->E2_ZCODFAV 	:= space(6)
		M->E2_ZLOJFAV	:= space(2)
		M->E2_ZNOMFAV	:= space(60)
		M->E2_ZBCOFAV	:= Space(Len("E2_ZBCOFAV"))
		M->E2_ZAGEFAV	:= Space(Len("E2_ZAGEFAV"))
		M->E2_ZDVAFAV	:= Space(Len("E2_ZDVAFAV"))
		M->E2_ZCTAFAV	:= Space(Len("E2_ZCTAFAV"))
		M->E2_ZDVCFAV	:= Space(Len("E2_ZDVCFAV"))
		M->E2_ZCGCFAV	:= Space(Len("E2_ZCGCFAV"))
	Else
		
	//	cChave := xCod+ xLoja+ xCodFav+xLojFav  - Rafael Garcia - alteração para desconsiderar a loja do fornecedor conforme  
	//solicitação do usuário Mauricio e validado pelo analista Eric da Totvs 
		cQuery := " SELECT SZA.ZA_MSBLQL "
		cQuery += " FROM "+RetSQLName("SZA") + "  SZA  "
		cQuery += " WHERE SZA.ZA_FILIAL = '" + xFilial("SZA") + "' AND SZA.ZA_CODFORN = '" + xCod + "'"  
		cQuery += " AND SZA.D_E_L_E_T_= ' ' "
		cQuery += " and SZA.ZA_CODFAV= '"+xCodFav+"' AND SZA.ZA_LOJFAV='"+xLojFav+"'"
	

		cAlias2:= CriaTrab(Nil,.F.)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias2, .F., .T.)
 
		(cAlias2)->(DbGoTop())
		If (cAlias2)->(Eof())

			lRet := .F.
	  		Alert("Favorecido não cadastrado para este fornecedor!")  
		Else
			If (cAlias2)->ZA_MSBLQL == "1" .or. Posicione("SA2",1,xFilial("SA2")+M->E2_ZCODFAV+M->E2_ZLOJFAV,"A2_MSBLQL") == "1"
				lRet := .F.
		  		Alert("Favorecido bloqueado para uso!")  
		  	Endif
	    Endif 
	    (cAlias2)->(DbCloseArea())
	    If !lRet
			M->E2_ZCODFAV 	:= space(6)
			M->E2_ZLOJFAV	:= space(2)
			M->E2_ZNOMFAV	:= space(60)
			M->E2_ZBCOFAV	:= Space(Len("E2_ZBCOFAV"))
			M->E2_ZAGEFAV	:= Space(Len("E2_ZAGEFAV"))
			M->E2_ZDVAFAV	:= Space(Len("E2_ZDVAFAV"))
			M->E2_ZCTAFAV	:= Space(Len("E2_ZCTAFAV"))
			M->E2_ZDVCFAV	:= Space(Len("E2_ZDVCFAV"))
			M->E2_ZCGCFAV	:= Space(Len("E2_ZCGCFAV"))
		Endif	
	Endif 
EndIf
RestArea(aArea)

Return(lRet)                                                                        


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Cadastro de Favorecidos por Fornecedor
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Consulta especifica para chamada da rotina no F3 do campo
=====================================================================================
*/
User Function FIN02F3(xCodFor, xLojFor)
Local aArea	:= GetArea() 
Local bRet := .F.
 
//Private nPosProd   	:= aScan(aHeader, {|x| alltrim(x[2]) == "ZA_CODFAV"})
//Private nPosMarca  	:= aScan(aHeader, {|x| alltrim(x[2]) == "ZA_LOJFAV"})
Private cCodigo    	:= "" //Alltrim(&(ReadVar()))
Private cLojaFor	:= ""
DEFAULT xCodFor 	:= ""
DEFAULT xLojFor		:= ""

cCodFav	:= ""	//Codigo do Favorecido 
cLojFav	:= ""	//Codigo da Loja
cNomFav	:= ""	//Nome do Favorecido
                        
cCodigo 	:= xCodFor
cLojaFor	:= xLojFor
  
bRet := FiltraZA(xCodFor, xLojFor)

RestArea( aArea )
 
Return(bRet)
 
Static Function FiltraZA(cCodigo, cLojaFor)
Local aArea			:= GetArea() 
Local 	cQuery		:= ""
Local 	oLstSB1 	:= nil
Private oDlgZZY 	:= nil
Private _bRet 		:= .F.
Private aDadosSZA 	:= {}
                                          
If Empty(cCodigo+cLojaFor) 
	Alert("Favor informar Fornecedor!")
	Return
Endif

//Query de marca x produto x referencia

//Rafael Garcia - alteração na query para desconsiderar a loja do fornecedor conforme solicitação do usuário Mauricio e 
//validado pelo analista Eric da Totvs 
cQuery := " SELECT ZA_CODFAV, ZA_LOJFAV, A2_BANCO, A2_AGENCIA, A2_NUMCON, A2_NOME "
cQuery += " FROM "+RetSQLName("SZA") + "  SZA  "
cQuery += " INNER JOIN "+RetSQLName("SA2") + "  SA2 ON SA2.A2_COD = SZA.ZA_CODFAV AND SA2.A2_LOJA = SZA.ZA_LOJFAV   "
cQuery += " WHERE SZA.ZA_FILIAL = '" + xFilial("SZA") + "' AND SZA.ZA_CODFORN = '" + cCodigo + "'" //+ " AND SZA.ZA_LOJFORN = '" + cLojaFor + "'" 
cQuery += " AND SZA.D_E_L_E_T_= ' ' "
cQuery += " AND SA2.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY SZA.ZA_CODFORN+ZA_LOJFORN+ZA_CODFAV+ZA_LOJFAV "

cAlias1:= CriaTrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 
(cAlias1)->(DbGoTop())
If (cAlias1)->(Eof())
	Aviso( "Cadastro de Favorecido", "Não existe dados a consultar", {"Ok"} )
	Return .F.
Endif
 
Do While (cAlias1)->(!Eof())
 
aAdd( aDadosSZA, { (cAlias1)->ZA_CODFAV, (cAlias1)->ZA_LOJFAV, (cAlias1)->A2_NOME, (cAlias1)->A2_BANCO, (cAlias1)->A2_AGENCIA, (cAlias1)->A2_NUMCON} )
 
(cAlias1)->(DbSkip())
 
Enddo
 
DbCloseArea()
 
nList := aScan(aDadosSZA, {|x| alltrim(x[3]) == alltrim(cCodigo)})
 
iif(nList = 0,nList := 1,nList)
 
//--Montagem da Tela
Define MsDialog oDlgZZY Title "Consulta de Favorecidos" From 0,0 To 280, 500 Of oMainWnd Pixel
 
@ 5,5 LISTBOX oLstZZY ;
VAR lVarMat ;
Fields HEADER "Codigo", "Loja", "Nome", "Banco", "Agencia", "Conta" ;
SIZE 245,110 On DblClick ( ConfZZY(oLstZZY:nAt, @aDadosSZA, @_bRet) ) ;
OF oDlgZZY PIXEL
 
oLstZZY:SetArray(aDadosSZA)
oLstZZY:nAt := nList
oLstZZY:bLine := { || {aDadosSZA[oLstZZY:nAt,1], aDadosSZA[oLstZZY:nAt,2], aDadosSZA[oLstZZY:nAt,3], aDadosSZA[oLstZZY:nAt,4], aDadosSZA[oLstZZY:nAt,5], aDadosSZA[oLstZZY:nAt,6]}}
 
DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfZZY(oLstZZY:nAt, @aDadosSZA, @_bRet) ENABLE OF oDlgZZY
DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY
 
Activate MSDialog oDlgZZY Centered
                                
 
RestArea(aArea)
 
Return _bRet
 
Static Function ConfZZY(_nPos, aDadosSZA, _bRet)
 
cCodigo := aDadosSZA[_nPos,1]
 
//aCols[n,nPosMarca] := cCodigo
 
cCodFav := aDadosSZA[_nPos,1]    //Não esquecer de alimentar essa variável quando for f3 pois ela e o retorno e se estiver com valor diferente complica.
cLojFav	:= Alltrim(aDadosSZA[_nPos,2])  
cNomFav	:= Alltrim(aDadosSZA[_nPos,3])  

_bRet := .T.
 
oDlgZZY:End()
 
Return

User Function FIN02Cod()

Return(cCodFav)

User Function FIN02Loj()

Return(cLojFav)

User Function FIN02Nom()

Local aArea := GetArea()
Local aAreaA2 := SA2->( GetArea() )

If !Empty( cCodFav+cLojFav )
	//If !Empty( Posicione("SA2",1,xFilial("SA2")+cCodFav+cLojFav,"A2_BANCO") )
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+cCodFav+cLojFav))
		M->E2_ZBCOFAV := SA2->A2_BANCO
		M->E2_ZAGEFAV := SA2->A2_AGENCIA
		M->E2_ZDVAFAV := SA2->A2_DVAGE
		M->E2_ZCTAFAV := SA2->A2_NUMCON
		M->E2_ZDVCFAV := SA2->A2_DVCTA
		M->E2_ZCGCFAV := SA2->A2_CGC
	EndIf
EndIf

RestArea(aArea)
SA2->( RestArea(aAreaA2) )

Return(cNomFav)              


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Validar a exclusao do favorecido
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function FIN02Exc(cCodFor,cLojFor,cCodFav,cLojFav) 
Local aArea			:= GetArea()
Local lRet			:= .T.            
Local cQuery		:= ""
Local _cAliasSL1	:= GetNextAlias()  

DEFAULT cCodFor	:= ""
DEFAULT cLojFor	:= ""
DEFAULT cCodFav	:= ""
DEFAULT cLojFav	:= ""
 
//Query de marca x produto x referencia
cQuery := " SELECT E2_NUM, E2_FORNECE, E2_LOJA "
cQuery += " FROM "+RetSQLName("SE2") + " SE2  "
cQuery += " WHERE SE2.E2_FILIAL  = '" + xFilial("SE2") 	+ "' "
cQuery += " AND   SE2.E2_FORNECE = '" + cCodFor 		+ "'" 
cQuery += " AND   SE2.E2_LOJA    = '" + cLojFor		 	+ "'" 
cQuery += " AND   SE2.E2_ZCODFAV = '" + cCodFav	 		+ "'" 
cQuery += " AND   SE2.E2_ZLOJFAV = '" + cLojFav		 	+ "'" 
cQuery += " AND SE2.D_E_L_E_T_= ' ' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAliasSL1)
 
If !(_cAliasSL1)->( Eof() )
	Aviso( "Cadastro de Favorecido", "Existe títulos a pagar em nome deste favorecido. Registro não pode ser excluido!", {"Ok"} )
	lRet := .F.
Endif

DbCloseArea()

RestArea(aArea)

Return(lRet)


/*
=====================================================================================
Programa............: MGFFIN02
Autor...............: Barbieri       
Data................: 20/04/2018 
Descricao / Objetivo: Validar conta de pecuarista
Doc. Origem.........: Contrato - GAP MGFFIN02
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Consulta especifica para chamada da rotina no F3 do campo
=====================================================================================
*/
User Function FIN02F3p(xCodFor, xLojFor)
Local aArea	:= GetArea() 
Local bRet := .F.
 
//Private nPosProd   	:= aScan(aHeader, {|x| alltrim(x[2]) == "A2_COD"})
//Private nPosMarca  	:= aScan(aHeader, {|x| alltrim(x[2]) == "A2_LOJA"})
Private cCodigo    	:= "" //Alltrim(&(ReadVar()))
Private cLojaFor	:= ""
DEFAULT xCodFor 	:= ""
DEFAULT xLojFor		:= ""

cCodPec	:= ""	//Codigo do Pecuarista
cLojPec	:= ""	//Codigo da Loja
cNomPec	:= ""	//Nome do Pecuarista
cBcoPec := ""   //Banco Pecuarista
cAgePec := ""   //Agencia Pecuarista
cCtaPec := ""   //Conta Pecuarista

                        
cCodigo 	:= xCodFor
cLojaFor	:= xLojFor
  
bRet := FiltrPEC(xCodFor, xLojFor)

RestArea( aArea )
 
Return(bRet)
 
Static Function FiltrPEC(cCodigo, cLojaFor)
Local aArea			:= GetArea() 
Local 	cQuery		:= ""
Private oDlgPEC 	:= nil
Private _bRet 		:= .F.
Private aDadosPEC 	:= {}
                                          
If Empty(cCodigo+cLojaFor) 
	Alert("Favor informar Fornecedor!")
	Return
Endif

//Barbieri - criação de query para buscar o pecuarista pelo A2_TIPO = 'F' E A2_GRPTRIB IN ('FPF','FRR') 
//validado pelo analista Eric da Totvs 
cQuery := " SELECT DISTINCT FIL_FORNEC, FIL_LOJA, FIL_BANCO, FIL_AGENCI, FIL_CONTA, A2_NOME, FIL_TIPO, FIL_TIPCTA  "
cQuery += " FROM "+RetSQLName("SA2") + "  SA2,  " + RetSQLName("FIL") + " FIL "
cQuery += " WHERE SA2.A2_FILIAL = FIL.FIL_FILIAL "
cQuery += " AND SA2.A2_COD = FIL.FIL_FORNEC "
cQuery += " AND SA2.A2_LOJA = FIL.FIL_LOJA "
cQuery += " AND SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.A2_COD = '" + cCodigo + "'" //+ " AND SA2.A2_LOJA = '" + cLojaFor + "'"
cQuery += " AND ( (SA2.A2_TIPO = 'F' AND SA2.A2_TIPORUR = 'F' AND SA2.A2_GRPTRIB IN ('FPF','FRR')  )   " 
cQuery += " OR    (SA2.A2_TIPO = 'J' AND SA2.A2_TIPORUR = 'J' AND SA2.A2_GRPTRIB IN ('FPJ','FRR')  ) ) "
cQuery += " AND SA2.D_E_L_E_T_= ' ' "
cQuery += " AND FIL.D_E_L_E_T_= ' ' "
cQuery += " ORDER BY FIL.FIL_FORNEC

cAlias1:= CriaTrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 
(cAlias1)->(DbGoTop())
If (cAlias1)->(Eof())
	Aviso( "Pecuaristas", "Não existem contas bancárias cadastradas para o pecuarista.", {"Ok"} )
	Return .F.
Endif
 
Do While (cAlias1)->(!Eof())
 
aAdd( aDadosPEC, { (cAlias1)->FIL_FORNEC, (cAlias1)->FIL_LOJA, (cAlias1)->A2_NOME, (cAlias1)->FIL_BANCO, (cAlias1)->FIL_AGENCI, (cAlias1)->FIL_CONTA, (cAlias1)->FIL_TIPO, (cAlias1)->FIL_TIPCTA} )
 
(cAlias1)->(DbSkip())
 
Enddo
 
DbCloseArea()
 
nList := aScan(aDadosPEC, {|x| alltrim(x[3]) == alltrim(cCodigo)})
 
iif(nList = 0,nList := 1,nList)
 
//--Montagem da Tela
Define MsDialog oDlgPEC Title "Consulta de Pecuaristas" From 0,0 To 280, 500 Of oMainWnd Pixel
 
@ 5,5 LISTBOX oLstPEC ;
VAR lVarMat ;
Fields HEADER "Codigo", "Loja", "Nome", "Banco", "Agencia", "Conta" ;
SIZE 245,110 On DblClick ( ConfPEC(oLstPEC:nAt, @aDadosPEC, @_bRet) ) ;
OF oLstPEC PIXEL
 
oLstPEC:SetArray(aDadosPEC)
oLstPEC:nAt := nList
oLstPEC:bLine := { || {aDadosPEC[oLstPEC:nAt,1], aDadosPEC[oLstPEC:nAt,2], aDadosPEC[oLstPEC:nAt,3], aDadosPEC[oLstPEC:nAt,4], aDadosPEC[oLstPEC:nAt,5], aDadosPEC[oLstPEC:nAt,6]}}
 
DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfPEC(oLstPEC:nAt, @aDadosPEC, @_bRet) ENABLE OF oDlgPEC
DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgPEC:End() ENABLE OF oDlgPEC
 
Activate MSDialog oDlgPEC Centered
                                
 
RestArea(aArea)
 
Return _bRet
 
Static Function ConfPEC(_nPos, aDadosPEC, _bRet)
 
cCodigo := aDadosPEC[_nPos,1]
 
//aCols[n,nPosMarca] := cCodigo
 
cCodPec     := aDadosPEC[_nPos,1]    //Não esquecer de alimentar essa variável quando for f3 pois ela e o retorno e se estiver com valor diferente complica.
cLojPec	    := Alltrim(aDadosPEC[_nPos,2])  
cNomPec	    := Alltrim(aDadosPEC[_nPos,3])  
cBcoPec	    := Alltrim(aDadosPEC[_nPos,4])
cAgePec	    := Alltrim(aDadosPEC[_nPos,5])
cCtaPec  	:= Alltrim(aDadosPEC[_nPos,6])
cTipFilPec	:= Alltrim(aDadosPEC[_nPos,7])
cTipCtaPec	:= Alltrim(aDadosPEC[_nPos,8])

_bRet := .T.
 
oDlgPEC:End()
 
Return

User Function FIN02Pec()

Local aArea := GetArea()
Local aAreaFIL := FIL->( GetArea() )

If !Empty( cCodPec )
	//If !Empty( Posicione("SA2",1,xFilial("SA2")+cCodFav+cLojFav,"A2_BANCO") )
	FIL->(dbSetOrder(1))
	If FIL->(dbSeek(xFilial("FIL")+cCodPec+cLojPec+cTipFilPec+cBcoPec+cAgePec)) //FIL_FILIAL+FIL_FORNEC+FIL_LOJA+FIL_TIPO+FIL_BANCO+FIL_AGENCI+FIL_CONTA
		M->E2_FORAGE := FIL->FIL_AGENCI //SA2->A2_AGENCIA
		M->E2_FAGEDV := FIL->FIL_DVAGE //SA2->A2_DVAGE
		M->E2_FORBCO := FIL->FIL_BANCO //SA2->A2_BANCO
		M->E2_FORCTA := FIL->FIL_CONTA //SA2->A2_NUMCON
		M->E2_FCTADV := FIL->FIL_DVCTA //SA2->A2_DVCTA
		If cTipCtaPec == '1'
			M->E2_XFINALI := "01"
		Else
			M->E2_XFINALI := "11"
		Endif
	EndIf
EndIf

RestArea(aArea)
FIL->( RestArea(aAreaFIL) )

Return(cCodPec)

