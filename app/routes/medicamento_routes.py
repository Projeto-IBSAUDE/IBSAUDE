from fastapi import APIRouter, HTTPException

from app.models.medicamento import Medicamento


router = APIRouter(prefix="/medicamentos", tags=["Medicamentos"])

medicamentos = []
proximo_id = 1


def _medicamento_para_dict(medicamento):
	return medicamento.__dict__


@router.get("/listar")
def listar_medicamentos():
	return medicamentos


@router.get("/{medicamento_id}")
def buscar_medicamento(medicamento_id: int):
	for medicamento in medicamentos:
		if medicamento.id == medicamento_id:
			return medicamento

	raise HTTPException(status_code=404, detail="Medicamento não encontrado")


@router.post("/medicamento-criar")
def criar_medicamento(dados: dict):
	global proximo_id

	dados = dict(dados)
	dados["id"] = proximo_id
	medicamento = Medicamento(**dados)
	proximo_id += 1

	medicamentos.append(medicamento)
	return _medicamento_para_dict(medicamento)


@router.put("/medicamento-atualizar/{medicamento_id}")
def atualizar_medicamento(medicamento_id: int, dados: dict):
	for medicamento in medicamentos:
		if medicamento.id == medicamento_id:
			for chave, valor in dados.items():
				setattr(medicamento, chave, valor)
			return _medicamento_para_dict(medicamento)

	raise HTTPException(status_code=404, detail="Medicamento não encontrado")


@router.delete("/medicamento-deletar/{medicamento_id}")
def remover_medicamento(medicamento_id: int):
	for medicamento in medicamentos:
		if medicamento.id == medicamento_id:
			medicamentos.remove(medicamento)
			return {"mensagem": "Medicamento removido com sucesso"}

	raise HTTPException(status_code=404, detail="Medicamento não encontrado")