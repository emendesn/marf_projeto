/*
=====================================================================================
Programa.:              MGFGCT02
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada do ponto de entrada CNTA300
Doc. Origem:            Contrato - GAP MGFGCT02
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
USER FUNCTION CNTA300
	Local aParam	    := {}
	Local cIdPonto      := ""
	Local cIdForm       := ""
	Local xRet
	Local cAliasCN9
	Local lContinua

	cAliasCN9	:= "CN9"

	//So permite a execucao do P.E. se houver execucao do update.
	lContinua	:= (cAliasCN9)->(FieldPos('CN9_ZTOTDE'))

	xRet	:= .T.

	If ( lContinua )

		If ( (IsInCallStack("CN300INVEN")) .OR. ( (ALTERA) .AND. ((cAliasCN9)->(CN9_ESPCTR) == "2")) )

			//Permite a chamada do P.E. SOMENTE se for executada a rotina de venda.

			xRet	:= U_MGFGCT03()

		EndIf

	EndIf

     //Tratamento Contrato Salesforce
	 If ( lContinua )

		If ( (IsInCallStack("CN300INVEN")) .OR. ( (ALTERA) .AND. ((cAliasCN9)->(CN9_ESPCTR) == "2")) )

			//Permite a chamada do P.E. SOMENTE se for executada a rotina de venda.
			xRet	:= U_MGFFINX7("1")

		EndIf

	EndIf

    //Tratamento Revisão do Contrato  Salesforce
    if ( FunName() == "CNTA300" .AND. (cAliasCN9)->(CN9_ESPCTR) == "2" )

		aParam := PARAMIXB
	    If aParam <> NIL
        	cIdPonto := aParam[2]
			cIdForm  := aParam[3]
        endif

		if (cIdPonto == "FORMPOS" .AND.  cIdForm == "CALC_CNS") //Formulário pos revisão
       		xRet	:= U_MGFFINX7("2")
		endif
	endif

Return xRet