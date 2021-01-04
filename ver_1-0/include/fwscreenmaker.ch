#Define STYLE0001 "Q3Frame{ margin:2px; }"
#Define STYLE0002 "Q3Frame{ margin:2px; margin-bottom:0px; margin-right:0px; border-style:solid; border-width:1px;"+;
	          		 	" border-color:#7988A3; background-color:#99A2B4; border-bottom:none; }"      
#Define STYLE0003 "QPushButton{margin-top:1px; border-bottom-color:#000000; background-color:#ffffff; color:#000000; border-style: solid; border-width:1px; }"
#Define STYLE0004 "QPushButton{border-bottom-color:#ffffff; background-color:#ffffff; color:#000000; border-style: solid; border-width:1px;}"

// Tipos de objetos
#Define OBJ_NONE   0 
#Define FWSMEDIT   1 
#Define FWSMGRID   2
#Define FWSMBAR    3
#Define FWSMFOLDER 4
#Define FWSMPANEL  5
#Define FWSMSCROLL 6

// Propriedades de alinhamento do TWindowDock
#Define AllAlign  1
#Define LeftAlign 2
#Define RightAlign 3
#Define TopAlign 4
#Define BottomAlign 5

// Descricao dos objetos [TODO - Definir nome dos componentes no programa]
Static OBJNAME := {"FWSMEdit","FWSMGrid","FWSMBar","FWSMFolder","FWSMPanel","FWSMScroll"}

// Colunas fixas das propriedades do objeto
#Define COL_ORDER			1
#Define COL_TYPE			2
#Define COL_NAME			3
#Define COL_TABORDER	4
#Define COL_ALIGN			5
#Define COL_LEFT			6
#Define COL_TOP				7
#Define COL_WIDTH			8
#Define COL_HEIGHT		9
#Define COL_PARENT		10

// Define vetor de alinhamento
Static ALIGN_TYPE := {'NONE','LEFT','RIGHT','TOP','BOTTOM','ALLCLIENT'}
                      
// Imagens dos componentes e botoes
Static IMGBUTT000 := 'obj_none'
Static IMGBACK001 := "fwedit_obj.png"
Static IMGBUTT001 := "fwedit.png"
Static IMGBACK002 := "fwgrid_obj.png"
Static IMGBUTT002 := "fwgrid.png"
Static IMGBACK003 := "fwbar_obj.png"
Static IMGBUTT003 := "fwbar.png"
Static IMGBACK004 := ""
Static IMGBUTT004 := "fwtab.png" 
Static IMGBACK005 := ""
Static IMGBUTT005 := "fwpanel.png"
Static IMGBACK006 := "fwscroll_obj.png"
Static IMGBUTT006 := "fwscroll.png"

//---------------------------------------------------------------------------
                     
#ifdef SPANISH
	#define STR0001 "Minimizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Minimize"
	#else
		Static STR0001 := "Propriedades"
		Static STR0002 := "Valor"
		Static STR0003 := "Deletar"
		Static STR0004 := "Abrir"
		Static STR0005 := "Salvar"
		Static STR0006 := "Digite a descrição da nova Aba"
		Static STR0007 := "Ok"
		Static STR0008 := "Cancela"
		Static STR0009 := "None"   
		Static STR0010 := "FWScreenMaker:getObj - Objeto não existe" 
		Static STR0011 := "Aguarde..."   
		Static STR0012 := "FWScreenMaker:refreshTabOrder - TabOrder inválido"   
		Static STR0013 := "Arquivo XML não pode ser criado"   
		Static STR0014 := "Alterar"   
		Static STR0015 := "Digite a nova descrição"   
		Static STR0016 := "FWScreenMaker:selectObj - Objeto não existe" 
		Static STR0017 := "TabOrder de um objeto não pode ser inferior ao TabOrder de seu Container" 
		Static STR0018 := "Informe o arquivo XML"
		Static STR0019 := "FWAutoForm:getParent - Objeto não existe"   
		Static STR0020 := "Campos para exibição no FWEdit"   
		Static STR0021 := "Campos para alteração no FWEdit"   
		Static STR0022 := "Define botões"
		Static STR0023 := "Adiciona"
		Static STR0024 := "Remove"
		Static STR0025 := "Botões"
		Static STR0026 := "Recurso"
		Static STR0027 := "Bloco de Código"
		Static STR0028 := "Seleciona Imagem"
		Static STR0029 := "Selecione a Imagem"
		Static STR0030 := "Inclua a ação"
		Static STR0031 := "Preencha o campo Alias do componente"
		Static STR0032 := "Selecione o botão"
		Static STR0033 := "Todos os Campos"   
		Static STR0034 := "Componentes"
		Static STR0035 := "Propriedades"
		Static STR0036 := "Arquivo CH do Fromulario não pode ser criado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Minimizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF