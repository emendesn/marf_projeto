#ifdef SPANISH
	#define STR0001 "Salir"
	#define STR0002 "Confirma"
	#define STR0003 "Reescribe"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Actualizacion de Relacion Ocurrencia vs. Accion"
	#define STR0010 "Relacion Ocurrencia vs. Accion"
	#define STR0011 "Archivo de Relacion Ocurrencia vs. Accion - Inclusion"
	#define STR0012 "Relacion"
	#define STR0013 "Agrega Ocurrencia"
	#define STR0014 "Agrega Accion"
	#define STR0015 "Borra item"
	#define STR0016 "Ocurrencia"
	#define STR0017 "Informe la Ocurrencia"
	#define STR0018 "Codigo"
	#define STR0019 "Descripcion"
	#define STR0020 "Accion"
	#define STR0021 "Informe la Accion"
	#define STR0022 "�Confirma el borrado de todo?"
	#define STR0023 "�Confirma el borrado de esta accion?"
	#define STR0024 "Archivo de Relacion Ocurrencia vs. Accion - Modificacion"
	#define STR0025 "Espere"
	#define STR0026 "Elaborando Estructura de la Relacion"
	#define STR0027 "Archivo de Relacion Ocurrencia vs. Accion - Borrado"
	#define STR0028 "�Confirma el borrado?"
	#define STR0029 "Archivo de Relacion Ocurrencia vs. Accion - Visualizacion"
	#define STR0030 "Modificar Ocurrencia"
	#define STR0031 "Mueve hacia arriba"
	#define STR0032 "Mueve hacia abajo"
	#define STR0033 "Las ocurrencias no se pueden mover."
	#define STR0034 "Leyenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Quit"
		#define STR0002 "Ok      "
		#define STR0003 "Retype  "
		#define STR0004 "Search   "
		#define STR0005 "View      "
		#define STR0006 "Insert "
		#define STR0007 "Edit   "
		#define STR0008 "Delete "
		#define STR0009 "Occurrence x Action Relation Update"
		#define STR0010 "Occurrence x Action Relation"
		#define STR0011 "Occurrence x Action Relation File - Insert"
		#define STR0012 "Relationship"
		#define STR0013 "Add Occurrence"
		#define STR0014 "Add Action"
		#define STR0015 "Delete item"
		#define STR0016 "Occurrence"
		#define STR0017 "Enter the Occurrence"
		#define STR0018 "Code  "
		#define STR0019 "Description"
		#define STR0020 "Action"
		#define STR0021 "Enter the Action"
		#define STR0022 "Ok to Clear All?             "
		#define STR0023 "OK to delete this Action ?"
		#define STR0024 "Occurrence x Action Relation File - Edit"
		#define STR0025 "Please wait   "
		#define STR0026 "Creating the Relationship Structure"
		#define STR0027 "Occurrence x Action Relation File - Delete"
		#define STR0028 "Ok to Delete?        "
		#define STR0029 "Occurrence x Action Relation File - View"
		#define STR0030 "Edit Occurrence"
		#define STR0031 "Move up"
		#define STR0032 "Move down"
		#define STR0033 "Occurrences cannot be moved."
		#define STR0034 "Caption"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0002 "Confirma"
		#define STR0003 "Redigita"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Actualiza��o Da Rela��o Ocorr�ncia X Ac��o", "Atualiza��o da Rela��o Ocorrencia x A��o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Rela��o Ocorr�ncia X Ac��o", "Rela��o Ocorrenciao x A��o" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Registo De Relac�o Ocorr�ncia X Ac��o - Inser��o", "Cadastro de Rela��o Ocorrencia x A��o - Inclus�o" )
		#define STR0012 "Relacionamento"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Adiciona Ocorr�ncia", "Adiciona Ocorrencia" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Adiciona Ac��o", "Adiciona A��o" )
		#define STR0015 "Remover item"
		#define STR0016 "Ocorr�ncia"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Indique A Ocorr�ncia", "Informe a Ocorr�ncia" )
		#define STR0018 "C�digo"
		#define STR0019 "Descri��o"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Ac��o", "A��o" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Indique A Ac��o", "Informe a A��o" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Cofacturairma a elimina��o de tudo ?", "Confirma a exclus�o de tudo ?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Cofacturairma a elimina��o da ac��o ?", "Confirma a exclus�o dessa a��o ?" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Registo De Rela��o Ocorr�ncia X Ac��o - Altera��o", "Cadastro de Rela��o Ocorrencia x A��o - Altera��o" )
		#define STR0025 "Aguarde"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Criar Estrutura Do Relacionamento", "Montando Estrutura do Relacionamento" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Registo De Rela��o Ocorr�ncia X Ac��o - Elimina��o", "Cadastro de Rela��o Ocorr�ncia x A��o - Exclus�o" )
		#define STR0028 "Confirma a exclus�o ?"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Registo De Rela��o Ocorr�ncia X Ac��o - Visualiza��o", "Cadastro de Rela��o Ocorr�ncia x A��o - Visualiza��o" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Alterar Ocorr�ncia", "Alterar Ocorrencia" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Mover para cima", "Move para cima" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Mover para baixo", "Move para baixo" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Ocorr�ncias n�o podem ser movidas.", "Ocorrencias nao podem ser movidas." )
		#define STR0034 "Legenda"
	#endif
#endif
