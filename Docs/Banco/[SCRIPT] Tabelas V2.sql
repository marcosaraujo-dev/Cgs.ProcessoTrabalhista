-- =============================================
-- SCRIPT COMPLETO - BASE DE DADOS esocial
-- Eventos S-2500 e S-2501 - Processos Trabalhistas
-- Autor: Sistema esocial
-- Data: 2025-01-15
-- =============================================

-- Criação do banco de dados
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'esocial')
BEGIN
    CREATE DATABASE esocial;
END
GO

USE esocial;
GO

-- =============================================
-- TABELAS DE DOMÍNIO/LOOKUP
-- =============================================

-- Status geral do sistema



CREATE TABLE [ptrab_status] (
    [StatusId]  INTEGER NOT NULL,
    [Codigo] VARCHAR(50) NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    [Tipo] VARCHAR(40) NOT NULL,
    CONSTRAINT [PK_ptrab_status] PRIMARY KEY ([StatusId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários dos status do registro de processo trabalhista', N'user', N'dbo',N'table', N'ptrab_status', NULL, NULL
GO


-- Inserir dados consolidados de status
INSERT INTO [ptrab_Status] ([StatusId] , [Codigo], [Descricao], [Tipo]) VALUES


(10, 'EM_PREENCHIMENTO', 'Em Preenchimento', 'GERAL'),

(110, 'ATIVO', 'Registro Ativo para uso', 'PROCESSO'),
(120, 'INATIVO', 'Registro Inativo para uso', 'PROCESSO'),

(210, 'COM_PENDENCIAS', 'Com Pendências de Cadastro', 'Trabalhador'),
(220, 'AGUARDANDO_TRANSMISSAO', 'Aguardando Transmissão', 'Trabalhador'),
(230, 'ENVIADO_TRANSMISSAO', 'Enviado para Transmissão', 'Trabalhador'),

(310, 'IRRF_CALCULADO', 'IRRF Calculado', 'IRRF'),
(320, 'IRRF_PENDENTE', 'IRRF Pendente de Cálculo', 'IRRF'),
(330, 'IRRF_PROCESSADO', 'IRRF Processado', 'IRRF'),
(340, 'IRRF_ERRO', 'Erro no Cálculo IRRF', 'IRRF');

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoInscricao"                                        */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoInscricao] (
    [TipoInscricaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoInscricaoCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoInscricao] PRIMARY KEY ([TipoInscricaoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela de dados primarios com o tipo de inscrição', N'user', N'dbo',N'table', N'ptrab_TipoInscricao', NULL, NULL
GO

insert into ptrab_TipoInscricao Values(1,'CNPJ')
insert into ptrab_TipoInscricao Values(2,'CPF')
insert into ptrab_TipoInscricao Values(3,'CAEPF')
insert into ptrab_TipoInscricao Values(4,'CNO')
insert into ptrab_TipoInscricao Values(5,'CGC')
insert into ptrab_TipoInscricao Values(6,'CEI')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoOrigem"                                           */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoOrigem] (
    [TipoOrigemId] INTEGER IDENTITY(1,1) NOT NULL,
    [OrigemCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoOrigem] PRIMARY KEY ([TipoOrigemId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários de origem do processo/demanda.', N'user', N'dbo',N'table', N'ptrab_TipoOrigem', NULL, NULL
GO

insert into ptrab_TipoOrigem Values( 1, 'Processo judicial')
insert into ptrab_TipoOrigem Values( 2, 'Demanda submetida à CCP ou ao NINTER')

GO
/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoCCP"                                              */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoCCP] (
    [TipoCCPId] INTEGER IDENTITY(1,1) NOT NULL,
    [CCPCodigo] INTEGER NOT NULL, -- tpCCP
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoCCP] PRIMARY KEY ([TipoCCPId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários para Indicar o âmbito de celebração do acordo', N'user', N'dbo',N'table', N'ptrab_TipoCCP', NULL, NULL
GO

Insert into ptrab_TipoCCP VALUES(1, 'CCP no âmbito de empresa')
Insert into ptrab_TipoCCP VALUES(2, 'CCP no âmbito do Sindicato')
Insert into ptrab_TipoCCP VALUES(3, 'NINTER')

GO

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoContrato"                                         */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoContrato] (
    [TipoContratoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ContratoCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(300) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoContrato] PRIMARY KEY ([TipoContratoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários com os tipos de contrato', N'user', N'dbo',N'table', N'ptrab_TipoContrato', NULL, NULL
GO

Insert into ptrab_TipoContrato VALUES( 1,'Trabalhador com vínculo formalizado, sem alteração nas datas de admissão e de desligamento')
Insert into ptrab_TipoContrato VALUES( 2, 'Trabalhador com vínculo formalizado, com alteração na data de admissão')
Insert into ptrab_TipoContrato VALUES( 3, 'Trabalhador com vínculo formalizado, com inclusão ou alteração de data de desligamento')
Insert into ptrab_TipoContrato VALUES( 4, 'Trabalhador com vínculo formalizado, com alteração na data de admissão e inclusão ou alteração de data de desligamento')
Insert into ptrab_TipoContrato VALUES( 5, 'Empregado com reconhecimento de vínculo')
Insert into ptrab_TipoContrato VALUES( 6, 'Trabalhador sem vínculo de emprego/estatutário (TSVE), sem reconhecimento de vínculo empregatício')
Insert into ptrab_TipoContrato VALUES( 7, 'Trabalhador com vínculo de emprego formalizado em período anterior ao esocial')
Insert into ptrab_TipoContrato VALUES( 8, 'Responsabilidade indireta')
Insert into ptrab_TipoContrato VALUES( 9, 'Trabalhador cujos contratos foram unificados (unicidade contratual)')

GO

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoNaturezaAtividade"                                */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoNaturezaAtividade] (
    [TipoNaturezaAtividadeId] INTEGER IDENTITY(1,1) NOT NULL,
    [NaturezaAtividadeCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoNaturezaAtividade] PRIMARY KEY ([TipoNaturezaAtividadeId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários de Natureza atividade', N'user', N'dbo',N'table', N'ptrab_TipoNaturezaAtividade', NULL, NULL
GO

Insert into ptrab_TipoNaturezaAtividade Values( 1, 'Trabalho Urbano')
Insert into ptrab_TipoNaturezaAtividade Values( 2, 'Trabalho Rural')

GO

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoUnidadePagamento"                                 */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoUnidadePagamento] (
    [TipoUnidadePagamentoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoUnidadePagamentoCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoUnidadePagamento] PRIMARY KEY ([TipoUnidadePagamentoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários de unidade de Pagamentos', N'user', N'dbo',N'table', N'ptrab_TipoUnidadePagamento', NULL, NULL
GO

insert into ptrab_TipoUnidadePagamento Values(1, 'Por Hora')
insert into ptrab_TipoUnidadePagamento Values(2, 'Por Dia')
insert into ptrab_TipoUnidadePagamento Values(3, 'Por Semana')
insert into ptrab_TipoUnidadePagamento Values(4, 'Por Quinzena')
insert into ptrab_TipoUnidadePagamento Values(5, 'Por Mês')
insert into ptrab_TipoUnidadePagamento Values(6, 'Por Tarefa')
insert into ptrab_TipoUnidadePagamento Values(7, 'Não Aplicável - Salário exclusivamente variável')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoRegimeTrabalhista"                                */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ptrab_TipoRegimeTrabalhista] (
    [TipoRegimeTrabalhistaId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoRegimeTrabalhistaCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(250) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoRegimeTrabalhista] PRIMARY KEY ([TipoRegimeTrabalhistaId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários de Regime Trabalhista', N'user', N'dbo',N'table', N'ptrab_TipoRegimeTrabalhista', NULL, NULL
GO


insert into ptrab_TipoRegimeTrabalhista Values(1,'CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas')
insert into ptrab_TipoRegimeTrabalhista Values(2,'Estatutário/legislações especificas (servidor emporario, militar, agente político, etc..')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoRegimePrevidenciario"                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ptrab_TipoRegimePrevidenciario] (
    [TipoRegimePrevidenciarioId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoRegimePrevidenciarioCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(250) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoRegimePrevidenciario] PRIMARY KEY ([TipoRegimePrevidenciarioId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários de Regime Previdenciario', N'user', N'dbo',N'table', N'ptrab_TipoRegimePrevidenciario', NULL, NULL
GO

insert into ptrab_TipoRegimePrevidenciario Values(1,'Regime Geral de Previdência Social - RGPS')
insert into ptrab_TipoRegimePrevidenciario Values(2,'Regime Próprio de Previdência Social - RPPS, Regime dos Parlamentares e Sistema de Proteção dos Militares dos Estados/DF')
insert into ptrab_TipoRegimePrevidenciario Values(3,'Regime de Previdência Social no exterior')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoContratoTempoParcial"                             */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoContratoTempoParcial] (
    [TipoContratoTempoParcialId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoContratoTempoParcialCodigo] INTEGER NOT NULL, -- tmpParc
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoContratoTempoParcial] PRIMARY KEY ([TipoContratoTempoParcialId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com dados primários com os códigos relativo ao tipo de contrato em tempo parcial.', N'user', N'dbo',N'table', N'ptrab_TipoContratoTempoParcial', NULL, NULL
GO

insert into ptrab_TipoContratoTempoParcial Values(0,'Não é contrato em tempo parcial')
insert into ptrab_TipoContratoTempoParcial Values(1,'Limitado a 25 horas semanais')
insert into ptrab_TipoContratoTempoParcial Values(2,'Limitado a 30 horas semanais')
insert into ptrab_TipoContratoTempoParcial Values(3,'Limitado a 36 horas semanais')

GO

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoDuracaoContrato"                                  */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoDuracaoContrato] (
    [TipoDuracaoContratoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoDuracaoContratoCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoDuracaoContrato] PRIMARY KEY ([TipoDuracaoContratoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários contendo os tipos de duração do contrato de trabalho', N'user', N'dbo',N'table', N'ptrab_TipoDuracaoContrato', NULL, NULL
GO

insert into ptrab_TipoDuracaoContrato Values(1,'Prazo indeterminado')
insert into ptrab_TipoDuracaoContrato Values(2,'Prazo determinado, definido em dias')
insert into ptrab_TipoDuracaoContrato Values(3,'Prazo determinado, vinculado à ocorrência de um fato')

GO
/* ---------------------------------------------------------------------- */
/* Add table "esoc_MotivoDesligamento"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [esoc_MotivoDesligamento] (
    [MotivoDesligamentoId] INTEGER IDENTITY(1,1) NOT NULL,
    [MotivoDesligamentoCodigo] VARCHAR(3),  -- mtvDeslig
    [Descricao] VARCHAR(400) NOT NULL,
    [DataInicio] DATE NOT NULL,
    [DataTermino] DATE,
    CONSTRAINT [PK_MotivoDesligamento] PRIMARY KEY ([MotivoDesligamentoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários contendo o Código de motivo do desligamento válido e existente na Tabela 19.', N'user', N'dbo',N'table', N'esoc_MotivoDesligamento', NULL, NULL
GO


SET DATEFORMAT DMY
Insert Into esoc_MotivoDesligamento Values(	1	, 'Rescisão com justa causa, por iniciativa do empregador',	'01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	2	, 'Rescisão sem justa causa, por iniciativa do empregador', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	3	, 'Rescisão antecipada do contrato a termo por iniciativa do empregador', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	4	, 'Rescisão antecipada do contrato a termo por iniciativa do empregado', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	5	, 'Rescisão por culpa recíproca', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	6	, 'Rescisão por término do contrato a termo', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	7	, 'Rescisão do contrato de trabalho por iniciativa do empregado', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	8	, 'Rescisão do contrato de trabalho por interesse do(a) empregado(a), nas hipóteses previstas nos arts. 394 e 483, § 1º, da CLT','01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	9	, 'Rescisão por opção do empregado em virtude de falecimento do empregador individual ou empregador doméstico', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	10	, 'Rescisão por falecimento do empregado', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	11	, 'Transferência de empregado para empresa do mesmo grupo empresarial que tenha assumido os encargos trabalhistas, sem que tenha havido rescisão do contrato de trabalho', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	12	, 'Transferência de empregado da empresa consorciada para o consórcio que tenha assumido os encargos trabalhistas, e vice-versa, sem que tenha havido rescisão do contrato de trabalho', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	13	, 'Transferência de empregado de empresa ou consórcio, para outra empresa ou consórcio que tenha assumido os encargos trabalhistas por motivo de sucessão (fusão, cisão ou incorporação), sem que tenha havido rescisão do contrato de trabalho', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	14	, 'Rescisão do contrato de trabalho por encerramento da empresa, de seus estabelecimentos ou supressão de parte de suas atividades ou falecimento do empregador individual ou empregador doméstico sem continuação da atividade', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	15	, 'Rescisão do contrato de aprendizagem por desempenho insuficiente, inadaptação ou ausência injustificada do aprendiz à escola que implique perda do ano letivo', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	16	, 'Declaração de nulidade do contrato de trabalho por infringência ao inciso II do art. 37 da Constituição Federal, quando mantido o direito ao salário', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	17	, 'Rescisão indireta do contrato de trabalho', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	18	, 'Aposentadoria compulsória', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	19	, 'Aposentadoria por idade', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	20	, 'Aposentadoria por idade e tempo de contribuição', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	21	, 'Reforma militar', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	21	, 'Reforma militar', '19/07/2021', null)	
Insert Into esoc_MotivoDesligamento Values(	22	, 'Reserva militar', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	22	, 'Reserva militar', '19/07/2021', null)
Insert Into esoc_MotivoDesligamento Values(	23	, 'Exoneração', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	23	, 'Exoneração', '19/07/2021', null)	
Insert Into esoc_MotivoDesligamento Values(	24	, 'Demissão', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	24	, 'Demissão', '19/07/2021', null)	
Insert Into esoc_MotivoDesligamento Values(	25	, 'Vacância de cargo efetivo', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	25	, 'Vacância de cargo efetivo', '19/07/2021', null)	
Insert Into esoc_MotivoDesligamento Values(	26	, 'Rescisão do contrato de trabalho por paralisação temporária ou definitiva da empresa, estabelecimento ou parte das atividades motivada por atos de autoridade municipal, estadual ou federal', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	27	, 'Rescisão por motivo de força maior', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	28	, 'Término da cessão/requisição', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	29	, 'Redistribuição', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	29	, 'Redistribuição ou Reforma Administrativa', '19/07/2021', null)
Insert Into esoc_MotivoDesligamento Values(	30	, 'Mudança de regime trabalhista', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	31	, 'Reversão de reintegração', '01/01/2014', null)	
Insert Into esoc_MotivoDesligamento Values(	32	, 'Extravio de militar', '01/01/2014', '18/07/2021')
Insert Into esoc_MotivoDesligamento Values(	32	, 'Extravio de militar', '19/07/2021', null)	
Insert Into esoc_MotivoDesligamento Values(	33	, 'Rescisão por acordo entre as partes (art. 484-A da CLT)', '11/11/2017', null)
Insert Into esoc_MotivoDesligamento Values(	34	, 'Transferência de titularidade do empregado doméstico para outro representante da mesma unidade familiar', '01/10/2015', null)
Insert Into esoc_MotivoDesligamento Values(	35	, 'Extinção do contrato de trabalho intermitente', '08/01/2018', '30/06/2018')
Insert Into esoc_MotivoDesligamento Values(	36	, 'Mudança de CPF', '21/01/2019', null)
Insert Into esoc_MotivoDesligamento Values(	37	, 'Remoção, em caso de alteração do órgão declarante', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	38	, 'Aposentadoria, exceto por invalidez', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	39	, 'Aposentadoria de servidor estatutário, por invalidez', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	40	, 'Término do exercício do mandato eletivo', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	41	, 'Rescisão do contrato de aprendizagem por desempenho insuficiente ou inadaptação do aprendiz', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	42	, 'Rescisão do contrato de aprendizagem por ausência injustificada do aprendiz à escola que implique perda do ano letivo', '10/05/2021', null)
Insert Into esoc_MotivoDesligamento Values(	43	, 'Transferência de empregado de empresa considerada inapta por inexistência de fato', '01/01/2014', null)
Insert Into esoc_MotivoDesligamento Values(	44	, 'Agrupamento contratual', '01/01/2014', null)

Go
/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoPensaoAlimenticia"                                */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoPensaoAlimenticia] (
    [TipoPensaoAlimenticiaId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoPensaoAlimenticiaCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(70) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoPensaoAlimenticia] PRIMARY KEY ([TipoPensaoAlimenticiaId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários com os tipos de pensão alimenticia', N'user', N'dbo',N'table', N'ptrab_TipoPensaoAlimenticia', NULL, NULL
GO

Insert into ptrab_TipoPensaoAlimenticia values (0,'Não existe pensão alimentícia')
Insert into ptrab_TipoPensaoAlimenticia values (1,'Percentual de pensão alimentícia')
Insert into ptrab_TipoPensaoAlimenticia values (2,'Valor de pensão alimentícia')
Insert into ptrab_TipoPensaoAlimenticia values (3,'Percentual e valor de pensão alimentícia')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoMotivoDesligamentoTSV"                            */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoMotivoDesligamentoTSV] (
    [TipoMotivoDesligamentoTSVId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoMotivoDesligamentoTSVCodigo] VARCHAR(2) NOT NULL,
    [Descricao] VARCHAR(300) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoMotivoDesligamentoTSV] PRIMARY KEY ([TipoMotivoDesligamentoTSVId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Dados primários com os motivos de desligamento', N'user', N'dbo',N'table', N'ptrab_TipoMotivoDesligamentoTSV', NULL, NULL
GO

insert into ptrab_TipoMotivoDesligamentoTSV Values(	'01'	,' Exoneração do diretor não empregado sem justa causa, por deliberação da assembleia, dos sócios cotistas ou da autoridade competente')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'02'	,'Término de mandato do diretor não empregado que não tenha sido reconduzido ao cargo')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'03'	,'Exoneração a pedido de diretor não empregado')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'04'	,'Exoneração do diretor não empregado por culpa recíproca ou força maior')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'05'	,'Morte do diretor não empregado')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'06'	,'Exoneração do diretor não empregado por falência, encerramento ou supressão de parte da empresa')
insert into ptrab_TipoMotivoDesligamentoTSV Values(	'99'	,'Outros')

GO
/* ---------------------------------------------------------------------- */
/* Add table "Categoria"                                                  */
/* ---------------------------------------------------------------------- */
CREATE TABLE [esoc_Categoria] (
    [CategoriaId] INTEGER IDENTITY(1,1) NOT NULL,
    [CategoriaCodigo] INTEGER NOT NULL,
    [Descricao] VARCHAR(400) NOT NULL,
    [Inicio] DATE NOT NULL,
    [Termino] DATE,
    CONSTRAINT [PK_Categoria] PRIMARY KEY ([CategoriaId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela de dados primários  com o código da categoria do trabalhador sendo um código válido e existente na Tabela 01. ', N'user', N'dbo',N'table', N'esoc_Categoria', NULL, NULL
GO


Set DATEFORMAT DMY
insert into esoc_Categoria Values(	101	, 'Empregado - Geral, inclusive o empregado público da administração direta ou indireta contratado pela CLT',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	102	, 'Empregado - Trabalhador rural por pequeno prazo da Lei 11.718/2008',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	103	, 'Empregado - Aprendiz',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	104	, 'Empregado - Doméstico',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	105	, 'Empregado - Contrato a termo firmado nos termos da Lei 9.601/1998',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	106	, 'Trabalhador temporário - Contrato nos termos da Lei 6.019/1974',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	107	, 'Empregado - Contrato de trabalho Verde e Amarelo - sem acordo para antecipação mensal da multa rescisória do FGTS',  '01/01/2020', '31/12/2022'	)
insert into esoc_Categoria Values(	108	, 'Empregado - Contrato de trabalho Verde e Amarelo - com acordo para antecipação mensal da multa rescisória do FGTS',  '01/01/2020', '31/12/2022'	)
insert into esoc_Categoria Values(	111	, 'Empregado - Contrato de trabalho intermitente',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	201	, 'Trabalhador avulso portuário',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	202	, 'Trabalhador avulso não portuário',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	301	, 'Servidor público titular de cargo efetivo, magistrado, ministro de Tribunal de Contas, conselheiro de Tribunal de Contas e membro do Ministério Público',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	302	, 'Servidor público ocupante de cargo exclusivo em comissão',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	303	, 'Exercente de mandato eletivo',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	304	, 'Servidor público exercente de mandato eletivo, inclusive com exercício de cargo em comissão',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	305	, 'Servidor público indicado para conselho ou órgão deliberativo, na condição de representante do governo, órgão ou entidade da administração pública',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	306	, 'Servidor público contratado por tempo determinado, sujeito a regime administrativo especial definido em lei própria',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	307	, 'Militar dos Estados e Distrito Federal',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	308	, 'Conscrito',  '01/01/2014', '25/04/2023'	)
insert into esoc_Categoria Values(	309	, 'Agente público - Outros',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	310	, 'Servidor público eventual',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	311	, 'Ministros, juízes, procuradores, promotores ou oficiais de justiça à disposição da Justiça Eleitoral',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	312	, 'Auxiliar local',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	313	, 'Servidor público exercente de atividade de instrutoria, curso ou concurso, convocado para pareceres técnicos, depoimentos ou aditância no exterior.',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	314	, 'Militar das Forças Armadas',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	401	, 'Dirigente sindical - Informação prestada pelo sindicato',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	410	, 'Trabalhador cedido/exercício em outro órgão/juiz auxiliar - Informação prestada pelo cessionário/destino',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	501	, 'Dirigente sindical - Segurado especial', '01/01/2014', 	null	)
insert into esoc_Categoria Values(	701	, 'Contribuinte individual - Autônomo em geral, exceto se enquadrado em uma das demais categorias de contribuinte individual',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	711	, 'Contribuinte individual - Transportador autônomo de passageiros',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	712	, 'Contribuinte individual - Transportador autônomo de carga',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	721	, 'Contribuinte individual - Diretor não empregado, com FGTS',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	722	, 'Contribuinte individual - Diretor não empregado, sem FGTS',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	723	, 'Contribuinte individual - Empresário, sócio e membro de conselho de administração ou fiscal',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	731	, 'Contribuinte individual - Cooperado que presta serviços por intermédio de cooperativa de trabalho',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	734	, 'Contribuinte individual - Transportador cooperado que presta serviços por intermédio de cooperativa de trabalho',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	738	, 'Contribuinte individual - Cooperado filiado a cooperativa de produção',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	741	, 'Contribuinte individual - Microempreendedor individual',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	751	, 'Contribuinte individual - Magistrado classista temporário da Justiça do Trabalho ou da Justiça Eleitoral que seja aposentado de qualquer regime previdenciário',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	761	, 'Contribuinte individual - Associado eleito para direção de cooperativa, associação ou entidade de classe de qualquer natureza ou finalidade, bem como o síndico ou administrador eleito para exercer atividade de direção condominial, desde que recebam remuneração',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	771	, 'Contribuinte individual - Membro de conselho tutelar, nos termos da Lei 8.069/1990',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	781	, 'Ministro de confissão religiosa ou membro de vida consagrada, de congregação ou de ordem religiosa',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	901	, 'Estagiário',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	902	, 'Médico residente, residente em área profissional de saúde ou médico em curso de formação',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	903	,  'Bolsista', '01/01/2014', 	null	)
insert into esoc_Categoria Values(	904	, 'Participante de curso de formação, como etapa de concurso público, sem vínculo de emprego/estatutário',  '01/01/2014', 	null	)
insert into esoc_Categoria Values(	906	, 'Beneficiário do Programa Nacional de Prestação de Serviço Civil Voluntário',  '28/01/2022', 	null	)

GO


/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoIndicativoRepercussao"                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ptrab_TipoIndicativoRepercussao] (
    [TipoIndicativoRepercussaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoIndicativoRepercussaoCodigo] INTEGER NOT NULL,  -- indReperc
    [Descricao] VARCHAR(200) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoIndicativoRepercussao] PRIMARY KEY ([TipoIndicativoRepercussaoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Dados primário com o Indicativo de repercussão do processo trabalhista ou de demanda submetida à CCP ou ao NINTER', N'user', N'dbo',N'table', N'ptrab_TipoIndicativoRepercussao', NULL, NULL
GO

Insert Into ptrab_TipoIndicativoRepercussao Values (1,'Decisão com repercussão tributária e/ou FGTS')
Insert Into ptrab_TipoIndicativoRepercussao Values (2,'Decisão sem repercussão tributária ou FGTS')
Insert Into ptrab_TipoIndicativoRepercussao Values (3,'Decisão com repercussão exclusiva para declaração de rendimentos para fins de Imposto de Renda')
Insert Into ptrab_TipoIndicativoRepercussao Values (4,'Decisão com repercussão exclusiva para declaração de rendimentos para fins de Imposto de Renda com pagamento através de depósito judicial')
Insert Into ptrab_TipoIndicativoRepercussao Values (5,'Decisão com repercussão tributária e/ou FGTS com pagamento através de depósito judicial')

Go


/* ---------------------------------------------------------------------- */
/* Add table "esoc_CodigoReceitaReclamatoriaTrabalhista"                       */
/* ---------------------------------------------------------------------- */
CREATE TABLE [esoc_CodigoReceitaReclamatoriaTrabalhista] (
    [CodigoReceitaReclamatoriaTrabalhistaId] INTEGER IDENTITY(1,1) NOT NULL,
    [CodigoReceitaReclamatoriaTrabalhistaCodigo] VARCHAR(6) NOT NULL,
    [Descricao] VARCHAR(350) NOT NULL,
    [Aliquota] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_CodigoReceitaReclamatoriaTrabalhista] PRIMARY KEY ([CodigoReceitaReclamatoriaTrabalhistaId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primarios referente a Tabela 29 - Códigos de Receita - Reclamatória Trabalhista', N'user', N'dbo',N'table', N'esoc_CodigoReceitaReclamatoriaTrabalhista', NULL, NULL
GO


Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113851' , 'CP patronal a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '20')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('164651' , 'CP GILRAT a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', 'Variável (RAT X FAP)')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('114151' , 'CP para financiamento de aposentadoria especial a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '6, 9 ou 12')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113852' , 'CP adicional a cargo das instituiçoes financeiras sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113854' , 'CP patronal a cargo da empresa sobre a remuneração do segurado contribuinte individual', '20')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('114155' , 'CP para financiamento de aposentadoria especial a cargo da empresa sobre a remuneração do segurado contribuinte individual', '6, 9 ou 12')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113855' , 'CP adicional a cargo das instituiçoes financeiras sobre a remuneração do segurado contribuinte individual', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113858' , 'CP patronal a cargo do empregador doméstico sobre a remuneração do segurado empregado doméstico', '8')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('164659' , 'CP GILRAT a cargo do empregador doméstico sobre a remuneração do segurado empregado doméstico', '0,8')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113857' , 'CP patronal a cargo do Microempreendedor - MEI sobre a remuneração do segurado empregado', '3')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113853' , 'CP patronal a cargo da empresa SIMPLES com atividade concomitante sobre a remuneração do segurado empregado ou trabalhador avulso', '20')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('164652' , 'CP GILRAT a cargo da empresa SIMPLES com atividade concomitante sobre a remuneração do segurado empregado ou trabalhador avulso', 'Variável (RAT X FAP)')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('114152' , 'CP adicional GILRAT a cargo da empresa SIMPLES com atividade concomitante sobre a remuneração do segurado empregado ou trabalhador avulso', '6, 9 ou 12')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('113856' , 'CP patronal a cargo da empresa SIMPLES com atividade concomitante sobre a remuneração do segurado contribuinte individual', '20')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('117051' , 'Salário-Educação a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('117651' , 'Incra a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '0,2')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('117652' , 'Incra (FPAS 531/795/825) a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,7')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('118151' , 'Senai a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('118451' , 'Sesi a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('119151' , 'Senac a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('119651' , 'Sesc a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('120051' , 'Sebrae a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '0,6')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('120052' , 'Sebrae (FPAS 566/574/647) a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '0,3')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('120551' , 'FDEPM a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('120951' , 'Fundo Aeroviário a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('121353' , 'Senar a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('121851' , 'Sest a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('121852' , 'Sest a cargo do trabalhador (descontado pela empresa) sobre a remuneração do segurado transportador autônomo', '1,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('122151' , 'Senat a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '1')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('122152' , 'Senat a cargo do trabalhador (descontado pela empresa) sobre a remuneração do segurado transportador autônomo', '1')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('122551' , 'Sescoop a cargo da empresa sobre a remuneração do segurado empregado ou trabalhador avulso', '2,5')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108251' , 'CP do segurado empregado e trabalhador avulso', 'Variável')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108252' , 'CP do segurado empregado contratado por curto prazo - Lei 11.718/2009', '8')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108253' , 'CP do segurado empregado doméstico', 'Variável')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108254' , 'CP do segurado empregado contratado por curto prazo por empregador segurado especial - Lei 11.718/2009', '8')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108255' , 'CP do segurado empregado contratado por empregador segurado especial', 'Variável')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('108257' , 'CP do segurado empregado contratado por empregador MEI', 'Variável')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('109951' , 'CP do segurado contribuinte individual - 11%', '11')
Insert Into esoc_CodigoReceitaReclamatoriaTrabalhista Values('109952' , 'CP do segurado contribuinte individual - 20%', '20')

Go

/* ---------------------------------------------------------------------- */
/* Add table "esoc_TipoCodigoReceitaIRRF"                                      */
/* ---------------------------------------------------------------------- */


CREATE TABLE [esoc_TipoCodigoReceitaIRRF] (
    [TipoCodigoReceitaIRRFId] INTEGER IDENTITY(1,1) NOT NULL,
    [CodigoReceitaIRRF] VARCHAR(6) NOT NULL,
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_TipoCodigoReceitaIRRF] PRIMARY KEY ([TipoCodigoReceitaIRRFId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os Códigos de Receita - CR relativo a Imposto de Renda Retido na Fonte.', N'user', N'dbo',N'table', N'esoc_TipoCodigoReceitaIRRF', NULL, NULL
GO

Insert Into [esoc_TipoCodigoReceitaIRRF] Values ('593656', 'IRRF - Decisão da Justiça do Trabalho')
Insert Into [esoc_TipoCodigoReceitaIRRF] Values ('056152', 'IRRF - CCP/NINTER')
Insert Into [esoc_TipoCodigoReceitaIRRF] Values ('188951', 'IRRF - RRA')

GO

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoRendimento"                                       */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoRendimento] (
    [TipoRendimentoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoRendimentoCodigo] INTEGER NOT NULL, -- tpRend
    [Descricao] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoRendimento] PRIMARY KEY ([TipoRendimentoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os tipos de rendimento ', N'user', N'dbo',N'table', N'ptrab_TipoRendimento', NULL, NULL
GO

Insert Into ptrab_TipoRendimento Values(11, 'Remuneração mensal')
Insert Into ptrab_TipoRendimento Values(12, '13º salário')
Insert Into ptrab_TipoRendimento Values(18, 'RRA')
Insert Into ptrab_TipoRendimento Values(12, 'Rendimento isento ou não tributável')

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_TipoProcesso"                                         */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoProcesso] (
    [TipoProcessoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoProcessoCodigo] INTEGER NOT NULL, -- tpProcRet
    [Descricao] VARCHAR(40) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoProcesso] PRIMARY KEY ([TipoProcessoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários com os tipos de processos', N'user', N'dbo',N'table', N'ptrab_TipoProcesso', NULL, NULL
GO

Insert Into ptrab_TipoProcesso Values (1, 'Administrativo')
Insert Into ptrab_TipoProcesso Values (2, 'Judicial')

GO

/* ---------------------------------------------------------------------- */
/* Add table "esoc_IndicativoSuspensao"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [esoc_IndicativoSuspensao] (
    [IndicativoSuspensaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [IndicativoSuspensaoCodigo] VARCHAR(2) NOT NULL, --codSusp
    [Descricao] VARCHAR(150) NOT NULL,
    CONSTRAINT [PK_IndicativoSuspensao] PRIMARY KEY ([IndicativoSuspensaoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os Indicativo de suspensão da exigibilidade.', N'user', N'dbo',N'table', N'esoc_IndicativoSuspensao', NULL, NULL
GO


Insert Into esoc_IndicativoSuspensao Values('01', 'Liminar em mandado de segurança')
Insert Into esoc_IndicativoSuspensao Values('02', 'Depósito judicial do montante integral')
Insert Into esoc_IndicativoSuspensao Values('03', 'Depósito administrativo do montante integral')
Insert Into esoc_IndicativoSuspensao Values('04', 'Antecipação de tutela')
Insert Into esoc_IndicativoSuspensao Values('05', 'Liminar em medida cautelar')
Insert Into esoc_IndicativoSuspensao Values('08', 'Sentença em mandado de segurança favorável ao contribuinte')
Insert Into esoc_IndicativoSuspensao Values('09', 'Sentença em ação ordinária favorável ao contribuinte e confirmada pelo TRF')
Insert Into esoc_IndicativoSuspensao Values('10', 'Acórdão do TRF favorável ao contribuinte')
Insert Into esoc_IndicativoSuspensao Values('11', 'Acórdão do STJ em recurso especial favorável ao ')
Insert Into esoc_IndicativoSuspensao Values('12', 'Acórdão do STF em recurso extraordinário favorável ao contribuinte')
Insert Into esoc_IndicativoSuspensao Values('13', 'Sentença 1ª instância não transitada em julgado com efeito suspensivo')
Insert Into esoc_IndicativoSuspensao Values('14', 'Contestação administrativa FAP')
Insert Into esoc_IndicativoSuspensao Values('90', 'Decisão definitiva a favor do contribuinte')
Insert Into esoc_IndicativoSuspensao Values('92', 'Sem suspensão da exigibilidade')

GO
/* ---------------------------------------------------------------------- */
/* Add table "esoc_TipoDependente"                                             */
/* ---------------------------------------------------------------------- */


CREATE TABLE [esoc_TipoDependente] (
    [TipoDependenteId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoDependenteCodigo] VARCHAR(2) NOT NULL, -- tpDep
    [Descricao] VARCHAR(250) NOT NULL,
    [DataInicio] DATE NOT NULL,
    [DataTermino] DATE,
    CONSTRAINT [PK_TipoDependente] PRIMARY KEY ([TipoDependenteId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Dados Priários com as informações da Tabela 07 - Tipos de Dependente', N'user', N'dbo',N'table', N'esoc_TipoDependente', NULL, NULL
GO

Insert Into esoc_TipoDependente Values('01', 'Cônjuge', '01/01/2014', null)	
Insert Into esoc_TipoDependente Values('02', 'Companheiro(a) com o(a) qual tenha filho ou viva há mais de 5 (cinco) anos ou possua declaração de união estável', '08/01/2018', null)	
Insert Into esoc_TipoDependente Values('03', 'Filho(a) ou enteado(a)', '08/01/2018', null)	
Insert Into esoc_TipoDependente Values('04', 'Filho(a) ou enteado(a), universitário(a) ou cursando escola técnica de 2º grau', '08/01/2018', '25/04/2023')
Insert Into esoc_TipoDependente Values('06', 'Irmão(ã), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial', '08/01/2018', null)	
Insert Into esoc_TipoDependente Values('07', 'Irmão(ã), neto(a) ou bisneto(a) sem arrimo dos pais, universitário(a) ou cursando escola técnica de 2° grau, do(a) qual detenha a guarda judicial', '08/01/2018', '25/04/2023')
Insert Into esoc_TipoDependente Values('09', 'Pais, avós e bisavós', '01/01/2014', null)	
Insert Into esoc_TipoDependente Values('10', 'Menor pobre do qual detenha a guarda judicial', '08/01/2018', null)	
Insert Into esoc_TipoDependente Values('11', 'A pessoa absolutamente incapaz, da qual seja tutor ou curador', '01/01/2014', null)	
Insert Into esoc_TipoDependente Values('12', 'Ex-cônjuge', '08/01/2018', null)	
Insert Into esoc_TipoDependente Values('99', 'Agregado/Outros', '01/01/2014', null)	

Go

/* ---------------------------------------------------------------------- */
/* Add table "ptrab_IndicativoApuracao"                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [ptrab_TipoIndicativoApuracao] (
    [TipoIndicativoApuracaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoIndicativoApuracaoCodigo] INTEGER NOT NULL,  -- indApuracao
    [Descricao] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoIndicativoApuracao] PRIMARY KEY ([TipoIndicativoApuracaoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com os dados primários Indicativo de Apuracao', N'user', N'dbo',N'table', N'ptrab_TipoIndicativoApuracao', NULL, NULL
GO

Insert Into ptrab_TipoIndicativoApuracao Values (1, 'Mensal')
Insert Into ptrab_TipoIndicativoApuracao Values (2, 'Anual (13º Salário)') 


/* ---------------------------------------------------------------------- */
/* Add table "ptrab_InfoAgNocivo"                                         */
/* ---------------------------------------------------------------------- */


CREATE TABLE [ptrab_TipoInfoAgNocivo] (
    [TipoInfoAgNocivoId] INTEGER IDENTITY(1,1) NOT NULL,
    [TipoInfoAgNocivoCodigo] INTEGER NOT NULL, -- grauExp
    [Descricao] VARCHAR(150) NOT NULL,
    CONSTRAINT [PK_ptrab_TipoInfoAgNocivo] PRIMARY KEY ([TipoInfoAgNocivoId])
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Tabela com o Grupo referente ao detalhamento do grau de exposição do trabalhador aos agentes nocivos que ensejam a cobrança da contribuição adicional para financiamento dos benefícios de aposentadoria especial.', N'user', N'dbo',N'table', N'ptrab_TipoInfoAgNocivo', NULL, NULL
GO

Insert Into ptrab_TipoInfoAgNocivo Values(1, 'Não ensejador de aposentadoria especial')
Insert Into ptrab_TipoInfoAgNocivo Values(2, 'Ensejador de aposentadoria especial - FAE15_12% (15 anos de contribuição e alíquota de 12%)')
Insert Into ptrab_TipoInfoAgNocivo Values(3, 'Ensejador de aposentadoria especial - FAE20_09% (20 anos de contribuição e alíquota de 9%)')
Insert Into ptrab_TipoInfoAgNocivo Values(4, 'Ensejador de aposentadoria especial - FAE25_06% (25 anos de contribuição e alíquota de 6%)')
Go




-- =============================================
-- TABELA PRINCIPAL: CADASTRO DE PROCESSOS
-- =============================================

CREATE TABLE [dbo].[ptrab_CadastroProcesso] (
    [CadastroProcessoId] INTEGER IDENTITY(1,1) NOT NULL,
    [NumeroProcesso] VARCHAR(20) NOT NULL,
    [TipoOrigemId] INTEGER NOT NULL, -- FK para ptrab_TipoOrigem
    [Observacao] VARCHAR(999) NULL,
    [StatusId] INTEGER NOT NULL , -- FK para ptrab_status
    
    -- Dados do Empregador (ideEmpregador)
    [EmpregadorTipoInscricaoId] INTEGER NOT NULL, -- FK para ptrab_TipoInscricao
    [EmpregadorNumeroInscricao] VARCHAR(14) NOT NULL,
    [EmpregadorCodigoIdentificacaoSistema] VARCHAR(20) NULL,
    
    -- Dados do Responsável Indireto (ideResp) - OPCIONAL
    [ResponsavelTipoInscricaoId] INTEGER NULL, -- FK para ptrab_TipoInscricao
    [ResponsavelNumeroInscricao] VARCHAR(14) NULL,
    
    -- Dados do Processo Judicial (infoProcJud) - SE OrigemId = 1
    [DataSentenca] DATETIME NULL,
    [UFVara] VARCHAR(2) NULL,
    [CodigoMunicipio] VARCHAR(7) NULL,
    [IdentificadorVara] VARCHAR(50) NULL,
    
    -- Dados do CCP/NINTER (infoCCP) - SE OrigemId = 2 ou 3
    [DataCCP] DATETIME NULL,
    [CNPJCCP] VARCHAR(14) NULL,
    [TipoCCPId] INTEGER NULL, -- tpCCP (FK para ptrab_TipoCCP)
    
    -- Auditoria
    [UsuarioInclusao] VARCHAR(200) NOT NULL,
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    [UsuarioEnvioTransmissao] VARCHAR(200) NULL,
    [DataEnvioTransmissao] DATETIME NULL,
    
    CONSTRAINT [PK_ptrab_CadastroProcesso] PRIMARY KEY ([CadastroProcessoId]),
	CONSTRAINT [FK_ptrab_CadastroProcesso_TipoOrigem] 
        FOREIGN KEY ([TipoOrigemId]) REFERENCES [ptrab_TipoOrigem] ([TipoOrigemId]),
	CONSTRAINT [FK_ptrab_CadastroProcesso_Status] 
        FOREIGN KEY ([StatusId]) REFERENCES [ptrab_Status] ([StatusId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_EmpregadorTipoInscricao] 
        FOREIGN KEY ([EmpregadorTipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_ResponsavelTipoInscricao] 
        FOREIGN KEY ([ResponsavelTipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    CONSTRAINT [FK_ptrab_CadastroProcesso_TipoCCP] 
		FOREIGN KEY ([TipoCCPId]) REFERENCES [ptrab_TipoCCP] ([TipoCCPId])

	);

-- Índices para ptrab_CadastroProcesso
CREATE INDEX [IDX_ptrab_CadastroProcesso_NumeroProcesso] ON [ptrab_CadastroProcesso] ([NumeroProcesso]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_OrigemId] ON [ptrab_CadastroProcesso] ([TipoOrigemId]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_StatusId] ON [ptrab_CadastroProcesso] ([StatusId]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_EmpregadorInscricao] ON [ptrab_CadastroProcesso] ([EmpregadorNumeroInscricao]);
CREATE INDEX [IDX_ptrab_CadastroProcesso_DataInclusao] ON [ptrab_CadastroProcesso] ([DataInclusao]);

-- =============================================
-- DETALHAMENTO S-2500: PROCESSO TRABALHISTA
-- =============================================
-- =============================================
-- TRABALHADORES DO PROCESSO (Array) ideTrab
-- =============================================

CREATE TABLE [dbo].[ptrab_ProcessoTrabalhista] (
    [ProcessoTrabalhistaId] INTEGER IDENTITY(1,1) NOT NULL,
    [CadastroProcessoId] INTEGER NOT NULL,
    [CPF] VARCHAR(11) NOT NULL, -- cpfTrab
    [Nome] VARCHAR(70) NULL, -- nmTrab
    [DataNascimento] DATETIME NULL,  -- dtNascto
	[ideSeqTrab] Integer NULL,  --ideSeqTrab
	[StatusId] INTEGER NOT NULL, -- FK para ptrab_Status
    
	-- Auditoria
    [UsuarioInclusao] VARCHAR(200) NOT NULL,
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    [UsuarioEnvioTransmissao] VARCHAR(200) NULL,
    [DataEnvioTransmissao] DATETIME NULL,
   
    
    CONSTRAINT [PK_ptrab_TrabalhadorProcesso] PRIMARY KEY ([ProcessoTrabalhistaId]),
    CONSTRAINT [FK_ptrab_TrabalhadorProcesso_CadastroProcesso] 
        FOREIGN KEY ([CadastroProcessoId]) REFERENCES [ptrab_CadastroProcesso] ([CadastroProcessoId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_TrabalhadorProcesso_ptrab_Status] 
        FOREIGN KEY ([StatusId]) REFERENCES [ptrab_Status] ([StatusId]),
    
    CONSTRAINT [CK_ptrab_TrabalhadorProcesso_CPF] CHECK (LEN([CPF]) = 11),
    CONSTRAINT [UQ_ptrab_TrabalhadorProcesso_Processo_CPF] UNIQUE ([CadastroProcessoId], [CPF])
);

CREATE INDEX [IDX_ptrab_TrabalhadorProcesso_CadastroProcessoId] ON [ptrab_ProcessoTrabalhista] ([CadastroProcessoId]);
CREATE INDEX [IDX_ptrab_TrabalhadorProcesso_CPF] ON [ptrab_ProcessoTrabalhista] ([CPF]);



-- =============================================
-- S-2500: Informações do contrato de trabalho. (infoContr)
-- =============================================
CREATE TABLE [dbo].[ptrab_InformacaoContrato] (
    [InformacaoContratoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoTrabalhistaId] INTEGER NOT NULL,
    
    -- Informações do Contrato (infoContr)
    [TipoContratoId] INTEGER NOT NULL, -- tpContr (FK para ptrab_TipoContrato )
    [IndicadorContrato] CHAR(1) NOT NULL, -- indContr (S=Sim, N=Não) 
    [DataAdmissaoOriginal] DATETIME NULL, -- dtAdmOrig
    [IndicadorReintegracao] CHAR(1) NULL, -- indReint (S=Sim, N=Não)
    [IndicadorCategoria] CHAR(1) NULL, -- indCateg (S=Sim, N=Não)  
    [IndicadorNaturezaAtividade] CHAR(1) NOT NULL, -- indNatAtiv (S=Sim, N=Não)
    [IndicadorMotivoDesligamento] CHAR(1) NOT NULL, -- indMotDeslig (S=Sim, N=Não)
    [Matricula] VARCHAR(30) NULL,
    [CategoriaId] INTEGER NULL, -- FK para Categoria que o código será atribuido no campo do XML codCateg,
    [DataInicioTSVE] DATETIME NULL, -- dtInicio (para TSVE)
    
    -- Informações Complementares (infoCompl)
    [CodigoCBO] VARCHAR(6) NULL, --codCBO
    [TipoNaturezaAtividadeId] INTEGER NULL, -- natAtividade (FK para ptrab_TipoNaturezaAtividade) 
    
    -- Remuneração
    [DataRemuneracao] DATETIME NULL, -- dtRemun
    [ValorSalarioFixo] MONEY NULL, -- vrSalFx
    [TipoUnidadePagamentoId] INTEGER NULL, -- undSalFixo (FK para ptrab_TipoUnidadePagamento) 
    [DescricaoSalarioVariavel] VARCHAR(999) NULL, -- dscSalVar
    
    -- Informações do Vínculo (infoVinc)
    [TipoRegimeTrabalhistaId] INTEGER NULL, -- tpRegTrab (FK para ptrab_TipoRegimeTrabalhista : 1=CLT, 2=Estatutário)
    [TipoRegimePrevidenciarioId] INTEGER NULL, -- tpRegPrev (FK para ptrab_TipoRegimePrevidenciario 1=RGPS, 2=RPPS, 3=Regime Exterior, 4=SPSMFA)
    [DataAdmissao] DATETIME NULL, -- dtAdm
    
	[TipoContratoTempoParcialId] INT NULL, -- tmpParc (FK para TipoContratoTempoParcial)
    
    -- Duração do Contrato (duracao)
    [TipoDuracaoContratoId] INTEGER NULL, -- tpContr (FK para ptrab_TipoDuracaoContrato 1=Prazo indeterminado, 2=Prazo determinado)
    [DataTermino] DATETIME NULL, -- dtTerm
    [ClausulaAssecuratoria] CHAR(1) NULL, -- clauAssec: S=Sim, N=Não
    [ObjetoDeterminante] VARCHAR(255) NULL, -- objDet
    
    -- Observações do Vínculo
    [ObservacoesVinculo] VARCHAR(255) NULL,
    
    -- Sucessão de Vínculo (sucessaoVinc)
    [SucessaoTipoInscricaoId] INTEGER NULL, -- tpInsc (FK para ptrab_TipoInscricao)
    [SucessaoNumeroInscricao] VARCHAR(14) NULL, -- nrInsc
    [SucessaoMatriculaAnterior] VARCHAR(30) NULL, -- matricAnt
    [SucessaoDataTransferencia] DATETIME NULL, -- dtTransf
    
    -- Informações de Desligamento (infoDeslig)
	[DataDesligamento] DATETIME NUll, -- dtDeslig
    [MotivoDesligamentoId] INTEGER NULL, -- mtvDeslig (FK para MotivoDesligamento)
    [DataProjetadaFimAviso] DATETIME NULL, -- dtProjFimAPI
    [TipoPensaoAlimenticiaId] INTEGER NULL, -- tpPensao (FK para ptrab_TipoPensaoAlimenticia)
    [PercentualAlimenticia] DECIMAL(5,2) NULL, -- percAliment
    [ValorAlimenticia] MONEY NULL, -- vrAlim
    
    -- Informações de Término TSVE (infoTerm)
    [DataTerminoTSVE] DATETIME NULL, -- dtTerm
    [TipoMotivoDesligamentoTSVId] Int NULL, -- mtvDesligTSV (fk para ptrab_TipoMotivoDesligamentoTSV) 
    
    -- Mudança de Categoria/Atividade (mudCategAtiv)
    [CategoriaIdMudanca] INTEGER NULL, -- codCateg (FK para Categoria)
    [TipoNaturezaAtividadeIdMudanca] INTEGER NULL, -- natAtividade (FK para ptrab_TipoNaturezaAtividade) 
    [DataMudancaCategoria] DATETIME NULL, -- dtMudCategAtiv
    
    [UsuarioInclusao] VARCHAR(200) NOT NULL DEFAULT 'SISTEMA',
    [DataInclusao] DATETIME NOT NULL DEFAULT GETDATE(),
    [UsuarioAlteracao] VARCHAR(200) NULL,
    [DataAlteracao] DATETIME NULL,
    
    CONSTRAINT [PK_ptrab_InformacaoContrato] PRIMARY KEY ([InformacaoContratoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_ProcessoTrabalhista] 
        FOREIGN KEY ([ProcessoTrabalhistaId]) REFERENCES [ptrab_ProcessoTrabalhista] ([ProcessoTrabalhistaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoContrato] 
        FOREIGN KEY ([TipoContratoId]) REFERENCES [ptrab_TipoContrato] ([TipoContratoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_Categoria] 
        FOREIGN KEY ([CategoriaId]) REFERENCES [esoc_Categoria] ([CategoriaId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoNaturezaAtividade] 
        FOREIGN KEY ([TipoNaturezaAtividadeId]) REFERENCES [ptrab_TipoNaturezaAtividade] ([TipoNaturezaAtividadeId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoUnidadePagamento] 
        FOREIGN KEY ([TipoUnidadePagamentoId]) REFERENCES [ptrab_TipoUnidadePagamento] ([TipoUnidadePagamentoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoRegimeTrabalhista] 
        FOREIGN KEY ([TipoRegimeTrabalhistaId]) REFERENCES [ptrab_TipoRegimeTrabalhista] ([TipoRegimeTrabalhistaId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoRegimePrevidenciario] 
        FOREIGN KEY ([TipoRegimePrevidenciarioId]) REFERENCES [ptrab_TipoRegimePrevidenciario] ([TipoRegimePrevidenciarioId]),
	CONSTRAINT [FK_ptrab_InformacaoContrato_TipoContratoTempoParcial] 
        FOREIGN KEY ([TipoContratoTempoParcialId]) REFERENCES [ptrab_TipoContratoTempoParcial] ([TipoContratoTempoParcialId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoDuracaoContrato] 
        FOREIGN KEY ([TipoDuracaoContratoId]) REFERENCES [ptrab_TipoDuracaoContrato] ([TipoDuracaoContratoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_SucessaoTipoInscricao] 
        FOREIGN KEY ([SucessaoTipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_esoc_MotivoDesligamento] 
        FOREIGN KEY ([MotivoDesligamentoId]) REFERENCES [esoc_MotivoDesligamento] ([MotivoDesligamentoId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_ptrab_TipoPensaoAlimenticia] 
        FOREIGN KEY ([TipoPensaoAlimenticiaId]) REFERENCES [ptrab_TipoPensaoAlimenticia] ([TipoPensaoAlimenticiaId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoMotivoDesligamentoTSV] 
        FOREIGN KEY ([TipoMotivoDesligamentoTSVId]) REFERENCES [ptrab_TipoMotivoDesligamentoTSV] ([TipoMotivoDesligamentoTSVId]),
	CONSTRAINT [FK_ptrab_InformacaoContrato_CategoriaMudanca] 
        FOREIGN KEY ([CategoriaIdMudanca]) REFERENCES [esoc_Categoria] ([CategoriaId]),
    CONSTRAINT [FK_ptrab_InformacaoContrato_TipoNaturezaAtividadeMudanca] 
        FOREIGN KEY ([TipoNaturezaAtividadeIdMudanca]) REFERENCES [ptrab_TipoNaturezaAtividade] ([TipoNaturezaAtividadeId]),
    
    
    -- Constraints de validação
    CONSTRAINT [CK_ptrab_InformacaoContrato_IndicadorContrato] CHECK ([IndicadorContrato] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_InformacaoContrato_IndicadorReintegracao] CHECK ([IndicadorReintegracao] IN ('S', 'N') OR [IndicadorReintegracao] IS NULL),
    CONSTRAINT [CK_ptrab_InformacaoContrato_IndicadorCategoria] CHECK ([IndicadorCategoria] IN ('S', 'N') OR [IndicadorCategoria] IS NULL),
    CONSTRAINT [CK_ptrab_InformacaoContrato_IndicadorNaturezaAtividade] CHECK ([IndicadorNaturezaAtividade] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_InformacaoContrato_IndicadorMotivoDesligamento] CHECK ([IndicadorMotivoDesligamento] IN ('S', 'N')),
    CONSTRAINT [CK_ptrab_InformacaoContrato_ClausulaAssecuratoria] CHECK ([ClausulaAssecuratoria] IN ('S', 'N') OR [ClausulaAssecuratoria] IS NULL),
   );

CREATE INDEX [IDX_ptrab_InformacaoContrato_ProcessoTrabalhistaId] ON [ptrab_InformacaoContrato] ([ProcessoTrabalhistaId]);
CREATE INDEX [IDX_ptrab_InformacaoContrato_StatusId] ON [ptrab_InformacaoContrato] ([StatusId]);
CREATE INDEX [IDX_ptrab_InformacaoContrato_Matricula] ON [ptrab_InformacaoContrato] ([Matricula]);
CREATE INDEX [IDX_ptrab_InformacaoContrato_CPF_Processo] ON [ptrab_InformacaoContrato] ([ProcessoTrabalhistaId], [StatusId]);

-- =============================================
-- UNICIDADE CONTRATUAL (unicContr)
-- =============================================

CREATE TABLE [dbo].[ptrab_UnicidadeContratual] (
    [UnicidadeContratualId] INTEGER IDENTITY(1,1) NOT NULL,
    [InformacaoContratoId] INTEGER NOT NULL,
    [MatriculaIncorporada] VARCHAR(30) NULL, -- matUnic
    [CategoriaId] INTEGER NULL, -- codCateg (FK para esoc_Categoria)
    [DataInicio] DATETIME NULL, -- dtInicio
    
    CONSTRAINT [PK_ptrab_UnicidadeContratual] PRIMARY KEY ([UnicidadeContratualId]),
    CONSTRAINT [FK_ptrab_UnicidadeContratual_InformacaoContrato] 
        FOREIGN KEY ([InformacaoContratoId]) REFERENCES [ptrab_InformacaoContrato] ([InformacaoContratoId]) ON DELETE CASCADE,
	CONSTRAINT [FK_ptrab_UnicidadeContratual_Categoria] 
        FOREIGN KEY ([CategoriaId]) REFERENCES [esoc_Categoria] ([CategoriaId])
);

CREATE INDEX [IDX_ptrab_UnicidadeContratual_InformacaoContratoId] ON [ptrab_UnicidadeContratual] ([InformacaoContratoId]);

-- =============================================
-- ESTABELECIMENTO RESPONSÁVEL PELO PAGAMENTO (ideEstab)
-- =============================================

CREATE TABLE [dbo].[ptrab_EstabelecimentoPagamento] (
    [EstabelecimentoPagamentoId] INTEGER IDENTITY(1,1) NOT NULL,
    [InformacaoContratoId] INTEGER NOT NULL,
     [TipoInscricaoId] INTEGER NOT NULL, -- tpInsc (FK para ptrab_TipoInscricao)
    [NumeroInscricao] VARCHAR(14) NOT NULL, -- nrInsc
    
    CONSTRAINT [PK_ptrab_EstabelecimentoPagamento] PRIMARY KEY ([EstabelecimentoPagamentoId]),
    CONSTRAINT [FK_ptrab_EstabelecimentoPagamento_InformacaoContrato] 
        FOREIGN KEY ([InformacaoContratoId]) REFERENCES [ptrab_InformacaoContrato] ([InformacaoContratoId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_EstabelecimentoPagamento_TipoInscricao] 
        FOREIGN KEY ([TipoInscricaoId]) REFERENCES [ptrab_TipoInscricao] ([TipoInscricaoId]),
    
    CONSTRAINT [CK_ptrab_EstabelecimentoPagamento_NumeroInscricao] CHECK (LEN([NumeroInscricao]) BETWEEN 8 AND 14)
);

CREATE INDEX [IDX_ptrab_EstabelecimentoPagamento_InformacaoContratoId] ON [ptrab_EstabelecimentoPagamento] ([InformacaoContratoId]);

-- =============================================
-- PERÍODOS E VALORES DO PROCESSO (infoValores)
-- =============================================

CREATE TABLE [dbo].[ptrab_PeriodoValores] (
    [PeriodoValoresId] INTEGER IDENTITY(1,1) NOT NULL,
    [EstabelecimentoPagamentoId] INTEGER NOT NULL,
	[TipoIndicativoRepercussaoId] INTEGER NULL, -- indReperc
    [CompetenciaInicio] VARCHAR(7) NOT NULL, -- compIni (YYYY-MM)
    [CompetenciaFim] VARCHAR(7) NOT NULL, -- compFim (YYYY-MM)
    [IndenizacaoSubstitutiva] CHAR(1) NULL, -- indenSD: S=Sim, N=Não
    [IndenizacaoAbono] CHAR(1) NULL, -- indenAbono: S=Sim, N=Não
    
    CONSTRAINT [PK_ptrab_PeriodoValores] PRIMARY KEY ([PeriodoValoresId]),
    CONSTRAINT [FK_ptrab_PeriodoValores_EstabelecimentoPagamento] 
        FOREIGN KEY ([EstabelecimentoPagamentoId]) REFERENCES [ptrab_EstabelecimentoPagamento] ([EstabelecimentoPagamentoId]) ON DELETE CASCADE,
     CONSTRAINT [FK_ptrab_PeriodoValores_TipoIndicativoRepercussao] 
        FOREIGN KEY ([TipoIndicativoRepercussaoId]) REFERENCES [ptrab_TipoIndicativoRepercussao] ([TipoIndicativoRepercussaoId]) ON DELETE CASCADE,
    

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
-- BASES DE CÁLCULO PREVIDENCIÁRIAS (baseCalculo)
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
    [TipoInfoAgNocivoId] INT NOT NULL, -- grauExp (Fk para ptrab_TipoInfoAgNocivo)
    
    CONSTRAINT [PK_ptrab_AgenteNocivo] PRIMARY KEY ([AgenteNocivoId]),
    CONSTRAINT [FK_ptrab_AgenteNocivo_BaseCalculoPrevidencia] 
        FOREIGN KEY ([BaseCalculoPrevidenciaId]) REFERENCES [ptrab_BaseCalculoPrevidencia] ([BaseCalculoPrevidenciaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_AgenteNocivo_TipoInfoAgNocivo] 
        FOREIGN KEY ([TipoInfoAgNocivoId]) REFERENCES [ptrab_TipoInfoAgNocivo] ([TipoInfoAgNocivoId]) ON DELETE CASCADE,

--    CONSTRAINT [CK_ptrab_AgenteNocivo_GrauExposicao] CHECK ([TipoInfoAgNocivoId] IN ('1', '2', '3', '4'))
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
-- BASES DE CÁLCULO POR MUDANÇA DE CATEGORIA (baseMudCateg)
-- =============================================

CREATE TABLE [dbo].[ptrab_BaseCalculoMudancaCategoria] (
    [BaseCalculoMudancaCategoriaId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoApuracaoId] INTEGER NOT NULL,
    [CategoriaIdOriginal] INT NOT NULL, -- indCateg
    [ValorBasePrevidenciario] MONEY NOT NULL DEFAULT 0, -- vrBcCpMensal
    
    CONSTRAINT [PK_ptrab_BaseCalculoMudancaCategoria] PRIMARY KEY ([BaseCalculoMudancaCategoriaId]),
    CONSTRAINT [FK_ptrab_BaseCalculoMudancaCategoria_PeriodoApuracao] 
        FOREIGN KEY ([PeriodoApuracaoId]) REFERENCES [ptrab_PeriodoApuracao] ([PeriodoApuracaoId]) ON DELETE CASCADE,
     CONSTRAINT [FK_ptrab_BaseCalculoMudancaCategoria_Categoria] 
        FOREIGN KEY ([CategoriaIdOriginal]) REFERENCES [esoc_Categoria] ([CategoriaId]),
    CONSTRAINT [CK_ptrab_BaseCalculoMudancaCategoria_ValorBase] CHECK ([ValorBasePrevidenciario] >= 0)
);

CREATE INDEX [IDX_ptrab_BaseCalculoMudancaCategoria_PeriodoApuracaoId] ON [ptrab_BaseCalculoMudancaCategoria] ([PeriodoApuracaoId]);


-- =============================================
-- Informações relativas ao trabalho intermitente. (infoInterm)
-- =============================================
CREATE TABLE [dbo].[ptrab_infoIntermitente] (
    [InfoIntermitenteId] INTEGER IDENTITY(1,1) NOT NULL,
    [PeriodoApuracaoId] INTEGER NOT NULL,
	[DiaTrabalho] INTEGER NOT NULL, -- dia (0-31) - 0 = não trabalhou no mês
	[HorasTrabalhadasDia] VARCHAR(4) NULL, -- hrsTrab (HHMM) - obrigatório se classTrib = 22

	 CONSTRAINT [PK_ptrab_infoIntermitente] PRIMARY KEY ([InfoIntermitenteId]),
	 CONSTRAINT [FK_ptrab_infoIntermitente] 
        FOREIGN KEY ([PeriodoApuracaoId]) REFERENCES [ptrab_PeriodoApuracao] ([PeriodoApuracaoId]) ON DELETE CASCADE,

	CONSTRAINT [CK_ptrab_TrabalhoIntermitente_DiaTrabalho] 
        CHECK ([DiaTrabalho] BETWEEN 0 AND 31),

	CONSTRAINT [CK_ptrab_TrabalhoIntermitente_HorasTrabalhadasDia] 
        CHECK ([HorasTrabalhadasDia] IS NULL OR 
               ([HorasTrabalhadasDia] LIKE '[0-2][0-9][0-5][0-9]' AND 
                CAST(LEFT([HorasTrabalhadasDia], 2) AS INTEGER) <= 23 AND
                CAST(RIGHT([HorasTrabalhadasDia], 2) AS INTEGER) <= 59)),
	-- Constraint para validar que se DiaTrabalho > 0, deve ter HorasTrabalhadasDia
    CONSTRAINT [CK_ptrab_TrabalhoIntermitente_HorasObrigatorias] 
        CHECK (([DiaTrabalho] = 0) OR 
               ([DiaTrabalho] > 0 AND [HorasTrabalhadasDia] IS NOT NULL)),
	-- Unicidade por período
    CONSTRAINT [UQ_ptrab_TrabalhoIntermitente_Periodo_Dia] 
        UNIQUE ([PeriodoApuracaoId], [DiaTrabalho])
	);

	CREATE INDEX [IDX_ptrab_InfoIntermitente_DiaTrabalho] 
    ON [ptrab_InfoIntermitente] ([DiaTrabalho]);


-- =============================================
-- S-2501
-- =============================================

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
    [ProcessoTrabalhistaId] INTEGER NOT NULL,
    
    CONSTRAINT [PK_ptrab_TributosTrabalhador] PRIMARY KEY ([TributosTrabalhadorId]),
    CONSTRAINT [FK_ptrab_TributosTrabalhador_Header] 
        FOREIGN KEY ([TributosProcessoHeaderId]) REFERENCES [ptrab_TributosProcessoHeader] ([TributosProcessoHeaderId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_TributosTrabalhador_Trabalhador] 
        FOREIGN KEY ([ProcessoTrabalhistaId]) REFERENCES [ptrab_ProcessoTrabalhista] ([ProcessoTrabalhistaId]),
    
    CONSTRAINT [UQ_ptrab_TributosTrabalhador_Header_Trabalhador] 
        UNIQUE ([TributosProcessoHeaderId], [ProcessoTrabalhistaId])
);

CREATE INDEX [IDX_ptrab_TributosTrabalhador_HeaderId] ON [ptrab_TributosTrabalhador] ([TributosProcessoHeaderId]);
CREATE INDEX [IDX_ptrab_TributosTrabalhador_TrabalhadorId] ON [ptrab_TributosTrabalhador] ([ProcessoTrabalhistaId]);

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
    [CodigoReceitaReclamatoriaTrabalhistaId] INT NOT NULL, -- tpCR (fk CodigoReceitaReclamatoriaTrabalhista)
    [ValorContribuicaoMensal] MONEY NOT NULL DEFAULT 0, -- vrCr
    [ValorContribuicao13] MONEY NOT NULL DEFAULT 0, -- vrCr13
    [ValorTotal] AS ([ValorContribuicaoMensal] + [ValorContribuicao13]), -- Campo calculado
    
    CONSTRAINT [PK_ptrab_ContribuicaoCodigoReceita] PRIMARY KEY ([ContribuicaoCodigoReceitaId]),
    CONSTRAINT [FK_ptrab_ContribuicaoCodigoReceita_CalculoTributos] 
        FOREIGN KEY ([CalculoTributosPeriodoId]) REFERENCES [ptrab_CalculoTributosPeriodo] ([CalculoTributosPeriodoId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_ContribuicaoCodigoReceita_esoc_CodigoReceitaReclamatoriaTrabalhista] 
        FOREIGN KEY ([CodigoReceitaReclamatoriaTrabalhistaId]) REFERENCES [esoc_CodigoReceitaReclamatoriaTrabalhista] ([CodigoReceitaReclamatoriaTrabalhistaId]) ON DELETE CASCADE,
    CONSTRAINT [CK_ptrab_ContribuicaoCodigoReceita_ValorMensal] CHECK ([ValorContribuicaoMensal] >= 0),
    CONSTRAINT [CK_ptrab_ContribuicaoCodigoReceita_Valor13] CHECK ([ValorContribuicao13] >= 0),
    CONSTRAINT [UQ_ptrab_ContribuicaoCodigoReceita_Calculo_Codigo] 
        UNIQUE ([CalculoTributosPeriodoId], [CodigoReceitaReclamatoriaTrabalhistaId])
);

CREATE INDEX [IDX_ptrab_ContribuicaoCodigoReceita_CalculoId] ON [ptrab_ContribuicaoCodigoReceita] ([CalculoTributosPeriodoId]);
CREATE INDEX [IDX_ptrab_ContribuicaoCodigoReceita_CodigoReceita] ON [ptrab_ContribuicaoCodigoReceita] ([CodigoReceitaReclamatoriaTrabalhistaId]);

-- =============================================
-- S-2501: IRRF POR CÓDIGO DE RECEITA (infoCRIRRF)
-- =============================================

CREATE TABLE [dbo].[ptrab_IRRFCodigoReceita] (
    [IRRFCodigoReceitaId] INTEGER IDENTITY(1,1) NOT NULL,
    [TributosTrabalhadorId] INTEGER NOT NULL,
    [TipoCodigoReceitaIRRFId] INT NOT NULL, -- tpCR (FK para esoc_TipoCodigoReceitaIRRF)
    [ValorIRRF] MONEY NOT NULL DEFAULT 0, -- vrIrrf
    
    CONSTRAINT [PK_ptrab_IRRFCodigoReceita] PRIMARY KEY ([IRRFCodigoReceitaId]),
    CONSTRAINT [FK_ptrab_IRRFCodigoReceita_TributosTrabalhador] 
        FOREIGN KEY ([TributosTrabalhadorId]) REFERENCES [ptrab_TributosTrabalhador] ([TributosTrabalhadorId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_IRRFCodigoReceita_esoc_TipoCodigoReceitaIRRF] 
        FOREIGN KEY ([TipoCodigoReceitaIRRFId]) REFERENCES [esoc_TipoCodigoReceitaIRRF] ([TipoCodigoReceitaIRRFId]) ON DELETE CASCADE,
 --   CONSTRAINT [CK_ptrab_IRRFCodigoReceita_ValorIRRF] CHECK ([ValorIRRF] >= 0),
    CONSTRAINT [UQ_ptrab_IRRFCodigoReceita_Trabalhador_Codigo] 
        UNIQUE ([TributosTrabalhadorId], [TipoCodigoReceitaIRRFId])
);

CREATE INDEX [IDX_ptrab_IRRFCodigoReceita_TributosTrabalhadorId] ON [ptrab_IRRFCodigoReceita] ([TributosTrabalhadorId]);
CREATE INDEX [IDX_ptrab_IRRFCodigoReceita_CodigoReceita] ON [ptrab_IRRFCodigoReceita] ([TipoCodigoReceitaIRRFId]);

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
    [TipoRendimentoId] INTEGER NOT NULL, -- tpRend: (FK para ptrab_TipoRendimento ).
    [CPFDependente] VARCHAR(11) NOT NULL, -- cpfDep
    [ValorDeducao] MONEY NOT NULL DEFAULT 0, -- vlrDedDep
    
    CONSTRAINT [PK_ptrab_DeducaoDependentes] PRIMARY KEY ([DeducaoDependentesId]),
    CONSTRAINT [FK_ptrab_DeducaoDependentes_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_DeducaoDependentes_TipoRendimento] 
        FOREIGN KEY ([TipoRendimentoId]) REFERENCES [ptrab_TipoRendimento] ([TipoRendimentoId]) ON DELETE CASCADE,
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
    [TipoRendimentoId] INTEGER NOT NULL, -- tpRend
    [CPFBeneficiario] VARCHAR(11) NOT NULL, -- cpfDep
    [ValorPensao] MONEY NOT NULL DEFAULT 0, -- vlrPensao
    
    CONSTRAINT [PK_ptrab_PensaoAlimenticia] PRIMARY KEY ([PensaoAlimenticiaId]),
    CONSTRAINT [FK_ptrab_PensaoAlimenticia_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_PensaoAlimenticia_ptrab_TipoRendimento] 
        FOREIGN KEY ([TipoRendimentoId]) REFERENCES [ptrab_TipoRendimento] ([TipoRendimentoId]) ON DELETE CASCADE,
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
    [TipoProcessoId] INTEGER NOT NULL, -- tpProcRet (FK ára ptrab_TipoProcesso)
    [NumeroProcesso] VARCHAR(21) NOT NULL, -- nrProcRet
    [IndicativoSuspensaoId] INT NULL, -- codSusp (FK Tabela esoc_IndicativoSuspensao)
  
    CONSTRAINT [PK_ptrab_ProcessoRetencao] PRIMARY KEY ([ProcessoRetencaoId]),
    CONSTRAINT [FK_ptrab_ProcessoRetencao_IRRFCodigoReceita] 
        FOREIGN KEY ([IRRFCodigoReceitaId]) REFERENCES [ptrab_IRRFCodigoReceita] ([IRRFCodigoReceitaId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_ProcessoRetencao_esoc_IndicativoSuspensao] 
        FOREIGN KEY ([IndicativoSuspensaoId]) REFERENCES [esoc_IndicativoSuspensao] ([IndicativoSuspensaoId]) ON DELETE CASCADE,
	CONSTRAINT [FK_ptrab_ProcessoRetencao_esoc_TipoProcesso] 
        FOREIGN KEY ([TipoProcessoId]) REFERENCES [ptrab_TipoProcesso] ([TipoProcessoId]) ON DELETE CASCADE,

 --   CONSTRAINT [CK_ptrab_ProcessoRetencao_TipoProcesso] CHECK ([TipoProcesso] IN (1, 2))
);

CREATE INDEX [IDX_ptrab_ProcessoRetencao_IRRFCodigoReceitaId] ON [ptrab_ProcessoRetencao] ([IRRFCodigoReceitaId]);
CREATE INDEX [IDX_ptrab_ProcessoRetencao_NumeroProcesso] ON [ptrab_ProcessoRetencao] ([NumeroProcesso]);

-- =============================================
-- S-2501: VALORES DE RETENÇÃO (infoValores)
-- =============================================

CREATE TABLE [dbo].[ptrab_ValoresRetencao] (
    [ValoresRetencaoId] INTEGER IDENTITY(1,1) NOT NULL,
    [ProcessoRetencaoId] INTEGER NOT NULL,
    [TipoIndicativoApuracaoId] INTEGER NOT NULL, -- indApuracao (fk para ptrab_TipoIndicativoApuracao)
    [ValorNaoRetido] MONEY NULL, -- vlrNRetido
    [ValorDepositoJudicial] MONEY NULL, -- vlrDepJud
    [ValorCompetenciaAnoCivil] MONEY NULL, -- vlrCmpAnoCivil
    [ValorCompetenciaAnoAnterior] MONEY NULL, -- vlrCmpAnoAnt
    [ValorRendimentoSuspenso] MONEY NULL, -- vlrRendSusp
    
    CONSTRAINT [PK_ptrab_ValoresRetencao] PRIMARY KEY ([ValoresRetencaoId]),
    CONSTRAINT [FK_ptrab_ValoresRetencao_ProcessoRetencao] 
        FOREIGN KEY ([ProcessoRetencaoId]) REFERENCES [ptrab_ProcessoRetencao] ([ProcessoRetencaoId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_ValoresRetencao_TipoIndicativoApuracao] 
        FOREIGN KEY ([TipoIndicativoApuracaoId]) REFERENCES [ptrab_TipoIndicativoApuracao] ([TipoIndicativoApuracaoId]) ON DELETE CASCADE,
    --CONSTRAINT [CK_ptrab_ValoresRetencao_IndicadorApuracao] CHECK ([TipoIndicativoApuracaoId] IN (1, 2)),
    --CONSTRAINT [CK_ptrab_ValoresRetencao_ValorNaoRetido] CHECK ([ValorNaoRetido] IS NULL OR [ValorNaoRetido] >= 0),
    --CONSTRAINT [CK_ptrab_ValoresRetencao_ValorDepositoJudicial] CHECK ([ValorDepositoJudicial] IS NULL OR [ValorDepositoJudicial] >= 0),
    --CONSTRAINT [CK_ptrab_ValoresRetencao_ValorCompetenciaAnoCivil] CHECK ([ValorCompetenciaAnoCivil] IS NULL OR [ValorCompetenciaAnoCivil] >= 0),
    --CONSTRAINT [CK_ptrab_ValoresRetencao_ValorCompetenciaAnoAnterior] CHECK ([ValorCompetenciaAnoAnterior] IS NULL OR [ValorCompetenciaAnoAnterior] >= 0),
    --CONSTRAINT [CK_ptrab_ValoresRetencao_ValorRendimentoSuspenso] CHECK ([ValorRendimentoSuspenso] IS NULL OR [ValorRendimentoSuspenso] >= 0)
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
	[TipoDependenteId] INT NOT NULL, -- tpDep
    [DescricaoDependente] VARCHAR(60) NULL, -- descrDep
    
    CONSTRAINT [PK_ptrab_InformacaoDependente] PRIMARY KEY ([InfoDepNaoCadastradoId]),
    CONSTRAINT [FK_ptrab_InformacaoDependente_IRRFComplementar] 
        FOREIGN KEY ([IRRFComplementarId]) REFERENCES [ptrab_IRRFComplementar] ([IRRFComplementarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ptrab_InformacaoDependente_esoc_TipoDependente] 
        FOREIGN KEY ([TipoDependenteId]) REFERENCES [esoc_TipoDependente] ([TipoDependenteId]) ON DELETE CASCADE,

    CONSTRAINT [CK_ptrab_InformacaoDependente_CPF] CHECK (LEN([CPFDependente]) = 11),
  
  
);

CREATE INDEX [IDX_ptrab_InformacaoDependente_IRRFComplementarId] ON [ptrab_InfoDepNaoCadastrado] ([IRRFComplementarId]);
CREATE INDEX [IDX_ptrab_InformacaoDependente_CPFDependente] ON [ptrab_InfoDepNaoCadastrado] ([CPFDependente]);


