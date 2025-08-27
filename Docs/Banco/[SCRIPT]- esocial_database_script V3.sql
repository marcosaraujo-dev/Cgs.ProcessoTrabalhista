-- =============================================
-- BANCO DE DADOS eSocial - PROCESSO TRABALHISTA COMPLETO
-- PostgreSQL Version 12+
-- Eventos: S-2500, S-2501, S-2555, S-3500
-- Autor: Sistema eSocial
-- Data: Agosto 2025
-- Versão: 3.0 - COMPLETA E VALIDADA
-- =============================================

-- Criação do banco de dados
CREATE DATABASE esocial_processos_trabalhistas;

-- Conectar ao banco criado
\c esocial_processos_trabalhistas;

-- Criação do schema
CREATE SCHEMA IF NOT EXISTS processotrabalhista;

-- Definir o schema como padrão para a sessão
SET search_path TO processotrabalhista, public;

-- =============================================
-- EXTENSÕES NECESSÁRIAS
-- =============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- 1. TABELAS DE DOMÍNIO/LOOKUP
-- =============================================

-- Status dos registros
CREATE TABLE status_sistema (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO status_sistema (codigo, descricao) VALUES
('RASCUNHO', 'Rascunho'),
('EM_ELABORACAO', 'Em Elaboração'),
('VALIDADO', 'Validado'),
('PENDENTE_ENVIO', 'Pendente de Envio'),
('ENVIADO', 'Enviado'),
('PROCESSADO_SUCESSO', 'Processado com Sucesso'),
('PROCESSADO_ERRO', 'Processado com Erro'),
('CANCELADO', 'Cancelado'),
('EXCLUIDO', 'Excluído');

-- Tipos de Inscrição (Tabela 05 do eSocial)
CREATE TABLE tipos_inscricao (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(50) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO tipos_inscricao (codigo, descricao) VALUES
(1, 'CNPJ'),
(2, 'CPF'),
(3, 'CAEPF'),
(4, 'CNO'),
(5, 'CGC'),
(6, 'CEI');

-- Origem do Processo
CREATE TABLE origens_processo (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO origens_processo (codigo, descricao) VALUES
(1, 'Processo Judicial'),
(2, 'Demanda submetida à CCP ou ao NINTER');

-- Tipos de Contrato (tpContr do eSocial)
CREATE TABLE tipos_contrato (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(200) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO tipos_contrato (codigo, descricao) VALUES
(1, 'Trabalhador com vínculo formalizado no eSocial, sem alteração nas datas de admissão e de desligamento'),
(2, 'Trabalhador com vínculo formalizado no eSocial, com alteração na data de admissão'),
(3, 'Trabalhador com vínculo formalizado no eSocial, com inclusão ou alteração de data de desligamento'),
(4, 'Trabalhador com vínculo formalizado no eSocial, com alteração na data de admissão e inclusão ou alteração de data de desligamento'),
(5, 'Empregado com reconhecimento de vínculo'),
(6, 'Trabalhador sem vínculo de emprego/estatutário (TSVE), sem reconhecimento de vínculo empregatício'),
(7, 'Trabalhador com vínculo de emprego formalizado em período anterior ao eSocial'),
(8, 'Responsabilidade indireta'),
(9, 'Trabalhador cujos contratos foram unificados (unicidade contratual)');

-- Tipos de CCP
CREATE TABLE tipos_ccp (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO tipos_ccp (codigo, descricao) VALUES
(1, 'CCP no âmbito de empresa'),
(2, 'CCP no âmbito de sindicato'),
(3, 'NINTER');

-- Unidades de Salário Fixo
CREATE TABLE unidades_salario_fixo (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(50) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO unidades_salario_fixo (codigo, descricao) VALUES
(1, 'Por hora'),
(2, 'Por dia'),
(3, 'Por semana'),
(4, 'Por quinzena'),
(5, 'Por mês'),
(6, 'Por tarefa'),
(7, 'Não aplicável - Salário exclusivamente variável');

-- Tipos de Regime Trabalhista
CREATE TABLE tipos_regime_trabalhista (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO tipos_regime_trabalhista (codigo, descricao) VALUES
(1, 'CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas'),
(2, 'Estatutário/legislações específicas (servidor temporário, militar, agente político, etc.)');

-- Tipos de Regime Previdenciário
CREATE TABLE tipos_regime_previdenciario (
    id SERIAL PRIMARY KEY,
    codigo INTEGER NOT NULL UNIQUE,
    descricao VARCHAR(150) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

INSERT INTO tipos_regime_previdenciario (codigo, descricao) VALUES
(1, 'Regime Geral de Previdência Social - RGPS'),
(2, 'Regime Próprio de Previdência Social - RPPS, Regime dos Parlamentares e Sistema de Proteção dos Militares dos Estados/DF'),
(3, 'Regime de Previdência Social no exterior');

-- =============================================
-- 2. TABELA PRINCIPAL: CADASTRO DE PROCESSOS (S-2500)
-- =============================================

CREATE TABLE processos_trabalhistas (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    numero_processo VARCHAR(50) NOT NULL UNIQUE,
    origem_processo_id INTEGER NOT NULL REFERENCES origens_processo(id),
    observacoes_processo TEXT,
    status_id INTEGER NOT NULL REFERENCES status_sistema(id) DEFAULT 1,
    
    -- Dados do Empregador (ideEmpregador)
    empregador_tipo_inscricao_id INTEGER NOT NULL REFERENCES tipos_inscricao(id),
    empregador_numero_inscricao VARCHAR(14) NOT NULL,
    empregador_codigo_sistema_origem VARCHAR(30), -- Para consulta externa via popup
    empregador_razao_social VARCHAR(200), -- Preenchido via consulta ou manual
    
    -- Dados do Responsável Indireto (ideResp) - OPCIONAL
    responsavel_tipo_inscricao_id INTEGER REFERENCES tipos_inscricao(id),
    responsavel_numero_inscricao VARCHAR(14),
    responsavel_data_admissao DATE, -- dtAdmRespDir
    responsavel_matricula VARCHAR(30), -- matRespDir
    
    -- Auditoria obrigatória
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_processo_empregador_inscricao 
        CHECK (length(empregador_numero_inscricao) BETWEEN 8 AND 14),
    CONSTRAINT ck_processo_responsavel_inscricao 
        CHECK (responsavel_numero_inscricao IS NULL OR length(responsavel_numero_inscricao) BETWEEN 8 AND 14)
);

-- Índices para performance
CREATE INDEX idx_processos_numero ON processos_trabalhistas(numero_processo);
CREATE INDEX idx_processos_status ON processos_trabalhistas(status_id);
CREATE INDEX idx_processos_empregador ON processos_trabalhistas(empregador_numero_inscricao);

-- =============================================
-- 3. INFORMAÇÕES DO PROCESSO JUDICIAL (infoProcJud)
-- =============================================

CREATE TABLE processos_judiciais (
    id SERIAL PRIMARY KEY,
    processo_trabalhista_id INTEGER NOT NULL REFERENCES processos_trabalhistas(id) ON DELETE CASCADE,
    
    -- Dados específicos do processo judicial
    data_sentenca DATE NOT NULL, -- dtSent
    uf_vara VARCHAR(2) NOT NULL, -- ufVara
    codigo_municipio VARCHAR(7) NOT NULL, -- codMunic
    identificador_vara INTEGER NOT NULL, -- idVara
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_processo_judicial_uf CHECK (length(uf_vara) = 2),
    CONSTRAINT ck_processo_judicial_municipio CHECK (length(codigo_municipio) = 7),
    CONSTRAINT ck_processo_judicial_vara CHECK (identificador_vara BETWEEN 1 AND 9999)
);

-- =============================================
-- 4. INFORMAÇÕES DE CCP/NINTER (infoCCP)
-- =============================================

CREATE TABLE processos_ccp (
    id SERIAL PRIMARY KEY,
    processo_trabalhista_id INTEGER NOT NULL REFERENCES processos_trabalhistas(id) ON DELETE CASCADE,
    
    -- Dados específicos do CCP/NINTER
    data_ccp DATE NOT NULL, -- dtCCP
    tipo_ccp_id INTEGER NOT NULL REFERENCES tipos_ccp(id), -- tpCCP
    cnpj_ccp VARCHAR(14), -- cnpjCCP
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_processo_ccp_cnpj CHECK (cnpj_ccp IS NULL OR length(cnpj_ccp) = 14)
);

-- =============================================
-- 5. TRABALHADORES DO PROCESSO (ideTrab)
-- =============================================

CREATE TABLE trabalhadores_processo (
    id SERIAL PRIMARY KEY,
    processo_trabalhista_id INTEGER NOT NULL REFERENCES processos_trabalhistas(id) ON DELETE CASCADE,
    
    -- Dados do trabalhador
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(70), -- nmTrab
    data_nascimento DATE, -- dtNascto
    codigo_sistema_origem VARCHAR(30), -- Para consulta externa via popup
    sequencia_trabalhador INTEGER, -- ideSeqTrab - sequencial para múltiplos S-2500
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_trabalhador_processo_cpf CHECK (length(cpf) = 11),
    CONSTRAINT ck_trabalhador_sequencia CHECK (sequencia_trabalhador IS NULL OR sequencia_trabalhador BETWEEN 1 AND 999),
    CONSTRAINT uk_trabalhador_processo UNIQUE(processo_trabalhista_id, cpf, sequencia_trabalhador)
);

CREATE INDEX idx_trabalhadores_processo_cpf ON trabalhadores_processo(cpf);

-- =============================================
-- 6. INFORMAÇÕES DO CONTRATO (infoContr)
-- =============================================

CREATE TABLE contratos_processo (
    id SERIAL PRIMARY KEY,
    trabalhador_processo_id INTEGER NOT NULL REFERENCES trabalhadores_processo(id) ON DELETE CASCADE,
    
    -- Informações básicas do contrato
    tipo_contrato_id INTEGER NOT NULL REFERENCES tipos_contrato(id), -- tpContr
    indicador_contrato CHAR(1) NOT NULL CHECK (indicador_contrato IN ('S', 'N')), -- indContr
    data_admissao_original DATE, -- dtAdmOrig
    indicador_reintegracao CHAR(1) CHECK (indicador_reintegracao IN ('S', 'N')), -- indReint
    indicador_categoria CHAR(1) NOT NULL CHECK (indicador_categoria IN ('S', 'N')), -- indCateg
    indicador_natureza_atividade CHAR(1) NOT NULL CHECK (indicador_natureza_atividade IN ('S', 'N')), -- indNatAtiv
    indicador_motivo_desligamento CHAR(1) NOT NULL CHECK (indicador_motivo_desligamento IN ('S', 'N')), -- indMotDeslig
    
    -- Dados de identificação
    matricula VARCHAR(30), -- matricula
    codigo_categoria VARCHAR(3), -- codCateg
    data_inicio_tsve DATE, -- dtInicio (para TSVE)
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 7. INFORMAÇÕES COMPLEMENTARES (infoCompl)
-- =============================================

CREATE TABLE contratos_complementares (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Informações complementares
    codigo_cbo VARCHAR(6), -- codCBO
    natureza_atividade INTEGER CHECK (natureza_atividade IN (1, 2)), -- natAtividade: 1=Urbano, 2=Rural
    quantidade_dias_trabalho INTEGER, -- qtdDiasTrab
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 8. REMUNERAÇÃO (remuneracao)
-- =============================================

CREATE TABLE remuneracoes_processo (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados da remuneração
    data_remuneracao DATE NOT NULL, -- dtRemun
    valor_salario_fixo DECIMAL(14,2) NOT NULL, -- vrSalFx
    unidade_salario_fixo_id INTEGER NOT NULL REFERENCES unidades_salario_fixo(id), -- undSalFixo
    descricao_salario_variavel TEXT, -- dscSalVar
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_remuneracao_valor_salario CHECK (valor_salario_fixo >= 0)
);

-- =============================================
-- 9. INFORMAÇÕES DO VÍNCULO (infoVinc)
-- =============================================

CREATE TABLE vinculos_processo (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados do vínculo
    tipo_regime_trabalhista_id INTEGER NOT NULL REFERENCES tipos_regime_trabalhista(id), -- tpRegTrab
    tipo_regime_previdenciario_id INTEGER NOT NULL REFERENCES tipos_regime_previdenciario(id), -- tpRegPrev
    data_admissao DATE NOT NULL, -- dtAdm
    tipo_jornada INTEGER, -- tpJornada
    tempo_parcial INTEGER CHECK (tempo_parcial IN (0, 1, 2, 3)), -- tmpParc
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 10. DURAÇÃO DO CONTRATO (duracao)
-- =============================================

CREATE TABLE duracoes_contrato (
    id SERIAL PRIMARY KEY,
    vinculo_processo_id INTEGER NOT NULL REFERENCES vinculos_processo(id) ON DELETE CASCADE,
    
    -- Dados de duração
    tipo_contrato INTEGER CHECK (tipo_contrato IN (1,2,3)), -- tpContr: 1=Indeterminado, 2=Determinado definido em dias, 3=Determinado vinculado a fato
    data_termino DATE, -- dtTerm
    clausula_assecuratoria CHAR(1) CHECK (clausula_assecuratoria IN ('S', 'N')), -- clauAssec
    objeto_determinante VARCHAR(255), -- objDet
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 11. OBSERVAÇÕES DO CONTRATO (observacoes)
-- =============================================

CREATE TABLE observacoes_contratos (
    id SERIAL PRIMARY KEY,
    vinculo_processo_id INTEGER NOT NULL REFERENCES vinculos_processo(id) ON DELETE CASCADE,
    
    -- Observação
    observacao VARCHAR(255) NOT NULL,
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 12. SUCESSÃO DE VÍNCULO (sucessaoVinc)
-- =============================================

CREATE TABLE sucessoes_vinculo (
    id SERIAL PRIMARY KEY,
    vinculo_processo_id INTEGER NOT NULL REFERENCES vinculos_processo(id) ON DELETE CASCADE,
    
    -- Dados da sucessão
    tipo_inscricao_id INTEGER NOT NULL REFERENCES tipos_inscricao(id),
    numero_inscricao VARCHAR(14) NOT NULL,
    matricula_anterior VARCHAR(30), -- matricAnt
    data_transferencia DATE NOT NULL, -- dtTransf
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_sucessao_numero_inscricao 
        CHECK (length(numero_inscricao) BETWEEN 8 AND 14)
);

-- =============================================
-- 13. INFORMAÇÕES DE DESLIGAMENTO (infoDeslig)
-- =============================================

CREATE TABLE desligamentos_processo (
    id SERIAL PRIMARY KEY,
    vinculo_processo_id INTEGER NOT NULL REFERENCES vinculos_processo(id) ON DELETE CASCADE,
    
    -- Dados do desligamento
    data_desligamento DATE NOT NULL, -- dtDeslig
    motivo_desligamento VARCHAR(2) NOT NULL, -- mtvDeslig
    data_projetada_fim_aviso DATE, -- dtProjFimAPI
    pensao_alimenticia INTEGER CHECK (pensao_alimenticia IN (0,1,2,3)), -- pensAlim
    percentual_alimenticia DECIMAL(5,2), -- percAliment
    valor_alimenticia DECIMAL(14,2), -- vrAlim
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 14. INFORMAÇÕES DE TÉRMINO DE TSVE (infoTerm)
-- =============================================

CREATE TABLE terminos_tsve (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados do término
    data_termino DATE NOT NULL, -- dtTerm
    motivo_desligamento_tsv VARCHAR(2), -- mtvDesligTSV (para categoria 721)
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 15. MUDANÇA DE CATEGORIA/ATIVIDADE (mudCategAtiv)
-- =============================================

CREATE TABLE mudancas_categoria_atividade (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados da mudança
    codigo_categoria VARCHAR(3) NOT NULL, -- codCateg
    natureza_atividade INTEGER CHECK (natureza_atividade IN (1, 2)), -- natAtividade
    data_mudanca_categoria DATE NOT NULL, -- dtMudCategAtiv
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 16. UNICIDADE CONTRATUAL (unicContr)
-- =============================================

CREATE TABLE unicidades_contratuais (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados da unicidade
    matricula_unificada VARCHAR(30), -- matUnic
    codigo_categoria VARCHAR(3), -- codCateg
    data_inicio DATE, -- dtInicio
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 17. ESTABELECIMENTOS RESPONSÁVEIS (ideEstab)
-- =============================================

CREATE TABLE estabelecimentos_processo (
    id SERIAL PRIMARY KEY,
    contrato_processo_id INTEGER NOT NULL REFERENCES contratos_processo(id) ON DELETE CASCADE,
    
    -- Dados do estabelecimento
    tipo_inscricao_id INTEGER NOT NULL REFERENCES tipos_inscricao(id),
    numero_inscricao VARCHAR(14) NOT NULL,
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_estabelecimento_numero_inscricao 
        CHECK (length(numero_inscricao) IN (12, 14))
);

-- =============================================
-- 18. PERÍODOS E VALORES (infoVlr)
-- =============================================

CREATE TABLE periodos_valores (
    id SERIAL PRIMARY KEY,
    estabelecimento_processo_id INTEGER NOT NULL REFERENCES estabelecimentos_processo(id) ON DELETE CASCADE,
    
    -- Períodos
    competencia_inicio VARCHAR(7) NOT NULL, -- compIni (YYYY-MM)
    competencia_fim VARCHAR(7) NOT NULL, -- compFim (YYYY-MM)
    indicador_repercussao INTEGER NOT NULL CHECK (indicador_repercussao IN (1,2,3,4,5)), -- indReperc
    indenizacao_substitutiva CHAR(1) CHECK (indenizacao_substitutiva = 'S'), -- indenSD
    indenizacao_abono CHAR(1) CHECK (indenizacao_abono = 'S'), -- indenAbono
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_periodo_competencia_inicio 
        CHECK (competencia_inicio ~ '^[0-9]{4}-[0-1][0-9]$'),
    CONSTRAINT ck_periodo_competencia_fim 
        CHECK (competencia_fim ~ '^[0-9]{4}-[0-1][0-9]$')
);

-- =============================================
-- 19. ABONOS (abono)
-- =============================================

CREATE TABLE abonos_processo (
    id SERIAL PRIMARY KEY,
    periodo_valores_id INTEGER NOT NULL REFERENCES periodos_valores(id) ON DELETE CASCADE,
    
    -- Dados do abono
    ano_base INTEGER NOT NULL CHECK (ano_base BETWEEN 1900 AND 2100), -- anoBase
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 20. IDENTIFICAÇÃO DOS PERÍODOS (idePeriodo)
-- =============================================

CREATE TABLE identificacoes_periodo (
    id SERIAL PRIMARY KEY,
    periodo_valores_id INTEGER NOT NULL REFERENCES periodos_valores(id) ON DELETE CASCADE,
    
    -- Identificação do período
    periodo_referencia VARCHAR(7) NOT NULL, -- perRef (YYYY-MM)
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_identificacao_periodo_referencia 
        CHECK (periodo_referencia ~ '^[0-9]{4}-[0-1][0-9]$')
);

-- =============================================
-- 21. BASES DE CÁLCULO (baseCalculo)
-- =============================================

CREATE TABLE bases_calculo_processo (
    id SERIAL PRIMARY KEY,
    identificacao_periodo_id INTEGER NOT NULL REFERENCES identificacoes_periodo(id) ON DELETE CASCADE,
    
    -- Bases de cálculo
    valor_bc_cp_mensal DECIMAL(14,2) NOT NULL DEFAULT 0, -- vrBcCpMensal
    valor_bc_cp_13 DECIMAL(14,2) DEFAULT 0, -- vrBcCp13
    grau_exposicao_agente_nocivo INTEGER CHECK (grau_exposicao_agente_nocivo IN (1,2,3,4)), -- grauExp
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_base_calculo_valores CHECK (valor_bc_cp_mensal >= 0 AND (valor_bc_cp_13 IS NULL OR valor_bc_cp_13 >= 0))
);

-- =============================================
-- 22. INFORMAÇÕES DO FGTS (infoFGTS)
-- =============================================

CREATE TABLE fgts_processo (
    id SERIAL PRIMARY KEY,
    identificacao_periodo_id INTEGER NOT NULL REFERENCES identificacoes_periodo(id) ON DELETE CASCADE,
    
    -- Bases de cálculo FGTS
    valor_bc_fgts_proc_trab DECIMAL(14,2) NOT NULL DEFAULT 0, -- vrBcFGTSProcTrab
    valor_bc_fgts_sefip DECIMAL(14,2) DEFAULT 0, -- vrBcFGTSSefip
    valor_bc_fgts_dec_ant DECIMAL(14,2) DEFAULT 0, -- vrBcFGTSDecAnt
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_fgts_valores CHECK (valor_bc_fgts_proc_trab >= 0 
        AND (valor_bc_fgts_sefip IS NULL OR valor_bc_fgts_sefip >= 0)
        AND (valor_bc_fgts_dec_ant IS NULL OR valor_bc_fgts_dec_ant >= 0))
);

-- =============================================
-- 23. BASES DE MUDANÇA DE CATEGORIA (baseMudCateg)
-- =============================================

CREATE TABLE bases_mudanca_categoria (
    id SERIAL PRIMARY KEY,
    identificacao_periodo_id INTEGER NOT NULL REFERENCES identificacoes_periodo(id) ON DELETE CASCADE,
    
    -- Dados da mudança
    codigo_categoria VARCHAR(3) NOT NULL, -- codCateg
    valor_bc_c_prev DECIMAL(14,2) NOT NULL, -- vrBcCPrev
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_base_mudanca_valor CHECK (valor_bc_c_prev > 0)
);

-- =============================================
-- 24. TRABALHO INTERMITENTE (infoInterm)
-- =============================================

CREATE TABLE trabalho_intermitente (
    id SERIAL PRIMARY KEY,
    identificacao_periodo_id INTEGER NOT NULL REFERENCES identificacoes_periodo(id) ON DELETE CASCADE,
    
    -- Dados do trabalho intermitente
    dia INTEGER NOT NULL CHECK (dia BETWEEN 0 AND 31), -- dia
    horas_trabalhadas VARCHAR(4), -- hrsTrab (HHMM)
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
    status_ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 25. S-2501: INFORMAÇÕES DOS TRIBUTOS
-- =============================================

CREATE TABLE tributos_processo (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    trabalhador_processo_id INTEGER NOT NULL REFERENCES trabalhadores_processo(id) ON DELETE CASCADE,
    numero_processo VARCHAR(50) NOT NULL,
    periodo_apuracao_pagamento VARCHAR(7) NOT NULL, -- perApurPgto (YYYY-MM)
    sequencia_processo INTEGER DEFAULT 1, -- ideSeqProc
    observacoes TEXT,
    status_id INTEGER NOT NULL REFERENCES status_sistema(id) DEFAULT 1,
    
    -- Auditoria obrigatória
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_tributos_periodo_apuracao 
        CHECK (periodo_apuracao_pagamento ~ '^[0-9]{4}-[0-1][0-9]$'),
    CONSTRAINT uk_tributos_trabalhador_periodo 
        UNIQUE(trabalhador_processo_id, periodo_apuracao_pagamento, sequencia_processo)
);

CREATE INDEX idx_tributos_numero_processo ON tributos_processo(numero_processo);
CREATE INDEX idx_tributos_periodo ON tributos_processo(periodo_apuracao_pagamento);

-- =============================================
-- 26. CÁLCULO DE TRIBUTOS (calcTrib)
-- =============================================

CREATE TABLE calculo_tributos (
    id SERIAL PRIMARY KEY,
    tributo_processo_id INTEGER NOT NULL REFERENCES tributos_processo(id) ON DELETE CASCADE,
    
    -- Dados do período
    periodo_referencia VARCHAR(7) NOT NULL, -- perRef (YYYY-MM)
    valor_bc_cp_mensal DECIMAL(14,2) NOT NULL DEFAULT 0, -- vrBcCpMensal
    valor_bc_cp_13 DECIMAL(14,2) NOT NULL DEFAULT 0, -- vrBcCp13
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_calculo_periodo_referencia 
        CHECK (periodo_referencia ~ '^[0-9]{4}-[0-1][0-9]$'),
    CONSTRAINT ck_calculo_valores CHECK (valor_bc_cp_mensal >= 0 AND valor_bc_cp_13 >= 0)
);

-- =============================================
-- 27. CÓDIGOS DE RECEITA CONTRIBUIÇÃO SOCIAL (infoCRContrib)
-- =============================================

CREATE TABLE codigos_receita_contrib_social (
    id SERIAL PRIMARY KEY,
    calculo_tributo_id INTEGER NOT NULL REFERENCES calculo_tributos(id) ON DELETE CASCADE,
    
    -- Dados da receita
    tipo_cr VARCHAR(6) NOT NULL, -- tpCR - Código de Receita
    valor_cr DECIMAL(14,2) NOT NULL, -- vrCR
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_contrib_social_valor CHECK (valor_cr > 0)
);

-- =============================================
-- 28. CÓDIGOS DE RECEITA IRRF (infoCRIRRF)
-- =============================================

CREATE TABLE codigos_receita_irrf (
    id SERIAL PRIMARY KEY,
    tributo_processo_id INTEGER NOT NULL REFERENCES tributos_processo(id) ON DELETE CASCADE,
    
    -- Dados da receita
    tipo_cr VARCHAR(6) NOT NULL CHECK (tipo_cr IN ('593656', '056152', '188951')), -- tpCR
    valor_cr DECIMAL(14,2) NOT NULL DEFAULT 0, -- vrCR
    valor_cr_13 DECIMAL(14,2) DEFAULT 0, -- vrCR13
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_irrf_valor_cr CHECK (valor_cr >= 0),
    CONSTRAINT ck_irrf_valor_cr_13 CHECK (valor_cr_13 IS NULL OR valor_cr_13 > 0)
);

-- =============================================
-- 29. INFORMAÇÕES COMPLEMENTARES IR (infoIR)
-- =============================================

CREATE TABLE informacoes_ir (
    id SERIAL PRIMARY KEY,
    codigo_receita_irrf_id INTEGER NOT NULL REFERENCES codigos_receita_irrf(id) ON DELETE CASCADE,
    
    -- Rendimentos tributáveis
    valor_rendimento_tributavel DECIMAL(14,2) DEFAULT 0, -- vrRendTrib
    valor_rendimento_tributavel_13 DECIMAL(14,2) DEFAULT 0, -- vrRendTrib13
    
    -- Rendimentos isentos por moléstia grave
    valor_rendimento_molestia_grave DECIMAL(14,2) DEFAULT 0, -- vrRendMoleGrave
    valor_rendimento_molestia_grave_13 DECIMAL(14,2) DEFAULT 0, -- vrRendMoleGrave13
    
    -- Rendimentos isentos para 65 anos ou mais
    valor_rendimento_isento_65 DECIMAL(14,2) DEFAULT 0, -- vrRendIsen65
    valor_rendimento_isento_65_dec DECIMAL(14,2) DEFAULT 0, -- vrRendIsen65Dec
    
    -- Juros de mora
    valor_juros_mora DECIMAL(14,2) DEFAULT 0, -- vrJurosMora
    valor_juros_mora_13 DECIMAL(14,2) DEFAULT 0, -- vrJurosMora13
    
    -- Outros rendimentos isentos ou não tributáveis
    valor_rendimento_isento_nao_tributavel DECIMAL(14,2) DEFAULT 0, -- vrRendIsenNTrib
    descricao_isento_nao_tributavel VARCHAR(60), -- descIsenNTrib
    
    -- Previdência oficial
    valor_previdencia_oficial DECIMAL(14,2) DEFAULT 0, -- vrPrevOficial
    valor_previdencia_oficial_13 DECIMAL(14,2) DEFAULT 0, -- vrPrevOficial13
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_ir_valores_positivos CHECK (
        (valor_rendimento_tributavel IS NULL OR valor_rendimento_tributavel >= 0) AND
        (valor_rendimento_tributavel_13 IS NULL OR valor_rendimento_tributavel_13 >= 0) AND
        (valor_rendimento_molestia_grave IS NULL OR valor_rendimento_molestia_grave >= 0) AND
        (valor_rendimento_molestia_grave_13 IS NULL OR valor_rendimento_molestia_grave_13 >= 0) AND
        (valor_rendimento_isento_65 IS NULL OR valor_rendimento_isento_65 >= 0) AND
        (valor_rendimento_isento_65_dec IS NULL OR valor_rendimento_isento_65_dec >= 0) AND
        (valor_juros_mora IS NULL OR valor_juros_mora >= 0) AND
        (valor_juros_mora_13 IS NULL OR valor_juros_mora_13 >= 0) AND
        (valor_rendimento_isento_nao_tributavel IS NULL OR valor_rendimento_isento_nao_tributavel >= 0) AND
        (valor_previdencia_oficial IS NULL OR valor_previdencia_oficial >= 0) AND
        (valor_previdencia_oficial_13 IS NULL OR valor_previdencia_oficial_13 >= 0)
    )
);

-- =============================================
-- 30. RENDIMENTOS ISENTOS 0561 (rendIsen0561)
-- =============================================

CREATE TABLE rendimentos_isentos_0561 (
    id SERIAL PRIMARY KEY,
    informacao_ir_id INTEGER NOT NULL REFERENCES informacoes_ir(id) ON DELETE CASCADE,
    
    -- Rendimentos específicos do CR 0561
    valor_diarias DECIMAL(14,2) DEFAULT 0, -- vlrDiarias
    valor_ajuda_custo DECIMAL(14,2) DEFAULT 0, -- vlrAjudaCusto
    valor_indenizacao_rescisao DECIMAL(14,2) DEFAULT 0, -- vlrIndResContrato
    valor_abono_pecuniario DECIMAL(14,2) DEFAULT 0, -- vlrAbonoPec
    valor_auxilio_moradia DECIMAL(14,2) DEFAULT 0, -- vlrAuxMoradia
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_rendimentos_0561_valores CHECK (
        (valor_diarias IS NULL OR valor_diarias >= 0) AND
        (valor_ajuda_custo IS NULL OR valor_ajuda_custo >= 0) AND
        (valor_indenizacao_rescisao IS NULL OR valor_indenizacao_rescisao >= 0) AND
        (valor_abono_pecuniario IS NULL OR valor_abono_pecuniario >= 0) AND
        (valor_auxilio_moradia IS NULL OR valor_auxilio_moradia >= 0)
    )
);

-- =============================================
-- 31. INFORMAÇÕES RRA (infoRRA)
-- =============================================

CREATE TABLE informacoes_rra (
    id SERIAL PRIMARY KEY,
    codigo_receita_irrf_id INTEGER NOT NULL REFERENCES codigos_receita_irrf(id) ON DELETE CASCADE,
    
    -- Dados do RRA
    descricao_rra VARCHAR(50) NOT NULL, -- descRRA
    quantidade_meses_rra DECIMAL(4,1) NOT NULL, -- qtdMesesRRA
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_rra_quantidade_meses CHECK (quantidade_meses_rra > 0)
);

-- =============================================
-- 32. DESPESAS PROCESSO JUDICIAL (despProcJud)
-- =============================================

CREATE TABLE despesas_processo_judicial (
    id SERIAL PRIMARY KEY,
    informacao_rra_id INTEGER NOT NULL REFERENCES informacoes_rra(id) ON DELETE CASCADE,
    
    -- Despesas
    valor_despesas_custas DECIMAL(14,2) NOT NULL DEFAULT 0, -- vlrDespCustas
    valor_despesas_advogados DECIMAL(14,2) NOT NULL DEFAULT 0, -- vlrDespAdvogados
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_despesas_valores CHECK (valor_despesas_custas >= 0 AND valor_despesas_advogados >= 0)
);

-- =============================================
-- 33. IDENTIFICAÇÃO ADVOGADOS (ideAdv)
-- =============================================

CREATE TABLE advogados (
    id SERIAL PRIMARY KEY,
    despesa_processo_judicial_id INTEGER NOT NULL REFERENCES despesas_processo_judicial(id) ON DELETE CASCADE,
    
    -- Dados do advogado
    tipo_inscricao_id INTEGER NOT NULL REFERENCES tipos_inscricao(id),
    numero_inscricao VARCHAR(14) NOT NULL,
    valor_advogado DECIMAL(14,2) DEFAULT 0, -- vlrAdv
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_advogado_numero_inscricao 
        CHECK (length(numero_inscricao) IN (11, 14)),
    CONSTRAINT ck_advogado_valor CHECK (valor_advogado IS NULL OR valor_advogado >= 0)
);

-- =============================================
-- 34. DEDUÇÕES DEPENDENTES (dedDepen)
-- =============================================

CREATE TABLE deducoes_dependentes (
    id SERIAL PRIMARY KEY,
    codigo_receita_irrf_id INTEGER NOT NULL REFERENCES codigos_receita_irrf(id) ON DELETE CASCADE,
    
    -- Dados da dedução
    tipo_rendimento INTEGER NOT NULL CHECK (tipo_rendimento IN (11, 12)), -- tpRend: 11=Mensal, 12=13º
    cpf_dependente VARCHAR(11) NOT NULL, -- cpfDep
    valor_deducao DECIMAL(14,2) NOT NULL, -- vlrDeducao
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_deducao_cpf_dependente CHECK (length(cpf_dependente) = 11),
    CONSTRAINT ck_deducao_valor CHECK (valor_deducao > 0)
);

-- =============================================
-- 35. PENSÃO ALIMENTÍCIA (penAlim)
-- =============================================

CREATE TABLE pensoes_alimenticias (
    id SERIAL PRIMARY KEY,
    codigo_receita_irrf_id INTEGER NOT NULL REFERENCES codigos_receita_irrf(id) ON DELETE CASCADE,
    
    -- Dados da pensão
    tipo_rendimento INTEGER NOT NULL CHECK (tipo_rendimento IN (11, 12, 18, 79)), -- tpRend
    cpf_beneficiario VARCHAR(11) NOT NULL, -- cpfDep
    valor_pensao DECIMAL(14,2) NOT NULL, -- vlrPensao
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_pensao_cpf_beneficiario CHECK (length(cpf_beneficiario) = 11),
    CONSTRAINT ck_pensao_valor CHECK (valor_pensao > 0)
);

-- =============================================
-- 36. PROCESSOS DE RETENÇÃO (infoProcRet)
-- =============================================

CREATE TABLE processos_retencao (
    id SERIAL PRIMARY KEY,
    codigo_receita_irrf_id INTEGER NOT NULL REFERENCES codigos_receita_irrf(id) ON DELETE CASCADE,
    
    -- Dados do processo
    tipo_processo_retencao INTEGER NOT NULL CHECK (tipo_processo_retencao IN (1, 2)), -- tpProcRet: 1=Administrativo, 2=Judicial
    numero_processo_retencao VARCHAR(21) NOT NULL, -- nrProcRet
    codigo_suspensao INTEGER, -- codSusp
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_processo_retencao_numero 
        CHECK (length(numero_processo_retencao) IN (17, 20, 21)),
    CONSTRAINT ck_processo_retencao_codigo_suspensao 
        CHECK (codigo_suspensao IS NULL OR codigo_suspensao BETWEEN 1 AND 99999999999999)
);

-- =============================================
-- 37. VALORES PROCESSOS RETENÇÃO (infoValores)
-- =============================================

CREATE TABLE valores_processos_retencao (
    id SERIAL PRIMARY KEY,
    processo_retencao_id INTEGER NOT NULL REFERENCES processos_retencao(id) ON DELETE CASCADE,
    
    -- Indicativo do período
    indicativo_apuracao INTEGER NOT NULL CHECK (indicativo_apuracao IN (1, 2)), -- indApuracao: 1=Mensal, 2=Anual (13º)
    
    -- Valores
    valor_nao_retido DECIMAL(14,2) DEFAULT 0, -- vlrNRetido
    valor_deposito_judicial DECIMAL(14,2) DEFAULT 0, -- vlrDepJud
    valor_compensacao_ano_calendario DECIMAL(14,2) DEFAULT 0, -- vlrCmpAnoCal
    valor_compensacao_anos_anteriores DECIMAL(14,2) DEFAULT 0, -- vlrCmpAnoAnt
    valor_rendimento_suspenso DECIMAL(14,2) DEFAULT 0, -- vlrRendSusp
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_valores_retencao CHECK (
        (valor_nao_retido IS NULL OR valor_nao_retido > 0) AND
        (valor_deposito_judicial IS NULL OR valor_deposito_judicial > 0) AND
        (valor_compensacao_ano_calendario IS NULL OR valor_compensacao_ano_calendario > 0) AND
        (valor_compensacao_anos_anteriores IS NULL OR valor_compensacao_anos_anteriores > 0) AND
        (valor_rendimento_suspenso IS NULL OR valor_rendimento_suspenso > 0)
    )
);

-- =============================================
-- 38. DEDUÇÕES SUSPENSAS (dedSusp)
-- =============================================

CREATE TABLE deducoes_suspensas (
    id SERIAL PRIMARY KEY,
    valores_processo_retencao_id INTEGER NOT NULL REFERENCES valores_processos_retencao(id) ON DELETE CASCADE,
    
    -- Dados da dedução suspensa
    indicativo_tipo_deducao INTEGER NOT NULL CHECK (indicativo_tipo_deducao IN (1, 5, 7)), -- indTpDeducao: 1=Previdência, 5=Pensão, 7=Dependentes
    valor_deducao_suspensa DECIMAL(14,2), -- vlrDedSusp
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_deducao_suspensa_valor CHECK (valor_deducao_suspensa IS NULL OR valor_deducao_suspensa > 0)
);

-- =============================================
-- 39. BENEFICIÁRIOS PENSÃO SUSPENSA (benefPen)
-- =============================================

CREATE TABLE beneficiarios_pensao_suspensa (
    id SERIAL PRIMARY KEY,
    deducao_suspensa_id INTEGER NOT NULL REFERENCES deducoes_suspensas(id) ON DELETE CASCADE,
    
    -- Dados do beneficiário
    cpf_beneficiario VARCHAR(11) NOT NULL, -- cpfDep
    valor_dependente_suspenso DECIMAL(14,2) NOT NULL, -- vlrDepenSusp
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_beneficiario_cpf CHECK (length(cpf_beneficiario) = 11),
    CONSTRAINT ck_beneficiario_valor CHECK (valor_dependente_suspenso > 0)
);

-- =============================================
-- 40. INFORMAÇÕES IR COMPLEMENTARES (infoIRComplem)
-- =============================================

CREATE TABLE informacoes_ir_complementares (
    id SERIAL PRIMARY KEY,
    tributo_processo_id INTEGER NOT NULL REFERENCES tributos_processo(id) ON DELETE CASCADE,
    
    -- Data do laudo de moléstia grave
    data_laudo DATE, -- dtLaudo
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_data_laudo CHECK (data_laudo IS NULL OR data_laudo >= '1900-01-01')
);

-- =============================================
-- 41. DEPENDENTES NÃO CADASTRADOS (infoDep)
-- =============================================

CREATE TABLE dependentes_nao_cadastrados (
    id SERIAL PRIMARY KEY,
    informacao_ir_complementar_id INTEGER NOT NULL REFERENCES informacoes_ir_complementares(id) ON DELETE CASCADE,
    
    -- Dados do dependente
    cpf_dependente VARCHAR(11) NOT NULL, -- cpfDep
    data_nascimento DATE, -- dtNascto
    nome VARCHAR(70), -- nome
    dependente_irrf CHAR(1) CHECK (dependente_irrf = 'S'), -- depIRRF
    tipo_dependente VARCHAR(2), -- tpDep
    descricao_dependencia VARCHAR(100), -- descrDep
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_dependente_cpf CHECK (length(cpf_dependente) = 11),
    CONSTRAINT ck_dependente_data_nascimento CHECK (data_nascimento IS NULL OR data_nascimento >= '1890-01-01')
);

-- =============================================
-- 42. FASE 02: CONSOLIDAÇÃO (S-2555)
-- =============================================

CREATE TABLE consolidacoes_tributos (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    numero_processo VARCHAR(50) NOT NULL,
    periodo_apuracao_pagamento VARCHAR(7) NOT NULL, -- perApurPgto
    status_id INTEGER NOT NULL REFERENCES status_sistema(id) DEFAULT 1,
    observacoes TEXT,
    
    -- Auditoria obrigatória
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_consolidacao_periodo_apuracao 
        CHECK (periodo_apuracao_pagamento ~ '^[0-9]{4}-[0-1][0-9]$')
);

-- =============================================
-- 43. FASE 02: EXCLUSÃO DE EVENTOS (S-3500)
-- =============================================

CREATE TABLE exclusoes_eventos (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    tipo_evento VARCHAR(6) NOT NULL CHECK (tipo_evento IN ('S-2500', 'S-2501', 'S-2555')),
    numero_recibo_evento VARCHAR(40) NOT NULL, -- nrRecEvt
    numero_processo VARCHAR(50) NOT NULL, -- nrProcTrab
    cpf_trabalhador VARCHAR(11), -- cpfTrab (obrigatório para S-2500)
    periodo_apuracao_pagamento VARCHAR(7), -- perApurPgto (obrigatório para S-2501/S-2555)
    sequencia_processo INTEGER, -- ideSeqProc
    status_id INTEGER NOT NULL REFERENCES status_sistema(id) DEFAULT 1,
    observacoes TEXT,
    
    -- Auditoria obrigatória
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    CONSTRAINT ck_exclusao_cpf_s2500 
        CHECK ((tipo_evento != 'S-2500') OR (tipo_evento = 'S-2500' AND cpf_trabalhador IS NOT NULL)),
    CONSTRAINT ck_exclusao_periodo_s2501_s2555 
        CHECK ((tipo_evento = 'S-2500') OR (tipo_evento IN ('S-2501', 'S-2555') AND periodo_apuracao_pagamento IS NOT NULL)),
    CONSTRAINT ck_exclusao_cpf_formato 
        CHECK (cpf_trabalhador IS NULL OR length(cpf_trabalhador) = 11)
);

-- =============================================
-- 44. CONTROLE DE ENVIO DE XMLs
-- =============================================

CREATE TABLE controle_envio_xml (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    tipo_evento VARCHAR(6) NOT NULL CHECK (tipo_evento IN ('S-2500', 'S-2501', 'S-2555', 'S-3500')),
    numero_processo VARCHAR(50) NOT NULL,
    
    -- FKs específicas por tipo de evento (apenas uma deve estar preenchida)
    trabalhador_processo_id INTEGER REFERENCES trabalhadores_processo(id) ON DELETE CASCADE,
    tributo_processo_id INTEGER REFERENCES tributos_processo(id) ON DELETE CASCADE,
    consolidacao_tributo_id INTEGER REFERENCES consolidacoes_tributos(id) ON DELETE CASCADE,
    exclusao_evento_id INTEGER REFERENCES exclusoes_eventos(id) ON DELETE CASCADE,
    
    -- Dados do envio
    numero_recibo VARCHAR(40), -- Retornado pelo eSocial
    xml_conteudo TEXT, -- XML gerado
    xml_resposta TEXT, -- Resposta do eSocial
    data_envio TIMESTAMP,
    data_processamento TIMESTAMP,
    status_envio VARCHAR(30) DEFAULT 'PENDENTE', -- PENDENTE, ENVIADO, PROCESSADO, ERRO
    mensagem_retorno TEXT,
    
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_criacao VARCHAR(200) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(200),
     
    
    -- Constraint: apenas uma FK deve estar preenchida
    CONSTRAINT ck_controle_envio_apenas_uma_referencia CHECK (
        (CASE WHEN trabalhador_processo_id IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN tributo_processo_id IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN consolidacao_tributo_id IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN exclusao_evento_id IS NOT NULL THEN 1 ELSE 0 END) = 1
    ),
    
    -- Constraint: FK deve corresponder ao tipo_evento
    CONSTRAINT ck_controle_envio_tipo_evento_referencia CHECK (
        (tipo_evento = 'S-2500' AND trabalhador_processo_id IS NOT NULL) OR
        (tipo_evento = 'S-2501' AND tributo_processo_id IS NOT NULL) OR
        (tipo_evento = 'S-2555' AND consolidacao_tributo_id IS NOT NULL) OR
        (tipo_evento = 'S-3500' AND exclusao_evento_id IS NOT NULL)
    )
);

CREATE INDEX idx_controle_envio_tipo_evento ON controle_envio_xml(tipo_evento);
CREATE INDEX idx_controle_envio_numero_processo ON controle_envio_xml(numero_processo);
CREATE INDEX idx_controle_envio_status ON controle_envio_xml(status_envio);

-- =============================================
-- 45. LOG DE AUDITORIA GERAL
-- =============================================

CREATE TABLE log_auditoria (
    id SERIAL PRIMARY KEY,
    tabela VARCHAR(100) NOT NULL,
    operacao VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    registro_id INTEGER NOT NULL,
    dados_antes JSONB,
    dados_depois JSONB,
    usuario VARCHAR(200) NOT NULL,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_usuario INET,
    observacoes TEXT
);

CREATE INDEX idx_log_auditoria_tabela ON log_auditoria(tabela);
CREATE INDEX idx_log_auditoria_data ON log_auditoria(data_operacao);
CREATE INDEX idx_log_auditoria_usuario ON log_auditoria(usuario);

-- =============================================
-- 46. FUNÇÕES E TRIGGERS PARA AUDITORIA
-- =============================================

-- Função para atualizar data_alteracao automaticamente
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.data_alteracao = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger nas tabelas principais
CREATE TRIGGER set_timestamp_processos_trabalhistas
    BEFORE UPDATE ON processos_trabalhistas
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_trabalhadores_processo
    BEFORE UPDATE ON trabalhadores_processo
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_tributos_processo
    BEFORE UPDATE ON tributos_processo
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_consolidacoes_tributos
    BEFORE UPDATE ON consolidacoes_tributos
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_exclusoes_eventos
    BEFORE UPDATE ON exclusoes_eventos
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

-- =============================================
-- 47. COMENTÁRIOS DAS TABELAS
-- =============================================

COMMENT ON SCHEMA processotrabalhista IS 'Schema para eventos de processo trabalhista do eSocial (S-2500, S-2501, S-2555, S-3500) - Versão Completa';

-- Tabelas de Domínio
COMMENT ON TABLE status_sistema IS 'Estados possíveis dos registros no sistema';
COMMENT ON TABLE tipos_inscricao IS 'Tipos de inscrição conforme Tabela 05 do eSocial';
COMMENT ON TABLE origens_processo IS 'Origem do processo: Judicial ou CCP/NINTER';
COMMENT ON TABLE tipos_contrato IS 'Tipos de contrato conforme documentação S-2500';

-- Processo Trabalhista (S-2500)
COMMENT ON TABLE processos_trabalhistas IS 'Cadastro principal dos processos trabalhistas - Base para evento S-2500';
COMMENT ON TABLE processos_judiciais IS 'Informações específicas de processos judiciais (infoProcJud)';
COMMENT ON TABLE processos_ccp IS 'Informações específicas de CCP/NINTER (infoCCP)';
COMMENT ON TABLE trabalhadores_processo IS 'Trabalhadores vinculados aos processos - Permite múltiplos trabalhadores por processo (ideTrab)';
COMMENT ON TABLE contratos_processo IS 'Informações contratuais específicas de cada trabalhador no processo (infoContr)';
COMMENT ON TABLE contratos_complementares IS 'Informações complementares do contrato (infoCompl)';
COMMENT ON TABLE remuneracoes_processo IS 'Dados de remuneração do trabalhador (remuneracao)';
COMMENT ON TABLE vinculos_processo IS 'Informações do vínculo trabalhista (infoVinc)';
COMMENT ON TABLE duracoes_contrato IS 'Duração do contrato de trabalho (duracao)';
COMMENT ON TABLE observacoes_contratos IS 'Observações do contrato (observacoes)';
COMMENT ON TABLE sucessoes_vinculo IS 'Informações de sucessão de vínculo (sucessaoVinc)';
COMMENT ON TABLE desligamentos_processo IS 'Informações de desligamento (infoDeslig)';
COMMENT ON TABLE terminos_tsve IS 'Informações de término de TSVE (infoTerm)';
COMMENT ON TABLE mudancas_categoria_atividade IS 'Mudanças de categoria/atividade (mudCategAtiv)';
COMMENT ON TABLE unicidades_contratuais IS 'Informações de unicidade contratual (unicContr)';
COMMENT ON TABLE estabelecimentos_processo IS 'Estabelecimentos responsáveis pelos pagamentos (ideEstab)';
COMMENT ON TABLE periodos_valores IS 'Períodos e valores decorrentes do processo (infoVlr)';
COMMENT ON TABLE abonos_processo IS 'Anos-base com indenização substitutiva de abono (abono)';
COMMENT ON TABLE identificacoes_periodo IS 'Identificação dos períodos de referência (idePeriodo)';
COMMENT ON TABLE bases_calculo_processo IS 'Bases de cálculo de contribuição previdenciária (baseCalculo)';
COMMENT ON TABLE fgts_processo IS 'Informações de FGTS para geração de guia (infoFGTS)';
COMMENT ON TABLE bases_mudanca_categoria IS 'Bases de cálculo para mudança de categoria (baseMudCateg)';
COMMENT ON TABLE trabalho_intermitente IS 'Informações de trabalho intermitente (infoInterm)';

-- Tributos (S-2501)
COMMENT ON TABLE tributos_processo IS 'Informações dos tributos decorrentes - Base para evento S-2501';
COMMENT ON TABLE calculo_tributos IS 'Períodos de referência para cálculo de tributos (calcTrib)';
COMMENT ON TABLE codigos_receita_contrib_social IS 'Códigos de receita para contribuições sociais (infoCRContrib)';
COMMENT ON TABLE codigos_receita_irrf IS 'Códigos de receita para IRRF (infoCRIRRF)';
COMMENT ON TABLE informacoes_ir IS 'Informações complementares de Imposto de Renda (infoIR)';
COMMENT ON TABLE rendimentos_isentos_0561 IS 'Rendimentos isentos exclusivos do CR 0561 (rendIsen0561)';
COMMENT ON TABLE informacoes_rra IS 'Informações de Rendimentos Recebidos Acumuladamente (infoRRA)';
COMMENT ON TABLE despesas_processo_judicial IS 'Detalhamento das despesas com processo judicial (despProcJud)';
COMMENT ON TABLE advogados IS 'Identificação dos advogados (ideAdv)';
COMMENT ON TABLE deducoes_dependentes IS 'Deduções relativas a dependentes (dedDepen)';
COMMENT ON TABLE pensoes_alimenticias IS 'Informações de pensão alimentícia (penAlim)';
COMMENT ON TABLE processos_retencao IS 'Processos relacionados à não retenção de tributos (infoProcRet)';
COMMENT ON TABLE valores_processos_retencao IS 'Valores relacionados aos processos de retenção (infoValores)';
COMMENT ON TABLE deducoes_suspensas IS 'Deduções com exigibilidade suspensa (dedSusp)';
COMMENT ON TABLE beneficiarios_pensao_suspensa IS 'Beneficiários de pensão com dedução suspensa (benefPen)';
COMMENT ON TABLE informacoes_ir_complementares IS 'Informações complementares de IR (infoIRComplem)';
COMMENT ON TABLE dependentes_nao_cadastrados IS 'Dependentes não cadastrados no eSocial (infoDep)';

-- Consolidação e Exclusão
COMMENT ON TABLE consolidacoes_tributos IS 'Solicitações de consolidação - Evento S-2555';
COMMENT ON TABLE exclusoes_eventos IS 'Solicitações de exclusão de eventos - Evento S-3500';

-- Controle
COMMENT ON TABLE controle_envio_xml IS 'Controle de geração e envio dos XMLs para o eSocial';
COMMENT ON TABLE log_auditoria IS 'Log completo de auditoria do sistema';

-- =============================================
-- 48. CRIAÇÃO DO USUÁRIO E CONCESSÃO DE PERMISSÕES
-- =============================================

-- Criar usuário user_app (se não existir)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'user_app') THEN
        CREATE USER user_app WITH LOGIN PASSWORD 'app_password_2025!';
    END IF;
END
$$;

-- Conceder permissões no banco
GRANT CONNECT ON DATABASE esocial_processos_trabalhistas TO user_app;

-- Conceder permissões no schema processotrabalhista
GRANT USAGE ON SCHEMA processotrabalhista TO user_app;
GRANT CREATE ON SCHEMA processotrabalhista TO user_app;

-- Conceder permissões em todas as tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA processotrabalhista TO user_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA processotrabalhista TO user_app;

-- Conceder permissões em tabelas futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA processotrabalhista 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO user_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA processotrabalhista 
    GRANT USAGE, SELECT ON SEQUENCES TO user_app;

-- Conceder permissões para executar funções
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA processotrabalhista TO user_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA processotrabalhista 
    GRANT EXECUTE ON FUNCTIONS TO user_app;


-- =============================================
-- ÍNDICES PARA PERFORMANCE
-- Recomendações para otimizar as queries
-- =============================================

-- Índices adicionais para performance das queries

-- Para queries de busca por período
CREATE INDEX IF NOT EXISTS idx_tributos_processo_periodo 
    ON processotrabalhista.tributos_processo(periodo_apuracao_pagamento);

CREATE INDEX IF NOT EXISTS idx_calculo_tributos_periodo 
    ON processotrabalhista.calculo_tributos(periodo_referencia);

CREATE INDEX IF NOT EXISTS idx_identificacao_periodo_referencia 
    ON processotrabalhista.identificacoes_periodo(periodo_referencia);

-- Para queries de controle de envio
CREATE INDEX IF NOT EXISTS idx_controle_envio_tipo_status 
    ON processotrabalhista.controle_envio_xml(tipo_evento, status_envio);

CREATE INDEX IF NOT EXISTS idx_controle_envio_data_envio 
    ON processotrabalhista.controle_envio_xml(data_envio);

-- Para queries de relacionamento trabalhador/processo
CREATE INDEX IF NOT EXISTS idx_trabalhadores_processo_cpf_status 
    ON processotrabalhista.trabalhadores_processo(cpf, status_ativo);

-- Para queries de auditoria
CREATE INDEX IF NOT EXISTS idx_processos_data_usuario 
    ON processotrabalhista.processos_trabalhistas(data_criacao, usuario_criacao);

CREATE INDEX IF NOT EXISTS idx_tributos_data_usuario 
    ON processotrabalhista.tributos_processo(data_criacao, usuario_criacao);

-- Para queries de validação
CREATE INDEX IF NOT EXISTS idx_controle_envio_trabalhador_tipo 
    ON processotrabalhista.controle_envio_xml(trabalhador_processo_id, tipo_evento);

-- =============================================
-- SCRIPT FINALIZADO - VERSÃO COMPLETA
-- Total de Tabelas: 48 tabelas + tabelas de domínio
-- Eventos Suportados: S-2500, S-2501, S-2555, S-3500
-- Status: VALIDADO conforme documentação eSocial v.S-1.3
-- =============================================