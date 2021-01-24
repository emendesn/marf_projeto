/*/{Protheus.doc} MGFEEC57
    @author leonardo.kume
    @since 30/07/2018
    Ponto de entrada Copia Pedido
/*/
User Function MGFEEC57()

	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
    Local aAliasEE7	:= {}
    Local aAliasEE8	:= {}
    Local aButAux   := {}
    Local cNum      := ""
    Local lRet      := .t.
    Local nI        := 1
    Local lHilton   := .f.

	If 	cParam ==  "PE_COPYPED"
		aAliasEE7	:= EE7->(GetArea())
		aAliasEE8	:= EE8->(GetArea())
       
		If At("(",EE7->EE7_PEDIDO)>0
		   cNum        := AllTrim(EE7->EE7_PEDIDO)+"A"
		Else
			cNum        := M->(ALLTRIM(EE7_ZEXP))
			cNum        += iif(lHilton,'H','')
			cNum        += M->(ALLTRIM(EE7_ZANOEX)+ALLTRIM(EE7_ZSUBEX))+"A"
		EndIf
       
        While Exist57(@cNum)
            cNum := Soma1(cNum)
            If At("(",EE7->EE7_PEDIDO)>0 
                cNum:=SubStr(EE7->EE7_PEDIDO,1, At(")",EE7->EE7_PEDIDO))+Substr(cNum,Len(cNum),1)
            EndIf
        EndDo
        
        M->EE7_PEDIDO := cNum
        EE8->(RestArea(aAliasEE8))
        EE7->(RestArea(aAliasEE7))
    EndIf
    /*If cParam == "ANTES_TELA_PRINCIPAL"
        For nI := 1 to Len(aButtons)
            If aButtons[nI][1] == "S4WB005N" .and. Alltrim(RetCodUsr()) $ GetMv("MGF_EXPCPY",,"")
                aAdd(aButAux, aButtons[nI])
            ElseIf aButtons[nI][1] <> "S4WB005N"
                aAdd(aButAux, aButtons[nI])
            EndIf
        Next nI
        aButtons := aButAux
    EndIf*/

Return lRet

/*/{Protheus.doc} Exist57
    Verifica se o pedido já existe
/*/
Static Function Exist57(cNum)
    Local lRet := .F.
    Local cAliasEE7 := GetNextAlias()

    BeginSql Alias cAliasEE7
        SELECT '*'
        FROM %Table:EE7% EE7
        INNER JOIN %Table:EE8% EE8
        ON 		EE8.%notDel% AND
        EE8_FILIAL = %xFilial:EE8% AND
        EE8_PEDIDO	   = EE7_PEDIDO
        WHERE 	EE7.%notDel% AND
        EE7_FILIAL 	= %xFilial:EE7% AND
        EE7_PEDIDO	= %Exp:cNum%
    EndSql

    lRet := !(cAliasEE7)->(Eof())

    (cAliasEE7)->(DbCloseArea())

Return lRet
