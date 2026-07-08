class MedicamentoController:
	medicamentos = []
	proximo_id = 1

	@staticmethod
	def criar(medicamento):
		if medicamento.id is None:
			medicamento.id = MedicamentoController.proximo_id
			MedicamentoController.proximo_id += 1

		MedicamentoController.medicamentos.append(medicamento)
		return medicamento

	@staticmethod
	def listar():
		return MedicamentoController.medicamentos

	@staticmethod
	def buscar_por_id(medicamento_id):
		for medicamento in MedicamentoController.medicamentos:
			if medicamento.id == medicamento_id:
				return medicamento
		return None

	@staticmethod
	def atualizar(medicamento_id, medicamento_novo):
		medicamento = MedicamentoController.buscar_por_id(medicamento_id)

		if medicamento is None:
			return None

		medicamento.nome = medicamento_novo.nome
		medicamento.classificacao_id = medicamento_novo.classificacao_id
		medicamento.codigo_interno = medicamento_novo.codigo_interno
		medicamento.codigo_oficial = medicamento_novo.codigo_oficial
		medicamento.uso_especifico = medicamento_novo.uso_especifico
		medicamento.apresentacao = medicamento_novo.apresentacao
		medicamento.fabricante_id = medicamento_novo.fabricante_id
		medicamento.estoque_minimo = medicamento_novo.estoque_minimo
		medicamento.dias_alerta_vencimento = medicamento_novo.dias_alerta_vencimento
		medicamento.ativo = medicamento_novo.ativo
		medicamento.criado_em = medicamento_novo.criado_em

		return medicamento

	@staticmethod
	def remover(medicamento_id):
		medicamento = MedicamentoController.buscar_por_id(medicamento_id)

		if medicamento is None:
			return False

		MedicamentoController.medicamentos.remove(medicamento)
		return True