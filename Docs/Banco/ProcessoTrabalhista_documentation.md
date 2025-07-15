## 3.7 S-2501: IRRF Complementar e Estruturas Detalhadas

### Resumo das Novas Estruturas (infoIRComplem)

O grupo `infoIRComplem` foi introduzido na versão S-1.3 do eSocial para atender às necessidades de substituição da DIRF. Este grupo contém informações detalhadas sobre:

- **Planos de Saúde**: Informações sobre operadoras e beneficiários
- **Dependentes Não Cadastrados**: Dependentes não informados nos eventos S-2200, S-2205, etc.
- **Reembolsos Médicos**: Reembolsos efetuados pela empresa ou grupo econômico
- **Informações de Incapacidade**: Dados sobre trabalhadores com deficiência
- **Rendimentos RRA**: Rendimentos recebidos acumuladamente
- **Processos de Retenção**: Informações sobre suspensões e retenções de IRRF

### Fluxo de Relacionamentos infoIRComplem

```
ptrab_TributosTrabalhador
└── ptrab_IRRFComplementar (infoIRComplem)
    ├── ptrab_PlanoSaude (planSaude)
    │   ├── ptrab_InformacaoMedicaDependente (infoDep)
    ├── ptrab_DependenteNaoCadastrado (infoDepNaoCad)
    ├── ptrab_ReembolsoMedico (infoReembMed)
    │   └── ptrab_DetalheReembolsoMedico (detReembMed)
    └── ptrab_InformacaoIncapacidade (infoInc)

ptrab_IRRFCodigoReceita
├── ptrab_InformacaoIRRF (infoIR)
├── ptrab_RendimentosRRA (infoRRA)
│   ├── ptrab_DespesasProcessoJudicial (despProcJud)
│   └── ptrab_AdvogadosRRA (ideAdv)
├── ptrab_DeducaoDependentes (dedDepen)
├── ptrab_PensaoAlimenticia (penAlim)
└── ptrab_ProcessoRetencao (infoProcRet)
    ├── ptrab_ValoresRetencao (infoValores)
    └── ptrab_DeducoesSuspensas (dedSusp)
        └── ptrab_BeneficiariosPensaoSuspensa (benefPen)
```

### Validações Específicas do infoIRComplem

#### Planos de Saúde:
- CNPJ da operadora obrigatório (14 dígitos)
- Registro ANS opcional (6 dígitos)
- Valores monetários sempre >= 0

#### Dependentes Não Cadastrados:
- CPF obrigatório e válido (11 dígitos)
- Tipo de rendimento conforme tabela eSocial
- Data de nascimento obrigatória

#### Reembolsos Médicos:
- Estrutura mestre-detalhe obrigatória
- CPF beneficiário obrigatório quando tipo = Dependente
- Indicador de reembolso: 1=Própria empresa, 2=Grupo econômico

#### Processos de Retenção:
- Tipo processo: 1=Administrativo, 2=Judicial
- Número processo obrigatório (até 21 caracteres)
- Valores de retenção com validações específicas por tipo

## 3.8 Tabelas de Controle e Auditoria Estendidas

### Campos de Auditoria Padrão
Todas as tabelas principais (S-2500 e S-2501) possuem os seguintes campos de auditoria:

| Campo | Tipo | Descrição | Uso |
|-------|------|-----------|-----|
| UsuarioInclusao | VARCHAR(200) | Usuário que criou o registro | Obrigatório na criação |
| DataInclusao | DATETIME | Data/hora da criação | Automático (GETDATE()) |
| UsuarioAlteracao | VARCHAR(200) | Usuário da última alteração | Preenchido em updates |
| DataAlteracao | DATETIME | Data/hora da última alteração | Automático em updates |
| UsuarioEnvioTransmissao | VARCHAR(200) | Usuário que enviou para o eSocial | Processo de transmissão |
| DataEnvioTransmissao | DATETIME | Data/hora do envio | Processo de transmissão |

### Status de Processamento
Os seguintes status são utilizados no sistema:

| Código | Descrição | Uso |
|--------|-----------|-----|
| CADASTRADO | Cadastrado | Registro inicial |
| EM_ELABORACAO | Em Elaboração | Sendo preenchido |
| PENDENTE_ENVIO | Pendente de Envio | Pronto para transmissão |
| ENVIADO | Enviado | Transmitido para o eSocial |
|# Documentação do Sistema eSocial - Processos Trabalhistas
## Eventos S-2500 (Processo Trabalhista) e S-2501 (Tributos Decorrentes)

### 1. Visão Geral do Sistema

Este sistema foi desenvolvido para gerenciar os cadastros e transmissões dos eventos S-2500 (Processo Trabalhista) e S-2501 (Tributos Decorrentes de Processo Trabalhista) do eSocial.

#### Funcionalidades Principais:
- **Cadastro de Processos**: Registro dos dados básicos do processo trabalhista
- **Gestão de Trabalhadores**: Vinculação de trabalhadores aos processos
- **Detalhamento Contratual**: Informações detalhadas do contrato de trabalho (S-2500)
- **Cálculo de Tributos**: Gestão dos tributos decorrentes do processo (S-2501)
- **Transmissão Individual**: Envio por trabalhador, mesmo em processos com múltiplos funcionários

### 2. Estrutura Hierárquica dos Dados

```
📊 PROCESSO TRABALHISTA (Raiz)
├── 👤 Empregador (obrigatório)
├── 🏢 Responsável Indireto (opcional)
├── ⚖️ Dados Judiciais/CCP
├── 👥 TRABALHADORES (array)
│   └── 📋 PROCESSO TRABALHISTA S-2500 (por trabalhador)
│       ├── 🤝 Unicidade Contratual
│       ├── 🏭 Estabelecimento Pagamento
│       └── 💰 Períodos de Valores
│           ├── 🎁 Abono Salarial
│           └── 📅 Períodos de Apuração
│               ├── 💼 Base Cálculo Previdência
│               ├── 🏦 Base Cálculo FGTS
│               └── 🔄 Base Cálculo Mudança Categoria
└── 💸 TRIBUTOS S-2501 (por competência)
    └── 👨‍💼 Tributos por Trabalhador
        ├── 📊 Cálculo por Período
        │   └── 🧾 Contribuições por Código
        └── 📋 IRRF por Código
            ├── ℹ️ Informações IRRF
            ├── 💰 Rendimentos RRA
            ├── 👨‍👩‍👧‍👦 Deduções Dependentes
            ├── 💳 Pensão Alimentícia
            └── ⏸️ Processos de Retenção
```

### 3. Documentação das Tabelas

## 3.1 Tabelas de Domínio (Lookup)

### `ptrab_Status`
**Finalidade**: Controla os status dos registros no sistema
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| StatusId | INT IDENTITY | Chave primária | - |
| Codigo | VARCHAR(20) | Código do status (CADASTRADO, EM_ELABORACAO, etc.) | - |
| Descricao | VARCHAR(100) | Descrição legível do status | - |
| Ativo | BIT | Indica se o status está ativo | - |

### `ptrab_TipoInscricao`
**Finalidade**: Define os tipos de inscrição (CNPJ, CPF, CAEPF, CNO)
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| TipoInscricaoId | INT IDENTITY | Chave primária | - |
| Codigo | INT | Código numérico (1=CNPJ, 2=CPF, 3=CAEPF, 4=CNO) | tpInsc |
| Descricao | VARCHAR(50) | Descrição do tipo | - |

### `ptrab_Origem`
**Finalidade**: Define a origem do processo trabalhista
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| OrigemId | INT IDENTITY | Chave primária | - |
| Codigo | INT | Código (1=Judicial, 2=CCP, 3=NINTER) | origem |
| Descricao | VARCHAR(100) | Descrição da origem | - |

### `ptrab_TipoContrato`
**Finalidade**: Tipos de contrato de trabalho
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| TipoContratoId | INT IDENTITY | Chave primária | - |
| Codigo | INT | Código do tipo de contrato | tpContr |
| Descricao | VARCHAR(100) | Descrição do contrato | - |

## 3.2 Tabela Principal - Cadastro de Processos

### `ptrab_CadastroProcesso`
**Finalidade**: Tabela raiz que armazena os dados básicos do processo trabalhista

#### Campos Principais:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| CadastroProcessoId | INT IDENTITY | Sim | Chave primária | - |
| NumeroProcesso | VARCHAR(20) | Sim | Número único do processo | nrProcTrab |
| OrigemId | INT | Sim | Origem do processo (FK) | origem |
| Observacao | VARCHAR(999) | Não | Observações gerais | obs |
| StatusId | INT | Sim | Status atual do processo | - |

#### Dados do Empregador (ideEmpregador):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| EmpregadorTipoInscricaoId | INT | Sim | Tipo de inscrição do empregador | tpInsc |
| EmpregadorNumeroInscricao | VARCHAR(14) | Sim | CNPJ/CPF do empregador | nrInsc |
| EmpregadorCodigoIdentificacaoSistema | VARCHAR(20) | Não | Código interno do sistema | - |

#### Dados do Responsável Indireto (ideResp) - OPCIONAL:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| ResponsavelTipoInscricaoId | INT | Não | Tipo de inscrição do responsável | tpInsc |
| ResponsavelNumeroInscricao | VARCHAR(14) | Não | CNPJ/CPF do responsável | nrInsc |

#### Dados do Processo Judicial (infoProcJud) - SE OrigemId = 1:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DataSentenca | DATETIME | Sim* | Data da sentença | dtSent |
| UFVara | VARCHAR(2) | Sim* | UF da vara | ufVara |
| CodigoMunicipio | VARCHAR(7) | Sim* | Código do município | codMunic |
| IdentificadorVara | VARCHAR(50) | Não | Identificador da vara | idVara |

#### Dados do CCP/NINTER (infoCCP) - SE OrigemId = 2 ou 3:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DataCCP | DATETIME | Sim* | Data do acordo CCP/NINTER | dtCCP |
| CNPJCCP | VARCHAR(14) | Não | CNPJ do CCP | cnpjCCP |
| TipoCCP | INT | Não | 1=CCP, 2=NINTER | - |

*Obrigatório conforme a origem do processo

#### Campos de Auditoria:
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| UsuarioInclusao | VARCHAR(200) | Usuário que incluiu o registro | - |
| DataInclusao | DATETIME | Data/hora da inclusão | - |
| UsuarioAlteracao | VARCHAR(200) | Usuário da última alteração | - |
| DataAlteracao | DATETIME | Data/hora da última alteração | - |
| UsuarioEnvioTransmissao | VARCHAR(200) | Usuário que enviou para transmissão | - |
| DataEnvioTransmissao | DATETIME | Data/hora do envio | - |
| UsuarioEnvioTransmissao | VARCHAR(200) | Usuário que enviou para transmissão |
| DataEnvioTransmissao | DATETIME | Data/hora do envio |

#### Constraints Importantes:
- `UQ_ptrab_CadastroProcesso_NumeroProcesso`: Número do processo deve ser único
- `CK_ptrab_CadastroProcesso_DadosJudicial`: Valida dados obrigatórios para processos judiciais
- `CK_ptrab_CadastroProcesso_DadosCCP`: Valida dados obrigatórios para CCP/NINTER

## 3.3 Trabalhadores do Processo

### `ptrab_TrabalhadorProcesso`
**Finalidade**: Array de trabalhadores vinculados ao processo

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| TrabalhadorProcessoId | INT IDENTITY | Sim | Chave primária | - |
| CadastroProcessoId | INT | Sim | FK para o processo (CASCADE DELETE) | - |
| CPF | VARCHAR(11) | Sim | CPF do trabalhador (11 dígitos) | cpfTrab |
| Nome | VARCHAR(70) | Não | Nome do trabalhador | nmTrab |
| DataNascimento | DATETIME | Não | Data de nascimento | dtNascto |
| StatusTrabalhador | INT | Sim | 1=Ativo, 2=Inativo | - |

#### Constraints:
- `UQ_ptrab_TrabalhadorProcesso_Processo_CPF`: CPF único por processo
- `CK_ptrab_TrabalhadorProcesso_CPF`: CPF deve ter 11 dígitos

## 3.4 S-2500: Processo Trabalhista Detalhado

### `ptrab_ProcessoTrabalhista`
**Finalidade**: Detalhamento completo do processo trabalhista por trabalhador (Evento S-2500)

#### Campos de Controle:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| ProcessoTrabalhistaId | INT IDENTITY | Sim | Chave primária | - |
| TrabalhadorProcessoId | INT | Sim | FK para trabalhador (CASCADE DELETE) | - |
| StatusId | INT | Sim | Status do processo | - |

#### Informações do Contrato (infoContr):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| TipoContratoId | INT | Sim | Tipo do contrato | tpContr |
| IndicadorContrato | CHAR(1) | Sim | S=Sim, N=Não | indContr |
| DataAdmissaoOriginal | DATETIME | Não | Data admissão original | dtAdmOrig |
| IndicadorReintegracao | CHAR(1) | Não | S=Sim, N=Não | indReint |
| IndicadorCategoria | CHAR(1) | Não | S=Sim, N=Não | indCateg |
| IndicadorNaturezaAtividade | CHAR(1) | Sim | S=Sim, N=Não | indNatAtiv |
| IndicadorMotivoDesligamento | CHAR(1) | Sim | S=Sim, N=Não | indMotDeslig |
| Matricula | VARCHAR(30) | Não | Matrícula do funcionário | matricula |
| CodigoCategoria | VARCHAR(3) | Não | Categoria do trabalhador | codCateg |
| DataInicioTSVE | DATETIME | Não | Data início TSVE | dtInicio |

#### Informações Complementares (infoCompl):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| CodigoCBO | VARCHAR(6) | Não | Código CBO | codCBO |
| NaturezaAtividade | INT | Não | Natureza da atividade | natAtividade |

#### Remuneração:
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DataRemuneracao | DATETIME | Não | Data da remuneração | dtRemun |
| ValorSalarioFixo | MONEY | Não | Valor do salário fixo | vrSalFx |
| UnidadePagamento | INT | Não | Unidade do salário fixo | undSalFixo |
| DescricaoSalarioVariavel | VARCHAR(999) | Não | Descrição salário variável | dscSalVar |

#### Informações do Vínculo (infoVinc):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| TipoRegimeTrabalhista | INT | Não | 1=CLT, 2=Estatutário | tpRegTrab |
| TipoRegimePrevidenciario | INT | Não | 1=RGPS, 2=RPPS, 3=Exterior, 4=SPSMFA | tpRegPrev |
| DataAdmissao | DATETIME | Não | Data de admissão | dtAdm |
| TipoJornada | INT | Não | Tipo da jornada | tpJornada |

#### Duração do Contrato (duracao):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| TipoDuracao | INT | Não | 1=Indeterminado, 2=Determinado | tpContr |
| DataTermino | DATETIME | Não | Data de término | dtTerm |
| ClausulaAssecuratoria | CHAR(1) | Não | S=Sim, N=Não | clauAssec |
| ObjetoDeterminante | VARCHAR(255) | Não | Objeto determinante | objDet |

#### Sucessão de Vínculo (sucessaoVinc):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| SucessaoTipoInscricao | INT | Não | Tipo inscrição sucessora | tpInsc |
| SucessaoNumeroInscricao | VARCHAR(14) | Não | Número inscrição sucessora | nrInsc |
| SucessaoMatriculaAnterior | VARCHAR(30) | Não | Matrícula anterior | matricAnt |
| SucessaoDataTransferencia | DATETIME | Não | Data transferência | dtTransf |

#### Informações de Desligamento (infoDeslig):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| MotivoDesligamento | VARCHAR(2) | Não | Motivo do desligamento | mtvDeslig |
| DataProjetadaFimAviso | DATETIME | Não | Data projetada fim aviso | dtProjFimAPI |
| TipoPensaoAlimenticia | INT | Não | Tipo pensão alimentícia | tpPensao |
| PercentualAlimenticia | DECIMAL(5,2) | Não | Percentual alimentícia | percAliment |
| ValorAlimenticia | MONEY | Não | Valor alimentícia | vrAlim |

#### Informações de Término TSVE (infoTerm):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DataTerminoTSVE | DATETIME | Não | Data término TSVE | dtTerm |
| MotivoDesligamentoTSV | VARCHAR(2) | Não | Motivo do término | mtvDesligTSV |

#### Mudança de Categoria/Atividade (mudCategAtiv):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| MudancaCategoria | VARCHAR(3) | Não | Código da categoria do trabalhador | codCateg |
| MudancaNaturezaAtividade | INT | Não | Nova natureza da atividade | natAtividade |
| DataMudancaCategoria | DATETIME | Não | Data da mudança de categoria/atividade | dtMudCategAtiv |

#### Campos de Auditoria:
| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| UsuarioInclusao | VARCHAR(200) | Usuário que incluiu o registro | - |
| DataInclusao | DATETIME | Data/hora da inclusão | - |
| UsuarioAlteracao | VARCHAR(200) | Usuário da última alteração | - |
| DataAlteracao | DATETIME | Data/hora da última alteração | - |
| UsuarioEnvioTransmissao | VARCHAR(200) | Usuário que enviou para transmissão | - |
| DataEnvioTransmissao | DATETIME | Data/hora do envio | - |1=Indeterminado, 2=Determinado |
| DataTermino | DATETIME | Não | Data de término |
| ClausulaAssecuratoria | CHAR(1) | Não | S=Sim, N=Não |
| ObjetoDeterminante | VARCHAR(255) | Não | Objeto determinante |

#### Sucessão de Vínculo (sucessaoVinc):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| SucessaoTipoInscricao | INT | Não | Tipo inscrição sucessora | tpInsc |
| SucessaoNumeroInscricao | VARCHAR(14) | Não | Número inscrição sucessora | nrInsc |
| SucessaoMatriculaAnterior | VARCHAR(30) | Não | Matrícula anterior | matricAnt |
| SucessaoDataTransferencia | DATETIME | Não | Data transferência | dtTransf |

#### Informações de Desligamento (infoDeslig):
| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DataDesligamento | DATETIME | Não | data de desligamento do vínculo (último dia trabalhado) | dtDeslig |
| MotivoDesligamento | VARCHAR(2) | Não | Motivo do desligamento | mtvDeslig |
| DataProjetadaFimAviso | DATETIME | Não | Data projetada fim aviso | dtProjFimAPI |
| TipoPensaoAlimenticia | INT | Não | Tipo pensão alimentícia | pensAlim |
| PercentualAlimenticia | DECIMAL(5,2) | Não | Percentual alimentícia | percAliment |
| ValorAlimenticia | MONEY | Não | Valor alimentícia | vrAlim |

## 3.5 Tabelas Complementares S-2500

### `ptrab_UnicidadeContratual`
**Finalidade**: Informações de unicidade contratual (unicContr)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| UnicidadeContratualId | INT IDENTITY | Chave primária | - |
| ProcessoTrabalhistaId | INT | FK processo trabalhista | - |
| MatriculaIncorporada | VARCHAR(30) | Matrícula incorporada | matUnic |
| CodigoCategoria | VARCHAR(3) | Código da categoria | codCateg |
| DataInicio | DATETIME | Data de início | dtInicio |

### `ptrab_EstabelecimentoPagamento`
**Finalidade**: Estabelecimento responsável pelo pagamento (ideEstab)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| EstabelecimentoPagamentoId | INT IDENTITY | Chave primária | - |
| ProcessoTrabalhistaId | INT | FK processo trabalhista | - |
| TipoInscricaoId | INT | Tipo de inscrição | tpInsc |
| NumeroInscricao | VARCHAR(14) | Número da inscrição | nrInsc |

### `ptrab_PeriodoValores`
**Finalidade**: Períodos e valores do processo (infoValores)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| PeriodoValoresId | INT IDENTITY | Chave primária | - |
| EstabelecimentoPagamentoId | INT | FK estabelecimento | - |
| CompetenciaInicio | VARCHAR(7) | Competência inicial (YYYY-MM) | compIni |
| CompetenciaFim | VARCHAR(7) | Competência final (YYYY-MM) | compFim |
| IndicadorRepercussao | INT | Indicador de repercussão | indReperc |
| IndenizacaoSubstitutiva | CHAR(1) | S=Sim, N=Não | indenSD |
| IndenizacaoAbono | CHAR(1) | S=Sim, N=Não | indenAbono |

### `ptrab_AbonoSalarial`
**Finalidade**: Informações de abono salarial (abono)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| AbonoSalarialId | INT IDENTITY | Chave primária | - |
| PeriodoValoresId | INT | FK período valores | - |
| AnoBase | VARCHAR(4) | Ano base do abono | anoBase |

### `ptrab_PeriodoApuracao`
**Finalidade**: Períodos de apuração (idePeriodo)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| PeriodoApuracaoId | INT IDENTITY | Chave primária | - |
| PeriodoValoresId | INT | FK período valores | - |
| PeriodoReferencia | VARCHAR(7) | Período referência (YYYY-MM) | perRef |

### `ptrab_BaseCalculoPrevidencia`
**Finalidade**: Bases de cálculo previdenciárias (basesCp)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| BaseCalculoPrevidenciaId | INT IDENTITY | Chave primária | - |
| PeriodoApuracaoId | INT | FK período apuração | - |
| ValorBaseMensal | MONEY | Valor base mensal | vrBcCpMensal |
| ValorBase13 | MONEY | Valor base 13º | vrBcCp13 |

### `ptrab_AgenteNocivo`
**Finalidade**: Informações de agentes nocivos (infoAgNocivo)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| AgenteNocivoId | INT IDENTITY | Chave primária | - |
| BaseCalculoPrevidenciaId | INT | FK base cálculo previdência | - |
| GrauExposicao | VARCHAR(1) | Grau de exposição (1,2,3,4) | grauExp |

### `ptrab_BaseCalculoFGTS`
**Finalidade**: Bases de cálculo FGTS (infoFGTS)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| BaseCalculoFGTSId | INT IDENTITY | Chave primária | - |
| PeriodoApuracaoId | INT | FK período apuração | - |
| ValorBaseCalculoFGTS | MONEY | Valor base FGTS | vrBcFGTS |
| ValorBaseCalculoFGTSSefip | MONEY | Valor base FGTS SEFIP | vrBcFgtsGuia |
| ValorBaseCalculoFGTSDecAnt | MONEY | Valor base FGTS declaração anterior | vrBcFGTSDecAnt |

### `ptrab_BaseCalculoMudancaCategoria`
**Finalidade**: Bases de cálculo por mudança de categoria (basesRemun)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| BaseCalculoMudancaCategoriaId | INT IDENTITY | Chave primária | - |
| PeriodoApuracaoId | INT | FK período apuração | - |
| CategoriaOriginal | VARCHAR(3) | Categoria original | indCateg |
| ValorBasePrevidenciario | MONEY | Valor base previdenciário | vrBcCpMensal |

## 3.6 S-2501: Tributos Decorrentes

### `ptrab_TributosProcessoHeader`
**Finalidade**: Cabeçalho dos tributos por competência (S-2501)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| TributosProcessoHeaderId | INT IDENTITY | Chave primária | - |
| CadastroProcessoId | INT | FK processo | - |
| CompetenciaPagamento | VARCHAR(7) | Competência pagamento (YYYY-MM) | perApurPgto |
| ObservacoesPagamento | VARCHAR(999) | Observações | obs |
| StatusEnvio | INT | Status do envio | - |

### `ptrab_TributosTrabalhador`
**Finalidade**: Trabalhadores com tributos (ideTrab)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| TributosTrabalhadorId | INT IDENTITY | Chave primária | - |
| TributosProcessoHeaderId | INT | FK header tributos | - |
| TrabalhadorProcessoId | INT | FK trabalhador | - |

### `ptrab_CalculoTributosPeriodo`
**Finalidade**: Cálculos de tributos por período (calcTrib)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| CalculoTributosPeriodoId | INT IDENTITY | Chave primária | - |
| TributosTrabalhadorId | INT | FK tributos trabalhador | - |
| PeriodoReferencia | VARCHAR(7) | Período referência (YYYY-MM) | perRef |
| ValorBaseCalculoMensal | MONEY | Base cálculo mensal | vrBcCpMensal |
| ValorBaseCalculo13 | MONEY | Base cálculo 13º | vrBcCp13 |

### `ptrab_ContribuicaoCodigoReceita`
**Finalidade**: Contribuições por código de receita (infoCRContrib)

| Campo | Tipo | Descrição | CampoXML |
|-------|------|-----------|----------|
| ContribuicaoCodigoReceitaId | INT IDENTITY | Chave primária | - |
| CalculoTributosPeriodoId | INT | FK cálculo tributos | - |
| CodigoReceita | VARCHAR(6) | Código da receita | tpCR |
| ValorContribuicaoMensal | MONEY | Valor contribuição mensal | vrCr |
| ValorContribuicao13 | MONEY | Valor contribuição 13º | vrCr13 |
| ValorTotal | MONEY | Campo calculado (mensal + 13º) | - |

### `ptrab_IRRFCodigoReceita`
**Finalidade**: IRRF por código de receita (infoCRIRRF)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| IRRFCodigoReceitaId | INT IDENTITY | Sim | Chave primária | - |
| TributosTrabalhadorId | INT | Sim | FK tributos trabalhador | - |
| CodigoReceita | VARCHAR(6) | Sim | Código da receita | tpCR |
| ValorIRRF | MONEY | Sim | Valor do IRRF | vrIrrf |

### `ptrab_IRRFComplementar`
**Finalidade**: Informações complementares de IRRF (infoIRComplem)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| IRRFComplementarId | INT IDENTITY | Sim | Chave primária | - |
| TributosTrabalhadorId | INT | Sim | FK tributos trabalhador | - |
| DataLaudo | DATETIME | Não | Data do laudo médico | dtLaudo |
| InformacoesComplementares | VARCHAR(999) | Não | Informações complementares | infComplem |

### `ptrab_PlanoSaude`
**Finalidade**: Informações de planos de saúde (planSaude)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| PlanoSaudeId | INT IDENTITY | Sim | Chave primária | - |
| IRRFComplementarId | INT | Sim | FK IRRF complementar | - |
| CNPJOperadora | VARCHAR(14) | Sim | CNPJ da operadora | cnpjOper |
| RegistroANS | VARCHAR(6) | Não | Registro ANS | regANS |
| ValorSalarioFamilia | MONEY | Não | Valor salário família | vlrSalFam |
| ValorSalarioMaternidade | MONEY | Não | Valor salário maternidade | vlrSalMat |

### `ptrab_DependenteNaoCadastrado`
**Finalidade**: Dependentes não cadastrados (infoDepNaoCad)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DependenteNaoCadastradoId | INT IDENTITY | Sim | Chave primária | - |
| IRRFComplementarId | INT | Sim | FK IRRF complementar | - |
| TipoRendimento | INT | Sim | Tipo de rendimento | tpRend |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep |
| RelacaoParentesco | VARCHAR(2) | Sim | Relação de parentesco | tpDep |
| DescricaoRelacao | VARCHAR(60) | Não | Descrição da relação | descDep |
| DataNascimento | DATETIME | Sim | Data de nascimento | dtNascto |

### `ptrab_ReembolsoMedico`
**Finalidade**: Informações de reembolsos médicos (infoReembMed)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| ReembolsoMedicoId | INT IDENTITY | Sim | Chave primária | - |
| IRRFComplementarId | INT | Sim | FK IRRF complementar | - |
| TipoRendimento | INT | Sim | Tipo de rendimento | tpRend |
| IndicadorReembolso | INT | Sim | Indicador do reembolso | indOrgReemb |
| CNPJOperadora | VARCHAR(14) | Não | CNPJ da operadora | cnpjOper |
| RegistroANS | VARCHAR(6) | Não | Registro ANS | regANS |

### `ptrab_DetalheReembolsoMedico`
**Finalidade**: Detalhes dos reembolsos médicos (detReembMed)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DetalheReembolsoMedicoId | INT IDENTITY | Sim | Chave primária | - |
| ReembolsoMedicoId | INT | Sim | FK reembolso médico | - |
| TipoBeneficiario | INT | Sim | Tipo beneficiário | tpBenef |
| CPFBeneficiario | VARCHAR(11) | Condicional | CPF beneficiário | cpfBenef |
| ValorReembolso | MONEY | Sim | Valor do reembolso | vlrReemb |

### `ptrab_InformacaoMedicaDependente`
**Finalidade**: Informações médicas por dependente (infoDep)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| InformacaoMedicaDependenteId | INT IDENTITY | Sim | Chave primária | - |
| PlanoSaudeId | INT | Sim | FK plano de saúde | - |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep |
| RelacaoParentesco | VARCHAR(2) | Sim | Relação de parentesco | tpDep |
| DescricaoRelacao | VARCHAR(60) | Não | Descrição da relação | descDep |
| DataNascimento | DATETIME | Sim | Data de nascimento | dtNascto |

### `ptrab_InformacaoIRRF`
**Finalidade**: Informações complementares relativas ao IRRF (infoIR)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| InformacaoIRRFId | INT IDENTITY | Sim | Chave primária | - |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | - |
| ValorRendimentoTributavel | MONEY | Não | Valor rendimento tributável | vrRendTrib |
| ValorRendimentoTributavel13 | MONEY | Não | Valor rendimento tributável 13º | vrRendTrib13 |
| ValorRendimentoMolestiGrave | MONEY | Não | Valor rendimento moléstia grave | vrRendMoleGrave |
| ValorRendimentoIsentos65 | MONEY | Não | Valor rendimento isentos 65 anos | vrRendIsen65 |
| ValorJurosMora | MONEY | Não | Valor juros de mora | vrJurosMora |
| ValorRendimentoIsentoNaoTributavel | MONEY | Não | Valor rendimento isento não tributável | vrRendIsenNTrib |
| DescricaoIsentoNaoTributavel | VARCHAR(60) | Não | Descrição isento não tributável | descIsenNTrib |
| ValorPrevidenciaOficial | MONEY | Não | Valor previdência oficial | vrPrevOficial |
| ValorRendimentoPensaoAlim | MONEY | Não | Valor rendimento pensão alimentícia | vrRendPensAlim |
| ValorRendimentoAposentadoria | MONEY | Não | Valor rendimento aposentadoria | vrRendAposentadoria |
| ValorRendimentoBolsaEstudo | MONEY | Não | Valor rendimento bolsa estudo | vrRendBolsaEst |
| ValorRendimentoAuxilio | MONEY | Não | Valor rendimento auxílio | vrRendAuxilio |
| ValorRendimentoOutros | MONEY | Não | Valor rendimento outros | vrRendOutros |
| DescricaoRendimentoOutros | VARCHAR(60) | Não | Descrição rendimento outros | descRendOutros |
| ValorDeducaoPrevidenciaria | MONEY | Não | Valor dedução previdenciária | vrDedutPrevidOfic |
| ValorDeducaoFAPI | MONEY | Não | Valor dedução FAPI | vrDedutFAPI |
| ValorRendimentoPensaoTitular | MONEY | Não | Valor rendimento pensão titular | vrRendPensTit |

### `ptrab_RendimentosRRA`
**Finalidade**: Rendimentos recebidos acumuladamente (infoRRA)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| RendimentosRRAId | INT IDENTITY | Sim | Chave primária | - |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | - |
| DescricaoRRA | VARCHAR(50) | Sim | Descrição RRA | descRRA |
| QuantidadeMesesRRA | INT | Sim | Quantidade meses RRA | qtdMesesRRA |

### `ptrab_DespesasProcessoJudicial`
**Finalidade**: Despesas de processo judicial (despProcJud)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DespesasProcessoJudicialId | INT IDENTITY | Sim | Chave primária | - |
| RendimentosRRAId | INT | Sim | FK rendimentos RRA | - |
| ValorDespesasCustas | MONEY | Sim | Valor despesas custas | vlrDespCustas |
| ValorDespesasAdvogados | MONEY | Sim | Valor despesas advogados | vlrDespAdv |

### `ptrab_AdvogadosRRA`
**Finalidade**: Identificação dos advogados (ideAdv)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| AdvogadosRRAId | INT IDENTITY | Sim | Chave primária | - |
| RendimentosRRAId | INT | Sim | FK rendimentos RRA | - |
| TipoInscricaoId | INT | Sim | Tipo de inscrição | tpInsc |
| NumeroInscricao | VARCHAR(14) | Sim | Número da inscrição | nrInsc |
| ValorDespesaAdvogado | MONEY | Não | Valor despesa advogado | vlrAdv |

### `ptrab_DeducaoDependentes`
**Finalidade**: Dedução de dependentes (dedDepen)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DeducaoDependentesId | INT IDENTITY | Sim | Chave primária | - |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | - |
| TipoRendimento | INT | Sim | Tipo rendimento | tpRend |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep |
| ValorDeducao | MONEY | Sim | Valor da dedução | vlrDedDep |

### `ptrab_PensaoAlimenticia`
**Finalidade**: Pensão alimentícia (penAlim)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| PensaoAlimenticiaId | INT IDENTITY | Sim | Chave primária | - |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | - |
| TipoRendimento | INT | Sim | Tipo rendimento | tpRend |
| CPFBeneficiario | VARCHAR(11) | Sim | CPF do beneficiário | cpfBenef |
| ValorPensao | MONEY | Sim | Valor da pensão | vlrPensao |

### `ptrab_ProcessoRetencao`
**Finalidade**: Processos de retenção (infoProcRet)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| ProcessoRetencaoId | INT IDENTITY | Sim | Chave primária | - |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | - |
| TipoProcesso | INT | Sim | Tipo processo (1=Administrativo, 2=Judicial) | tpProcRet |
| NumeroProcesso | VARCHAR(21) | Sim | Número do processo | nrProcRet |
| CodigoSuspensao | VARCHAR(14) | Não | Código de suspensão | codSusp |
| IndicadorSuspensao | VARCHAR(2) | Não | Indicador de suspensão | indSusp |

### `ptrab_ValoresRetencao`
**Finalidade**: Valores de retenção (infoValores)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| ValoresRetencaoId | INT IDENTITY | Sim | Chave primária | - |
| ProcessoRetencaoId | INT | Sim | FK processo retenção | - |
| IndicadorApuracao | INT | Sim | Indicador apuração (1=Mensal, 2=Anual) | indApuracao |
| ValorNaoRetido | MONEY | Não | Valor não retido | vlrNRetido |
| ValorDepositoJudicial | MONEY | Não | Valor depósito judicial | vlrDepJud |
| ValorCompetenciaAnoCivil | MONEY | Não | Valor competência ano civil | vlrCmpAnoCivil |
| ValorCompetenciaAnoAnterior | MONEY | Não | Valor competência ano anterior | vlrCmpAnoAnt |
| ValorRendimentoSuspenso | MONEY | Não | Valor rendimento suspenso | vlrRendSusp |

### `ptrab_DeducoesSuspensas`
**Finalidade**: Deduções suspensas (dedSusp)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| DeducoesSuspensasId | INT IDENTITY | Sim | Chave primária | - |
| ProcessoRetencaoId | INT | Sim | FK processo retenção | - |
| IndicadorTipoDeducao | INT | Sim | Indicativo do tipo de dedução (1 - Previdência oficial, 5 - Pensão alimentícia, 7 - Dependentes) | indTpDeducao |
| ValorDeducaoSuspensa | MONEY | Sim | Valor dedução suspensa | vlrDedSusp |

### `ptrab_BeneficiariosPensaoSuspensa`
**Finalidade**: Beneficiários de pensão suspensa (benefPen)

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| BeneficiariosPensaoSuspensaId | INT IDENTITY | Sim | Chave primária | - |
| DeducoesSuspensasId | INT | Sim | FK deduções suspensas | - |
| CPFBeneficiario | VARCHAR(11) | Sim | CPF do beneficiário | cpfBenef |
| ValorDependenteSuspenso | MONEY | Sim | Valor dependente suspenso | vlrDepenSusp |

### `ptrab_InfoDepNaoCadastrado`
**Finalidade**: Informações de dependentes não cadastrados pelo S-2200/S-2205/S-2300.

| Campo | Tipo | Obrigatório | Descrição | CampoXML |
|-------|------|-------------|-----------|----------|
| InfoDepNaoCadastradoId | INT IDENTITY | Sim | Chave primária | - |
| IRRFComplementarId | INT | Sim | FK IRRF complementar | - |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep |
| NomeDependente | VARCHAR(70) | Sim | Nome do dependente | nome |
| DataNascimento | MONEY | Sim | data de nascimento do dependente | dtNascto |
| DependenteIRRF | VARCHAR(1) | Não | Somente informar se dependente para fins de dedução de seu rendimento tributável pelo Imposto de Renda  | depIRRF |
| TipoDependente | VARCHAR(2) | Sim | Tipo de dependente  | tpDep |
| DescricaoDependente | VARCHAR(60) | Não | descrição da dependência ( Informação obrigatória e exclusiva se {tpDep} = 99.).  | descrDep |

## 4. Relacionamentos e Integridade

### 4.1 Cascade Delete
O sistema utiliza CASCADE DELETE nos seguintes relacionamentos:
- `ptrab_TrabalhadorProcesso` → `ptrab_CadastroProcesso`
- `ptrab_ProcessoTrabalhista` → `ptrab_TrabalhadorProcesso`
- Todas as tabelas filhas seguem o mesmo padrão

### 4.2 Constraints de Integridade
- **Unicidade**: Número do processo, CPF por processo, competência por processo
- **Validação de Dados**: CPF com 11 dígitos, UF com 2 caracteres, competências no formato YYYY-MM
- **Valores Monetários**: Todos os valores monetários devem ser >= 0
- **Dados Condicionais**: Validação automática de campos obrigatórios por origem do processo

### 4.3 Índices de Performance
- Índices em chaves estrangeiras para otimizar JOINs
- Índices compostos para consultas frequentes
- Índices em campos de busca (CPF, número do processo, competências)

## 5. Auditoria e Controle

### 5.1 Campos de Auditoria
Todas as tabelas principais possuem:
- `UsuarioInclusao` / `DataInclusao`
- `UsuarioAlteracao` / `DataAlteracao`

### 5.2 Controle de Status
- Status centralizados na tabela `ptrab_Status`
- Controle de fluxo desde cadastro até transmissão
- Rastreabilidade completa do processo

## 6. Considerações de Transmissão

### 6.1 Transmissão Individual
- Cada trabalhador é transmitido separadamente
- Mesmo processo pode ter múltiplas transmissões
- Controle individual de status por trabalhador

### 6.2 Competências S-2501
- Uma competência por transmissão S-2501
- Múltiplos trabalhadores por competência
- Relacionamento direto com S-2500 correspondente

### 6.3 Validações de Negócio
- Processo deve existir antes dos trabalhadores
- S-2500 deve existir antes do S-2501
- Competências devem estar dentro do período do processo
