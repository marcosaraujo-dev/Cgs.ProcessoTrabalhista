-- ===================================================================
-- SCRIPT COMPLETO - eSocial Processo Trabalhista
-- Banco de Dados: PostgreSQL 17+
-- Schema: processotrabalhista
-- Versão eSocial: S-1.3
-- Total de Tabelas: 31
-- ===================================================================

-- Criação da Database
CREATE DATABASE esocial
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default;

-- Conexão com a database
\c esocial;

-- Criação do Schema
CREATE SCHEMA IF NOT EXISTS processotrabalhista;

-- Definir search_path
SET search_path TO processotrabalhista, public;

-- ===================================================================
-- 1. TABELAS DE DOMÍNIO E CONFIGURAÇÃO
-- ===================================================================

-- Tabela de Origem do Processo Trabalhista
CREATE TABLE processotrabalhista.ptrab_origem (
    id_origem BIGSERIAL PRIMARY KEY,
    codigo_origem SMALLINT NOT NULL UNIQUE,
    descricao_origem VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Tipos de CCP
CREATE TABLE processotrabalhista.ptrab_tipo_ccp (
    id_tipo_ccp BIGSERIAL PRIMARY KEY,
    codigo_tipo_ccp SMALLINT NOT NULL UNIQUE,
    descricao_tipo_ccp VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Categorias de Trabalhadores (Tabela 01 eSocial)
CREATE TABLE processotrabalhista.ptrab_categoria (
    id_categoria BIGSERIAL PRIMARY KEY,
    codigo_categoria VARCHAR(3) NOT NULL UNIQUE,
    descricao_categoria VARCHAR(200) NOT NULL,
    grupo_categoria VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
    data_termino DATE,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Motivos de Desligamento (Tabela 19 eSocial)
CREATE TABLE processotrabalhista.ptrab_motivo_desligamento (
    id_motivo_desligamento BIGSERIAL PRIMARY KEY,
    codigo_motivo VARCHAR(2) NOT NULL UNIQUE,
    descricao_motivo VARCHAR(200) NOT NULL,
    data_inicio DATE NOT NULL,
    data_termino DATE,
    codigo_categoria VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Códigos de Receita - Reclamatória Trabalhista (Tabela 29 eSocial)
CREATE TABLE processotrabalhista.ptrab_codigo_receita (
    id_codigo_receita BIGSERIAL PRIMARY KEY,
    codigo_receita VARCHAR(10) NOT NULL UNIQUE,
    descricao_receita VARCHAR(300) NOT NULL,
    aliquota VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Indicativos de Suspensão
CREATE TABLE processotrabalhista.ptrab_indicativo_suspensao (
    id_indicativo_suspensao BIGSERIAL PRIMARY KEY,
    codigo_suspensao VARCHAR(2) NOT NULL UNIQUE,
    descricao_suspensao VARCHAR(200) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Tipos de Dependente (Tabela 07 eSocial)
CREATE TABLE processotrabalhista.ptrab_tipo_dependente (
    id_tipo_dependente BIGSERIAL PRIMARY KEY,
    codigo_tipo_dependente VARCHAR(2) NOT NULL UNIQUE,
    descricao_tipo_dependente VARCHAR(200) NOT NULL,
    data_inicio DATE NOT NULL,
    data_termino DATE,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Motivos de Desligamento TSVE
CREATE TABLE processotrabalhista.ptrab_motivo_desligamento_tsve (
    id_motivo_desligamento_tsve BIGSERIAL PRIMARY KEY,
    codigo_motivo_tsve VARCHAR(2) NOT NULL UNIQUE,
    descricao_motivo_tsve VARCHAR(300) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Status do Sistema
CREATE TABLE processotrabalhista.ptrab_status_sistema (
    id_status_sistema BIGSERIAL PRIMARY KEY,
    codigo_status VARCHAR(30) NOT NULL UNIQUE,
    descricao_status VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- ===================================================================
-- 2. EVENTO S-2500 - PROCESSO TRABALHISTA
-- ===================================================================

-- Tabela Principal de Processo Judicial
CREATE TABLE processotrabalhista.ptrab_processo_judicial (
    id_processo_judicial BIGSERIAL PRIMARY KEY,
    numero_processo VARCHAR(30) NOT NULL UNIQUE,
    tipo_processo SMALLINT NOT NULL DEFAULT 5, -- 5 = Reclamatória Trabalhista
    descricao_processo TEXT,
    status_processo SMALLINT DEFAULT 1, -- 1=Ativo, 2=Inativo, 3=Finalizado
    observacoes TEXT,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela Principal do Processo Trabalhista (Header S-2500)
CREATE TABLE processotrabalhista.ptrab_processo_trabalhista (
    id_processo_trabalhista BIGSERIAL PRIMARY KEY,
    id_processo_judicial BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_processo_judicial(id_processo_judicial),
    numero_processo_trabalhista VARCHAR(30) NOT NULL,
    ide_seq_proc INTEGER DEFAULT 1,
    id_origem BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_origem(id_origem),
    id_tipo_ccp BIGINT REFERENCES processotrabalhista.ptrab_tipo_ccp(id_tipo_ccp),
    data_decisao DATE,
    indicativo_competencia SMALLINT, -- 1=competência da Justiça do Trabalho, 2=outras competências
    competencia_origem VARCHAR(7), -- AAAA-MM
    observacoes_processo TEXT,
    id_status_sistema BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_status_sistema(id_status_sistema) DEFAULT 1,
    numero_recibo_esocial VARCHAR(40),
    data_envio_esocial TIMESTAMP,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP,
    UNIQUE(id_processo_judicial, numero_processo_trabalhista, ide_seq_proc)
);

-- Tabela de Identificação do Empregador
CREATE TABLE processotrabalhista.ptrab_ide_empregador (
    id_ide_empregador BIGSERIAL PRIMARY KEY,
    id_processo_trabalhista BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_processo_trabalhista(id_processo_trabalhista) ON DELETE CASCADE,
    tipo_inscricao SMALLINT NOT NULL, -- 1=CNPJ, 2=CPF
    numero_inscricao VARCHAR(14) NOT NULL,
    razao_social VARCHAR(200),
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Identificação do Trabalhador
CREATE TABLE processotrabalhista.ptrab_identificacao_trabalhador (
    id_identificacao_trabalhador BIGSERIAL PRIMARY KEY,
    id_processo_trabalhista BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_processo_trabalhista(id_processo_trabalhista) ON DELETE CASCADE,
    cpf_trabalhador VARCHAR(11) NOT NULL,
    nome_trabalhador VARCHAR(200),
    data_nascimento DATE,
    ide_seq_trab INTEGER NOT NULL DEFAULT 1,
    observacoes TEXT,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Informações do Contrato
CREATE TABLE processotrabalhista.ptrab_info_contrato (
    id_info_contrato BIGSERIAL PRIMARY KEY,
    id_identificacao_trabalhador BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_identificacao_trabalhador(id_identificacao_trabalhador) ON DELETE CASCADE,
    id_categoria BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_categoria(id_categoria),
    data_inicio_contrato DATE,
    data_fim_contrato DATE,
    tipo_contrato SMALLINT,
    tipo_regime_trabalhista SMALLINT,
    tipo_regime_previdenciario SMALLINT,
    indicativo_admissao SMALLINT,
    id_motivo_desligamento BIGINT REFERENCES processotrabalhista.ptrab_motivo_desligamento(id_motivo_desligamento),
    indicativo_pagamento_13 SMALLINT,
    codigo_estabelecimento VARCHAR(30),
    codigo_lotacao_tributaria VARCHAR(30),
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Informações Complementares do Contrato
CREATE TABLE processotrabalhista.ptrab_info_complementar_contrato (
    id_info_complementar BIGSERIAL PRIMARY KEY,
    id_info_contrato BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_info_contrato(id_info_contrato) ON DELETE CASCADE,
    codigo_cargo VARCHAR(30),
    codigo_funcao VARCHAR(30),
    codigo_cbo VARCHAR(10),
    codigo_categoria_esocial VARCHAR(3),
    data_opcao_fgts DATE,
    data_retratacao_fgts DATE,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Remuneração
CREATE TABLE processotrabalhista.ptrab_remuneracao (
    id_remuneracao BIGSERIAL PRIMARY KEY,
    id_info_complementar BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_info_complementar_contrato(id_info_complementar) ON DELETE CASCADE,
    codigo_rubrica VARCHAR(30) NOT NULL,
    descricao_rubrica VARCHAR(200),
    valor_remuneracao DECIMAL(15,2),
    unidade_salario_fixo SMALLINT,
    descricao_salario VARCHAR(200),
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Identificação do Estabelecimento
CREATE TABLE processotrabalhista.ptrab_identificacao_estabelecimento (
    id_identificacao_estabelecimento BIGSERIAL PRIMARY KEY,
    id_identificacao_trabalhador BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_identificacao_trabalhador(id_identificacao_trabalhador) ON DELETE CASCADE,
    tipo_inscricao_estabelecimento SMALLINT NOT NULL,
    numero_inscricao_estabelecimento VARCHAR(14) NOT NULL,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Informações de Valores
CREATE TABLE processotrabalhista.ptrab_info_valores (
    id_info_valores BIGSERIAL PRIMARY KEY,
    id_identificacao_estabelecimento BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_identificacao_estabelecimento(id_identificacao_estabelecimento) ON DELETE CASCADE,
    indicativo_recolhimento_fgts SMALLINT,
    codigo_categoria_trabalhador VARCHAR(3),
    valor_remuneracao_mm DECIMAL(15,2),
    valor_remuneracao_13 DECIMAL(15,2),
    indicativo_abono_anual SMALLINT,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Abono Salarial
CREATE TABLE processotrabalhista.ptrab_abono (
    id_abono BIGSERIAL PRIMARY KEY,
    id_info_valores BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_info_valores(id_info_valores) ON DELETE CASCADE,
    ano_base INTEGER NOT NULL,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Identificação do Período
CREATE TABLE processotrabalhista.ptrab_identificacao_periodo (
    id_identificacao_periodo BIGSERIAL PRIMARY KEY,
    id_info_valores BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_info_valores(id_info_valores) ON DELETE CASCADE,
    periodo_apuracao VARCHAR(7) NOT NULL, -- AAAA-MM
    indicativo_apuracao SMALLINT, -- 1=Mensal, 2=Anual
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Base de Cálculo
CREATE TABLE processotrabalhista.ptrab_base_calculo (
    id_base_calculo BIGSERIAL PRIMARY KEY,
    id_identificacao_periodo BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_identificacao_periodo(id_identificacao_periodo) ON DELETE CASCADE,
    indicativo_incidencia_cp SMALLINT,
    codigo_categoria VARCHAR(3),
    base_calculo_cp DECIMAL(15,2),
    valor_cp_seg DECIMAL(15,2),
    valor_cp_terc DECIMAL(15,2),
    base_calculo_fgts DECIMAL(15,2),
    valor_fgts DECIMAL(15,2),
    observacoes TEXT,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- ===================================================================
-- 3. EVENTO S-2501 - TRIBUTOS DECORRENTES
-- ===================================================================

-- Tabela Principal de Tributos Decorrentes (S-2501)
CREATE TABLE processotrabalhista.ptrab_tributos_decorrentes (
    id_tributo_decorrente BIGSERIAL PRIMARY KEY,
    id_processo_trabalhista BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_processo_trabalhista(id_processo_trabalhista) ON DELETE CASCADE,
    ide_seq_proc INTEGER NOT NULL,
    periodo_apuracao_pagamento VARCHAR(7) NOT NULL, -- AAAA-MM
    indicativo_apuracao SMALLINT, -- 1=Mensal, 2=Anual
    observacoes TEXT,
    id_status_sistema BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_status_sistema(id_status_sistema) DEFAULT 1,
    numero_recibo_esocial VARCHAR(40),
    data_envio_esocial TIMESTAMP,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Informações do Processo para Tributos
CREATE TABLE processotrabalhista.ptrab_info_processo_tributo (
    id_info_processo_tributo BIGSERIAL PRIMARY KEY,
    id_tributo_decorrente BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_tributos_decorrentes(id_tributo_decorrente) ON DELETE CASCADE,
    cpf_trabalhador VARCHAR(11) NOT NULL,
    indicativo_retificacao SMALLINT,
    valor_irrf DECIMAL(15,2),
    valor_contribuicao_social DECIMAL(15,2),
    id_indicativo_suspensao BIGINT REFERENCES processotrabalhista.ptrab_indicativo_suspensao(id_indicativo_suspensao),
    processo_suspensao VARCHAR(30),
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Informações de Receitas
CREATE TABLE processotrabalhista.ptrab_info_receita (
    id_info_receita BIGSERIAL PRIMARY KEY,
    id_info_processo_tributo BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_info_processo_tributo(id_info_processo_tributo) ON DELETE CASCADE,
    id_codigo_receita BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_codigo_receita(id_codigo_receita),
    valor_principal DECIMAL(15,2),
    valor_juros DECIMAL(15,2),
    valor_multa DECIMAL(15,2),
    valor_total DECIMAL(15,2),
    data_vencimento DATE,
    observacoes TEXT,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- ===================================================================
-- 4. FASE 02 - EVENTOS S-2555 E S-3500
-- ===================================================================

-- Tabela de Solicitação de Consolidação (S-2555)
CREATE TABLE processotrabalhista.ptrab_consolidacao (
    id_consolidacao BIGSERIAL PRIMARY KEY,
    id_processo_trabalhista BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_processo_trabalhista(id_processo_trabalhista) ON DELETE CASCADE,
    periodo_apuracao VARCHAR(7) NOT NULL, -- AAAA-MM
    indicativo_apuracao SMALLINT, -- 1=Mensal, 2=Anual
    data_solicitacao DATE,
    observacoes TEXT,
    id_status_sistema BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_status_sistema(id_status_sistema) DEFAULT 1,
    numero_recibo_esocial VARCHAR(40),
    data_envio_esocial TIMESTAMP,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Exclusão de Eventos (S-3500)
CREATE TABLE processotrabalhista.ptrab_exclusao_eventos (
    id_exclusao_evento BIGSERIAL PRIMARY KEY,
    tipo_evento VARCHAR(6) NOT NULL, -- S-2500, S-2501, S-2555
    numero_recibo_original VARCHAR(40) NOT NULL,
    id_processo_trabalhista BIGINT REFERENCES processotrabalhista.ptrab_processo_trabalhista(id_processo_trabalhista),
    id_tributo_decorrente BIGINT REFERENCES processotrabalhista.ptrab_tributos_decorrentes(id_tributo_decorrente),
    id_consolidacao BIGINT REFERENCES processotrabalhista.ptrab_consolidacao(id_consolidacao),
    cpf_trabalhador VARCHAR(11),
    periodo_apuracao_pagamento VARCHAR(7), -- AAAA-MM (para S-2501 e S-2555)
    ide_seq_proc INTEGER,
    motivo_exclusao TEXT,
    data_solicitacao DATE,
    id_status_sistema BIGINT NOT NULL REFERENCES processotrabalhista.ptrab_status_sistema(id_status_sistema) DEFAULT 1,
    numero_recibo_exclusao VARCHAR(40),
    data_envio_esocial TIMESTAMP,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- ===================================================================
-- 5. TABELAS DE INTEGRAÇÃO EXTERNA
-- ===================================================================

-- Tabela de Cache de Empresas (Integração Externa)
CREATE TABLE processotrabalhista.ptrab_cache_empresa (
    id_cache_empresa BIGSERIAL PRIMARY KEY,
    codigo_empresa VARCHAR(20) NOT NULL UNIQUE,
    cnpj_empresa VARCHAR(14),
    razao_social VARCHAR(200),
    data_ultima_consulta TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- Tabela de Cache de Trabalhadores (Integração Externa)
CREATE TABLE processotrabalhista.ptrab_cache_trabalhador (
    id_cache_trabalhador BIGSERIAL PRIMARY KEY,
    codigo_trabalhador VARCHAR(20) NOT NULL UNIQUE,
    cpf_trabalhador VARCHAR(11),
    nome_trabalhador VARCHAR(200),
    data_nascimento DATE,
    data_ultima_consulta TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    usuario_criacao VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_alteracao VARCHAR(50),
    data_alteracao TIMESTAMP
);

-- ===================================================================
-- 6. ÍNDICES PARA PERFORMANCE
-- ===================================================================

-- Índices das tabelas principais
CREATE INDEX idx_ptrab_processo_judicial_numero ON processotrabalhista.ptrab_processo_judicial(numero_processo);
CREATE INDEX idx_ptrab_processo_judicial_status ON processotrabalhista.ptrab_processo_judicial(status_processo);

CREATE INDEX idx_ptrab_processo_trabalhista_judicial ON processotrabalhista.ptrab_processo_trabalhista(id_processo_judicial);
CREATE INDEX idx_ptrab_processo_trabalhista_numero ON processotrabalhista.ptrab_processo_trabalhista(numero_processo_trabalhista);
CREATE INDEX idx_ptrab_processo_trabalhista_status ON processotrabalhista.ptrab_processo_trabalhista(id_status_sistema);
CREATE INDEX idx_ptrab_processo_trabalhista_recibo ON processotrabalhista.ptrab_processo_trabalhista(numero_recibo_esocial);

CREATE INDEX idx_ptrab_ide_empregador_processo ON processotrabalhista.ptrab_ide_empregador(id_processo_trabalhista);
CREATE INDEX idx_ptrab_ide_empregador_inscricao ON processotrabalhista.ptrab_ide_empregador(numero_inscricao);

CREATE INDEX idx_ptrab_identificacao_trabalhador_processo ON processotrabalhista.ptrab_identificacao_trabalhador(id_processo_trabalhista);
CREATE INDEX idx_ptrab_identificacao_trabalhador_cpf ON processotrabalhista.ptrab_identificacao_trabalhador(cpf_trabalhador);

CREATE INDEX idx_ptrab_info_contrato_trabalhador ON processotrabalhista.ptrab_info_contrato(id_identificacao_trabalhador);
CREATE INDEX idx_ptrab_info_contrato_categoria ON processotrabalhista.ptrab_info_contrato(id_categoria);

CREATE INDEX idx_ptrab_info_complementar_contrato ON processotrabalhista.ptrab_info_complementar_contrato(id_info_contrato);
CREATE INDEX idx_ptrab_remuneracao_complementar ON processotrabalhista.ptrab_remuneracao(id_info_complementar);

CREATE INDEX idx_ptrab_identificacao_estabelecimento_trabalhador ON processotrabalhista.ptrab_identificacao_estabelecimento(id_identificacao_trabalhador);
CREATE INDEX idx_ptrab_info_valores_estabelecimento ON processotrabalhista.ptrab_info_valores(id_identificacao_estabelecimento);
CREATE INDEX idx_ptrab_abono_valores ON processotrabalhista.ptrab_abono(id_info_valores);

CREATE INDEX idx_ptrab_identificacao_periodo_valores ON processotrabalhista.ptrab_identificacao_periodo(id_info_valores);
CREATE INDEX idx_ptrab_identificacao_periodo_apuracao ON processotrabalhista.ptrab_identificacao_periodo(periodo_apuracao);
CREATE INDEX idx_ptrab_base_calculo_periodo ON processotrabalhista.ptrab_base_calculo(id_identificacao_periodo);

-- Índices das tabelas S-2501
CREATE INDEX idx_ptrab_tributos_decorrentes_processo ON processotrabalhista.ptrab_tributos_decorrentes(id_processo_trabalhista);
CREATE INDEX idx_ptrab_tributos_decorrentes_periodo ON processotrabalhista.ptrab_tributos_decorrentes(periodo_apuracao_pagamento);
CREATE INDEX idx_ptrab_tributos_decorrentes_status ON processotrabalhista.ptrab_tributos_decorrentes(id_status_sistema);
CREATE INDEX idx_ptrab_tributos_decorrentes_recibo ON processotrabalhista.ptrab_tributos_decorrentes(numero_recibo_esocial);

CREATE INDEX idx_ptrab_info_processo_tributo_decorrente ON processotrabalhista.ptrab_info_processo_tributo(id_tributo_decorrente);
CREATE INDEX idx_ptrab_info_processo_tributo_cpf ON processotrabalhista.ptrab_info_processo_tributo(cpf_trabalhador);

CREATE INDEX idx_ptrab_info_receita_processo_tributo ON processotrabalhista.ptrab_info_receita(id_info_processo_tributo);
CREATE INDEX idx_ptrab_info_receita_codigo_receita ON processotrabalhista.ptrab_info_receita(id_codigo_receita);

-- Índices das tabelas Fase 2
CREATE INDEX idx_ptrab_consolidacao_processo ON processotrabalhista.ptrab_consolidacao(id_processo_trabalhista);
CREATE INDEX idx_ptrab_consolidacao_periodo ON processotrabalhista.ptrab_consolidacao(periodo_apuracao);
CREATE INDEX idx_ptrab_consolidacao_status ON processotrabalhista.ptrab_consolidacao(id_status_sistema);

CREATE INDEX idx_ptrab_exclusao_eventos_tipo ON processotrabalhista.ptrab_exclusao_eventos(tipo_evento);
CREATE INDEX idx_ptrab_exclusao_eventos_recibo ON processotrabalhista.ptrab_exclusao_eventos(numero_recibo_original);
CREATE INDEX idx_ptrab_exclusao_eventos_processo ON processotrabalhista.ptrab_exclusao_eventos(id_processo_trabalhista);
CREATE INDEX idx_ptrab_exclusao_eventos_tributo ON processotrabalhista.ptrab_exclusao_eventos(id_tributo_decorrente);
CREATE INDEX idx_ptrab_exclusao_eventos_consolidacao ON processotrabalhista.ptrab_exclusao_eventos(id_consolidacao);

-- Índices das tabelas de cache
CREATE INDEX idx_ptrab_cache_empresa_cnpj ON processotrabalhista.ptrab_cache_empresa(cnpj_empresa);
CREATE INDEX idx_ptrab_cache_trabalhador_cpf ON processotrabalhista.ptrab_cache_trabalhador(cpf_trabalhador);

-- Índices das tabelas de domínio
CREATE INDEX idx_ptrab_categoria_codigo ON processotrabalhista.ptrab_categoria(codigo_categoria);
CREATE INDEX idx_ptrab_motivo_desligamento_codigo ON processotrabalhista.ptrab_motivo_desligamento(codigo_motivo);
CREATE INDEX idx_ptrab_codigo_receita_codigo ON processotrabalhista.ptrab_codigo_receita(codigo_receita);
CREATE INDEX idx_ptrab_status_sistema_codigo ON processotrabalhista.ptrab_status_sistema(codigo_status);

-- ===================================================================
-- 7. VIEWS PARA FACILITAR CONSULTAS
-- ===================================================================

-- View para listagem completa de processos trabalhistas
CREATE VIEW processotrabalhista.vw_processos_trabalhistas AS
SELECT 
    pt.id_processo_trabalhista,
    pj.numero_processo,
    pt.numero_processo_trabalhista,
    pt.ide_seq_proc,
    po.descricao_origem as origem_processo,
    tc.descricao_tipo_ccp as tipo_ccp,
    pt.data_decisao,
    pt.competencia_origem,
    ss.codigo_status,
    ss.descricao_status,
    pt.numero_recibo_esocial,
    pt.data_envio_esocial,
    pt.usuario_criacao,
    pt.data_criacao,
    pt.usuario_alteracao,
    pt.data_alteracao
FROM processotrabalhista.ptrab_processo_trabalhista pt
INNER JOIN processotrabalhista.ptrab_processo_judicial pj ON pt.id_processo_judicial = pj.id_processo_judicial
INNER JOIN processotrabalhista.ptrab_origem po ON pt.id_origem = po.id_origem
INNER JOIN processotrabalhista.ptrab_status_sistema ss ON pt.id_status_sistema = ss.id_status_sistema
LEFT JOIN processotrabalhista.ptrab_tipo_ccp tc ON pt.id_tipo_ccp = tc.id_tipo_ccp;

-- View para listagem de trabalhadores por processo
CREATE VIEW processotrabalhista.vw_trabalhadores_processo AS
SELECT 
    it.id_identificacao_trabalhador,
    pt.id_processo_trabalhista,
    pj.numero_processo,
    pt.numero_processo_trabalhista,
    it.cpf_trabalhador,
    it.nome_trabalhador,
    it.data_nascimento,
    it.ide_seq_trab,
    ic.data_inicio_contrato,
    ic.data_fim_contrato,
    cat.codigo_categoria,
    cat.descricao_categoria,
    md.codigo_motivo as codigo_motivo_desligamento,
    md.descricao_motivo as descricao_motivo_desligamento
FROM processotrabalhista.ptrab_identificacao_trabalhador it
INNER JOIN processotrabalhista.ptrab_processo_trabalhista pt ON it.id_processo_trabalhista = pt.id_processo_trabalhista
INNER JOIN processotrabalhista.ptrab_processo_judicial pj ON pt.id_processo_judicial = pj.id_processo_judicial
LEFT JOIN processotrabalhista.ptrab_info_contrato ic ON it.id_identificacao_trabalhador = ic.id_identificacao_trabalhador
LEFT JOIN processotrabalhista.ptrab_categoria cat ON ic.id_categoria = cat.id_categoria
LEFT JOIN processotrabalhista.ptrab_motivo_desligamento md ON ic.id_motivo_desligamento = md.id_motivo_desligamento;

-- View para listagem de tributos decorrentes
CREATE VIEW processotrabalhista.vw_tributos_decorrentes AS
SELECT 
    td.id_tributo_decorrente,
    pt.id_processo_trabalhista,
    pj.numero_processo,
    pt.numero_processo_trabalhista,
    td.ide_seq_proc,
    td.periodo_apuracao_pagamento,
    td.indicativo_apuracao,
    ss.codigo_status,
    ss.descricao_status,
    td.numero_recibo_esocial,
    td.data_envio_esocial,
    ipt.cpf_trabalhador,
    ipt.valor_irrf,
    ipt.valor_contribuicao_social,
    sus.codigo_suspensao,
    sus.descricao_suspensao,
    td.usuario_criacao,
    td.data_criacao,
    td.usuario_alteracao,
    td.data_alteracao
FROM processotrabalhista.ptrab_tributos_decorrentes td
INNER JOIN processotrabalhista.ptrab_processo_trabalhista pt ON td.id_processo_trabalhista = pt.id_processo_trabalhista
INNER JOIN processotrabalhista.ptrab_processo_judicial pj ON pt.id_processo_judicial = pj.id_processo_judicial
INNER JOIN processotrabalhista.ptrab_status_sistema ss ON td.id_status_sistema = ss.id_status_sistema
LEFT JOIN processotrabalhista.ptrab_info_processo_tributo ipt ON td.id_tributo_decorrente = ipt.id_tributo_decorrente
LEFT JOIN processotrabalhista.ptrab_indicativo_suspensao sus ON ipt.id_indicativo_suspensao = sus.id_indicativo_suspensao;

-- View para receitas por tributo
CREATE VIEW processotrabalhista.vw_receitas_tributos AS
SELECT 
    ir.id_info_receita,
    td.id_tributo_decorrente,
    pt.numero_processo_trabalhista,
    td.periodo_apuracao_pagamento,
    ipt.cpf_trabalhador,
    cr.codigo_receita,
    cr.descricao_receita,
    cr.aliquota,
    ir.valor_principal,
    ir.valor_juros,
    ir.valor_multa,
    ir.valor_total,
    ir.data_vencimento
FROM processotrabalhista.ptrab_info_receita ir
INNER JOIN processotrabalhista.ptrab_info_processo_tributo ipt ON ir.id_info_processo_tributo = ipt.id_info_processo_tributo
INNER JOIN processotrabalhista.ptrab_tributos_decorrentes td ON ipt.id_tributo_decorrente = td.id_tributo_decorrente
INNER JOIN processotrabalhista.ptrab_processo_trabalhista pt ON td.id_processo_trabalhista = pt.id_processo_trabalhista
INNER JOIN processotrabalhista.ptrab_codigo_receita cr ON ir.id_codigo_receita = cr.id_codigo_receita;

-- ===================================================================
-- 8. CARGA INICIAL DE DADOS
-- ===================================================================

-- Carga inicial da tabela ptrab_origem
INSERT INTO processotrabalhista.ptrab_origem (codigo_origem, descricao_origem) VALUES
(1, 'Processo Trabalhista'),
(2, 'Comissão de Conciliação Prévia - CCP'),
(3, 'Núcleo Intersindical - Ninter');

-- Carga inicial da tabela ptrab_status_sistema
INSERT INTO processotrabalhista.ptrab_status_sistema (codigo_status, descricao_status) VALUES
('RASCUNHO', 'Rascunho - Em elaboração'),
('VALIDADO', 'Validado - Pronto para envio'),
('ENVIADO', 'Enviado - Aguardando processamento'),
('CANCELADO', 'Cancelado - Processo cancelado'),
('EXCLUIDO', 'Excluído - Processo excluído');

-- Carga inicial da tabela ptrab_tipo_ccp
INSERT INTO processotrabalhista.ptrab_tipo_ccp (codigo_tipo_ccp, descricao_tipo_ccp) VALUES
(1, 'CCP Intra-Empresarial'),
(2, 'CCP Inter-Empresarial');

-- Carga inicial dos indicativos de suspensão
INSERT INTO processotrabalhista.ptrab_indicativo_suspensao (codigo_suspensao, descricao_suspensao) VALUES
('01', 'Liminar em mandado de segurança'),
('02', 'Depósito judicial do montante integral'),
('03', 'Depósito administrativo do montante integral'),
('04', 'Antecipação de tutela'),
('05', 'Liminar em medida cautelar'),
('08', 'Sentença em mandado de segurança favorável ao contribuinte');

-- Exemplo de algumas categorias principais (seria carregado completamente após análise dos arquivos)
INSERT INTO processotrabalhista.ptrab_categoria (codigo_categoria, descricao_categoria, grupo_categoria, data_inicio) VALUES
('101', 'Empregado - Geral, inclusive o empregado público da administração direta ou indireta contratado pela CLT', 'Empregado e Trabalhador Temporário', '2014-01-01'),
('102', 'Empregado - Trabalhador rural por pequeno prazo da Lei 11.718/2008', 'Empregado e Trabalhador Temporário', '2014-01-01'),
('103', 'Empregado - Aprendiz', 'Empregado e Trabalhador Temporário', '2014-01-01'),
('104', 'Empregado - Doméstico', 'Empregado e Trabalhador Temporário', '2014-01-01'),
('105', 'Empregado - Contrato a termo firmado nos termos da Lei 9.601/1998', 'Empregado e Trabalhador Temporário', '2014-01-01');

-- ===================================================================
-- 9. TRIGGERS DE AUDITORIA (OPCIONAL)
-- ===================================================================

-- Função para atualizar data_alteracao
CREATE OR REPLACE FUNCTION processotrabalhista.trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.data_alteracao = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger em algumas tabelas principais
CREATE TRIGGER set_timestamp_ptrab_processo_trabalhista
    BEFORE UPDATE ON processotrabalhista.ptrab_processo_trabalhista
    FOR EACH ROW
    EXECUTE FUNCTION processotrabalhista.trigger_set_timestamp();

CREATE TRIGGER set_timestamp_ptrab_tributos_decorrentes
    BEFORE UPDATE ON processotrabalhista.ptrab_tributos_decorrentes
    FOR EACH ROW
    EXECUTE FUNCTION processotrabalhista.trigger_set_timestamp();

-- ===================================================================
-- FIM DO SCRIPT
-- ===================================================================