--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2026-07-09 10:59:26

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
-- TOC entry 6 (class 2615 OID 122884)
-- Name: ibsaude; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ibsaude;


ALTER SCHEMA ibsaude OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 122885)
-- Name: atualizar_saldo_lote(); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.atualizar_saldo_lote() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    sinal_movimento INTEGER;
BEGIN
    SELECT sinal INTO sinal_movimento 
    FROM tipos_movimento 
    WHERE id = NEW.tipo_movimento_id;
    
    UPDATE lotes 
    SET quantidade_atual = quantidade_atual + (NEW.quantidade * sinal_movimento)
    WHERE id = NEW.lote_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION ibsaude.atualizar_saldo_lote() OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 122886)
-- Name: bloquear_alteracao_log(); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.bloquear_alteracao_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'log_auditoria é imutável: % não é permitido', TG_OP;
END;
$$;


ALTER FUNCTION ibsaude.bloquear_alteracao_log() OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 122887)
-- Name: criar_particao_mensal(text, date); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.criar_particao_mensal(tabela_base text, mes_referencia date) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    nome_particao TEXT := tabela_base || '_' || to_char(mes_referencia, 'YYYY_MM');
    inicio DATE := date_trunc('month', mes_referencia);
    fim    DATE := inicio + INTERVAL '1 month';
BEGIN
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES FROM (%L) TO (%L)',
        nome_particao, tabela_base, inicio, fim
    );
END;
$$;


ALTER FUNCTION ibsaude.criar_particao_mensal(tabela_base text, mes_referencia date) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 122888)
-- Name: fn_auditoria(); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.fn_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    usuario_atual BIGINT;
BEGIN
    -- Em produção: usuario_atual viria de current_setting('app.usuario_id', true)
    -- setado pela aplicação no início de cada transação.
    usuario_atual := NULLIF(current_setting('app.usuario_id', true), '')::BIGINT;

    IF TG_OP = 'DELETE' THEN
        INSERT INTO log_auditoria (usuario_id, acao, tabela_afetada, registro_id, dados_anteriores)
        VALUES (usuario_atual, TG_OP, TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO log_auditoria (usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos)
        VALUES (usuario_atual, TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSE
        INSERT INTO log_auditoria (usuario_id, acao, tabela_afetada, registro_id, dados_novos)
        VALUES (usuario_atual, TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
        RETURN NEW;
    END IF;
END;
$$;


ALTER FUNCTION ibsaude.fn_auditoria() OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 122889)
-- Name: registrar_entrada_lote(); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.registrar_entrada_lote() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    tipo_entrada_id BIGINT;
BEGIN
    SELECT id INTO tipo_entrada_id FROM tipos_movimento WHERE nome = 'ENTRADA';
    
    INSERT INTO movimentacoes_estoque
        (lote_id, tipo_movimento_id, quantidade, usuario_id, referencia_tabela, referencia_id)
    SELECT NEW.id, tipo_entrada_id, NEW.quantidade_adquirida, c.responsavel_recebimento_id,
            'compras', NEW.compra_id
    FROM compras c WHERE c.id = NEW.compra_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION ibsaude.registrar_entrada_lote() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 122890)
-- Name: registrar_saida_distribuicao(); Type: FUNCTION; Schema: ibsaude; Owner: postgres
--

CREATE FUNCTION ibsaude.registrar_saida_distribuicao() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    saldo_disponivel NUMERIC(12,2);
    usuario_responsavel BIGINT;
    tipo_saida_id BIGINT;
BEGIN
    SELECT quantidade_atual INTO saldo_disponivel FROM lotes WHERE id = NEW.lote_id;
    IF saldo_disponivel < NEW.quantidade THEN
        RAISE EXCEPTION 'Saldo insuficiente no lote % (disponível: %, solicitado: %)',
            NEW.lote_id, saldo_disponivel, NEW.quantidade;
    END IF;

    SELECT responsavel_liberacao_id INTO usuario_responsavel
    FROM distribuicoes WHERE id = NEW.distribuicao_id;
    
    SELECT id INTO tipo_saida_id FROM tipos_movimento WHERE nome = 'SAIDA';

    INSERT INTO movimentacoes_estoque
        (lote_id, tipo_movimento_id, quantidade, usuario_id, referencia_tabela, referencia_id)
    VALUES
        (NEW.lote_id, tipo_saida_id, NEW.quantidade, usuario_responsavel,
            'distribuicoes_itens', NEW.id);

    RETURN NEW;
END;
$$;


ALTER FUNCTION ibsaude.registrar_saida_distribuicao() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 122891)
-- Name: classificacoes_medicamento; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.classificacoes_medicamento (
    id bigint NOT NULL,
    nome character varying(30) NOT NULL,
    descricao text
);


ALTER TABLE ibsaude.classificacoes_medicamento OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 122896)
-- Name: classificacoes_medicamento_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.classificacoes_medicamento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.classificacoes_medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 122897)
-- Name: compras; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.compras (
    id bigint NOT NULL,
    numero_nota_fiscal character varying(50) NOT NULL,
    fornecedor_id bigint NOT NULL,
    data_entrada date NOT NULL,
    responsavel_recebimento_id bigint NOT NULL,
    documento_id bigint,
    valor_total numeric(14,2) DEFAULT 0 NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT compras_valor_total_check CHECK ((valor_total >= (0)::numeric))
);


ALTER TABLE ibsaude.compras OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 122903)
-- Name: compras_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.compras ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 122904)
-- Name: distribuicoes; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.distribuicoes (
    id bigint NOT NULL,
    unidade_saude_id bigint NOT NULL,
    status_id bigint DEFAULT 1 NOT NULL,
    data_envio date,
    responsavel_liberacao_id bigint NOT NULL,
    responsavel_recebimento_nome character varying(150),
    documento_pedido_id bigint,
    valor_total numeric(14,2) DEFAULT 0 NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT distribuicoes_valor_total_check CHECK ((valor_total >= (0)::numeric))
);


ALTER TABLE ibsaude.distribuicoes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 122911)
-- Name: distribuicoes_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.distribuicoes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.distribuicoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 122912)
-- Name: distribuicoes_itens; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.distribuicoes_itens (
    id bigint NOT NULL,
    distribuicao_id bigint NOT NULL,
    lote_id bigint NOT NULL,
    quantidade numeric(12,2) NOT NULL,
    valor_unitario numeric(12,4) NOT NULL,
    valor_total numeric(14,2) GENERATED ALWAYS AS ((quantidade * valor_unitario)) STORED,
    CONSTRAINT distribuicoes_itens_quantidade_check CHECK ((quantidade > (0)::numeric)),
    CONSTRAINT distribuicoes_itens_valor_unitario_check CHECK ((valor_unitario >= (0)::numeric))
);


ALTER TABLE ibsaude.distribuicoes_itens OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 122918)
-- Name: distribuicoes_itens_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.distribuicoes_itens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.distribuicoes_itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 122919)
-- Name: documentos; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.documentos (
    id bigint NOT NULL,
    tipo_documento_id bigint NOT NULL,
    nome_arquivo character varying(255) NOT NULL,
    caminho_storage text NOT NULL,
    hash_sha256 character(64),
    tamanho_bytes bigint,
    enviado_por bigint,
    criado_em timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ibsaude.documentos OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 122925)
-- Name: documentos_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.documentos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.documentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 122926)
-- Name: fabricantes; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.fabricantes (
    id bigint NOT NULL,
    nome character varying(150) NOT NULL,
    cnpj character varying(18),
    pais character varying(60) NOT NULL
);


ALTER TABLE ibsaude.fabricantes OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 122929)
-- Name: fabricantes_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.fabricantes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.fabricantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 122930)
-- Name: fornecedores; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.fornecedores (
    id bigint NOT NULL,
    nome character varying(150) NOT NULL,
    cnpj character varying(18) NOT NULL,
    telefone character varying(20),
    email character varying(150),
    endereco text,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE ibsaude.fornecedores OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 122936)
-- Name: fornecedores_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.fornecedores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.fornecedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 122937)
-- Name: log_auditoria; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.log_auditoria (
    id bigint NOT NULL,
    usuario_id bigint,
    acao character varying(20) NOT NULL,
    tabela_afetada character varying(60) NOT NULL,
    registro_id bigint,
    dados_anteriores jsonb,
    dados_novos jsonb,
    ip_origem inet,
    criado_em timestamp with time zone DEFAULT now() NOT NULL
)
PARTITION BY RANGE (criado_em);


ALTER TABLE ibsaude.log_auditoria OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 122941)
-- Name: log_auditoria_2026_07; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.log_auditoria_2026_07 (
    id bigint NOT NULL,
    usuario_id bigint,
    acao character varying(20) NOT NULL,
    tabela_afetada character varying(60) NOT NULL,
    registro_id bigint,
    dados_anteriores jsonb,
    dados_novos jsonb,
    ip_origem inet,
    criado_em timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ibsaude.log_auditoria_2026_07 OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 122947)
-- Name: log_auditoria_2026_08; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.log_auditoria_2026_08 (
    id bigint NOT NULL,
    usuario_id bigint,
    acao character varying(20) NOT NULL,
    tabela_afetada character varying(60) NOT NULL,
    registro_id bigint,
    dados_anteriores jsonb,
    dados_novos jsonb,
    ip_origem inet,
    criado_em timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ibsaude.log_auditoria_2026_08 OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 122953)
-- Name: log_auditoria_2026_09; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.log_auditoria_2026_09 (
    id bigint NOT NULL,
    usuario_id bigint,
    acao character varying(20) NOT NULL,
    tabela_afetada character varying(60) NOT NULL,
    registro_id bigint,
    dados_anteriores jsonb,
    dados_novos jsonb,
    ip_origem inet,
    criado_em timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ibsaude.log_auditoria_2026_09 OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 122959)
-- Name: log_auditoria_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.log_auditoria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.log_auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 122960)
-- Name: lotes; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.lotes (
    id bigint NOT NULL,
    medicamento_id bigint NOT NULL,
    compra_id bigint NOT NULL,
    numero_lote character varying(50) NOT NULL,
    data_validade date NOT NULL,
    quantidade_adquirida numeric(12,2) NOT NULL,
    valor_unitario numeric(12,4) NOT NULL,
    valor_total numeric(14,2) GENERATED ALWAYS AS ((quantidade_adquirida * valor_unitario)) STORED,
    quantidade_atual numeric(12,2) DEFAULT 0 NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT lotes_quantidade_adquirida_check CHECK ((quantidade_adquirida > (0)::numeric)),
    CONSTRAINT lotes_quantidade_atual_check CHECK ((quantidade_atual >= (0)::numeric)),
    CONSTRAINT lotes_valor_unitario_check CHECK ((valor_unitario >= (0)::numeric))
);


ALTER TABLE ibsaude.lotes OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 122969)
-- Name: lotes_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.lotes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 122970)
-- Name: medicamentos; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.medicamentos (
    id bigint NOT NULL,
    nome character varying(150) NOT NULL,
    classificacao_id bigint NOT NULL,
    codigo_interno character varying(30),
    codigo_oficial character varying(30),
    uso_especifico text,
    apresentacao character varying(60) NOT NULL,
    fabricante_id bigint NOT NULL,
    estoque_minimo numeric(12,2) DEFAULT 0 NOT NULL,
    dias_alerta_vencimento integer DEFAULT 90 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT medicamentos_estoque_minimo_check CHECK ((estoque_minimo >= (0)::numeric))
);


ALTER TABLE ibsaude.medicamentos OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 122980)
-- Name: medicamentos_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.medicamentos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.medicamentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 122981)
-- Name: movimentacoes_estoque; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.movimentacoes_estoque (
    id bigint NOT NULL,
    lote_id bigint NOT NULL,
    tipo_movimento_id bigint NOT NULL,
    quantidade numeric(12,2) NOT NULL,
    data_movimento timestamp with time zone DEFAULT now() NOT NULL,
    usuario_id bigint NOT NULL,
    referencia_tabela character varying(40),
    referencia_id bigint,
    observacao text,
    CONSTRAINT movimentacoes_estoque_quantidade_check CHECK ((quantidade > (0)::numeric))
)
PARTITION BY RANGE (data_movimento);


ALTER TABLE ibsaude.movimentacoes_estoque OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 122986)
-- Name: movimentacoes_estoque_2026_07; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.movimentacoes_estoque_2026_07 (
    id bigint NOT NULL,
    lote_id bigint NOT NULL,
    tipo_movimento_id bigint NOT NULL,
    quantidade numeric(12,2) NOT NULL,
    data_movimento timestamp with time zone DEFAULT now() NOT NULL,
    usuario_id bigint NOT NULL,
    referencia_tabela character varying(40),
    referencia_id bigint,
    observacao text,
    CONSTRAINT movimentacoes_estoque_quantidade_check CHECK ((quantidade > (0)::numeric))
);


ALTER TABLE ibsaude.movimentacoes_estoque_2026_07 OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 122993)
-- Name: movimentacoes_estoque_2026_08; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.movimentacoes_estoque_2026_08 (
    id bigint NOT NULL,
    lote_id bigint NOT NULL,
    tipo_movimento_id bigint NOT NULL,
    quantidade numeric(12,2) NOT NULL,
    data_movimento timestamp with time zone DEFAULT now() NOT NULL,
    usuario_id bigint NOT NULL,
    referencia_tabela character varying(40),
    referencia_id bigint,
    observacao text,
    CONSTRAINT movimentacoes_estoque_quantidade_check CHECK ((quantidade > (0)::numeric))
);


ALTER TABLE ibsaude.movimentacoes_estoque_2026_08 OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 123000)
-- Name: movimentacoes_estoque_2026_09; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.movimentacoes_estoque_2026_09 (
    id bigint NOT NULL,
    lote_id bigint NOT NULL,
    tipo_movimento_id bigint NOT NULL,
    quantidade numeric(12,2) NOT NULL,
    data_movimento timestamp with time zone DEFAULT now() NOT NULL,
    usuario_id bigint NOT NULL,
    referencia_tabela character varying(40),
    referencia_id bigint,
    observacao text,
    CONSTRAINT movimentacoes_estoque_quantidade_check CHECK ((quantidade > (0)::numeric))
);


ALTER TABLE ibsaude.movimentacoes_estoque_2026_09 OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 123007)
-- Name: movimentacoes_estoque_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.movimentacoes_estoque ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.movimentacoes_estoque_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 123008)
-- Name: perfis; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.perfis (
    id bigint NOT NULL,
    nome character varying(30) NOT NULL,
    descricao text
);


ALTER TABLE ibsaude.perfis OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 123013)
-- Name: perfis_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.perfis ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 123014)
-- Name: status_distribuicao; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.status_distribuicao (
    id bigint NOT NULL,
    nome character varying(20) NOT NULL,
    descricao text,
    ordem integer NOT NULL
);


ALTER TABLE ibsaude.status_distribuicao OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 123019)
-- Name: status_distribuicao_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.status_distribuicao ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.status_distribuicao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 248 (class 1259 OID 123020)
-- Name: tipos_documento; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.tipos_documento (
    id bigint NOT NULL,
    nome character varying(30) NOT NULL,
    descricao text
);


ALTER TABLE ibsaude.tipos_documento OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 123025)
-- Name: tipos_documento_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.tipos_documento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.tipos_documento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 123026)
-- Name: tipos_movimento; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.tipos_movimento (
    id bigint NOT NULL,
    nome character varying(20) NOT NULL,
    descricao text,
    sinal integer NOT NULL,
    CONSTRAINT tipos_movimento_sinal_check CHECK ((sinal = ANY (ARRAY[1, '-1'::integer])))
);


ALTER TABLE ibsaude.tipos_movimento OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 123032)
-- Name: tipos_movimento_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.tipos_movimento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.tipos_movimento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 123033)
-- Name: unidades_saude; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.unidades_saude (
    id bigint NOT NULL,
    nome character varying(150) NOT NULL,
    cnpj character varying(18),
    tipo character varying(60),
    endereco text,
    responsavel_local character varying(150),
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE ibsaude.unidades_saude OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 123039)
-- Name: unidades_saude_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.unidades_saude ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.unidades_saude_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 254 (class 1259 OID 123040)
-- Name: usuarios; Type: TABLE; Schema: ibsaude; Owner: postgres
--

CREATE TABLE ibsaude.usuarios (
    id bigint NOT NULL,
    nome character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    senha_hash text NOT NULL,
    perfil_id bigint NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    atualizado_em timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ibsaude.usuarios OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 123048)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.usuarios ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ibsaude.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 256 (class 1259 OID 123049)
-- Name: vw_alertas_vencimento; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_alertas_vencimento AS
 SELECT l.id AS lote_id,
    m.nome AS medicamento,
    l.numero_lote,
    l.data_validade,
    l.quantidade_atual,
    (l.data_validade - CURRENT_DATE) AS dias_para_vencer
   FROM (ibsaude.lotes l
     JOIN ibsaude.medicamentos m ON ((m.id = l.medicamento_id)))
  WHERE ((l.quantidade_atual > (0)::numeric) AND (l.data_validade <= (CURRENT_DATE + ((m.dias_alerta_vencimento || ' days'::text))::interval)))
  ORDER BY l.data_validade;


ALTER VIEW ibsaude.vw_alertas_vencimento OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 123054)
-- Name: vw_estoque_atual; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_estoque_atual AS
 SELECT m.id AS medicamento_id,
    m.nome AS medicamento,
    c.nome AS classificacao,
    sum(l.quantidade_atual) AS saldo_total,
    m.estoque_minimo,
    (sum(l.quantidade_atual) < m.estoque_minimo) AS estoque_critico
   FROM ((ibsaude.medicamentos m
     LEFT JOIN ibsaude.classificacoes_medicamento c ON ((c.id = m.classificacao_id)))
     LEFT JOIN ibsaude.lotes l ON ((l.medicamento_id = m.id)))
  WHERE m.ativo
  GROUP BY m.id, m.nome, c.nome, m.estoque_minimo;


ALTER VIEW ibsaude.vw_estoque_atual OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 123059)
-- Name: vw_itens_criticos; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_itens_criticos AS
 SELECT medicamento_id,
    medicamento,
    classificacao,
    saldo_total,
    estoque_minimo,
    estoque_critico
   FROM ibsaude.vw_estoque_atual
  WHERE estoque_critico;


ALTER VIEW ibsaude.vw_itens_criticos OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 123063)
-- Name: vw_rastreabilidade_lote; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_rastreabilidade_lote AS
 SELECT l.id AS lote_id,
    l.numero_lote,
    med.nome AS medicamento,
    c.data_entrada,
    ur.nome AS registrado_por,
    us.nome AS unidade_destino,
    di.quantidade AS quantidade_enviada,
    ul.nome AS autorizado_por,
    d.data_envio,
    l.valor_unitario,
    di.valor_total AS custo_saida
   FROM (((((((ibsaude.lotes l
     JOIN ibsaude.medicamentos med ON ((med.id = l.medicamento_id)))
     JOIN ibsaude.compras c ON ((c.id = l.compra_id)))
     JOIN ibsaude.usuarios ur ON ((ur.id = c.responsavel_recebimento_id)))
     LEFT JOIN ibsaude.distribuicoes_itens di ON ((di.lote_id = l.id)))
     LEFT JOIN ibsaude.distribuicoes d ON ((d.id = di.distribuicao_id)))
     LEFT JOIN ibsaude.unidades_saude us ON ((us.id = d.unidade_saude_id)))
     LEFT JOIN ibsaude.usuarios ul ON ((ul.id = d.responsavel_liberacao_id)));


ALTER VIEW ibsaude.vw_rastreabilidade_lote OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 123068)
-- Name: vw_relatorio_por_unidade; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_relatorio_por_unidade AS
 SELECT u.id AS unidade_saude_id,
    u.nome AS unidade_saude,
    count(DISTINCT d.id) AS total_distribuicoes,
    COALESCE(sum(d.valor_total), (0)::numeric) AS valor_total_recebido
   FROM (ibsaude.unidades_saude u
     LEFT JOIN ibsaude.distribuicoes d ON ((d.unidade_saude_id = u.id)))
  GROUP BY u.id, u.nome;


ALTER VIEW ibsaude.vw_relatorio_por_unidade OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 123073)
-- Name: vw_total_investido_mensal; Type: VIEW; Schema: ibsaude; Owner: postgres
--

CREATE VIEW ibsaude.vw_total_investido_mensal AS
 SELECT date_trunc('month'::text, (data_entrada)::timestamp with time zone) AS mes,
    sum(valor_total) AS total_investido
   FROM ibsaude.compras c
  GROUP BY (date_trunc('month'::text, (data_entrada)::timestamp with time zone))
  ORDER BY (date_trunc('month'::text, (data_entrada)::timestamp with time zone));


ALTER VIEW ibsaude.vw_total_investido_mensal OWNER TO postgres;

--
-- TOC entry 4769 (class 0 OID 0)
-- Name: log_auditoria_2026_07; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria ATTACH PARTITION ibsaude.log_auditoria_2026_07 FOR VALUES FROM ('2026-06-30 22:00:00-05') TO ('2026-07-31 22:00:00-05');


--
-- TOC entry 4770 (class 0 OID 0)
-- Name: log_auditoria_2026_08; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria ATTACH PARTITION ibsaude.log_auditoria_2026_08 FOR VALUES FROM ('2026-07-31 22:00:00-05') TO ('2026-08-31 22:00:00-05');


--
-- TOC entry 4771 (class 0 OID 0)
-- Name: log_auditoria_2026_09; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria ATTACH PARTITION ibsaude.log_auditoria_2026_09 FOR VALUES FROM ('2026-08-31 22:00:00-05') TO ('2026-09-30 22:00:00-05');


--
-- TOC entry 4772 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_07; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_07 FOR VALUES FROM ('2026-06-30 22:00:00-05') TO ('2026-07-31 22:00:00-05');


--
-- TOC entry 4773 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_08; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_08 FOR VALUES FROM ('2026-07-31 22:00:00-05') TO ('2026-08-31 22:00:00-05');


--
-- TOC entry 4774 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_09; Type: TABLE ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_09 FOR VALUES FROM ('2026-08-31 22:00:00-05') TO ('2026-09-30 22:00:00-05');


--
-- TOC entry 4816 (class 2606 OID 123078)
-- Name: classificacoes_medicamento classificacoes_medicamento_nome_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.classificacoes_medicamento
    ADD CONSTRAINT classificacoes_medicamento_nome_key UNIQUE (nome);


--
-- TOC entry 4818 (class 2606 OID 123080)
-- Name: classificacoes_medicamento classificacoes_medicamento_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.classificacoes_medicamento
    ADD CONSTRAINT classificacoes_medicamento_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 123082)
-- Name: compras compras_numero_nota_fiscal_fornecedor_id_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.compras
    ADD CONSTRAINT compras_numero_nota_fiscal_fornecedor_id_key UNIQUE (numero_nota_fiscal, fornecedor_id);


--
-- TOC entry 4822 (class 2606 OID 123084)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 123086)
-- Name: distribuicoes_itens distribuicoes_itens_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes_itens
    ADD CONSTRAINT distribuicoes_itens_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 123088)
-- Name: distribuicoes distribuicoes_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes
    ADD CONSTRAINT distribuicoes_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 123090)
-- Name: documentos documentos_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.documentos
    ADD CONSTRAINT documentos_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 123092)
-- Name: fabricantes fabricantes_cnpj_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.fabricantes
    ADD CONSTRAINT fabricantes_cnpj_key UNIQUE (cnpj);


--
-- TOC entry 4839 (class 2606 OID 123094)
-- Name: fabricantes fabricantes_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.fabricantes
    ADD CONSTRAINT fabricantes_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 123096)
-- Name: fornecedores fornecedores_cnpj_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.fornecedores
    ADD CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj);


--
-- TOC entry 4843 (class 2606 OID 123098)
-- Name: fornecedores fornecedores_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 123100)
-- Name: log_auditoria log_auditoria_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria
    ADD CONSTRAINT log_auditoria_pkey PRIMARY KEY (id, criado_em);


--
-- TOC entry 4850 (class 2606 OID 123102)
-- Name: log_auditoria_2026_07 log_auditoria_2026_07_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria_2026_07
    ADD CONSTRAINT log_auditoria_2026_07_pkey PRIMARY KEY (id, criado_em);


--
-- TOC entry 4855 (class 2606 OID 123104)
-- Name: log_auditoria_2026_08 log_auditoria_2026_08_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria_2026_08
    ADD CONSTRAINT log_auditoria_2026_08_pkey PRIMARY KEY (id, criado_em);


--
-- TOC entry 4860 (class 2606 OID 123106)
-- Name: log_auditoria_2026_09 log_auditoria_2026_09_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.log_auditoria_2026_09
    ADD CONSTRAINT log_auditoria_2026_09_pkey PRIMARY KEY (id, criado_em);


--
-- TOC entry 4869 (class 2606 OID 123108)
-- Name: lotes lotes_medicamento_id_numero_lote_compra_id_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.lotes
    ADD CONSTRAINT lotes_medicamento_id_numero_lote_compra_id_key UNIQUE (medicamento_id, numero_lote, compra_id);


--
-- TOC entry 4871 (class 2606 OID 123110)
-- Name: lotes lotes_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.lotes
    ADD CONSTRAINT lotes_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 123112)
-- Name: medicamentos medicamentos_codigo_interno_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.medicamentos
    ADD CONSTRAINT medicamentos_codigo_interno_key UNIQUE (codigo_interno);


--
-- TOC entry 4877 (class 2606 OID 123114)
-- Name: medicamentos medicamentos_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 123116)
-- Name: movimentacoes_estoque movimentacoes_estoque_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque
    ADD CONSTRAINT movimentacoes_estoque_pkey PRIMARY KEY (id, data_movimento);


--
-- TOC entry 4884 (class 2606 OID 123118)
-- Name: movimentacoes_estoque_2026_07 movimentacoes_estoque_2026_07_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque_2026_07
    ADD CONSTRAINT movimentacoes_estoque_2026_07_pkey PRIMARY KEY (id, data_movimento);


--
-- TOC entry 4888 (class 2606 OID 123120)
-- Name: movimentacoes_estoque_2026_08 movimentacoes_estoque_2026_08_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque_2026_08
    ADD CONSTRAINT movimentacoes_estoque_2026_08_pkey PRIMARY KEY (id, data_movimento);


--
-- TOC entry 4892 (class 2606 OID 123122)
-- Name: movimentacoes_estoque_2026_09 movimentacoes_estoque_2026_09_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.movimentacoes_estoque_2026_09
    ADD CONSTRAINT movimentacoes_estoque_2026_09_pkey PRIMARY KEY (id, data_movimento);


--
-- TOC entry 4895 (class 2606 OID 123124)
-- Name: perfis perfis_nome_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.perfis
    ADD CONSTRAINT perfis_nome_key UNIQUE (nome);


--
-- TOC entry 4897 (class 2606 OID 123126)
-- Name: perfis perfis_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.perfis
    ADD CONSTRAINT perfis_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 123128)
-- Name: status_distribuicao status_distribuicao_nome_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.status_distribuicao
    ADD CONSTRAINT status_distribuicao_nome_key UNIQUE (nome);


--
-- TOC entry 4901 (class 2606 OID 123130)
-- Name: status_distribuicao status_distribuicao_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.status_distribuicao
    ADD CONSTRAINT status_distribuicao_pkey PRIMARY KEY (id);


--
-- TOC entry 4903 (class 2606 OID 123132)
-- Name: tipos_documento tipos_documento_nome_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.tipos_documento
    ADD CONSTRAINT tipos_documento_nome_key UNIQUE (nome);


--
-- TOC entry 4905 (class 2606 OID 123134)
-- Name: tipos_documento tipos_documento_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.tipos_documento
    ADD CONSTRAINT tipos_documento_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 123136)
-- Name: tipos_movimento tipos_movimento_nome_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.tipos_movimento
    ADD CONSTRAINT tipos_movimento_nome_key UNIQUE (nome);


--
-- TOC entry 4909 (class 2606 OID 123138)
-- Name: tipos_movimento tipos_movimento_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.tipos_movimento
    ADD CONSTRAINT tipos_movimento_pkey PRIMARY KEY (id);


--
-- TOC entry 4911 (class 2606 OID 123140)
-- Name: unidades_saude unidades_saude_cnpj_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.unidades_saude
    ADD CONSTRAINT unidades_saude_cnpj_key UNIQUE (cnpj);


--
-- TOC entry 4913 (class 2606 OID 123142)
-- Name: unidades_saude unidades_saude_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.unidades_saude
    ADD CONSTRAINT unidades_saude_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 123144)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4918 (class 2606 OID 123146)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 1259 OID 123147)
-- Name: idx_compras_data; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_compras_data ON ibsaude.compras USING btree (data_entrada);


--
-- TOC entry 4824 (class 1259 OID 123148)
-- Name: idx_compras_fornecedor; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_compras_fornecedor ON ibsaude.compras USING btree (fornecedor_id);


--
-- TOC entry 4832 (class 1259 OID 123149)
-- Name: idx_dist_itens_distribuicao; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_dist_itens_distribuicao ON ibsaude.distribuicoes_itens USING btree (distribuicao_id);


--
-- TOC entry 4833 (class 1259 OID 123150)
-- Name: idx_dist_itens_lote; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_dist_itens_lote ON ibsaude.distribuicoes_itens USING btree (lote_id);


--
-- TOC entry 4827 (class 1259 OID 123151)
-- Name: idx_distribuicoes_data; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_distribuicoes_data ON ibsaude.distribuicoes USING btree (data_envio);


--
-- TOC entry 4828 (class 1259 OID 123152)
-- Name: idx_distribuicoes_status; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_distribuicoes_status ON ibsaude.distribuicoes USING btree (status_id);


--
-- TOC entry 4829 (class 1259 OID 123153)
-- Name: idx_distribuicoes_unidade; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_distribuicoes_unidade ON ibsaude.distribuicoes USING btree (unidade_saude_id);


--
-- TOC entry 4844 (class 1259 OID 123154)
-- Name: idx_log_registro; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_log_registro ON ONLY ibsaude.log_auditoria USING btree (tabela_afetada, registro_id);


--
-- TOC entry 4845 (class 1259 OID 123155)
-- Name: idx_log_tabela; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_log_tabela ON ONLY ibsaude.log_auditoria USING btree (tabela_afetada);


--
-- TOC entry 4846 (class 1259 OID 123156)
-- Name: idx_log_usuario; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_log_usuario ON ONLY ibsaude.log_auditoria USING btree (usuario_id);


--
-- TOC entry 4864 (class 1259 OID 123157)
-- Name: idx_lotes_compra; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_lotes_compra ON ibsaude.lotes USING btree (compra_id);


--
-- TOC entry 4865 (class 1259 OID 123158)
-- Name: idx_lotes_medicamento; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_lotes_medicamento ON ibsaude.lotes USING btree (medicamento_id);


--
-- TOC entry 4866 (class 1259 OID 123159)
-- Name: idx_lotes_peps; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_lotes_peps ON ibsaude.lotes USING btree (medicamento_id, data_validade) WHERE (quantidade_atual > (0)::numeric);


--
-- TOC entry 4867 (class 1259 OID 123160)
-- Name: idx_lotes_validade; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_lotes_validade ON ibsaude.lotes USING btree (data_validade);


--
-- TOC entry 4872 (class 1259 OID 123161)
-- Name: idx_medicamentos_busca; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_medicamentos_busca ON ibsaude.medicamentos USING gin (to_tsvector('portuguese'::regconfig, (nome)::text));


--
-- TOC entry 4873 (class 1259 OID 123162)
-- Name: idx_medicamentos_classificacao; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_medicamentos_classificacao ON ibsaude.medicamentos USING btree (classificacao_id);


--
-- TOC entry 4878 (class 1259 OID 123163)
-- Name: idx_mov_lote; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_mov_lote ON ONLY ibsaude.movimentacoes_estoque USING btree (lote_id);


--
-- TOC entry 4879 (class 1259 OID 123164)
-- Name: idx_mov_tipo; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_mov_tipo ON ONLY ibsaude.movimentacoes_estoque USING btree (tipo_movimento_id);


--
-- TOC entry 4914 (class 1259 OID 123165)
-- Name: idx_usuarios_perfil; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX idx_usuarios_perfil ON ibsaude.usuarios USING btree (perfil_id) WHERE ativo;


--
-- TOC entry 4851 (class 1259 OID 123166)
-- Name: log_auditoria_2026_07_tabela_afetada_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_07_tabela_afetada_idx ON ibsaude.log_auditoria_2026_07 USING btree (tabela_afetada);


--
-- TOC entry 4852 (class 1259 OID 123167)
-- Name: log_auditoria_2026_07_tabela_afetada_registro_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_07_tabela_afetada_registro_id_idx ON ibsaude.log_auditoria_2026_07 USING btree (tabela_afetada, registro_id);


--
-- TOC entry 4853 (class 1259 OID 123168)
-- Name: log_auditoria_2026_07_usuario_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_07_usuario_id_idx ON ibsaude.log_auditoria_2026_07 USING btree (usuario_id);


--
-- TOC entry 4856 (class 1259 OID 123169)
-- Name: log_auditoria_2026_08_tabela_afetada_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_08_tabela_afetada_idx ON ibsaude.log_auditoria_2026_08 USING btree (tabela_afetada);


--
-- TOC entry 4857 (class 1259 OID 123170)
-- Name: log_auditoria_2026_08_tabela_afetada_registro_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_08_tabela_afetada_registro_id_idx ON ibsaude.log_auditoria_2026_08 USING btree (tabela_afetada, registro_id);


--
-- TOC entry 4858 (class 1259 OID 123171)
-- Name: log_auditoria_2026_08_usuario_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_08_usuario_id_idx ON ibsaude.log_auditoria_2026_08 USING btree (usuario_id);


--
-- TOC entry 4861 (class 1259 OID 123172)
-- Name: log_auditoria_2026_09_tabela_afetada_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_09_tabela_afetada_idx ON ibsaude.log_auditoria_2026_09 USING btree (tabela_afetada);


--
-- TOC entry 4862 (class 1259 OID 123173)
-- Name: log_auditoria_2026_09_tabela_afetada_registro_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_09_tabela_afetada_registro_id_idx ON ibsaude.log_auditoria_2026_09 USING btree (tabela_afetada, registro_id);


--
-- TOC entry 4863 (class 1259 OID 123174)
-- Name: log_auditoria_2026_09_usuario_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX log_auditoria_2026_09_usuario_id_idx ON ibsaude.log_auditoria_2026_09 USING btree (usuario_id);


--
-- TOC entry 4882 (class 1259 OID 123175)
-- Name: movimentacoes_estoque_2026_07_lote_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_07_lote_id_idx ON ibsaude.movimentacoes_estoque_2026_07 USING btree (lote_id);


--
-- TOC entry 4885 (class 1259 OID 123176)
-- Name: movimentacoes_estoque_2026_07_tipo_movimento_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_07_tipo_movimento_id_idx ON ibsaude.movimentacoes_estoque_2026_07 USING btree (tipo_movimento_id);


--
-- TOC entry 4886 (class 1259 OID 123177)
-- Name: movimentacoes_estoque_2026_08_lote_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_08_lote_id_idx ON ibsaude.movimentacoes_estoque_2026_08 USING btree (lote_id);


--
-- TOC entry 4889 (class 1259 OID 123178)
-- Name: movimentacoes_estoque_2026_08_tipo_movimento_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_08_tipo_movimento_id_idx ON ibsaude.movimentacoes_estoque_2026_08 USING btree (tipo_movimento_id);


--
-- TOC entry 4890 (class 1259 OID 123179)
-- Name: movimentacoes_estoque_2026_09_lote_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_09_lote_id_idx ON ibsaude.movimentacoes_estoque_2026_09 USING btree (lote_id);


--
-- TOC entry 4893 (class 1259 OID 123180)
-- Name: movimentacoes_estoque_2026_09_tipo_movimento_id_idx; Type: INDEX; Schema: ibsaude; Owner: postgres
--

CREATE INDEX movimentacoes_estoque_2026_09_tipo_movimento_id_idx ON ibsaude.movimentacoes_estoque_2026_09 USING btree (tipo_movimento_id);


--
-- TOC entry 4919 (class 0 OID 0)
-- Name: log_auditoria_2026_07_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.log_auditoria_pkey ATTACH PARTITION ibsaude.log_auditoria_2026_07_pkey;


--
-- TOC entry 4920 (class 0 OID 0)
-- Name: log_auditoria_2026_07_tabela_afetada_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_tabela ATTACH PARTITION ibsaude.log_auditoria_2026_07_tabela_afetada_idx;


--
-- TOC entry 4921 (class 0 OID 0)
-- Name: log_auditoria_2026_07_tabela_afetada_registro_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_registro ATTACH PARTITION ibsaude.log_auditoria_2026_07_tabela_afetada_registro_id_idx;


--
-- TOC entry 4922 (class 0 OID 0)
-- Name: log_auditoria_2026_07_usuario_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_usuario ATTACH PARTITION ibsaude.log_auditoria_2026_07_usuario_id_idx;


--
-- TOC entry 4923 (class 0 OID 0)
-- Name: log_auditoria_2026_08_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.log_auditoria_pkey ATTACH PARTITION ibsaude.log_auditoria_2026_08_pkey;


--
-- TOC entry 4924 (class 0 OID 0)
-- Name: log_auditoria_2026_08_tabela_afetada_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_tabela ATTACH PARTITION ibsaude.log_auditoria_2026_08_tabela_afetada_idx;


--
-- TOC entry 4925 (class 0 OID 0)
-- Name: log_auditoria_2026_08_tabela_afetada_registro_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_registro ATTACH PARTITION ibsaude.log_auditoria_2026_08_tabela_afetada_registro_id_idx;


--
-- TOC entry 4926 (class 0 OID 0)
-- Name: log_auditoria_2026_08_usuario_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_usuario ATTACH PARTITION ibsaude.log_auditoria_2026_08_usuario_id_idx;


--
-- TOC entry 4927 (class 0 OID 0)
-- Name: log_auditoria_2026_09_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.log_auditoria_pkey ATTACH PARTITION ibsaude.log_auditoria_2026_09_pkey;


--
-- TOC entry 4928 (class 0 OID 0)
-- Name: log_auditoria_2026_09_tabela_afetada_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_tabela ATTACH PARTITION ibsaude.log_auditoria_2026_09_tabela_afetada_idx;


--
-- TOC entry 4929 (class 0 OID 0)
-- Name: log_auditoria_2026_09_tabela_afetada_registro_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_registro ATTACH PARTITION ibsaude.log_auditoria_2026_09_tabela_afetada_registro_id_idx;


--
-- TOC entry 4930 (class 0 OID 0)
-- Name: log_auditoria_2026_09_usuario_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_log_usuario ATTACH PARTITION ibsaude.log_auditoria_2026_09_usuario_id_idx;


--
-- TOC entry 4931 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_07_lote_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_lote ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_07_lote_id_idx;


--
-- TOC entry 4932 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_07_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.movimentacoes_estoque_pkey ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_07_pkey;


--
-- TOC entry 4933 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_07_tipo_movimento_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_tipo ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_07_tipo_movimento_id_idx;


--
-- TOC entry 4934 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_08_lote_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_lote ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_08_lote_id_idx;


--
-- TOC entry 4935 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_08_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.movimentacoes_estoque_pkey ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_08_pkey;


--
-- TOC entry 4936 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_08_tipo_movimento_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_tipo ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_08_tipo_movimento_id_idx;


--
-- TOC entry 4937 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_09_lote_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_lote ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_09_lote_id_idx;


--
-- TOC entry 4938 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_09_pkey; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.movimentacoes_estoque_pkey ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_09_pkey;


--
-- TOC entry 4939 (class 0 OID 0)
-- Name: movimentacoes_estoque_2026_09_tipo_movimento_id_idx; Type: INDEX ATTACH; Schema: ibsaude; Owner: postgres
--

ALTER INDEX ibsaude.idx_mov_tipo ATTACH PARTITION ibsaude.movimentacoes_estoque_2026_09_tipo_movimento_id_idx;


--
-- TOC entry 4967 (class 2620 OID 123181)
-- Name: movimentacoes_estoque trg_atualizar_saldo_lote; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_atualizar_saldo_lote AFTER INSERT ON ibsaude.movimentacoes_estoque FOR EACH ROW EXECUTE FUNCTION ibsaude.atualizar_saldo_lote();


--
-- TOC entry 4960 (class 2620 OID 123185)
-- Name: distribuicoes trg_auditoria_distribuicoes; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_auditoria_distribuicoes AFTER INSERT OR DELETE OR UPDATE ON ibsaude.distribuicoes FOR EACH ROW EXECUTE FUNCTION ibsaude.fn_auditoria();


--
-- TOC entry 4961 (class 2620 OID 123186)
-- Name: distribuicoes_itens trg_auditoria_distribuicoes_itens; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_auditoria_distribuicoes_itens AFTER INSERT OR DELETE OR UPDATE ON ibsaude.distribuicoes_itens FOR EACH ROW EXECUTE FUNCTION ibsaude.fn_auditoria();


--
-- TOC entry 4964 (class 2620 OID 123187)
-- Name: lotes trg_auditoria_lotes; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_auditoria_lotes AFTER INSERT OR DELETE OR UPDATE ON ibsaude.lotes FOR EACH ROW EXECUTE FUNCTION ibsaude.fn_auditoria();


--
-- TOC entry 4966 (class 2620 OID 123188)
-- Name: medicamentos trg_auditoria_medicamentos; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_auditoria_medicamentos AFTER INSERT OR DELETE OR UPDATE ON ibsaude.medicamentos FOR EACH ROW EXECUTE FUNCTION ibsaude.fn_auditoria();


--
-- TOC entry 4963 (class 2620 OID 123189)
-- Name: log_auditoria trg_log_auditoria_imutavel; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_log_auditoria_imutavel BEFORE DELETE OR UPDATE ON ibsaude.log_auditoria FOR EACH ROW EXECUTE FUNCTION ibsaude.bloquear_alteracao_log();


--
-- TOC entry 4965 (class 2620 OID 123193)
-- Name: lotes trg_registrar_entrada_lote; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_registrar_entrada_lote AFTER INSERT ON ibsaude.lotes FOR EACH ROW EXECUTE FUNCTION ibsaude.registrar_entrada_lote();


--
-- TOC entry 4962 (class 2620 OID 123194)
-- Name: distribuicoes_itens trg_registrar_saida_distribuicao; Type: TRIGGER; Schema: ibsaude; Owner: postgres
--

CREATE TRIGGER trg_registrar_saida_distribuicao AFTER INSERT ON ibsaude.distribuicoes_itens FOR EACH ROW EXECUTE FUNCTION ibsaude.registrar_saida_distribuicao();


--
-- TOC entry 4940 (class 2606 OID 123195)
-- Name: compras compras_documento_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.compras
    ADD CONSTRAINT compras_documento_id_fkey FOREIGN KEY (documento_id) REFERENCES ibsaude.documentos(id);


--
-- TOC entry 4941 (class 2606 OID 123200)
-- Name: compras compras_fornecedor_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.compras
    ADD CONSTRAINT compras_fornecedor_id_fkey FOREIGN KEY (fornecedor_id) REFERENCES ibsaude.fornecedores(id);


--
-- TOC entry 4942 (class 2606 OID 123205)
-- Name: compras compras_responsavel_recebimento_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.compras
    ADD CONSTRAINT compras_responsavel_recebimento_id_fkey FOREIGN KEY (responsavel_recebimento_id) REFERENCES ibsaude.usuarios(id);


--
-- TOC entry 4943 (class 2606 OID 123210)
-- Name: distribuicoes distribuicoes_documento_pedido_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes
    ADD CONSTRAINT distribuicoes_documento_pedido_id_fkey FOREIGN KEY (documento_pedido_id) REFERENCES ibsaude.documentos(id);


--
-- TOC entry 4947 (class 2606 OID 123215)
-- Name: distribuicoes_itens distribuicoes_itens_distribuicao_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes_itens
    ADD CONSTRAINT distribuicoes_itens_distribuicao_id_fkey FOREIGN KEY (distribuicao_id) REFERENCES ibsaude.distribuicoes(id) ON DELETE CASCADE;


--
-- TOC entry 4948 (class 2606 OID 123220)
-- Name: distribuicoes_itens distribuicoes_itens_lote_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes_itens
    ADD CONSTRAINT distribuicoes_itens_lote_id_fkey FOREIGN KEY (lote_id) REFERENCES ibsaude.lotes(id);


--
-- TOC entry 4944 (class 2606 OID 123225)
-- Name: distribuicoes distribuicoes_responsavel_liberacao_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes
    ADD CONSTRAINT distribuicoes_responsavel_liberacao_id_fkey FOREIGN KEY (responsavel_liberacao_id) REFERENCES ibsaude.usuarios(id);


--
-- TOC entry 4945 (class 2606 OID 123230)
-- Name: distribuicoes distribuicoes_status_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes
    ADD CONSTRAINT distribuicoes_status_id_fkey FOREIGN KEY (status_id) REFERENCES ibsaude.status_distribuicao(id);


--
-- TOC entry 4946 (class 2606 OID 123235)
-- Name: distribuicoes distribuicoes_unidade_saude_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.distribuicoes
    ADD CONSTRAINT distribuicoes_unidade_saude_id_fkey FOREIGN KEY (unidade_saude_id) REFERENCES ibsaude.unidades_saude(id);


--
-- TOC entry 4949 (class 2606 OID 123240)
-- Name: documentos documentos_enviado_por_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.documentos
    ADD CONSTRAINT documentos_enviado_por_fkey FOREIGN KEY (enviado_por) REFERENCES ibsaude.usuarios(id);


--
-- TOC entry 4950 (class 2606 OID 123245)
-- Name: documentos documentos_tipo_documento_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.documentos
    ADD CONSTRAINT documentos_tipo_documento_id_fkey FOREIGN KEY (tipo_documento_id) REFERENCES ibsaude.tipos_documento(id);


--
-- TOC entry 4951 (class 2606 OID 123250)
-- Name: log_auditoria log_auditoria_usuario_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.log_auditoria
    ADD CONSTRAINT log_auditoria_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES ibsaude.usuarios(id);


--
-- TOC entry 4952 (class 2606 OID 123264)
-- Name: lotes lotes_compra_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.lotes
    ADD CONSTRAINT lotes_compra_id_fkey FOREIGN KEY (compra_id) REFERENCES ibsaude.compras(id);


--
-- TOC entry 4953 (class 2606 OID 123269)
-- Name: lotes lotes_medicamento_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.lotes
    ADD CONSTRAINT lotes_medicamento_id_fkey FOREIGN KEY (medicamento_id) REFERENCES ibsaude.medicamentos(id);


--
-- TOC entry 4954 (class 2606 OID 123274)
-- Name: medicamentos medicamentos_classificacao_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.medicamentos
    ADD CONSTRAINT medicamentos_classificacao_id_fkey FOREIGN KEY (classificacao_id) REFERENCES ibsaude.classificacoes_medicamento(id);


--
-- TOC entry 4955 (class 2606 OID 123279)
-- Name: medicamentos medicamentos_fabricante_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.medicamentos
    ADD CONSTRAINT medicamentos_fabricante_id_fkey FOREIGN KEY (fabricante_id) REFERENCES ibsaude.fabricantes(id);


--
-- TOC entry 4956 (class 2606 OID 123284)
-- Name: movimentacoes_estoque movimentacoes_estoque_lote_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.movimentacoes_estoque
    ADD CONSTRAINT movimentacoes_estoque_lote_id_fkey FOREIGN KEY (lote_id) REFERENCES ibsaude.lotes(id);


--
-- TOC entry 4957 (class 2606 OID 123298)
-- Name: movimentacoes_estoque movimentacoes_estoque_tipo_movimento_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.movimentacoes_estoque
    ADD CONSTRAINT movimentacoes_estoque_tipo_movimento_id_fkey FOREIGN KEY (tipo_movimento_id) REFERENCES ibsaude.tipos_movimento(id);


--
-- TOC entry 4958 (class 2606 OID 123312)
-- Name: movimentacoes_estoque movimentacoes_estoque_usuario_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.movimentacoes_estoque
    ADD CONSTRAINT movimentacoes_estoque_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES ibsaude.usuarios(id);


--
-- TOC entry 4959 (class 2606 OID 123326)
-- Name: usuarios usuarios_perfil_id_fkey; Type: FK CONSTRAINT; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ONLY ibsaude.usuarios
    ADD CONSTRAINT usuarios_perfil_id_fkey FOREIGN KEY (perfil_id) REFERENCES ibsaude.perfis(id);


--
-- TOC entry 5120 (class 3256 OID 123331)
-- Name: lotes auditor_somente_leitura; Type: POLICY; Schema: ibsaude; Owner: postgres
--

CREATE POLICY auditor_somente_leitura ON ibsaude.lotes FOR SELECT USING (((current_setting('app.perfil'::text, true) = 'AUDITOR'::text) OR (current_setting('app.perfil'::text, true) IS DISTINCT FROM 'AUDITOR'::text)));


--
-- TOC entry 5117 (class 0 OID 122904)
-- Dependencies: 220
-- Name: distribuicoes; Type: ROW SECURITY; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.distribuicoes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5118 (class 0 OID 122937)
-- Dependencies: 230
-- Name: log_auditoria; Type: ROW SECURITY; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.log_auditoria ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5119 (class 0 OID 122960)
-- Dependencies: 235
-- Name: lotes; Type: ROW SECURITY; Schema: ibsaude; Owner: postgres
--

ALTER TABLE ibsaude.lotes ENABLE ROW LEVEL SECURITY;

-- Completed on 2026-07-09 10:59:27

--
-- PostgreSQL database dump complete
--

