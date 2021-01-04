#ifdef SPANISH
	#define STR0001 "Plan de Desarrollo Personal"
	#define STR0002 "Planificacion y Seguimiento de Metas"
	#define STR0003 "Actualmente Pendientes"
	#define STR0004 "Plan"
	#define STR0005 "Periodo"
	#define STR0006 "Nombre"
	#define STR0007 "Evaluador"
	#define STR0008 "Describa coment�rios adicionales y/o compromisos del evaluado y evaluador"
	#define STR0009 "Limpiar"
	#define STR0010 "Guardar"
	#define STR0011 "No existen items registrados"
	#define STR0012 "Pendiente"
	#define STR0013 "Revisar"
	#define STR0014 "Aprobado"
	#define STR0015 "Rechazado"
	#define STR0016 "Aprobar"
	#define STR0017 "Reprobar"
	#define STR0018 "Volver"
	#define STR0019 "Modificar"
	#define STR0020 "Excluir"
	#define STR0021 "Comentarios adicionales/o compromisos de evaluado y evaluador"
	#define STR0022 "Favor digitar una descripcion para el item"
	#define STR0023 "Solo se permite el borrado del item por el autor del mismo"
	#define STR0024 "Favor utilice la opcion Modificar"
	#define STR0025 "Esta seguro que desea APROBAR los items seleccionados"
	#define STR0026 "Esta seguro que desea REPROBAR los items seleccionados"
	#define STR0027 "Esta seguro que desea borrar el item"
	#define STR0028 "Completo"
	#define STR0029 "Lider Jerarquico"
	#define STR0030 "Consejero"
	#define STR0031 "Leyenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Personal Development Plan"
		#define STR0002 "Planning and following up of goals"
		#define STR0003 "Current issues"
		#define STR0004 "Plan"
		#define STR0005 "Period"
		#define STR0006 "Name"
		#define STR0007 "Appraiser"
		#define STR0008 "Describe the additional comments and/or appointments of the appraised and appraiser."
		#define STR0009 "Clear"
		#define STR0010 "Save"
		#define STR0011 "There are no registered items"
		#define STR0012 "Pending"
		#define STR0013 "Review"
		#define STR0014 "Approved"
		#define STR0015 "Rejected"
		#define STR0016 "Approve"
		#define STR0017 "Reject"
		#define STR0018 "Return"
		#define STR0019 "Modify"
		#define STR0020 "Delete"
		#define STR0021 "Additional comments and/or appointments of the appraised and appraiser"
		#define STR0022 "Please, enter a description for the item"
		#define STR0023 "Only the author of the item is allowed to delete it. "
		#define STR0024 "Please use the Modify option"
		#define STR0025 "Sure you want to APPROVE the selected items"
		#define STR0026 "Sure you want to REJECT the selected items"
		#define STR0027 "Sure you want to delete the item"
		#define STR0028 "Filled in "
		#define STR0029 "Hierarchical Leader"
		#define STR0030 "Mentor"
		#define STR0031 "Caption"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Plano De Desenvolvimento Pessoal", "Plano de Desenvolvimento Pessoal" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Planeamento E Acompanhamento De Metas", "Planejamento e Acompanhamento de Metas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Pend�ncias actuais", "Pend�ncias Atuais" )
		#define STR0004 "Plano"
		#define STR0005 "Per�odo"
		#define STR0006 "Nome"
		#define STR0007 "Avaliador"
		#define STR0008 "Descreva coment�rios adicionais e/ou compromissos do avaliado e avaliador"
		#define STR0009 "Limpar"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Guardar", "Salvar" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o existem itens registados", "N�o existem itens cadastrados" )
		#define STR0012 "Pendente"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Rever", "Revisar" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Autorizado", "Aprovado" )
		#define STR0015 "Rejeitado"
		#define STR0016 "Aprovar"
		#define STR0017 "Reprovar"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Voltar atr�s", "Voltar" )
		#define STR0019 "Alterar"
		#define STR0020 "Excluir"
		#define STR0021 "Coment�rios adicionais e/ou compromissos do avaliado e avaliador"
		#define STR0022 "Favor digitar uma descri��o para o item"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "S� � permitida a elimina��o do item pelo autor do mesmo", "S� � permitida a exclus�o do item pelo autor do mesmo" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Favor Utilize A Op��o Modificar", "Favor utilize a op��o Modificar" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja aprovar os itens seleccionados", "Tem certeza que deseja APROVAR os itens selecionados" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja reprovar os itens seleccionados", "Tem certeza que deseja REPROVAR os itens selecionados" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja eliminar o item", "Tem certeza que deseja excluir o item" )
		#define STR0028 "Preenchido"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Lider hier�rquico", "L�der Hier�rquico" )
		#define STR0030 "Mentor"
		#define STR0031 "Legenda"
	#endif
#endif
