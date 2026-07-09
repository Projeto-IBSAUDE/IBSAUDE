--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2026-07-09 11:01:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5081 (class 0 OID 122891)
-- Dependencies: 216
-- Data for Name: classificacoes_medicamento; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (1, 'ANTIBIOTICO', 'Medicamentos antibióticos');
INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (2, 'CONTROLADO', 'Medicamentos de controle especial');
INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (3, 'PSICOTROPICO', 'Medicamentos psicotrópicos');
INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (4, 'USO_CONTINUO', 'Medicamentos de uso contínuo');
INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (5, 'TERMOLABIL', 'Medicamentos que requerem refrigeração');
INSERT INTO ibsaude.classificacoes_medicamento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (6, 'USO_GERAL', 'Medicamentos de uso geral');


--
-- TOC entry 5107 (class 0 OID 123008)
-- Dependencies: 244
-- Data for Name: perfis; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.perfis (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (1, 'ADMINISTRADOR', 'Acesso total ao sistema');
INSERT INTO ibsaude.perfis (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (2, 'FARMACEUTICO', 'Operações de estoque e distribuição');
INSERT INTO ibsaude.perfis (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (3, 'GESTOR', 'Visualização de relatórios e indicadores');
INSERT INTO ibsaude.perfis (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (4, 'AUDITOR', 'Acesso somente leitura para auditoria');


--
-- TOC entry 5111 (class 0 OID 123020)
-- Dependencies: 248
-- Data for Name: tipos_documento; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.tipos_documento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (1, 'NOTA_FISCAL', 'Nota fiscal de compra');
INSERT INTO ibsaude.tipos_documento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (2, 'PEDIDO_FORMAL', 'Pedido formal de distribuição');
INSERT INTO ibsaude.tipos_documento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (3, 'XML_NFE', 'XML da nota fiscal eletrônica');
INSERT INTO ibsaude.tipos_documento (id, nome, descricao) OVERRIDING SYSTEM VALUE VALUES (4, 'OUTRO', 'Outros tipos de documento');


--
-- TOC entry 5117 (class 0 OID 123040)
-- Dependencies: 254
-- Data for Name: usuarios; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (1, 'Dr. Carlos Silva', 'carlos.silva@ibsaude.gov.br', 'hash_mock_admin', 1, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');
INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (2, 'Dra. Ana Souza', 'ana.souza@ibsaude.gov.br', 'hash_mock_farma', 2, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');
INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (3, 'Sr. Roberto Santos', 'roberto.santos@ibsaude.gov.br', 'hash_mock_gestor', 3, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');
INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (4, 'Dra. Mariana Costa', 'mariana.costa@ibsaude.gov.br', 'hash_mock_auditor', 4, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');
INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (5, 'Dr. João Pereira', 'joao.pereira@ibsaude.gov.br', 'hash_mock_farma2', 2, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');
INSERT INTO ibsaude.usuarios (id, nome, email, senha_hash, perfil_id, ativo, criado_em, atualizado_em) OVERRIDING SYSTEM VALUE VALUES (6, 'Sra. Lucia Oliveira', 'lucia.oliveira@ibsaude.gov.br', 'hash_mock_farma3', 2, true, '2026-07-07 08:18:44.847759-05', '2026-07-07 08:18:44.847759-05');


--
-- TOC entry 5089 (class 0 OID 122919)
-- Dependencies: 224
-- Data for Name: documentos; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (1, 1, 'NF_2026_001.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_001.pdf', 'a1b2c3d4e5f6...                                                 ', 245760, 1, '2026-07-07 08:18:45.194468-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (2, 1, 'NF_2026_002.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_002.pdf', 'b2c3d4e5f6a1...                                                 ', 314572, 1, '2026-07-07 08:18:45.194468-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (3, 1, 'NF_2026_003.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_003.pdf', 'c3d4e5f6a1b2...                                                 ', 182536, 2, '2026-07-07 08:18:45.194468-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (4, 2, 'Pedido_UBS_001.pdf', 's3://ibsaude-docs/pedidos/2026/Pedido_UBS_001.pdf', 'd4e5f6a1b2c3...                                                 ', 98765, 3, '2026-07-07 08:18:45.194468-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (5, 2, 'Pedido_HOSP_001.pdf', 's3://ibsaude-docs/pedidos/2026/Pedido_HOSP_001.pdf', 'e5f6a1b2c3d4...                                                 ', 123456, 4, '2026-07-07 08:18:45.194468-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (6, 1, 'NF_2026_001.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_001.pdf', 'a1b2c3d4e5f6...                                                 ', 245760, 1, '2026-07-07 08:20:07.882901-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (7, 1, 'NF_2026_002.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_002.pdf', 'b2c3d4e5f6a1...                                                 ', 314572, 1, '2026-07-07 08:20:07.882901-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (8, 1, 'NF_2026_003.pdf', 's3://ibsaude-docs/notas/2026/NF_2026_003.pdf', 'c3d4e5f6a1b2...                                                 ', 182536, 2, '2026-07-07 08:20:07.882901-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (9, 2, 'Pedido_UBS_001.pdf', 's3://ibsaude-docs/pedidos/2026/Pedido_UBS_001.pdf', 'd4e5f6a1b2c3...                                                 ', 98765, 3, '2026-07-07 08:20:07.882901-05');
INSERT INTO ibsaude.documentos (id, tipo_documento_id, nome_arquivo, caminho_storage, hash_sha256, tamanho_bytes, enviado_por, criado_em) OVERRIDING SYSTEM VALUE VALUES (10, 2, 'Pedido_HOSP_001.pdf', 's3://ibsaude-docs/pedidos/2026/Pedido_HOSP_001.pdf', 'e5f6a1b2c3d4...                                                 ', 123456, 4, '2026-07-07 08:20:07.882901-05');


--
-- TOC entry 5093 (class 0 OID 122930)
-- Dependencies: 228
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.fornecedores (id, nome, cnpj, telefone, email, endereco, ativo) OVERRIDING SYSTEM VALUE VALUES (1, 'Distribuidora Saúde Total', '12.345.678/0001-90', '(11) 3456-7890', 'vendas@saudetotal.com.br', 'Av. Paulista, 1000, São Paulo - SP', true);
INSERT INTO ibsaude.fornecedores (id, nome, cnpj, telefone, email, endereco, ativo) OVERRIDING SYSTEM VALUE VALUES (2, 'Medicorps Distribuição', '98.765.432/0001-10', '(11) 4567-8901', 'contato@medicorps.com.br', 'Rua Augusta, 500, São Paulo - SP', true);
INSERT INTO ibsaude.fornecedores (id, nome, cnpj, telefone, email, endereco, ativo) OVERRIDING SYSTEM VALUE VALUES (3, 'FarmaLog Logística', '56.789.123/0001-45', '(11) 5678-9012', 'logistica@farmalog.com.br', 'Av. Faria Lima, 2000, São Paulo - SP', true);
INSERT INTO ibsaude.fornecedores (id, nome, cnpj, telefone, email, endereco, ativo) OVERRIDING SYSTEM VALUE VALUES (4, 'Drogasil Distribuidora', '34.567.890/0001-23', '(11) 6789-0123', 'distribuicao@drogasil.com.br', 'Rua Vergueiro, 3000, São Paulo - SP', true);
INSERT INTO ibsaude.fornecedores (id, nome, cnpj, telefone, email, endereco, ativo) OVERRIDING SYSTEM VALUE VALUES (5, 'MedFarm Distribuição', '78.901.234/0001-56', '(11) 7890-1234', 'comercial@medfarm.com.br', 'Av. Brasil, 1500, São Paulo - SP', true);


--
-- TOC entry 5083 (class 0 OID 122897)
-- Dependencies: 218
-- Data for Name: compras; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (1, 'NF-2026-001', 1, '2026-01-15', 2, 1, 15750.00, '2026-07-07 08:18:45.207721-05');
INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (2, 'NF-2026-002', 2, '2026-02-10', 5, 2, 23450.50, '2026-07-07 08:18:45.207721-05');
INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (3, 'NF-2026-003', 3, '2026-03-20', 6, 3, 8950.75, '2026-07-07 08:18:45.207721-05');
INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (4, 'NF-2026-004', 4, '2026-04-05', 2, NULL, 12300.00, '2026-07-07 08:18:45.207721-05');
INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (5, 'NF-2026-005', 5, '2026-05-12', 5, NULL, 18750.25, '2026-07-07 08:18:45.207721-05');
INSERT INTO ibsaude.compras (id, numero_nota_fiscal, fornecedor_id, data_entrada, responsavel_recebimento_id, documento_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (6, 'NF-2026-006', 1, '2026-06-18', 6, NULL, 14200.00, '2026-07-07 08:18:45.207721-05');


--
-- TOC entry 5109 (class 0 OID 123014)
-- Dependencies: 246
-- Data for Name: status_distribuicao; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.status_distribuicao (id, nome, descricao, ordem) OVERRIDING SYSTEM VALUE VALUES (1, 'PENDENTE', 'Aguardando liberação', 1);
INSERT INTO ibsaude.status_distribuicao (id, nome, descricao, ordem) OVERRIDING SYSTEM VALUE VALUES (2, 'LIBERADA', 'Liberada para envio', 2);
INSERT INTO ibsaude.status_distribuicao (id, nome, descricao, ordem) OVERRIDING SYSTEM VALUE VALUES (3, 'ENVIADA', 'Enviada para unidade de saúde', 3);
INSERT INTO ibsaude.status_distribuicao (id, nome, descricao, ordem) OVERRIDING SYSTEM VALUE VALUES (4, 'RECEBIDA', 'Recebida pela unidade de saúde', 4);
INSERT INTO ibsaude.status_distribuicao (id, nome, descricao, ordem) OVERRIDING SYSTEM VALUE VALUES (5, 'CANCELADA', 'Distribuição cancelada', 5);


--
-- TOC entry 5115 (class 0 OID 123033)
-- Dependencies: 252
-- Data for Name: unidades_saude; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (1, 'UBS Jardim Saúde', '12.345.678/0001-90', 'UBS', 'Rua das Flores, 100, São Paulo - SP', 'Dra. Maria Oliveira', true);
INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (2, 'Hospital Municipal Central', '98.765.432/0001-10', 'Hospital', 'Av. Principal, 500, São Paulo - SP', 'Dr. Paulo Costa', true);
INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (3, 'CAPS Vila Nova', '56.789.123/0001-45', 'CAPS', 'Rua dos Pinheiros, 200, São Paulo - SP', 'Dra. Carla Mendes', true);
INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (4, 'UBS Jardim América', '34.567.890/0001-23', 'UBS', 'Av. América, 789, São Paulo - SP', 'Dr. Ricardo Almeida', true);
INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (5, 'Hospital Infantil Esperança', '78.901.234/0001-56', 'Hospital', 'Rua das Crianças, 300, São Paulo - SP', 'Dra. Patricia Lima', true);
INSERT INTO ibsaude.unidades_saude (id, nome, cnpj, tipo, endereco, responsavel_local, ativo) OVERRIDING SYSTEM VALUE VALUES (6, 'Policlínica Regional', '90.123.456/0001-78', 'Policlínica', 'Av. Regional, 1000, São Paulo - SP', 'Dr. Fernando Santos', true);


--
-- TOC entry 5085 (class 0 OID 122904)
-- Dependencies: 220
-- Data for Name: distribuicoes; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (1, 1, 4, '2026-01-20', 2, 'Dra. Maria Oliveira', 4, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (2, 2, 3, '2026-01-25', 5, 'Dr. Paulo Costa', NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (3, 3, 4, '2026-02-15', 6, 'Dra. Carla Mendes', 5, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (4, 4, 2, '2026-02-20', 2, NULL, NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (5, 1, 4, '2026-03-10', 5, 'Dra. Maria Oliveira', NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (6, 5, 1, '2026-03-25', 6, NULL, NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (7, 2, 4, '2026-04-15', 2, 'Dr. Paulo Costa', NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (8, 6, 3, '2026-04-28', 5, 'Dr. Fernando Santos', NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (9, 3, 4, '2026-05-10', 6, 'Dra. Carla Mendes', NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (10, 4, 1, '2026-05-20', 2, NULL, NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (11, 1, 2, '2026-06-15', 5, NULL, NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (12, 2, 1, '2026-06-25', 6, NULL, NULL, 0.00, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (13, 1, 4, '2026-01-20', 2, 'Dra. Maria Oliveira', 4, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (14, 2, 3, '2026-01-25', 5, 'Dr. Paulo Costa', NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (15, 3, 4, '2026-02-15', 6, 'Dra. Carla Mendes', 5, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (16, 4, 2, '2026-02-20', 2, NULL, NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (17, 1, 4, '2026-03-10', 5, 'Dra. Maria Oliveira', NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (18, 5, 1, '2026-03-25', 6, NULL, NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (19, 2, 4, '2026-04-15', 2, 'Dr. Paulo Costa', NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (20, 6, 3, '2026-04-28', 5, 'Dr. Fernando Santos', NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (21, 3, 4, '2026-05-10', 6, 'Dra. Carla Mendes', NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (22, 4, 1, '2026-05-20', 2, NULL, NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (23, 1, 2, '2026-06-15', 5, NULL, NULL, 0.00, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.distribuicoes (id, unidade_saude_id, status_id, data_envio, responsavel_liberacao_id, responsavel_recebimento_nome, documento_pedido_id, valor_total, criado_em) OVERRIDING SYSTEM VALUE VALUES (24, 2, 1, '2026-06-25', 6, NULL, NULL, 0.00, '2026-07-07 08:20:07.900983-05');


--
-- TOC entry 5091 (class 0 OID 122926)
-- Dependencies: 226
-- Data for Name: fabricantes; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (1, 'EMS Farmacêutica', '12.345.678/0001-90', 'Brasil');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (2, 'Eurofarma', '98.765.432/0001-10', 'Brasil');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (3, 'Novartis Brasil', '56.789.123/0001-45', 'Suíça');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (4, 'Pfizer Brasil', '34.567.890/0001-23', 'EUA');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (5, 'Sanofi Brasil', '78.901.234/0001-56', 'França');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (6, 'AstraZeneca Brasil', '90.123.456/0001-78', 'Reino Unido');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (7, 'Bayer Brasil', '23.456.789/0001-01', 'Alemanha');
INSERT INTO ibsaude.fabricantes (id, nome, cnpj, pais) OVERRIDING SYSTEM VALUE VALUES (8, 'Aché Laboratórios', '67.890.123/0001-34', 'Brasil');


--
-- TOC entry 5101 (class 0 OID 122970)
-- Dependencies: 237
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (1, 'Amoxicilina 500mg', 1, 'AMX-001', '7891234567890', 'Infecções bacterianas', 'Comprimido', 1, 1000.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (2, 'Azitromicina 500mg', 1, 'AZT-001', '7891234567891', 'Infecções respiratórias', 'Comprimido', 2, 500.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (3, 'Cefalexina 500mg', 1, 'CEF-001', '7891234567892', 'Infecções de pele', 'Cápsula', 3, 300.00, 120, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (4, 'Morfina 10mg', 2, 'MOR-001', '7891234567893', 'Dor severa', 'Ampola', 4, 100.00, 60, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (5, 'Fentanil 50mcg', 2, 'FEN-001', '7891234567894', 'Anestesia', 'Ampola', 4, 50.00, 60, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (6, 'Diazepam 5mg', 3, 'DIA-001', '7891234567895', 'Ansiedade', 'Comprimido', 5, 200.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (7, 'Fluoxetina 20mg', 3, 'FLU-001', '7891234567896', 'Depressão', 'Cápsula', 6, 200.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (8, 'Losartana 50mg', 4, 'LOS-001', '7891234567897', 'Hipertensão', 'Comprimido', 1, 500.00, 180, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (9, 'Metformina 850mg', 4, 'MET-001', '7891234567898', 'Diabetes tipo 2', 'Comprimido', 7, 400.00, 180, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (10, 'Atorvastatina 20mg', 4, 'ATO-001', '7891234567899', 'Colesterol', 'Comprimido', 4, 300.00, 180, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (11, 'Insulina NPH 100UI', 5, 'INS-001', '7891234567900', 'Diabetes', 'Frasco', 3, 100.00, 45, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (12, 'Vacina Influenza', 5, 'VAC-001', '7891234567901', 'Prevenção gripe', 'Frasco', 5, 200.00, 30, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (13, 'Dipirona 500mg', 6, 'DIP-001', '7891234567902', 'Dor e febre', 'Comprimido', 2, 2000.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (14, 'Paracetamol 750mg', 6, 'PAR-001', '7891234567903', 'Dor e febre', 'Comprimido', 8, 1500.00, 90, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (15, 'Omeprazol 20mg', 6, 'OME-001', '7891234567904', 'Proteção gástrica', 'Cápsula', 7, 800.00, 120, true, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.medicamentos (id, nome, classificacao_id, codigo_interno, codigo_oficial, uso_especifico, apresentacao, fabricante_id, estoque_minimo, dias_alerta_vencimento, ativo, criado_em) OVERRIDING SYSTEM VALUE VALUES (16, 'Soro Fisiológico 500ml', 6, 'SOR-001', '7891234567905', 'Hidratação', 'Bolsa', 6, 100.00, 365, true, '2026-07-07 08:18:44.882371-05');


--
-- TOC entry 5099 (class 0 OID 122960)
-- Dependencies: 235
-- Data for Name: lotes; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5087 (class 0 OID 122912)
-- Dependencies: 222
-- Data for Name: distribuicoes_itens; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5095 (class 0 OID 122941)
-- Dependencies: 231
-- Data for Name: log_auditoria_2026_07; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (1, NULL, 'INSERT', 'medicamentos', 1, NULL, '{"id": 1, "nome": "Amoxicilina 500mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 1, "codigo_interno": "AMX-001", "codigo_oficial": "7891234567890", "estoque_minimo": 1000.00, "uso_especifico": "Infecções bacterianas", "classificacao_id": 1, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (2, NULL, 'INSERT', 'medicamentos', 2, NULL, '{"id": 2, "nome": "Azitromicina 500mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 2, "codigo_interno": "AZT-001", "codigo_oficial": "7891234567891", "estoque_minimo": 500.00, "uso_especifico": "Infecções respiratórias", "classificacao_id": 1, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (3, NULL, 'INSERT', 'medicamentos', 3, NULL, '{"id": 3, "nome": "Cefalexina 500mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Cápsula", "fabricante_id": 3, "codigo_interno": "CEF-001", "codigo_oficial": "7891234567892", "estoque_minimo": 300.00, "uso_especifico": "Infecções de pele", "classificacao_id": 1, "dias_alerta_vencimento": 120}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (4, NULL, 'INSERT', 'medicamentos', 4, NULL, '{"id": 4, "nome": "Morfina 10mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Ampola", "fabricante_id": 4, "codigo_interno": "MOR-001", "codigo_oficial": "7891234567893", "estoque_minimo": 100.00, "uso_especifico": "Dor severa", "classificacao_id": 2, "dias_alerta_vencimento": 60}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (5, NULL, 'INSERT', 'medicamentos', 5, NULL, '{"id": 5, "nome": "Fentanil 50mcg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Ampola", "fabricante_id": 4, "codigo_interno": "FEN-001", "codigo_oficial": "7891234567894", "estoque_minimo": 50.00, "uso_especifico": "Anestesia", "classificacao_id": 2, "dias_alerta_vencimento": 60}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (6, NULL, 'INSERT', 'medicamentos', 6, NULL, '{"id": 6, "nome": "Diazepam 5mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 5, "codigo_interno": "DIA-001", "codigo_oficial": "7891234567895", "estoque_minimo": 200.00, "uso_especifico": "Ansiedade", "classificacao_id": 3, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (7, NULL, 'INSERT', 'medicamentos', 7, NULL, '{"id": 7, "nome": "Fluoxetina 20mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Cápsula", "fabricante_id": 6, "codigo_interno": "FLU-001", "codigo_oficial": "7891234567896", "estoque_minimo": 200.00, "uso_especifico": "Depressão", "classificacao_id": 3, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (8, NULL, 'INSERT', 'medicamentos', 8, NULL, '{"id": 8, "nome": "Losartana 50mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 1, "codigo_interno": "LOS-001", "codigo_oficial": "7891234567897", "estoque_minimo": 500.00, "uso_especifico": "Hipertensão", "classificacao_id": 4, "dias_alerta_vencimento": 180}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (9, NULL, 'INSERT', 'medicamentos', 9, NULL, '{"id": 9, "nome": "Metformina 850mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 7, "codigo_interno": "MET-001", "codigo_oficial": "7891234567898", "estoque_minimo": 400.00, "uso_especifico": "Diabetes tipo 2", "classificacao_id": 4, "dias_alerta_vencimento": 180}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (10, NULL, 'INSERT', 'medicamentos', 10, NULL, '{"id": 10, "nome": "Atorvastatina 20mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 4, "codigo_interno": "ATO-001", "codigo_oficial": "7891234567899", "estoque_minimo": 300.00, "uso_especifico": "Colesterol", "classificacao_id": 4, "dias_alerta_vencimento": 180}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (11, NULL, 'INSERT', 'medicamentos', 11, NULL, '{"id": 11, "nome": "Insulina NPH 100UI", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Frasco", "fabricante_id": 3, "codigo_interno": "INS-001", "codigo_oficial": "7891234567900", "estoque_minimo": 100.00, "uso_especifico": "Diabetes", "classificacao_id": 5, "dias_alerta_vencimento": 45}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (12, NULL, 'INSERT', 'medicamentos', 12, NULL, '{"id": 12, "nome": "Vacina Influenza", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Frasco", "fabricante_id": 5, "codigo_interno": "VAC-001", "codigo_oficial": "7891234567901", "estoque_minimo": 200.00, "uso_especifico": "Prevenção gripe", "classificacao_id": 5, "dias_alerta_vencimento": 30}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (13, NULL, 'INSERT', 'medicamentos', 13, NULL, '{"id": 13, "nome": "Dipirona 500mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 2, "codigo_interno": "DIP-001", "codigo_oficial": "7891234567902", "estoque_minimo": 2000.00, "uso_especifico": "Dor e febre", "classificacao_id": 6, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (14, NULL, 'INSERT', 'medicamentos', 14, NULL, '{"id": 14, "nome": "Paracetamol 750mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Comprimido", "fabricante_id": 8, "codigo_interno": "PAR-001", "codigo_oficial": "7891234567903", "estoque_minimo": 1500.00, "uso_especifico": "Dor e febre", "classificacao_id": 6, "dias_alerta_vencimento": 90}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (15, NULL, 'INSERT', 'medicamentos', 15, NULL, '{"id": 15, "nome": "Omeprazol 20mg", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Cápsula", "fabricante_id": 7, "codigo_interno": "OME-001", "codigo_oficial": "7891234567904", "estoque_minimo": 800.00, "uso_especifico": "Proteção gástrica", "classificacao_id": 6, "dias_alerta_vencimento": 120}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (16, NULL, 'INSERT', 'medicamentos', 16, NULL, '{"id": 16, "nome": "Soro Fisiológico 500ml", "ativo": true, "criado_em": "2026-07-07T10:18:44.882371-03:00", "apresentacao": "Bolsa", "fabricante_id": 6, "codigo_interno": "SOR-001", "codigo_oficial": "7891234567905", "estoque_minimo": 100.00, "uso_especifico": "Hidratação", "classificacao_id": 6, "dias_alerta_vencimento": 365}', NULL, '2026-07-07 08:18:44.882371-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (49, NULL, 'INSERT', 'distribuicoes', 1, NULL, '{"id": 1, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 3250.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (50, NULL, 'INSERT', 'distribuicoes', 2, NULL, '{"id": 2, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 2450.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (51, NULL, 'INSERT', 'distribuicoes', 3, NULL, '{"id": 3, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 1875.25, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (52, NULL, 'INSERT', 'distribuicoes', 4, NULL, '{"id": 4, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 3200.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (53, NULL, 'INSERT', 'distribuicoes', 5, NULL, '{"id": 5, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 2800.75, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (54, NULL, 'INSERT', 'distribuicoes', 6, NULL, '{"id": 6, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 1500.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (55, NULL, 'INSERT', 'distribuicoes', 7, NULL, '{"id": 7, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 4100.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (56, NULL, 'INSERT', 'distribuicoes', 8, NULL, '{"id": 8, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 2350.50, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (57, NULL, 'INSERT', 'distribuicoes', 9, NULL, '{"id": 9, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 1900.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (58, NULL, 'INSERT', 'distribuicoes', 10, NULL, '{"id": 10, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 2750.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (59, NULL, 'INSERT', 'distribuicoes', 11, NULL, '{"id": 11, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 1650.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (60, NULL, 'INSERT', 'distribuicoes', 12, NULL, '{"id": 12, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 3200.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:52.674046-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (61, NULL, 'UPDATE', 'distribuicoes', 1, '{"id": 1, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 3250.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 1, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (62, NULL, 'UPDATE', 'distribuicoes', 2, '{"id": 2, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 2450.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 2, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (63, NULL, 'UPDATE', 'distribuicoes', 3, '{"id": 3, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 1875.25, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 3, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (64, NULL, 'UPDATE', 'distribuicoes', 4, '{"id": 4, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 3200.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 4, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (65, NULL, 'UPDATE', 'distribuicoes', 5, '{"id": 5, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 2800.75, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 5, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (66, NULL, 'UPDATE', 'distribuicoes', 6, '{"id": 6, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 1500.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 6, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 0.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (67, NULL, 'UPDATE', 'distribuicoes', 7, '{"id": 7, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 4100.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 7, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (68, NULL, 'UPDATE', 'distribuicoes', 8, '{"id": 8, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 2350.50, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', '{"id": 8, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 0.00, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (69, NULL, 'UPDATE', 'distribuicoes', 9, '{"id": 9, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 1900.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 9, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (70, NULL, 'UPDATE', 'distribuicoes', 10, '{"id": 10, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 2750.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 10, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (71, NULL, 'UPDATE', 'distribuicoes', 11, '{"id": 11, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 1650.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', '{"id": 11, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (72, NULL, 'UPDATE', 'distribuicoes', 12, '{"id": 12, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 3200.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 12, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:18:55.528348-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (73, 2, 'INSERT', 'compras', 1, NULL, '{"valor_total": 15750.00, "numero_nota_fiscal": "NF-2026-001"}', '192.168.1.100', '2026-07-07 08:18:55.533155-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (74, 5, 'UPDATE', 'distribuicoes', 1, NULL, '{"status": "RECEBIDA", "data_envio": "2026-01-20"}', '192.168.1.101', '2026-07-07 08:18:55.533155-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (75, 6, 'INSERT', 'lotes', 1, NULL, '{"numero_lote": "LOT-2026-001-A", "quantidade_adquirida": 1000}', '192.168.1.102', '2026-07-07 08:18:55.533155-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (108, NULL, 'INSERT', 'distribuicoes', 13, NULL, '{"id": 13, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 3250.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (109, NULL, 'INSERT', 'distribuicoes', 14, NULL, '{"id": 14, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 2450.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (110, NULL, 'INSERT', 'distribuicoes', 15, NULL, '{"id": 15, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 1875.25, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (111, NULL, 'INSERT', 'distribuicoes', 16, NULL, '{"id": 16, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 3200.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (112, NULL, 'INSERT', 'distribuicoes', 17, NULL, '{"id": 17, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 2800.75, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (113, NULL, 'INSERT', 'distribuicoes', 18, NULL, '{"id": 18, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 1500.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (114, NULL, 'INSERT', 'distribuicoes', 19, NULL, '{"id": 19, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 4100.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (115, NULL, 'INSERT', 'distribuicoes', 20, NULL, '{"id": 20, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 2350.50, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (116, NULL, 'INSERT', 'distribuicoes', 21, NULL, '{"id": 21, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 1900.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (117, NULL, 'INSERT', 'distribuicoes', 22, NULL, '{"id": 22, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 2750.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (118, NULL, 'INSERT', 'distribuicoes', 23, NULL, '{"id": 23, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 1650.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (119, NULL, 'INSERT', 'distribuicoes', 24, NULL, '{"id": 24, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 3200.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.900983-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (120, NULL, 'UPDATE', 'distribuicoes', 1, '{"id": 1, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 1, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (121, NULL, 'UPDATE', 'distribuicoes', 2, '{"id": 2, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 2, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (122, NULL, 'UPDATE', 'distribuicoes', 3, '{"id": 3, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 3, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (123, NULL, 'UPDATE', 'distribuicoes', 4, '{"id": 4, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 4, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (124, NULL, 'UPDATE', 'distribuicoes', 5, '{"id": 5, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 5, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (125, NULL, 'UPDATE', 'distribuicoes', 6, '{"id": 6, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 0.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 6, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 0.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (126, NULL, 'UPDATE', 'distribuicoes', 7, '{"id": 7, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 7, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (127, NULL, 'UPDATE', 'distribuicoes', 8, '{"id": 8, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 0.00, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', '{"id": 8, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 0.00, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (128, NULL, 'UPDATE', 'distribuicoes', 9, '{"id": 9, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 9, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (129, NULL, 'UPDATE', 'distribuicoes', 10, '{"id": 10, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 10, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (130, NULL, 'UPDATE', 'distribuicoes', 11, '{"id": 11, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', '{"id": 11, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (131, NULL, 'UPDATE', 'distribuicoes', 12, '{"id": 12, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 12, "criado_em": "2026-07-07T10:18:52.674046-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (132, NULL, 'UPDATE', 'distribuicoes', 13, '{"id": 13, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 3250.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 13, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-01-20", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": 4, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (133, NULL, 'UPDATE', 'distribuicoes', 14, '{"id": 14, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 2450.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 14, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-01-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (134, NULL, 'UPDATE', 'distribuicoes', 15, '{"id": 15, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 1875.25, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 15, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-02-15", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": 5, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (135, NULL, 'UPDATE', 'distribuicoes', 16, '{"id": 16, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 3200.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 16, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-02-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (136, NULL, 'UPDATE', 'distribuicoes', 17, '{"id": 17, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 2800.75, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', '{"id": 17, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-03-10", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dra. Maria Oliveira"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (137, NULL, 'UPDATE', 'distribuicoes', 18, '{"id": 18, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 1500.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 18, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-03-25", "valor_total": 0.00, "unidade_saude_id": 5, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (138, NULL, 'UPDATE', 'distribuicoes', 19, '{"id": 19, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 4100.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', '{"id": 19, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-04-15", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": "Dr. Paulo Costa"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (139, NULL, 'UPDATE', 'distribuicoes', 20, '{"id": 20, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 2350.50, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', '{"id": 20, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 3, "data_envio": "2026-04-28", "valor_total": 0.00, "unidade_saude_id": 6, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": "Dr. Fernando Santos"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (140, NULL, 'UPDATE', 'distribuicoes', 21, '{"id": 21, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 1900.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', '{"id": 21, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 4, "data_envio": "2026-05-10", "valor_total": 0.00, "unidade_saude_id": 3, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": "Dra. Carla Mendes"}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (141, NULL, 'UPDATE', 'distribuicoes', 22, '{"id": 22, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 2750.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', '{"id": 22, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-05-20", "valor_total": 0.00, "unidade_saude_id": 4, "documento_pedido_id": null, "responsavel_liberacao_id": 2, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (142, NULL, 'UPDATE', 'distribuicoes', 23, '{"id": 23, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 1650.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', '{"id": 23, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 2, "data_envio": "2026-06-15", "valor_total": 0.00, "unidade_saude_id": 1, "documento_pedido_id": null, "responsavel_liberacao_id": 5, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (143, NULL, 'UPDATE', 'distribuicoes', 24, '{"id": 24, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 3200.50, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', '{"id": 24, "criado_em": "2026-07-07T10:20:07.900983-03:00", "status_id": 1, "data_envio": "2026-06-25", "valor_total": 0.00, "unidade_saude_id": 2, "documento_pedido_id": null, "responsavel_liberacao_id": 6, "responsavel_recebimento_nome": null}', NULL, '2026-07-07 08:20:07.918338-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (144, 2, 'INSERT', 'compras', 1, NULL, '{"valor_total": 15750.00, "numero_nota_fiscal": "NF-2026-001"}', '192.168.1.100', '2026-07-07 08:20:07.92191-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (145, 5, 'UPDATE', 'distribuicoes', 1, NULL, '{"status": "RECEBIDA", "data_envio": "2026-01-20"}', '192.168.1.101', '2026-07-07 08:20:07.92191-05');
INSERT INTO ibsaude.log_auditoria_2026_07 (id, usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos, ip_origem, criado_em) VALUES (146, 6, 'INSERT', 'lotes', 1, NULL, '{"numero_lote": "LOT-2026-001-A", "quantidade_adquirida": 1000}', '192.168.1.102', '2026-07-07 08:20:07.92191-05');


--
-- TOC entry 5096 (class 0 OID 122947)
-- Dependencies: 232
-- Data for Name: log_auditoria_2026_08; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5097 (class 0 OID 122953)
-- Dependencies: 233
-- Data for Name: log_auditoria_2026_09; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5103 (class 0 OID 122986)
-- Dependencies: 240
-- Data for Name: movimentacoes_estoque_2026_07; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5104 (class 0 OID 122993)
-- Dependencies: 241
-- Data for Name: movimentacoes_estoque_2026_08; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5105 (class 0 OID 123000)
-- Dependencies: 242
-- Data for Name: movimentacoes_estoque_2026_09; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--



--
-- TOC entry 5113 (class 0 OID 123026)
-- Dependencies: 250
-- Data for Name: tipos_movimento; Type: TABLE DATA; Schema: ibsaude; Owner: postgres
--

INSERT INTO ibsaude.tipos_movimento (id, nome, descricao, sinal) OVERRIDING SYSTEM VALUE VALUES (1, 'ENTRADA', 'Entrada de medicamentos via compra', 1);
INSERT INTO ibsaude.tipos_movimento (id, nome, descricao, sinal) OVERRIDING SYSTEM VALUE VALUES (2, 'SAIDA', 'Saída de medicamentos via distribuição', -1);
INSERT INTO ibsaude.tipos_movimento (id, nome, descricao, sinal) OVERRIDING SYSTEM VALUE VALUES (3, 'AJUSTE_POSITIVO', 'Ajuste manual positivo no estoque', 1);
INSERT INTO ibsaude.tipos_movimento (id, nome, descricao, sinal) OVERRIDING SYSTEM VALUE VALUES (4, 'AJUSTE_NEGATIVO', 'Ajuste manual negativo no estoque', -1);
INSERT INTO ibsaude.tipos_movimento (id, nome, descricao, sinal) OVERRIDING SYSTEM VALUE VALUES (5, 'DEVOLUCAO', 'Devolução de medicamentos', 1);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 217
-- Name: classificacoes_medicamento_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.classificacoes_medicamento_id_seq', 6, true);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 219
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.compras_id_seq', 7, true);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 221
-- Name: distribuicoes_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.distribuicoes_id_seq', 24, true);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 223
-- Name: distribuicoes_itens_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.distribuicoes_itens_id_seq', 60, true);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 225
-- Name: documentos_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.documentos_id_seq', 10, true);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 227
-- Name: fabricantes_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.fabricantes_id_seq', 9, true);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 229
-- Name: fornecedores_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.fornecedores_id_seq', 6, true);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 234
-- Name: log_auditoria_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.log_auditoria_id_seq', 146, true);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 236
-- Name: lotes_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.lotes_id_seq', 34, true);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 238
-- Name: medicamentos_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.medicamentos_id_seq', 17, true);


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 243
-- Name: movimentacoes_estoque_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.movimentacoes_estoque_id_seq', 38, true);


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 245
-- Name: perfis_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.perfis_id_seq', 4, true);


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 247
-- Name: status_distribuicao_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.status_distribuicao_id_seq', 5, true);


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 249
-- Name: tipos_documento_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.tipos_documento_id_seq', 4, true);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 251
-- Name: tipos_movimento_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.tipos_movimento_id_seq', 5, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 253
-- Name: unidades_saude_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.unidades_saude_id_seq', 7, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 255
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: ibsaude; Owner: postgres
--

SELECT pg_catalog.setval('ibsaude.usuarios_id_seq', 7, true);


-- Completed on 2026-07-09 11:01:39

--
-- PostgreSQL database dump complete
--

