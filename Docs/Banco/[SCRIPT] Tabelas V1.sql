-- =============================================
-- SCRIPT COMPLETO - BASE DE DADOS eSocial
-- Eventos S-2500 e S-2501 - Processos Trabalhistas
-- Autor: Sistema eSocial
-- Data: 2025-01-15
-- =============================================

-- Criação do banco de dados
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ESocialProcessos')
BEGIN
    CREATE DATABASE ESocialProcessos;
END
GO

USE ESocialProcessos;
GO

-- =============================================
-- TABELAS DE DOMÍNIO/LOOKUP
-- =============================================

-- Status geral do sistema
CREATE TABLE [dbo].[ptrab_Status] (
    [StatusId] INTEGER IDENTITY(1,1) NOT NULL,
    [Codigo] VARCHAR(20) NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    [Ativo] BIT DEFAULT 1,
    CONSTRAINT [PK_ptrab_Status] PRIMARY KEY ([StatusId])
);

INSERT INTO [ptrab_Status] ([Codigo], [Descricao]) VALUES
('CADASTRADO', 'Cadastrado'),
('EM_ELABORACAO', 'Em Elaboração'),
('PENDENTE_ENVIO', 'Pendente de Envio'),
('ENVIADO', 'Enviado'),
('PROCESSADO', 'Processado com Sucesso'),
('ERRO', 'Erro no Processamento'),
('CANCELADO', 'Cancelado');

-- Tipos de Inscrição
CREATE TABLE [dbo].[ptrab_TipoInscricao] (
    [TipoInscricaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [Codigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoInscricao] PRIMARY KEY ([TipoInscricaoId])
);

INSERT INTO [ptrab_TipoInscricao] ([Codigo], [Descricao]) VALUES
(1, 'CNPJ'),
(2, 'CPF'),
(3, 'CAEPF'),
(4, 'CNO');

-- Origem do Processo
CREATE TABLE [dbo].[ptrab_Origem] (
    [OrigemId] INTEGER IDENTITY(1,1) NOT NULL,
    [Codigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_Origem] PRIMARY KEY ([OrigemId])
);

INSERT INTO [ptrab_Origem] ([Codigo], [Descricao]) VALUES
(1, 'Processo Judicial'),
(2, 'CCP - Comissão de Conciliação Prévia'),
(3, 'NINTER - Núcleo Intersindical');

-- Tipos de Contrato
CREATE TABLE [dbo].[ptrab_TipoContrato] (
    [TipoContratoId] INTEGER IDENTITY(1,1) NOT NULL,
    [Codigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoContrato] PRIMARY KEY ([TipoContratoId])
);

INSERT INTO [ptrab_TipoContrato] ([Codigo], [Descricao]) VALUES
(1, 'Prazo indeterminado'),
(2, 'Prazo determinado'),
(3, 'Prazo determinado prorrogado'),
(4, 'Contrato de trabalho verde e amarelo'),
(5, 'Contrato de aprendizagem');

-- =============================================
-- TABELA PRINCIPAL: CADASTRO DE PROCESSOS
-- =============================================

CREATE TABLE [dbo].[ptrab_CadastroProcesso] (
    [CadastroProcessoId] INTEGER IDENTITY(1,1) NOT NULL,
    [NumeroProcesso] VARCHAR(20) NOT NULL,
    [OrigemId] INTEGER NOT NULL,
    [Observacao] VARCHAR(999) NULL,
    [StatusId] INTEGER NOT NULL DEFAULT 1,
    
    -- Dados do Empregador (ideEmpregador)
    [EmpregadorTipoInscricaoId] INTEGER NOT NULL,
    [EmpregadorNumeroInscricao] VARCHAR(14) NOT NULL,
    [EmpregadorCodigoIdentificacaoSistema] VARCHAR(20) NULL,
    
    -- Dados do Responsável Indireto (ideResp) - OPCIONAL
    [ResponsavelTipoInscricaoId] INTEGER NULL,
    [ResponsavelNumeroInscricao] VARCHAR(14) NULL,
    
    -- Dados do Processo Judicial (infoProcJud) - SE OrigemId = 1
    [DataSentenca] DATETIME NULL,
    [UFVara] VARCHAR(2) NULL,
    [CodigoMunicipio] VARCHAR(7) NULL,
    [IdentificadorVara] VARCHAR(50) NULL,
    
    -- Dados do CCP/NINTER (infoCCP) - SE OrigemId = 2 ou 3
    [DataCCP] DATETIME NULL,
    [CNPJCCP] VARCHAR(14) NULL,
    [TipoCCP] INTEGER NULL, -- 1=CCP, 2=NINTER
    
    -- Auditoria
    [UsuarioInclusao] VARCHAR(200) NOT NULL,
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    [UsuarioEnvioTransmissao] VARCHAR(200) NULL,
    [DataEnvioTransmissao] DATETIME NULL,
    
    CONSTRAINT [PK_ptrab_CadastroProcesso] PRIMARY KEY ([CadastroProcessoId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_Origem] 
        FOREIGN KEY ([OrigemId]) REFERENCES [ptrab_Origem] ([OrigemId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_Status] 
        FOREIGN KEY ([StatusId]) REFERENCES [ptrab_Status] ([StatusId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_EmpregadorTipoInscricao] 
        FOREIGN KEY ([EmpregadorTipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_ResponsavelTipoInscricao] 
        FOREIGN KEY ([ResponsavelTipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    
    CONSTRAINT [UQ_ptrab_CadastroProcesso_NumeroProcesso] UNIQUE ([NumeroProcesso]),
    CONSTRAINT [CK_ptrab_CadastroProcesso_UFVara] CHECK ([UFVara] IS NULL OR LEN([UFVara]) = 2),
    CONSTRAINT [CK_ptrab_CadastroProcesso_EmpregadorInscricao] CHECK (LEN([EmpregadorNumeroInscricao]) BETWEEN 8 AND 14),
    CONSTRAINT [CK_ptrab_CadastroProcesso_ResponsavelInscricao] CHECK ([ResponsavelNumeroInscricao] IS NULL OR LEN([ResponsavelNumeroInscricao]) BETWEEN 8 AND 14),
    
    -- Constraint para garantir dados obrigatórios por origem
    CONSTRAINT [CK_ptrab_CadastroProcesso_DadosJudicial] CHECK (
        ([OrigemId] != 1) OR 
        ([OrigemId] = 1 AND [DataSentenca] IS NOT NULL AND [UFVara] IS NOT NULL AND [CodigoMunicipio] IS NOT NULL)
    ),
    CONSTRAINT [CK_ptrab_CadastroProcesso_DadosCCP] CHECK (
        ([OrigemId] NOT IN (2,3)) OR 
        ([OrigemId] IN (2,3) AND [DataCCP] IS NOT NULL)
    )
);

-- Índices para ptrab_CadastroProcesso
CREATE INDEX [IDX_ptrab_CadastroProcesso_NumeroProcesso] ON [ptrab_CadastroProcesso] ([NumeroProcesso]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_OrigemId] ON [ptrab_CadastroProcesso] ([OrigemId]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_StatusId] ON [ptrab_CadastroProcesso] ([StatusId]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_EmpregadorInscricao] ON [ptrab_CadastroProcesso] ([EmpregadorNumeroInscricao]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_DataInclusao] ON [ptrab_CadastroProcesso] ([DataInclusao]);

-- =============================================
-- TRABALHADORES DO PROCESSO (Array)
-- =============================================

CREATE TABLE [dbo].[ptrab_TrabalhadorProcesso] (
    [TrabalhadorProcessoId] INTEGER IDENTITY(1,1) NOT NULL,
    [CadastroProcessoId] INTEGER NOT NULL,
    [CPF] VARCHAR(11) NOT NULL,
    [Nome] VARCHAR(70) NULL,
    [DataNascimento] DATETIME NULL,
    [StatusTrabalhador] INTEGER DEFAULT 1, -- 1=Ativo, 2=Inativo
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT [PK_ptrab_TrabalhadorProcesso] PRIMARY KEY ([TrabalhadorProcessoId]),
    CONSTRAINT [FK_ptrab_TrabalhadorProcesso_CadastroProcesso] 
        FOREIGN KEY ([CadastroProcessoId]) REFERENCES [ptrab_CadastroProcesso] ([CadastroProcessoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_TrabalhadorProcesso_CPF] CHECK (LEN([CPF]) = 11),
    CONSTRAINT [UQ_ptrab_TrabalhadorProcesso_Processo_CPF] UNIQUE ([CadastroProcessoId], [CPF])
);

CREATE INDEX [IDX_ptrab_TrabalhadorProcesso_CadastroProcessoId] ON [ptrab_TrabalhadorProcesso] ([CadastroProcessoId]);
CREATE INDEX [IDX_ptrab_TrabalhadorProcesso_CPF] ON [ptrab_TrabalhadorProcesso] ([CPF]);

-- =============================================
-- DETALHAMENTO S-2500: PROCESSO TRABALHISTA
-- =============================================

CREATE TABLE [dbo].[ptrab_ProcessoTrabalhista] (
    [ProcessoTrabalhistaId] INTEGER IDENTITY(1,1) NOT NULL,
    [TrabalhadorProcessoId] INTEGER NOT NULL,
    [StatusId] INTEGER NOT NULL,
    
    -- Informações do Contrato (infoContr)
    [TipoContratoId] INTEGER NOT NULL,
    [IndicadorContrato] CHAR(1) NOT NULL, -- S=Sim, N=Não (indContr)
    [DataAdmissaoOriginal] DATETIME NULL, -- dtAdmOrig
    [IndicadorReintegracao] CHAR(1) NULL, -- indReint: S=Sim, N=Não
    [IndicadorCategoria] CHAR(1) NULL, -- indCateg: S=Sim, N=Não  
    [IndicadorNaturezaAtividade] CHAR(1) NOT NULL, -- indNatAtiv: S=Sim, N=Não
    [IndicadorMotivoDesligamento] CHAR(1) NOT NULL, -- indMotDeslig: S=Sim, N=Não
    [Matricula] VARCHAR(30) NULL,
    [CodigoCategoria] VARCHAR(3) NULL,
    [DataInicioTSVE] DATETIME NULL, -- dtInicio (para TSVE)
    
    -- Informações Complementares (infoCompl)
    [CodigoCBO] VARCHAR(6) NULL,
    [NaturezaAtividade] INTEGER NULL, -- natAtividade
    
    -- Remuneração
    [DataRemuneracao] DATETIME NULL, -- dtRemun
    [ValorSalarioFixo] MONEY NULL, -- vrSalFx
    [UnidadePagamento] INTEGER NULL, -- undSalFixo
    [DescricaoSalarioVariavel] VARCHAR(999) NULL, -- dscSalVar
    
    -- Informações do Vínculo (infoVinc)
    [TipoRegimeTrabalhista] INTEGER NULL, -- tpRegTrab: 1=CLT, 2=Estatutário
    [TipoRegimePrevidenciario] INTEGER NULL, -- tpRegPrev: 1=RGPS, 2=RPPS, 3=Regime Exterior, 4=SPSMFA
    [DataAdmissao] DATETIME NULL, -- dtAdm
    [TipoJornada] INTEGER NULL, -- tpJornada
    
    -- Duração do Contrato (duracao)
    [TipoDuracao] INTEGER NULL, -- tpContr: 1=Prazo indeterminado, 2=Prazo determinado
    [DataTermino] DATETIME NULL, -- dtTerm
    [ClausulaAssecuratoria] CHAR(1) NULL, -- clauAssec: S=Sim, N=Não
    [ObjetoDeterminante] VARCHAR(255) NULL, -- objDet
    
    -- Observações do Vínculo
    [ObservacoesVinculo] VARCHAR(255) NULL,
    
    -- Sucessão de Vínculo (sucessaoVinc)
    [SucessaoTipoInscricao] INTEGER NULL, --tpInsc
    [SucessaoNumeroInscricao] VARCHAR(14) NULL, -- nrInsc
    [SucessaoMatriculaAnterior] VARCHAR(30) NULL, -- matricAnt
    [SucessaoDataTransferencia] DATETIME NULL, -- dtTransf
    
    -- Informações de Desligamento (infoDeslig)
	[DataDesligamento] DATETIME NUll, -- dtDeslig
    [MotivoDesligamento] VARCHAR(2) NULL, -- mtvDeslig
    [DataProjetadaFimAviso] DATETIME NULL, -- dtProjFimAPI
    [TipoPensaoAlimenticia] INTEGER NULL, -- tpPensao
    [PercentualAlimenticia] DECIMAL(5,2) NULL, -- percAliment
    [ValorAlimenticia] MONEY NULL, -- vrAlim
    
    -- Informações de Término TSVE (infoTerm)
    [DataTerminoTSVE] DATETIME NULL, -- dtTerm
    [MotivoDesligamentoTSV] VARCHAR(2) NULL, -- mtvDesligTSV
    
    -- Mudança de Categoria/Atividade (mudCategAtiv)
    [CodigoMudancaCategoria] VARCHAR(3) NULL, -- codCateg
    [MudancaNaturezaAtividade] INTEGER NULL, -- natAtividade  
    [DataMudancaCategoria] DATETIME NULL, -- dtMudCategAtiv
    
    -- Auditoria
    [UsuarioInclusao] VARCHAR(200) NOT NULL,
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    [UsuarioEnvioTransmissao] VARCHAR(200) NULL,
    [DataEnvioTransmissao] DATETIME NULL,
    
    CONSTRAINT [PK_ptrab_ProcessoTrabalhista] PRIMARY KEY ([ProcessoTrabalhistaId]),
    CONSTRAINT [FK_ptrab_ProcessoTrabalhista_TrabalhadorProcesso] 
        FOREIGN KEY ([TrabalhadorProcessoId]) REFERENCES [ptrab_TrabalhadorProcesso] ([TrabalhadorProcessoId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_ProcessoTrabalhista_Status] 
        FOREIGN KEY ([StatusId]) REFERENCES [ptrab_Status] ([StatusId]),
    CONSTRAINT [FK_ptrab_ProcessoTrabalhista_TipoContrato] 
        FOREIGN KEY ([TipoContratoId]) REFERENCES [ptrab_TipoContrato] ([TipoContratoId]),
    
    -- Constraints de validação
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_IndicadorContrato] CHECK ([IndicadorContrato] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_IndicadorReintegracao] CHECK ([IndicadorReintegracao] IN ('S', 'N') OR [IndicadorReintegracao] IS NULL),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_IndicadorCategoria] CHECK ([IndicadorCategoria] IN ('S', 'N') OR [IndicadorCategoria] IS NULL),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_IndicadorNaturezaAtividade] CHECK ([IndicadorNaturezaAtividade] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_IndicadorMotivoDesligamento] CHECK ([IndicadorMotivoDesligamento] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_ClausulaAssecuratoria] CHECK ([ClausulaAssecuratoria] IN ('S', 'N') OR [ClausulaAssecuratoria] IS NULL),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_TipoRegimeTrabalhista] CHECK ([TipoRegimeTrabalhista] IN (1, 2) OR [TipoRegimeTrabalhista] IS NULL),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_TipoRegimePrevidenciario] CHECK ([TipoRegimePrevidenciario] IN (1, 2, 3, 4) OR [TipoRegimePrevidenciario] IS NULL),
    CONSTRAINT [CK_ptrab_ProcessoTrabalhista_TipoDuracao] CHECK ([TipoDuracao] IN (1, 2) OR [TipoDuracao] IS NULL)
);

CREATE INDEX [IDX_ptrab_ProcessoTrabalhista_TrabalhadorProcessoId] ON [ptrab_ProcessoTrabalhista] ([TrabalhadorProcessoId]);
CREATE INDEX [IDX_ptrab_ProcessoTrabalhista_StatusId] ON [ptrab_ProcessoTrabalhista] ([StatusId]);
CREATE INDEX [IDX_ptrab_ProcessoTrabalhista_Matricula] ON [ptrab_ProcessoTrabalhista] ([Matricula]);
CREATE INDEX [IDX_ptrab_ProcessoTrabalhista_CPF_Processo] ON [ptrab_ProcessoTrabalhista] ([TrabalhadorProcessoId], [StatusId]);

-- =============================================
-- UNICIDADE CONTRATUAL (unicContr)
-- =============================================

CREATE TABLE [dbo].[ptrab_UnicidadeContratual] (
    [UnicidadeContratualId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoTrabalhistaId] INTEGER NOT NULL,
    [MatriculaIncorporada] VARCHAR(30) NULL, -- matUnic
    [CodigoCategoria] VARCHAR(3) NULL, -- codCateg
    [DataInicio] DATETIME NULL, -- dtInicio
    
    CONSTRAINT [PK_ptrab_UnicidadeContratual] PRIMARY KEY ([UnicidadeContratualId]),
    CONSTRAINT [FK_ptrab_UnicidadeContratual_ProcessoTrabalhista] 
        FOREIGN KEY ([ProcessoTrabalhistaId]) REFERENCES [ptrab_ProcessoTrabalhista] ([ProcessoTrabalhistaId]) ON DELETE CASCADE
);

CREATE INDEX [IDX_ptrab_UnicidadeContratual_ProcessoTrabalhistaId] ON [ptrab_UnicidadeContratual] ([ProcessoTrabalhistaId]);

-- =============================================
-- ESTABELECIMENTO RESPONSÁVEL PELO PAGAMENTO (ideEstab)
-- =============================================

CREATE TABLE [dbo].[ptrab_EstabelecimentoPagamento] (
    [EstabelecimentoPagamentoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoTrabalhistaId] INTEGER NOT NULL,
    [TipoInscricaoId] INTEGER NOT NULL,
    [NumeroInscricao] VARCHAR(14) NOT NULL,
    
    CONSTRAINT [PK_ptrab_EstabelecimentoPagamento] PRIMARY KEY ([EstabelecimentoPagamentoId]),
    CONSTRAINT [FK_ptrab_EstabelecimentoPagamento_ProcessoTrabalhista] 
        FOREIGN KEY ([ProcessoTrabalhistaId]) REFERENCES [ptrab_ProcessoTrabalhista] ([ProcessoTrabalhistaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_EstabelecimentoPagamento_TipoInscricao] 
        FOREIGN KEY ([TipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    
    CONSTRAINT [CK_ptrab_EstabelecimentoPagamento_NumeroInscricao] CHECK (LEN([NumeroInscricao]) BETWEEN 8 AND 14)
);

CREATE INDEX [IDX_ptrab_EstabelecimentoPagamento_ProcessoTrabalhistaId] ON [ptrab_EstabelecimentoPagamento] ([ProcessoTrabalhistaId]);

-- =============================================
-- PERÍODOS E VALORES DO PROCESSO (infoValores)
-- =============================================

CREATE TABLE [dbo].[ptrab_PeriodoValores] (
    [PeriodoValoresId] INTEGER IDENTITY(1,1) NOT NULL,
    [EstabelecimentoPagamentoId] INTEGER NOT NULL,
    [CompetenciaInicio] VARCHAR(7) NOT NULL, -- compIni (YYYY-MM)
    [CompetenciaFim] VARCHAR(7) NOT NULL, -- compFim (YYYY-MM)
    [IndicadorRepercussao] INTEGER NULL, -- indReperc
    [IndenizacaoSubstitutiva] CHAR(1) NULL, -- indenSD: S=Sim, N=Não
    [IndenizacaoAbono] CHAR(1) NULL, -- indenAbono: S=Sim, N=Não
    
    CONSTRAINT [PK_ptrab_PeriodoValores] PRIMARY KEY ([PeriodoValoresId]),
    CONSTRAINT [FK_ptrab_PeriodoValores_EstabelecimentoPagamento] 
        FOREIGN KEY ([EstabelecimentoPagamentoId]) REFERENCES [ptrab_EstabelecimentoPagamento] ([EstabelecimentoPagamentoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_PeriodoValores_CompetenciaInicio] CHECK ([CompetenciaInicio] LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'),
    CONSTRAINT [CK_ptrab_PeriodoValores_CompetenciaFim] CHECK ([CompetenciaFim] LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'),
    CONSTRAINT [CK_ptrab_PeriodoValores_IndenizacaoSubstitutiva] CHECK ([IndenizacaoSubstitutiva] IN ('S', 'N') OR [IndenizacaoSubstitutiva] IS NULL),
    CONSTRAINT [CK_ptrab_PeriodoValores_IndenizacaoAbono] CHECK ([IndenizacaoAbono] IN ('S', 'N') OR [IndenizacaoAbono] IS NULL)
);

CREATE INDEX [IDX_ptrab_PeriodoValores_EstabelecimentoPagamentoId] ON [ptrab_PeriodoValores] ([EstabelecimentoPagamentoId]);
CREATE INDEX [IDX_ptrab_PeriodoValores_Competencias] ON [ptrab_PeriodoValores] ([CompetenciaInicio], [CompetenciaFim]);

-- =============================================
-- ABONO SALARIAL (abono)
-- =============================================

CREATE TABLE [dbo].[ptrab_AbonoSalarial] (
    [AbonoSalarialId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoValoresId] INTEGER NOT NULL,
    [AnoBase] VARCHAR(4) NOT NULL, -- anoBase
    
    CONSTRAINT [PK_ptrab_AbonoSalarial] PRIMARY KEY ([AbonoSalarialId]),
    CONSTRAINT [FK_ptrab_AbonoSalarial_PeriodoValores] 
        FOREIGN KEY ([PeriodoValoresId]) REFERENCES [ptrab_PeriodoValores] ([PeriodoValoresId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_AbonoSalarial_AnoBase] CHECK ([AnoBase] LIKE '[0-9][0-9][0-9][0-9]')
);

CREATE INDEX [IDX_ptrab_AbonoSalarial_PeriodoValoresId] ON [ptrab_AbonoSalarial] ([PeriodoValoresId]);

-- =============================================
-- PERÍODOS DE APURAÇÃO (idePeriodo)
-- =============================================

CREATE TABLE [dbo].[ptrab_PeriodoApuracao] (
    [PeriodoApuracaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoValoresId] INTEGER NOT NULL,
    [PeriodoReferencia] VARCHAR(7) NOT NULL, -- perRef (YYYY-MM)
    
    CONSTRAINT [PK_ptrab_PeriodoApuracao] PRIMARY KEY ([PeriodoApuracaoId]),
    CONSTRAINT [FK_ptrab_PeriodoApuracao_PeriodoValores] 
        FOREIGN KEY ([PeriodoValoresId]) REFERENCES [ptrab_PeriodoValores] ([PeriodoValoresId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_PeriodoApuracao_PeriodoReferencia] CHECK ([PeriodoReferencia] LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'),
    CONSTRAINT [UQ_ptrab_PeriodoApuracao_Periodo_Valores] UNIQUE ([PeriodoValoresId], [PeriodoReferencia])
);

CREATE INDEX [IDX_ptrab_PeriodoApuracao_PeriodoValoresId] ON [ptrab_PeriodoApuracao] ([PeriodoValoresId]);
CREATE INDEX [IDX_ptrab_PeriodoApuracao_PeriodoReferencia] ON [ptrab_PeriodoApuracao] ([PeriodoReferencia]);

-- =============================================
-- BASES DE CÁLCULO PREVIDENCIÁRIAS (basesCp)
-- =============================================

CREATE TABLE [dbo].[ptrab_BaseCalculoPrevidencia] (
    [BaseCalculoPrevidenciaId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoApuracaoId] INTEGER NOT NULL,
    [ValorBaseMensal] MONEY NOT NULL DEFAULT 0, -- vrBcCpMensal
    [ValorBase13] MONEY NOT NULL DEFAULT 0, -- vrBcCp13
    
    CONSTRAINT [PK_ptrab_BaseCalculoPrevidencia] PRIMARY KEY ([BaseCalculoPrevidenciaId]),
    CONSTRAINT [FK_ptrab_BaseCalculoPrevidencia_PeriodoApuracao] 
        FOREIGN KEY ([PeriodoApuracaoId]) REFERENCES [ptrab_PeriodoApuracao] ([PeriodoApuracaoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_BaseCalculoPrevidencia_ValorBaseMensal] CHECK ([ValorBaseMensal] >= 0),
    CONSTRAINT [CK_ptrab_BaseCalculoPrevidencia_ValorBase13] CHECK ([ValorBase13] >= 0)
);

CREATE INDEX [IDX_ptrab_BaseCalculoPrevidencia_PeriodoApuracaoId] ON [ptrab_BaseCalculoPrevidencia] ([PeriodoApuracaoId]);

-- =============================================
-- Informações DE AGENTES NOCIVOS (infoAgNocivo)
-- =============================================

CREATE TABLE [dbo].[ptrab_AgenteNocivo] (
    [AgenteNocivoId] INTEGER IDENTITY(1,1) NOT NULL,
    [BaseCalculoPrevidenciaId] INTEGER NOT NULL,
    [GrauExposicao] VARCHAR(1) NOT NULL, -- grauExp: 1, 2, 3, 4
    
    CONSTRAINT [PK_ptrab_AgenteNocivo] PRIMARY KEY ([AgenteNocivoId]),
    CONSTRAINT [FK_ptrab_AgenteNocivo_BaseCalculoPrevidencia] 
        FOREIGN KEY ([BaseCalculoPrevidenciaId]) REFERENCES [ptrab_BaseCalculoPrevidencia] ([BaseCalculoPrevidenciaId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_AgenteNocivo_GrauExposicao] CHECK ([GrauExposicao] IN ('1', '2', '3', '4'))
);

CREATE INDEX [IDX_ptrab_AgenteNocivo_BaseCalculoPrevidenciaId] ON [ptrab_AgenteNocivo] ([BaseCalculoPrevidenciaId]);

-- =============================================
-- BASES DE CÁLCULO FGTS (infoFGTS)
-- =============================================

CREATE TABLE [dbo].[ptrab_BaseCalculoFGTS] (
    [BaseCalculoFGTSId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoApuracaoId] INTEGER NOT NULL,
    [ValorBaseCalculoFGTS] MONEY NOT NULL DEFAULT 0, -- vrBcFGTS
    [ValorBaseCalculoFGTSSefip] MONEY NULL, -- vrBcFgtsGuia
    [ValorBaseCalculoFGTSDecAnt] MONEY NULL, -- vrBcFGTSDecAnt
    
    CONSTRAINT [PK_ptrab_BaseCalculoFGTS] PRIMARY KEY ([BaseCalculoFGTSId]),
    CONSTRAINT [FK_ptrab_BaseCalculoFGTS_PeriodoApuracao] 
        FOREIGN KEY ([PeriodoApuracaoId]) REFERENCES [ptrab_PeriodoApuracao] ([PeriodoApuracaoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_BaseCalculoFGTS_ValorBaseCalculoFGTSDecAnt] CHECK ([ValorBaseCalculoFGTSDecAnt] IS NULL OR [ValorBaseCalculoFGTSDecAnt] >= 0)
);

CREATE INDEX [IDX_ptrab_BaseCalculoFGTS_PeriodoApuracaoId] ON [ptrab_BaseCalculoFGTS] ([PeriodoApuracaoId]);

-- =============================================
-- BASES DE CÁLCULO POR MUDANÇA DE CATEGORIA (basesRemun)
-- =============================================

CREATE TABLE [dbo].[ptrab_BaseCalculoMudancaCategoria] (
    [BaseCalculoMudancaCategoriaId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoApuracaoId] INTEGER NOT NULL,
    [CategoriaOriginal] VARCHAR(3) NOT NULL, -- indCateg
    [ValorBasePrevidenciario] MONEY NOT NULL DEFAULT 0, -- vrBcCpMensal
    
    CONSTRAINT [PK_ptrab_BaseCalculoMudancaCategoria] PRIMARY KEY ([BaseCalculoMudancaCategoriaId]),
    CONSTRAINT [FK_ptrab_BaseCalculoMudancaCategoria_PeriodoApuracao] 
        FOREIGN KEY ([PeriodoApuracaoId]) REFERENCES [ptrab_PeriodoApuracao] ([PeriodoApuracaoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_BaseCalculoMudancaCategoria_ValorBase] CHECK ([ValorBasePrevidenciario] >= 0)
);

CREATE INDEX [IDX_ptrab_BaseCalculoMudancaCategoria_PeriodoApuracaoId] ON [ptrab_BaseCalculoMudancaCategoria] ([PeriodoApuracaoId]);

-- =============================================
-- S-2501: HEADER DOS TRIBUTOS DECORRENTES
-- =============================================

CREATE TABLE [dbo].[ptrab_TributosProcessoHeader] (
    [TributosProcessoHeaderId] INTEGER IDENTITY(1,1) NOT NULL,
    [CadastroProcessoId] INTEGER NOT NULL,
    [CompetenciaPagamento] VARCHAR(7) NOT NULL, -- perApurPgto (YYYY-MM)
    [ObservacoesPagamento] VARCHAR(999) NULL, -- obs
    [StatusEnvio] INTEGER DEFAULT 1, -- 1=Pendente, 2=Enviado, 3=Processado, 4=Erro
    
    -- Auditoria
    [UsuarioInclusao] VARCHAR(200) NOT NULL,
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    [UsuarioEnvioTransmissao] VARCHAR(200) NULL,
    [DataEnvioTransmissao] DATETIME NULL,
    
    CONSTRAINT [PK_ptrab_TributosProcessoHeader] PRIMARY KEY ([TributosProcessoHeaderId]),
    CONSTRAINT [FK_ptrab_TributosProcessoHeader_CadastroProcesso] 
        FOREIGN KEY ([CadastroProcessoId]) REFERENCES [ptrab_CadastroProcesso] ([CadastroProcessoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_TributosProcessoHeader_Competencia] 
        CHECK ([CompetenciaPagamento] LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'),
    CONSTRAINT [UQ_ptrab_TributosProcessoHeader_Processo_Competencia] 
        UNIQUE ([CadastroProcessoId], [CompetenciaPagamento])
);

CREATE INDEX [IDX_ptrab_TributosProcessoHeader_CadastroProcessoId] ON [ptrab_TributosProcessoHeader] ([CadastroProcessoId]);
CREATE INDEX [IDX_ptrab_TributosProcessoHeader_Competencia] ON [ptrab_TributosProcessoHeader] ([CompetenciaPagamento]);
CREATE INDEX [IDX_ptrab_TributosProcessoHeader_StatusEnvio] ON [ptrab_TributosProcessoHeader] ([StatusEnvio]);

-- =============================================
-- S-2501: TRABALHADORES COM TRIBUTOS (ideTrab)
-- =============================================

CREATE TABLE [dbo].[ptrab_TributosTrabalhador] (
    [TributosTrabalhadorId] INTEGER IDENTITY(1,1) NOT NULL,
    [TributosProcessoHeaderId] INTEGER NOT NULL,
    [TrabalhadorProcessoId] INTEGER NOT NULL,
    
    CONSTRAINT [PK_ptrab_TributosTrabalhador] PRIMARY KEY ([TributosTrabalhadorId]),
    CONSTRAINT [FK_ptrab_TributosTrabalhador_Header] 
        FOREIGN KEY ([TributosProcessoHeaderId]) REFERENCES [ptrab_TributosProcessoHeader] ([TributosProcessoHeaderId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_TributosTrabalhador_Trabalhador] 
        FOREIGN KEY ([TrabalhadorProcessoId]) REFERENCES [ptrab_TrabalhadorProcesso] ([TrabalhadorProcessoId]),
    
    CONSTRAINT [UQ_ptrab_TributosTrabalhador_Header_Trabalhador] 
        UNIQUE ([TributosProcessoHeaderId], [TrabalhadorProcessoId])
);

CREATE INDEX [IDX_ptrab_TributosTrabalhador_HeaderId] ON [ptrab_TributosTrabalhador] ([TributosProcessoHeaderId]);
CREATE INDEX [IDX_ptrab_TributosTrabalhador_TrabalhadorId] ON [ptrab_TributosTrabalhador] ([TrabalhadorProcessoId]);

-- =============================================
-- S-2501: CÁLCULOS DE TRIBUTOS POR PERÍODO (calcTrib)
-- =============================================

CREATE TABLE [dbo].[ptrab_CalculoTributosPeriodo] (
    [CalculoTributosPeriodoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TributosTrabalhadorId] INTEGER NOT NULL,
    [PeriodoReferencia] VARCHAR(7) NOT NULL, -- perRef (YYYY-MM)
    [ValorBaseCalculoMensal] MONEY NOT NULL DEFAULT 0, -- vrBcCpMensal
    [ValorBaseCalculo13] MONEY NOT NULL DEFAULT 0, -- vrBcCp13
    
    CONSTRAINT [PK_ptrab_CalculoTributosPeriodo] PRIMARY KEY ([CalculoTributosPeriodoId]),
    CONSTRAINT [FK_ptrab_CalculoTributosPeriodo_TributosTrabalhador] 
        FOREIGN KEY ([TributosTrabalhadorId]) REFERENCES [ptrab_TributosTrabalhador] ([TributosTrabalhadorId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_CalculoTributosPeriodo_PeriodoReferencia] 
        CHECK ([PeriodoReferencia] LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'),
    CONSTRAINT [CK_ptrab_CalculoTributosPeriodo_ValorBaseCalculoMensal] CHECK ([ValorBaseCalculoMensal] >= 0),
    CONSTRAINT [CK_ptrab_CalculoTributosPeriodo_ValorBaseCalculo13] CHECK ([ValorBaseCalculo13] >= 0),
    CONSTRAINT [UQ_ptrab_CalculoTributosPeriodo_Trabalhador_Periodo] 
        UNIQUE ([TributosTrabalhadorId], [PeriodoReferencia])
);

CREATE INDEX [IDX_ptrab_CalculoTributosPeriodo_TributosTrabalhadorId] ON [ptrab_CalculoTributosPeriodo] ([TributosTrabalhadorId]);
CREATE INDEX [IDX_ptrab_CalculoTributosPeriodo_PeriodoReferencia] ON [ptrab_CalculoTributosPeriodo] ([PeriodoReferencia]);

-- =============================================
-- S-2501: CONTRIBUIÇÕES POR CÓDIGO DE RECEITA (infoCRContrib)
-- =============================================

CREATE TABLE [dbo].[ptrab_ContribuicaoCodigoReceita] (
    [ContribuicaoCodigoReceitaId] INTEGER IDENTITY(1,1) NOT NULL,
    [CalculoTributosPeriodoId] INTEGER NOT NULL,
    [CodigoReceita] VARCHAR(6) NOT NULL, -- tpCR
    [ValorContribuicaoMensal] MONEY NOT NULL DEFAULT 0, -- vrCr
    [ValorContribuicao13] MONEY NOT NULL DEFAULT 0, -- vrCr13
    [ValorTotal] AS ([ValorContribuicaoMensal] + [ValorContribuicao13]), -- Campo calculado
    
    CONSTRAINT [PK_ptrab_ContribuicaoCodigoReceita] PRIMARY KEY ([ContribuicaoCodigoReceitaId]),
    CONSTRAINT [FK_ptrab_ContribuicaoCodigoReceita_CalculoTributos] 
        FOREIGN KEY ([CalculoTributosPeriodoId]) REFERENCES [ptrab_CalculoTributosPeriodo] ([CalculoTributosPeriodoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_ContribuicaoCodigoReceita_ValorMensal] CHECK ([ValorContribuicaoMensal] >= 0),
    CONSTRAINT [CK_ptrab_ContribuicaoCodigoReceita_Valor13] CHECK ([ValorContribuicao13] >= 0),
    CONSTRAINT [UQ_ptrab_ContribuicaoCodigoReceita_Calculo_Codigo] 
        UNIQUE ([CalculoTributosPeriodoId], [CodigoReceita])
);

CREATE INDEX [IDX_ptrab_ContribuicaoCodigoReceita_CalculoId] ON [ptrab_ContribuicaoCodigoReceita] ([CalculoTributosPeriodoId]);
CREATE INDEX [IDX_ptrab_ContribuicaoCodigoReceita_CodigoReceita] ON [ptrab_ContribuicaoCodigoReceita] ([CodigoReceita]);

-- =============================================
-- S-2501: IRRF POR CÓDIGO DE RECEITA (infoCRIRRF)
-- =============================================

CREATE TABLE [dbo].[ptrab_IRRFCodigoReceita] (
    [IRRFCodigoReceitaId] INTEGER IDENTITY(1,1) NOT NULL,
    [TributosTrabalhadorId] INTEGER NOT NULL,
    [CodigoReceita] VARCHAR(6) NOT NULL, -- tpCR
    [ValorIRRF] MONEY NOT NULL DEFAULT 0, -- vrIrrf
    
    CONSTRAINT [PK_ptrab_IRRFCodigoReceita] PRIMARY KEY ([IRRFCodigoReceitaId]),
    CONSTRAINT [FK_ptrab_IRRFCodigoReceita_TributosTrabalhador] 
        FOREIGN KEY ([TributosTrabalhadorId]) REFERENCES [ptrab_TributosTrabalhador] ([TributosTrabalhadorId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_IRRFCodigoReceita_ValorIRRF] CHECK ([ValorIRRF] >= 0),
    CONSTRAINT [UQ_ptrab_IRRFCodigoReceita_Trabalhador_Codigo] 
        UNIQUE ([TributosTrabalhadorId], [CodigoReceita])
);

CREATE INDEX [IDX_ptrab_IRRFCodigoReceita_TributosTrabalhadorId] ON [ptrab_IRRFCodigoReceita] ([TributosTrabalhadorId]);
CREATE INDEX [IDX_ptrab_IRRFCodigoReceita_CodigoReceita] ON [ptrab_IRRFCodigoReceita] ([CodigoReceita]);

-- =============================================
-- S-2501: Informações COMPLEMENTARES IRRF (infoIR)
-- =============================================

CREATE TABLE [dbo].[ptrab_InformacaoIRRF] (
    [InformacaoIRRFId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFCodigoReceitaId] INTEGER NOT NULL,
    
    -- Rendimentos
    [ValorRendimentoTributavel] MONEY NULL, -- vrRendTrib
    [ValorRendimentoTributavel13] MONEY NULL, -- vrRendTrib13
    [ValorRendimentoMolestiGrave] MONEY NULL, -- vrRendMoleGrave
    [ValorRendimentoIsentos65] MONEY NULL, -- vrRendIsen65
    [ValorJurosMora] MONEY NULL, -- vrJurosMora
    [ValorRendimentoIsentoNaoTributavel] MONEY NULL, -- vrRendIsenNTrib
    [DescricaoIsentoNaoTributavel] VARCHAR(60) NULL, -- descIsenNTrib
    [ValorPrevidenciaOficial] MONEY NULL, -- vrPrevOficial
    
    CONSTRAINT [PK_ptrab_InformacaoIRRF] PRIMARY KEY ([InformacaoIRRFId]),
    CONSTRAINT [FK_ptrab_InformacaoIRRF_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    
    -- Constraints de valores Não negativos
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoTributavel] CHECK ([ValorRendimentoTributavel] IS NULL OR [ValorRendimentoTributavel] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoTributavel13] CHECK ([ValorRendimentoTributavel13] IS NULL OR [ValorRendimentoTributavel13] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoMolestiGrave] CHECK ([ValorRendimentoMolestiGrave] IS NULL OR [ValorRendimentoMolestiGrave] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoIsentos65] CHECK ([ValorRendimentoIsentos65] IS NULL OR [ValorRendimentoIsentos65] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorJurosMora] CHECK ([ValorJurosMora] IS NULL OR [ValorJurosMora] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoIsentoNaoTributavel] CHECK ([ValorRendimentoIsentoNaoTributavel] IS NULL OR [ValorRendimentoIsentoNaoTributavel] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorPrevidenciaOficial] CHECK ([ValorPrevidenciaOficial] IS NULL OR [ValorPrevidenciaOficial] >= 0)
);

CREATE INDEX [IDX_ptrab_InformacaoIRRF_IRRFCodigoReceitaId] ON [ptrab_InformacaoIRRF] ([IRRFCodigoReceitaId]);

-- =============================================
-- S-2501: RENDIMENTOS RECEBIDOS ACUMULADAMENTE (infoRRA)
-- =============================================

CREATE TABLE [dbo].[ptrab_RendimentosRRA] (
    [RendimentosRRAId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFCodigoReceitaId] INTEGER NOT NULL,
    [DescricaoRRA] VARCHAR(50) NOT NULL, -- descRRA
    [QuantidadeMesesRRA] INTEGER NOT NULL, -- qtdMesesRRA
    
    CONSTRAINT [PK_ptrab_RendimentosRRA] PRIMARY KEY ([RendimentosRRAId]),
    CONSTRAINT [FK_ptrab_RendimentosRRA_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_RendimentosRRA_QuantidadeMeses] CHECK ([QuantidadeMesesRRA] > 0)
);

CREATE INDEX [IDX_ptrab_RendimentosRRA_IRRFCodigoReceitaId] ON [ptrab_RendimentosRRA] ([IRRFCodigoReceitaId]);

-- =============================================
-- S-2501: DESPESAS DE PROCESSO JUDICIAL (despProcJud)
-- =============================================

CREATE TABLE [dbo].[ptrab_DespesasProcessoJudicial] (
    [DespesasProcessoJudicialId] INTEGER IDENTITY(1,1) NOT NULL,
    [RendimentosRRAId] INTEGER NOT NULL,
    [ValorDespesasCustas] MONEY NOT NULL DEFAULT 0, -- vlrDespCustas
    [ValorDespesasAdvogados] MONEY NOT NULL DEFAULT 0, -- vlrDespAdv
    
    CONSTRAINT [PK_ptrab_DespesasProcessoJudicial] PRIMARY KEY ([DespesasProcessoJudicialId]),
    CONSTRAINT [FK_ptrab_DespesasProcessoJudicial_RendimentosRRA] 
        FOREIGN KEY ([RendimentosRRAId]) REFERENCES [ptrab_RendimentosRRA] ([RendimentosRRAId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_DespesasProcessoJudicial_ValorDespesasCustas] CHECK ([ValorDespesasCustas] >= 0),
    CONSTRAINT [CK_ptrab_DespesasProcessoJudicial_ValorDespesasAdvogados] CHECK ([ValorDespesasAdvogados] >= 0)
);

CREATE INDEX [IDX_ptrab_DespesasProcessoJudicial_RendimentosRRAId] ON [ptrab_DespesasProcessoJudicial] ([RendimentosRRAId]);

-- =============================================
-- S-2501: IDENTIFICAÇÃO DOS ADVOGADOS (ideAdv)
-- =============================================

CREATE TABLE [dbo].[ptrab_AdvogadosRRA] (
    [AdvogadosRRAId] INTEGER IDENTITY(1,1) NOT NULL,
    [RendimentosRRAId] INTEGER NOT NULL,
    [TipoInscricaoId] INTEGER NOT NULL,
    [NumeroInscricao] VARCHAR(14) NOT NULL,
    [ValorDespesaAdvogado] MONEY NULL, -- vlrAdv
    
    CONSTRAINT [PK_ptrab_AdvogadosRRA] PRIMARY KEY ([AdvogadosRRAId]),
    CONSTRAINT [FK_ptrab_AdvogadosRRA_RendimentosRRA] 
        FOREIGN KEY ([RendimentosRRAId]) REFERENCES [ptrab_RendimentosRRA] ([RendimentosRRAId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_AdvogadosRRA_TipoInscricao] 
        FOREIGN KEY ([TipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    
    CONSTRAINT [CK_ptrab_AdvogadosRRA_NumeroInscricao] CHECK (LEN([NumeroInscricao]) BETWEEN 8 AND 14),
    CONSTRAINT [CK_ptrab_AdvogadosRRA_ValorDespesaAdvogado] CHECK ([ValorDespesaAdvogado] IS NULL OR [ValorDespesaAdvogado] >= 0)
);

CREATE INDEX [IDX_ptrab_AdvogadosRRA_RendimentosRRAId] ON [ptrab_AdvogadosRRA] ([RendimentosRRAId]);
CREATE INDEX [IDX_ptrab_AdvogadosRRA_NumeroInscricao] ON [ptrab_AdvogadosRRA] ([NumeroInscricao]);

-- =============================================
-- S-2501: DEDUÇÃO DE DEPENDENTES (dedDepen)
-- =============================================

CREATE TABLE [dbo].[ptrab_DeducaoDependentes] (
    [DeducaoDependentesId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFCodigoReceitaId] INTEGER NOT NULL,
    [TipoRendimento] INTEGER NOT NULL, -- tpRend: 11=Salário, 12=13ª salário, etc.
    [CPFDependente] VARCHAR(11) NOT NULL, -- cpfDep
    [ValorDeducao] MONEY NOT NULL DEFAULT 0, -- vlrDedDep
    
    CONSTRAINT [PK_ptrab_DeducaoDependentes] PRIMARY KEY ([DeducaoDependentesId]),
    CONSTRAINT [FK_ptrab_DeducaoDependentes_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_DeducaoDependentes_CPF] CHECK (LEN([CPFDependente]) = 11),
    CONSTRAINT [CK_ptrab_DeducaoDependentes_ValorDeducao] CHECK ([ValorDeducao] >= 0)
);

CREATE INDEX [IDX_ptrab_DeducaoDependentes_IRRFCodigoReceitaId] ON [ptrab_DeducaoDependentes] ([IRRFCodigoReceitaId]);
CREATE INDEX [IDX_ptrab_DeducaoDependentes_CPFDependente] ON [ptrab_DeducaoDependentes] ([CPFDependente]);

-- =============================================
-- S-2501: PENSÃO ALIMENTÍCIA (penAlim)
-- =============================================

CREATE TABLE [dbo].[ptrab_PensaoAlimenticia] (
    [PensaoAlimenticiaId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFCodigoReceitaId] INTEGER NOT NULL,
    [TipoRendimento] INTEGER NOT NULL, -- tpRend
    [CPFBeneficiario] VARCHAR(11) NOT NULL, -- cpfDep
    [ValorPensao] MONEY NOT NULL DEFAULT 0, -- vlrPensao
    
    CONSTRAINT [PK_ptrab_PensaoAlimenticia] PRIMARY KEY ([PensaoAlimenticiaId]),
    CONSTRAINT [FK_ptrab_PensaoAlimenticia_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_PensaoAlimenticia_CPF] CHECK (LEN([CPFBeneficiario]) = 11),
    CONSTRAINT [CK_ptrab_PensaoAlimenticia_ValorPensao] CHECK ([ValorPensao] >= 0)
);

CREATE INDEX [IDX_ptrab_PensaoAlimenticia_IRRFCodigoReceitaId] ON [ptrab_PensaoAlimenticia] ([IRRFCodigoReceitaId]);
CREATE INDEX [IDX_ptrab_PensaoAlimenticia_CPFBeneficiario] ON [ptrab_PensaoAlimenticia] ([CPFBeneficiario]);

-- =============================================
-- S-2501: PROCESSOS DE RETENÇÃO (infoProcRet)
-- =============================================

CREATE TABLE [dbo].[ptrab_ProcessoRetencao] (
    [ProcessoRetencaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFCodigoReceitaId] INTEGER NOT NULL,
    [TipoProcesso] INTEGER NOT NULL, -- tpProcRet: 1=Administrativo, 2=Judicial
    [NumeroProcesso] VARCHAR(21) NOT NULL, -- nrProcRet
    [CodigoSuspensao] VARCHAR(14) NULL, -- codSusp
    [IndicadorSuspensao] VARCHAR(2) NULL, -- indSusp
    
    CONSTRAINT [PK_ptrab_ProcessoRetencao] PRIMARY KEY ([ProcessoRetencaoId]),
    CONSTRAINT [FK_ptrab_ProcessoRetencao_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_ProcessoRetencao_TipoProcesso] CHECK ([TipoProcesso] IN (1, 2))
);

CREATE INDEX [IDX_ptrab_ProcessoRetencao_IRRFCodigoReceitaId] ON [ptrab_ProcessoRetencao] ([IRRFCodigoReceitaId]);
CREATE INDEX [IDX_ptrab_ProcessoRetencao_NumeroProcesso] ON [ptrab_ProcessoRetencao] ([NumeroProcesso]);

-- =============================================
-- S-2501: VALORES DE RETENÇÃO (infoValores)
-- =============================================

CREATE TABLE [dbo].[ptrab_ValoresRetencao] (
    [ValoresRetencaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoRetencaoId] INTEGER NOT NULL,
    [IndicadorApuracao] INTEGER NOT NULL, -- indApuracao: 1=Mensal, 2=Anual
    [ValorNaoRetido] MONEY NULL, -- vlrNRetido
    [ValorDepositoJudicial] MONEY NULL, -- vlrDepJud
    [ValorCompetenciaAnoCivil] MONEY NULL, -- vlrCmpAnoCivil
    [ValorCompetenciaAnoAnterior] MONEY NULL, -- vlrCmpAnoAnt
    [ValorRendimentoSuspenso] MONEY NULL, -- vlrRendSusp
    
    CONSTRAINT [PK_ptrab_ValoresRetencao] PRIMARY KEY ([ValoresRetencaoId]),
    CONSTRAINT [FK_ptrab_ValoresRetencao_ProcessoRetencao] 
        FOREIGN KEY ([ProcessoRetencaoId]) REFERENCES [ptrab_ProcessoRetencao] ([ProcessoRetencaoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_ValoresRetencao_IndicadorApuracao] CHECK ([IndicadorApuracao] IN (1, 2)),
    CONSTRAINT [CK_ptrab_ValoresRetencao_ValorNaoRetido] CHECK ([ValorNaoRetido] IS NULL OR [ValorNaoRetido] >= 0),
    CONSTRAINT [CK_ptrab_ValoresRetencao_ValorDepositoJudicial] CHECK ([ValorDepositoJudicial] IS NULL OR [ValorDepositoJudicial] >= 0),
    CONSTRAINT [CK_ptrab_ValoresRetencao_ValorCompetenciaAnoCivil] CHECK ([ValorCompetenciaAnoCivil] IS NULL OR [ValorCompetenciaAnoCivil] >= 0),
    CONSTRAINT [CK_ptrab_ValoresRetencao_ValorCompetenciaAnoAnterior] CHECK ([ValorCompetenciaAnoAnterior] IS NULL OR [ValorCompetenciaAnoAnterior] >= 0),
    CONSTRAINT [CK_ptrab_ValoresRetencao_ValorRendimentoSuspenso] CHECK ([ValorRendimentoSuspenso] IS NULL OR [ValorRendimentoSuspenso] >= 0)
);

CREATE INDEX [IDX_ptrab_ValoresRetencao_ProcessoRetencaoId] ON [ptrab_ValoresRetencao] ([ProcessoRetencaoId]);

-- =============================================
-- S-2501: DEDUÇÕES SUSPENSAS (dedSusp)
-- =============================================

CREATE TABLE [dbo].[ptrab_DeducoesSuspensas] (
    [DeducoesSuspensasId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoRetencaoId] INTEGER NOT NULL,
	[IndicadorTipoDeducao] INTEGER NOT NULL, -- indTpDeducao
    [ValorDeducaoSuspensa] MONEY NOT NULL DEFAULT 0, -- vlrDedSusp
    
    CONSTRAINT [PK_ptrab_DeducoesSuspensas] PRIMARY KEY ([DeducoesSuspensasId]),
    CONSTRAINT [FK_ptrab_DeducoesSuspensas_ProcessoRetencao] 
        FOREIGN KEY ([ProcessoRetencaoId]) REFERENCES [ptrab_ProcessoRetencao] ([ProcessoRetencaoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_DeducoesSuspensas_ValorDeducaoSuspensa] CHECK ([ValorDeducaoSuspensa] >= 0)
);

CREATE INDEX [IDX_ptrab_DeducoesSuspensas_ProcessoRetencaoId] ON [ptrab_DeducoesSuspensas] ([ProcessoRetencaoId]);

-- =============================================
-- S-2501: BENEFICIÁRIOS DE PENSÃO SUSPENSA (benefPen)
-- =============================================

CREATE TABLE [dbo].[ptrab_BeneficiariosPensaoSuspensa] (
    [BeneficiariosPensaoSuspensaId] INTEGER IDENTITY(1,1) NOT NULL,
    [DeducoesSuspensasId] INTEGER NOT NULL,
    [CPFBeneficiario] VARCHAR(11) NOT NULL, -- cpfDep
    [ValorDependenteSuspenso] MONEY NOT NULL DEFAULT 0, -- vlrDepenSusp
    
    CONSTRAINT [PK_ptrab_BeneficiariosPensaoSuspensa] PRIMARY KEY ([BeneficiariosPensaoSuspensaId]),
    CONSTRAINT [FK_ptrab_BeneficiariosPensaoSuspensa_DeducoesSuspensas] 
        FOREIGN KEY ([DeducoesSuspensasId]) REFERENCES [ptrab_DeducoesSuspensas] ([DeducoesSuspensasId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_BeneficiariosPensaoSuspensa_CPF] CHECK (LEN([CPFBeneficiario]) = 11),
    CONSTRAINT [CK_ptrab_BeneficiariosPensaoSuspensa_ValorDependenteSuspenso] CHECK ([ValorDependenteSuspenso] >= 0)
);

CREATE INDEX [IDX_ptrab_BeneficiariosPensaoSuspensa_DeducoesSuspensasId] ON [ptrab_BeneficiariosPensaoSuspensa] ([DeducoesSuspensasId]);
CREATE INDEX [IDX_ptrab_BeneficiariosPensaoSuspensa_CPFBeneficiario] ON [ptrab_BeneficiariosPensaoSuspensa] ([CPFBeneficiario]);

-- =============================================
-- S-2501: INFORMAÇÕES COMPLEMENTARES IRRF (infoIRComplem)
-- =============================================

CREATE TABLE [dbo].[ptrab_IRRFComplementar] (
    [IRRFComplementarId] INTEGER IDENTITY(1,1) NOT NULL,
    [TributosTrabalhadorId] INTEGER NOT NULL,
    
    -- Campos principais do infoIRComplem
    [DataLaudo] DATETIME NULL, -- dtLaudo
    
    CONSTRAINT [PK_ptrab_IRRFComplementar] PRIMARY KEY ([IRRFComplementarId]),
    CONSTRAINT [FK_ptrab_IRRFComplementar_TributosTrabalhador] 
        FOREIGN KEY ([TributosTrabalhadorId]) REFERENCES [ptrab_TributosTrabalhador] ([TributosTrabalhadorId]) ON DELETE CASCADE
);

CREATE INDEX [IDX_ptrab_IRRFComplementar_TributosTrabalhadorId] ON [ptrab_IRRFComplementar] ([TributosTrabalhadorId]);

-- =============================================
-- S-2501: INFORMAÇÕES DE DEPENDENTES NÃO CADASTRADOS (infoDep)
-- =============================================


CREATE TABLE [dbo].[ptrab_InfoDepNaoCadastrado] (
    [InfoDepNaoCadastradoId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFComplementarId] INTEGER NOT NULL,
    
    [CPFDependente] VARCHAR(11) NOT NULL, -- cpfDep
    [DataNascimento] DATETIME NOT NULL, -- dtNascto
	[NomeDependente] VARCHAR(70) NOT NULL, -- nome
	[DependenteIRRF] VARCHAR(1) NOT NULL, -- depIRRF
	[TipoDependente] VARCHAR(2) NOT NULL, -- tpDep
    [DescricaoDependente] VARCHAR(60) NULL, -- descrDep
    
    CONSTRAINT [PK_ptrab_InformacaoDependente] PRIMARY KEY ([InfoDepNaoCadastradoId]),
    CONSTRAINT [FK_ptrab_InformacaoDependente_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_InformacaoDependente_CPF] CHECK (LEN([CPFDependente]) = 11),
  
  
);

CREATE INDEX [IDX_ptrab_InformacaoDependente_IRRFComplementarId] ON [ptrab_InfoDepNaoCadastrado] ([IRRFComplementarId]);
CREATE INDEX [IDX_ptrab_InformacaoDependente_CPFDependente] ON [ptrab_InfoDepNaoCadastrado] ([CPFDependente]);


    

/*

Esses grupos não existem no S2501
-- =============================================
-- S-2501: INFORMAÇÕES DE PLANOS DE SAÚDE (planSaude)
-- =============================================

CREATE TABLE [dbo].[ptrab_PlanoSaude] (
    [PlanoSaudeId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFComplementarId] INTEGER NOT NULL,
    [CNPJOperadora] VARCHAR(14) NOT NULL, -- cnpjOper
    [RegistroANS] VARCHAR(6) NULL, -- regANS
    [ValorSalarioFamilia] MONEY NULL, -- vlrSalFam
    [ValorSalarioMaternidade] MONEY NULL, -- vlrSalMat
    
    CONSTRAINT [PK_ptrab_PlanoSaude] PRIMARY KEY ([PlanoSaudeId]),
    CONSTRAINT [FK_ptrab_PlanoSaude_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_PlanoSaude_CNPJOperadora] CHECK (LEN([CNPJOperadora]) = 14),
    CONSTRAINT [CK_ptrab_PlanoSaude_ValorSalarioFamilia] CHECK ([ValorSalarioFamilia] IS NULL OR [ValorSalarioFamilia] >= 0),
    CONSTRAINT [CK_ptrab_PlanoSaude_ValorSalarioMaternidade] CHECK ([ValorSalarioMaternidade] IS NULL OR [ValorSalarioMaternidade] >= 0)
);

CREATE INDEX [IDX_ptrab_PlanoSaude_IRRFComplementarId] ON [ptrab_PlanoSaude] ([IRRFComplementarId]);
CREATE INDEX [IDX_ptrab_PlanoSaude_CNPJOperadora] ON [ptrab_PlanoSaude] ([CNPJOperadora]);

-- =============================================
-- S-2501: INFORMAÇÕES DE DEPENDENTES NÃO CADASTRADOS (infoDepNaoCad)
-- =============================================

CREATE TABLE [dbo].[ptrab_DependenteNaoCadastrado] (
    [DependenteNaoCadastradoId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFComplementarId] INTEGER NOT NULL,
    [TipoRendimento] INTEGER NOT NULL, -- tpRend (11=Salário mensal, 12=13º salário, etc.)
    [CPFDependente] VARCHAR(11) NOT NULL, -- cpfDep
    [RelacaoParentesco] VARCHAR(2) NOT NULL, -- tpDep
    [DescricaoRelacao] VARCHAR(60) NULL, -- descDep
    [DataNascimento] DATETIME NOT NULL, -- dtNascto
    
    CONSTRAINT [PK_ptrab_DependenteNaoCadastrado] PRIMARY KEY ([DependenteNaoCadastradoId]),
    CONSTRAINT [FK_ptrab_DependenteNaoCadastrado_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_DependenteNaoCadastrado_CPF] CHECK (LEN([CPFDependente]) = 11),
    CONSTRAINT [CK_ptrab_DependenteNaoCadastrado_TipoRendimento] CHECK ([TipoRendimento] IN (11, 12, 13, 14, 16, 18, 19, 31, 32, 33, 34, 35, 41, 42, 43, 81, 82, 83))
);

CREATE INDEX [IDX_ptrab_DependenteNaoCadastrado_IRRFComplementarId] ON [ptrab_DependenteNaoCadastrado] ([IRRFComplementarId]);
CREATE INDEX [IDX_ptrab_DependenteNaoCadastrado_CPFDependente] ON [ptrab_DependenteNaoCadastrado] ([CPFDependente]);

-- =============================================
-- S-2501: REEMBOLSOS MÉDICOS (infoReembMed)
-- =============================================

CREATE TABLE [dbo].[ptrab_ReembolsoMedico] (
    [ReembolsoMedicoId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFComplementarId] INTEGER NOT NULL,
    [TipoRendimento] INTEGER NOT NULL, -- tpRend
    [IndicadorReembolso] INTEGER NOT NULL, -- indOrgReemb (1=Própria empresa, 2=Pessoa jurídica do grupo econômico)
    [CNPJOperadora] VARCHAR(14) NULL, -- cnpjOper
    [RegistroANS] VARCHAR(6) NULL, -- regANS
    
    CONSTRAINT [PK_ptrab_ReembolsoMedico] PRIMARY KEY ([ReembolsoMedicoId]),
    CONSTRAINT [FK_ptrab_ReembolsoMedico_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_ReembolsoMedico_TipoRendimento] CHECK ([TipoRendimento] IN (11, 12, 13, 14, 16, 18, 19, 31, 32, 33, 34, 35, 41, 42, 43, 81, 82, 83)),
    CONSTRAINT [CK_ptrab_ReembolsoMedico_IndicadorReembolso] CHECK ([IndicadorReembolso] IN (1, 2)),
    CONSTRAINT [CK_ptrab_ReembolsoMedico_CNPJOperadora] CHECK ([CNPJOperadora] IS NULL OR LEN([CNPJOperadora]) = 14)
);

CREATE INDEX [IDX_ptrab_ReembolsoMedico_IRRFComplementarId] ON [ptrab_ReembolsoMedico] ([IRRFComplementarId]);

-- =============================================
-- S-2501: DETALHES DOS REEMBOLSOS (detReembMed)
-- =============================================

CREATE TABLE [dbo].[ptrab_DetalheReembolsoMedico] (
    [DetalheReembolsoMedicoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ReembolsoMedicoId] INTEGER NOT NULL,
    [TipoBeneficiario] INTEGER NOT NULL, -- tpBenef (1=Titular, 2=Dependente)
    [CPFBeneficiario] VARCHAR(11) NULL, -- cpfBenef (obrigatório se tpBenef=2)
    [ValorReembolso] MONEY NOT NULL DEFAULT 0, -- vlrReemb
    
    CONSTRAINT [PK_ptrab_DetalheReembolsoMedico] PRIMARY KEY ([DetalheReembolsoMedicoId]),
    CONSTRAINT [FK_ptrab_DetalheReembolsoMedico_ReembolsoMedico] 
        FOREIGN KEY ([ReembolsoMedicoId]) REFERENCES [ptrab_ReembolsoMedico] ([ReembolsoMedicoId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_DetalheReembolsoMedico_TipoBeneficiario] CHECK ([TipoBeneficiario] IN (1, 2)),
    CONSTRAINT [CK_ptrab_DetalheReembolsoMedico_CPFBeneficiario] CHECK ([CPFBeneficiario] IS NULL OR LEN([CPFBeneficiario]) = 11),
    CONSTRAINT [CK_ptrab_DetalheReembolsoMedico_ValorReembolso] CHECK ([ValorReembolso] >= 0),
    
    -- Constraint para garantir CPF quando dependente
    CONSTRAINT [CK_ptrab_DetalheReembolsoMedico_CPFObrigatorio] CHECK (
        ([TipoBeneficiario] = 1) OR 
        ([TipoBeneficiario] = 2 AND [CPFBeneficiario] IS NOT NULL)
    )
);

CREATE INDEX [IDX_ptrab_DetalheReembolsoMedico_ReembolsoMedicoId] ON [ptrab_DetalheReembolsoMedico] ([ReembolsoMedicoId]);
CREATE INDEX [IDX_ptrab_DetalheReembolsoMedico_CPFBeneficiario] ON [ptrab_DetalheReembolsoMedico] ([CPFBeneficiario]);

-- =============================================
-- S-2501: INFORMAÇÕES MÉDICAS POR DEPENDENTE (infoDep)
-- =============================================

CREATE TABLE [dbo].[ptrab_InformacaoMedicaDependente] (
    [InformacaoMedicaDependenteId] INTEGER IDENTITY(1,1) NOT NULL,
    [PlanoSaudeId] INTEGER NOT NULL,
    [CPFDependente] VARCHAR(11) NOT NULL, -- cpfDep
    [RelacaoParentesco] VARCHAR(2) NOT NULL, -- tpDep
    [DescricaoRelacao] VARCHAR(60) NULL, -- descDep
    [DataNascimento] DATETIME NOT NULL, -- dtNascto
    
    CONSTRAINT [PK_ptrab_InformacaoMedicaDependente] PRIMARY KEY ([InformacaoMedicaDependenteId]),
    CONSTRAINT [FK_ptrab_InformacaoMedicaDependente_PlanoSaude] 
        FOREIGN KEY ([PlanoSaudeId]) REFERENCES [ptrab_PlanoSaude] ([PlanoSaudeId]) ON DELETE CASCADE,
    
    CONSTRAINT [CK_ptrab_InformacaoMedicaDependente_CPF] CHECK (LEN([CPFDependente]) = 11)
);

CREATE INDEX [IDX_ptrab_InformacaoMedicaDependente_PlanoSaudeId] ON [ptrab_InformacaoMedicaDependente] ([PlanoSaudeId]);
CREATE INDEX [IDX_ptrab_InformacaoMedicaDependente_CPFDependente] ON [ptrab_InformacaoMedicaDependente] ([CPFDependente]);

-- =============================================
-- S-2501: INFORMAÇÕES DE INCAPACIDADE (infoInc)
-- =============================================

CREATE TABLE [dbo].[ptrab_InformacaoIncapacidade] (
    [InformacaoIncapacidadeId] INTEGER IDENTITY(1,1) NOT NULL,
    [IRRFComplementarId] INTEGER NOT NULL,
    [DataNascimento] DATETIME NOT NULL, -- dtNascto
    [DataIncapacidade] DATETIME NOT NULL, -- dtIncap
    [InfoDeficiencia] VARCHAR(100) NULL, -- infoDef
    
    CONSTRAINT [PK_ptrab_InformacaoIncapacidade] PRIMARY KEY ([InformacaoIncapacidadeId]),
    CONSTRAINT [FK_ptrab_InformacaoIncapacidade_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE
);

CREATE INDEX [IDX_ptrab_InformacaoIncapacidade_IRRFComplementarId] ON [ptrab_InformacaoIncapacidade] ([IRRFComplementarId]);

-- =============================================
-- ATUALIZAÇÃO DA TABELA ptrab_InformacaoIRRF (COMPLETAR)
-- =============================================

-- Adicionar campos que estavam faltando na ptrab_InformacaoIRRF
ALTER TABLE [dbo].[ptrab_InformacaoIRRF] ADD
    [ValorRendimentoPensaoAlim] MONEY NULL, -- vrRendPensAlim
    [ValorRendimentoAposentadoria] MONEY NULL, -- vrRendAposentadoria
    [ValorRendimentoBolsaEstudo] MONEY NULL, -- vrRendBolsaEst
    [ValorRendimentoAuxilio] MONEY NULL, -- vrRendAuxilio
    [ValorRendimentoOutros] MONEY NULL, -- vrRendOutros
    [DescricaoRendimentoOutros] VARCHAR(60) NULL, -- descRendOutros
    [ValorDeducaoPrevidenciaria] MONEY NULL, -- vrDedutPrevidOfic
    [ValorDeducaoFAPI] MONEY NULL, -- vrDedutFAPI
    [ValorRendimentoPensaoTitular] MONEY NULL, -- vrRendPensTit;

-- Adicionar constraints para os novos campos
ALTER TABLE [dbo].[ptrab_InformacaoIRRF] ADD 
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoPensaoAlim] CHECK ([ValorRendimentoPensaoAlim] IS NULL OR [ValorRendimentoPensaoAlim] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoAposentadoria] CHECK ([ValorRendimentoAposentadoria] IS NULL OR [ValorRendimentoAposentadoria] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoBolsaEstudo] CHECK ([ValorRendimentoBolsaEstudo] IS NULL OR [ValorRendimentoBolsaEstudo] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoAuxilio] CHECK ([ValorRendimentoAuxilio] IS NULL OR [ValorRendimentoAuxilio] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoOutros] CHECK ([ValorRendimentoOutros] IS NULL OR [ValorRendimentoOutros] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorDeducaoPrevidenciaria] CHECK ([ValorDeducaoPrevidenciaria] IS NULL OR [ValorDeducaoPrevidenciaria] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorDeducaoFAPI] CHECK ([ValorDeducaoFAPI] IS NULL OR [ValorDeducaoFAPI] >= 0),
    CONSTRAINT [CK_ptrab_InformacaoIRRF_ValorRendimentoPensaoTitular] CHECK ([ValorRendimentoPensaoTitular] IS NULL OR [ValorRendimentoPensaoTitular] >= 0);
*/

-- =============================================
-- INSERIR DADOS PADRÃO PARA NOVOS TIPOS
-- =============================================

-- Inserir novos códigos de receita específicos para S-2501
INSERT INTO [ptrab_Status] ([Codigo], [Descricao]) VALUES
('IRRF_CALCULADO', 'IRRF Calculado'),
('IRRF_PENDENTE', 'IRRF Pendente de Cálculo'),
('IRRF_PROCESSADO', 'IRRF Processado'),
('IRRF_ERRO', 'Erro no Cálculo IRRF');
