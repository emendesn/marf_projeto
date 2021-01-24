/*
=====================================================================================
Programa............: CTSETFIL
Autor...............: Mauricio Gresele
Data................: Fev/2018
Descricao / Objetivo: Ponto de entrada para poder manipular as filiais selecionada. Rotina ADMGETFIL
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function CTSETFIL()

Local aFil := ParamIxb[1]

If FindFunction("U_MGFCTB14") .and. IsInCallStack("U_MGFCTB06")
	aFil := U_MGFCTB14()
Endif	

If FindFunction("U_MGFFATAC") .and. (IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc') .or. IsInCallStack('U_xMF08Vinc'))
	aFil := U_MGFFATAC()
Endif	

Return(aFil)