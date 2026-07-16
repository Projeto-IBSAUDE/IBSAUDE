from sqlalchemy import Column, Integer, String, DateTime, Boolean, Float
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()


class Medicamento(Base):
	__tablename__ = "medicamentos"

	id = Column(Integer, primary_key=True, index=True)
	nome = Column(String(255), nullable=False)
	descricao = Column(String(1000), nullable=True)
	fabricante = Column(String(255), nullable=True)
	preco = Column(Float, nullable=True)
	quantidade = Column(Integer, default=0, nullable=False)
	ativo = Column(Boolean, default=True, nullable=False)
	data_criacao = Column(DateTime, default=datetime.utcnow, nullable=False)
	data_atualizacao = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

	def __repr__(self):
		return f"<Medicamento(id={self.id}, nome='{self.nome}', fabricante='{self.fabricante}')>"
