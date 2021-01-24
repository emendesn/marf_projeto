/*
===========================================================================================
Programa.:              MGFEST81
Autor....:              Antonio Florêncio
Data.....:              Novembro/2020
Descricao / Objetivo:   P.E. para validacao do usuário no estorno da rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MGFEST81(_lAchou,cUsuario,cRotina)

Local _aGetArea    := GetArea()
Local _cEST81A     := " "
Local _lEST81B     := .F.

If !ExisteSx6("MGF_EST81A")
	CriarSX6("MGF_EST81A", "C", "Criar um parâmetro para incluir os programas que esta rotina ira executa.", "")
EndIf

If !ExisteSx6("MGF_EST81B")
	CriarSX6("MGF_EST81B", "L", "Ativa a rotina de validação no estorno da rotina MATA241.", ".F.")
EndIf

_cEST81A := GETMV("MGF_EST81A")
_lEST81B := GETMV("MGF_EST81B")

If !_lEST81B 
    _lAchou := .T. //Se rotina está desativada libera para todos usarem o estorno
Else
    If ALLTRIM(FUNNAME()) $ _cMGF_EST81A
        _lAchou := .T.
    Else
        dbSelectArea("ZHN")
        dbSetOrder(1)
        dbSeek(xFilial("ZHN")+cUsuario+cRotina)
        If !Eof() .And. ZHN_FILIAL = xFilial('ZHN') .And. cUsuario == ZHN_CODUSU .And. cRotina == alltrim(ZHN_ROTINA)
            _lAchou := .T.
        EndIf
    EndIf
EndIf
RestArea(_aGetArea)

Return(_lAchou)
