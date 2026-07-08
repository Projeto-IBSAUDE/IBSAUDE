import os
import sys

from fastapi import FastAPI
import uvicorn


if __package__ is None or __package__ == "":
	sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from app.routes.medicamento_routes import router as medicamento_router


app = FastAPI()

app.include_router(medicamento_router)


@app.get("/")
def home():
	return {"mensagem": "Início"}

if __name__ == "__main__":
	uvicorn.run(
		"app.main:app",
		port=8000, 
		reload=True)