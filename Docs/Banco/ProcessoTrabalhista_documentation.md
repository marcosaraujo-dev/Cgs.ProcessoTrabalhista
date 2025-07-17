**Documentação Completa do Sistema eSocial - Processos Trabalhistas**

**Eventos S-2500 (Processo Trabalhista) e S-2501 (Tributos Decorrentes)**

**1\. Visão Geral do Sistema**

Este sistema foi desenvolvido para gerenciar os cadastros e transmissões dos eventos S-2500 (Processo Trabalhista) e S-2501 (Tributos Decorrentes de Processo Trabalhista) do eSocial.

**Funcionalidades Principais:**

- **Cadastro de Processos**: Registro dos dados básicos do processo trabalhista
- **Gestão de Trabalhadores**: Vinculação de trabalhadores aos processos
- **Detalhamento Contratual**: Informações detalhadas do contrato de trabalho (S-2500)
- **Cálculo de Tributos**: Gestão dos tributos decorrentes do processo (S-2501)
- **Transmissão Individual**: Envio por trabalhador, mesmo em processos com múltiplos funcionários

**2\. Estruturas Hierárquicas dos Dados**

**2.1 Estrutura S-2500 (Processo Trabalhista)**

ptrab_CadastroProcesso (nrProcTrab)
└── ptrab_ProcessoTrabalhista (ideTrab)
    └── ptrab_InformacaoContrato (infoContr)
        ├── ptrab_UnicidadeContratual (unicContr)
        └── ptrab_EstabelecimentoPagamento (ideEstab)
            └── ptrab_PeriodoValores (infoValores)
                ├── ptrab_AbonoSalarial (abono)
                └── ptrab_PeriodoApuracao (idePeriodo)
                    ├── ptrab_BaseCalculoPrevidencia (basesCp)
                    │   └── ptrab_AgenteNocivo (infoAgNocivo)
                    ├── ptrab_BaseCalculoFGTS (infoFGTS)
                    ├── ptrab_BaseCalculoMudancaCategoria (baseMudCateg)
                    └── ptrab_infoIntermitente (infoInterm)

**2.2 Estrutura S-2501 (Tributos Decorrentes)**

ptrab_CadastroProcesso (processo base)
└── ptrab_TributosProcessoHeader (perApurPgto)
    └── ptrab_TributosTrabalhador (ideTrab)
        ├── ptrab_CalculoTributosPeriodo (calcTrib)
        │   └── ptrab_ContribuicaoCodigoReceita (infoCRContrib)
        ├── ptrab_IRRFCodigoReceita (infoCRIRRF)
        │   ├── ptrab_InformacaoIRRF (infoIR)
        │   ├── ptrab_RendimentosRRA (infoRRA)
        │   │   ├── ptrab_DespesasProcessoJudicial (despProcJud)
        │   │   └── ptrab_AdvogadosRRA (ideAdv)
        │   ├── ptrab_DeducaoDependentes (dedDepen)
        │   ├── ptrab_PensaoAlimenticia (penAlim)
        │   └── ptrab_ProcessoRetencao (infoProcRet)
        │       ├── ptrab_ValoresRetencao (infoValores)
        │       └── ptrab_DeducoesSuspensas (dedSusp)
        │           └── ptrab_BeneficiariosPensaoSuspensa (benefPen)
        └── ptrab_IRRFComplementar (infoIRComplem)
            └── ptrab_InfoDepNaoCadastrado (infoDep)

**3\. Documentação Detalhada das Tabelas**

**3.1 Tabelas de Domínio (Lookup)**

**ptrab_status**

**Finalidade**: Controla os status dos registros no sistema

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| StatusId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| Codigo | VARCHAR(50) | Sim | Código do status | \-  | Controle Interno | EM_PREENCHIMENTO, ATIVO, etc. |
| Descricao | VARCHAR(100) | Sim | Descrição legível do status | \-  | Controle Interno | Descrição amigável |
| Tipo | VARCHAR(40) | Sim | Tipo do status | \-  | Controle Interno | GERAL, PROCESSO, Trabalhador, IRRF |

**ptrab_TipoInscricao**

**Finalidade**: Define os tipos de inscrição (CNPJ, CPF, CAEPF, CNO, CGC, CEI)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoInscricaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoInscricaoCodigo | INT | Sim | Código numérico | tpInsc | ideEmpregador/ideResp/ideEstab/ideAdv | 1=CNPJ, 2=CPF, 3=CAEPF, 4=CNO, 5=CGC, 6=CEI |
| Descricao | VARCHAR(50) | Sim | Descrição do tipo | \-  | Controle Interno | Descrição do tipo de inscrição |

**ptrab_TipoOrigem**

**Finalidade**: Define a origem do processo trabalhista

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoOrigemId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| OrigemCodigo | INT | Sim | Código da origem | origem | evtProcTrab (raiz) | 1=Processo judicial, 2=Demanda CCP/NINTER |
| Descricao | VARCHAR(100) | Sim | Descrição da origem | \-  | Controle Interno | Descrição da origem |

**ptrab_TipoCCP**

**Finalidade**: Indicar o âmbito de celebração do acordo CCP

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoCCPId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CCPCodigo | INT | Sim | Código do tipo CCP | tpCCP | infoCCP | 1=CCP empresa, 2=CCP sindicato, 3=NINTER |
| Descricao | VARCHAR(100) | Sim | Descrição do tipo | \-  | Controle Interno | Descrição do âmbito |

**ptrab_TipoContrato**

**Finalidade**: Tipos de contrato de trabalho

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoContratoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| ContratoCodigo | INT | Sim | Código do tipo de contrato | tpContr | infoContr | 1 a 9 conforme manual eSocial |
| Descricao | VARCHAR(300) | Sim | Descrição do contrato | \-  | Controle Interno | Descrição detalhada |

**ptrab_TipoNaturezaAtividade**

**Finalidade**: Natureza da atividade (urbana/rural)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoNaturezaAtividadeId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| NaturezaAtividadeCodigo | INT | Sim | Código da natureza | natAtividade | infoCompl | 1=Trabalho Urbano, 2=Trabalho Rural |
| Descricao | VARCHAR(100) | Sim | Descrição da natureza | \-  | Controle Interno | Descrição da atividade |

**ptrab_TipoUnidadePagamento**

**Finalidade**: Unidade de pagamento do salário fixo

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoUnidadePagamentoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoUnidadePagamentoCodigo | INT | Sim | Código da unidade | undSalFixo | infoCompl/remuneracao | 1=Por Hora, 2=Por Dia, etc. |
| Descricao | VARCHAR(100) | Sim | Descrição da unidade | \-  | Controle Interno | Descrição da periodicidade |

**ptrab_TipoRegimeTrabalhista**

**Finalidade**: Regime trabalhista (CLT/Estatutário)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoRegimeTrabalhistaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoRegimeTrabalhistaCodigo | INT | Sim | Código do regime | tpRegTrab | infoVinc | 1=CLT, 2=Estatutário |
| Descricao | VARCHAR(250) | Sim | Descrição do regime | \-  | Controle Interno | Descrição detalhada |

**ptrab_TipoRegimePrevidenciario**

**Finalidade**: Regime previdenciário

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoRegimePrevidenciarioId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoRegimePrevidenciarioCodigo | INT | Sim | Código do regime | tpRegPrev | infoVinc | 1=RGPS, 2=RPPS, 3=Exterior |
| Descricao | VARCHAR(250) | Sim | Descrição do regime | \-  | Controle Interno | Descrição detalhada |

**ptrab_TipoContratoTempoParcial**

**Finalidade**: Tipo de contrato em tempo parcial

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoContratoTempoParcialId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoContratoTempoParcialCodigo | INT | Sim | Código do tipo | tmpParc | infoVinc | 0=Não é tempo parcial, 1=25h, 2=30h, 3=36h |
| Descricao | VARCHAR(100) | Sim | Descrição do tipo | \-  | Controle Interno | Descrição das horas |

**ptrab_TipoDuracaoContrato**

**Finalidade**: Duração do contrato de trabalho

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoDuracaoContratoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoDuracaoContratoCodigo | INT | Sim | Código da duração | tpContr | duracao | 1=Indeterminado, 2=Determinado dias, 3=Vinculado fato |
| Descricao | VARCHAR(100) | Sim | Descrição da duração | \-  | Controle Interno | Descrição do tipo |

**esoc_MotivoDesligamento**

**Finalidade**: Motivos de desligamento (Tabela 19 eSocial)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| MotivoDesligamentoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| MotivoDesligamentoCodigo | VARCHAR(3) | Sim | Código do motivo | mtvDeslig | infoDeslig | Conforme Tabela 19 eSocial |
| Descricao | VARCHAR(400) | Sim | Descrição do motivo | \-  | Controle Interno | Descrição detalhada |
| DataInicio | DATE | Sim | Data início vigência | \-  | Controle Interno | Controle temporal |
| DataTermino | DATE | Não | Data fim vigência | \-  | Controle Interno | Controle temporal |

**ptrab_TipoPensaoAlimenticia**

**Finalidade**: Tipos de pensão alimentícia

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoPensaoAlimenticiaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoPensaoAlimenticiaC |     |     |     |     |     |     |

ódigo | INT | Sim | Código do tipo | pensAlim | infoDeslig | 0=Não existe, 1=Percentual, 2=Valor, 3=Ambos | | Descricao | VARCHAR(70) | Sim | Descrição do tipo | - | Controle Interno | Descrição do tipo |

**ptrab_TipoMotivoDesligamentoTSV**

**Finalidade**: Motivos de desligamento TSVE

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoMotivoDesligamentoTSVId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoMotivoDesligamentoTSVCodigo | VARCHAR(2) | Sim | Código do motivo | mtvDesligTSV | infoTerm | 01 a 99 conforme manual |
| Descricao | VARCHAR(300) | Sim | Descrição do motivo | \-  | Controle Interno | Descrição detalhada |

**esoc_Categoria**

**Finalidade**: Categorias de trabalhador (Tabela 01 eSocial)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CategoriaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CategoriaCodigo | INT | Sim | Código da categoria | codCateg | Diversos grupos | Conforme Tabela 01 eSocial |
| Descricao | VARCHAR(400) | Sim | Descrição da categoria | \-  | Controle Interno | Descrição detalhada |
| Inicio | DATE | Sim | Data início vigência | \-  | Controle Interno | Controle temporal |
| Termino | DATE | Não | Data fim vigência | \-  | Controle Interno | Controle temporal |

**ptrab_TipoIndicativoRepercussao**

**Finalidade**: Indicativo de repercussão do processo

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoIndicativoRepercussaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoIndicativoRepercussaoCodigo | INT | Sim | Código do indicativo | indReperc | infoValores | 1=Com repercussão, 2=Sem repercussão, 3=Exclusivo IR |
| Descricao | VARCHAR(200) | Sim | Descrição do indicativo | \-  | Controle Interno | Descrição detalhada |

**esoc_CodigoReceitaReclamatoriaTrabalhista**

**Finalidade**: Códigos de receita para reclamatória trabalhista (Tabela 29)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CodigoReceitaReclamatoriaTrabalhistaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CodigoReceitaReclamatoriaTrabalhistaCodigo | VARCHAR(6) | Sim | Código da receita | tpCR | infoCRContrib | Conforme Tabela 29 eSocial |
| Descricao | VARCHAR(350) | Sim | Descrição da receita | \-  | Controle Interno | Descrição detalhada |
| Aliquota | VARCHAR(100) | Sim | Alíquota aplicável | \-  | Controle Interno | Informação da alíquota |

**esoc_TipoCodigoReceitaIRRF**

**Finalidade**: Códigos de receita para IRRF

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoCodigoReceitaIRRF | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CodigoReceitaIRRF | VARCHAR(6) | Sim | Código da receita | tpCR | infoCRIRRF | Códigos específicos IRRF |
| Descricao | VARCHAR(100) | Sim | Descrição da receita | \-  | Controle Interno | Descrição da receita |

**ptrab_TipoRendimento**

**Finalidade**: Tipos de rendimento para IRRF

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoRendimentoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoRendimentoCodigo | INT | Sim | Código do rendimento | tpRend | dedDepen/penAlim | 11=Mensal, 12=13º, 18=RRA, etc. |
| Descricao | VARCHAR(100) | Sim | Descrição do rendimento | \-  | Controle Interno | Descrição do tipo |

**ptrab_TipoProcesso**

**Finalidade**: Tipos de processo (administrativo/judicial)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoProcessoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoProcessoCodigo | INT | Sim | Código do tipo | tpProcRet | infoProcRet | 1=Administrativo, 2=Judicial |
| Descricao | VARCHAR(40) | Sim | Descrição do tipo | \-  | Controle Interno | Descrição do processo |

**esoc_IndicativoSuspensao**

**Finalidade**: Indicativo de suspensão da exigibilidade

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| IndicativoSuspensaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IndicativoSuspensaoCodigo | VARCHAR(2) | Sim | Código da suspensão | codSusp | infoProcRet | 01 a 92 conforme tabela |
| Descricao | VARCHAR(150) | Sim | Descrição da suspensão | \-  | Controle Interno | Descrição detalhada |

**esoc_TipoDependente**

**Finalidade**: Tipos de dependente (Tabela 07 eSocial)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoDependenteId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoDependenteCodigo | VARCHAR(2) | Sim | Código do dependente | tpDep | infoDep | Conforme Tabela 07 eSocial |
| Descricao | VARCHAR(250) | Sim | Descrição do dependente | \-  | Controle Interno | Descrição detalhada |
| DataInicio | DATE | Sim | Data início vigência | \-  | Controle Interno | Controle temporal |
| DataTermino | DATE | Não | Data fim vigência | \-  | Controle Interno | Controle temporal |

**ptrab_TipoIndicativoApuracao**

**Finalidade**: Indicativo de apuração (mensal/anual)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoIndicativoApuracaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoIndicativoApuracaoCodigo | INT | Sim | Código da apuração | indApuracao | infoValores (retenção) | 1=Mensal, 2=Anual |
| Descricao | VARCHAR(50) | Sim | Descrição da apuração | \-  | Controle Interno | Descrição do tipo |

**ptrab_TipoInfoAgNocivo**

**Finalidade**: Informações de agentes nocivos

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoInfoAgNocivoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TipoInfoAgNocivoCodigo | INT | Sim | Código do agente | grauExp | infoAgNocivo | 1=Não nocivo, 2=FAE15_12%, 3=FAE20_09%, 4=FAE25_06% |
| Descricao | VARCHAR(150) | Sim | Descrição do agente | \-  | Controle Interno | Descrição detalhada |

**3.2 Tabela Principal - Cadastro de Processos**

**ptrab_CadastroProcesso**

**Finalidade**: Tabela raiz que armazena os dados básicos do processo trabalhista

**Campos Principais:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CadastroProcessoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| NumeroProcesso | VARCHAR(20) | Sim | Número único do processo | nrProcTrab | evtProcTrab (raiz) | Identificador único |
| TipoOrigemId | INT | Sim | Origem do processo | origem | evtProcTrab (raiz) | FK ptrab_TipoOrigem → OrigemCodigo |
| Observacao | VARCHAR(999) | Não | Observações gerais | obs | evtProcTrab (raiz) | Observações livres |
| StatusId | INT | Sim | Status atual do processo | \-  | Controle Interno | FK ptrab_status → StatusId |

**Dados do Empregador (ideEmpregador):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| EmpregadorTipoInscricaoId | INT | Sim | Tipo de inscrição do empregador | tpInsc | ideEmpregador | FK ptrab_TipoInscricao → TipoInscricaoCodigo |
| EmpregadorNumeroInscricao | VARCHAR(14) | Sim | CNPJ/CPF do empregador | nrInsc | ideEmpregador | 8 a 14 dígitos |
| EmpregadorCodigoIdentificacaoSistema | VARCHAR(20) | Não | Código interno do sistema | \-  | Controle Interno | Controle interno |

**Dados do Responsável Indireto (ideResp) - OPCIONAL:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| ResponsavelTipoInscricaoId | INT | Não | Tipo de inscrição do responsável | tpInsc | ideResp | FK ptrab_TipoInscricao → TipoInscricaoCodigo |
| ResponsavelNumeroInscricao | VARCHAR(14) | Não | CNPJ/CPF do responsável | nrInsc | ideResp | 8 a 14 dígitos |

**Dados do Processo Judicial (infoProcJud) - SE TipoOrigemId = 1:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DataSentenca | DATETIME | Sim\* | Data da sentença | dtSent | infoProcJud | Obrigatório para processo judicial |
| UFVara | VARCHAR(2) | Sim\* | UF da vara | ufVara | infoProcJud | 2 caracteres - sigla UF |
| CodigoMunicipio | VARCHAR(7) | Sim\* | Código do município | codMunic | infoProcJud | Código IBGE |
| IdentificadorVara | VARCHAR(50) | Não | Identificador da vara | idVara | infoProcJud | Identificação da vara |

**Dados do CCP/NINTER (infoCCP) - SE TipoOrigemId = 2:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DataCCP | DATETIME | Sim\* | Data do acordo CCP/NINTER | dtCCP | infoCCP | Obrigatório para CCP/NINTER |
| CNPJCCP | VARCHAR(14) | Não | CNPJ do CCP | cnpjCCP | infoCCP | CNPJ do órgão CCP |
| TipoCCPId | INT | Não | Tipo do CCP | tpCCP | infoCCP | FK ptrab_TipoCCP → CCPCodigo |

**Campos de Auditoria:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| UsuarioInclusao | VARCHAR(200) | Sim | Usuário que incluiu o registro | \-  | Controle Interno | Auditoria |
| DataInclusao | DATETIME | Sim | Data/hora da inclusão | \-  | Controle Interno | GETDATE() automático |
| UsuarioAlteracao | VARCHAR(200) | Não | Usuário da última alteração | \-  | Controle Interno | Auditoria |
| DataAlteracao | DATETIME | Não | Data/hora da última alteração | \-  | Controle Interno | Auditoria |
| UsuarioEnvioTransmissao | VARCHAR(200) | Não | Usuário que enviou para transmissão | \-  | Controle Interno | Controle transmissão |
| DataEnvioTransmissao | DATETIME | Não | Data/hora do envio | \-  | Controle Interno | Controle transmissão |

**3.3 Trabalhadores do Processo**

**ptrab_ProcessoTrabalhista**

**Finalidade**: Array de trabalhadores vinculados ao processo

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| ProcessoTrabalhistaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CadastroProcessoId | INT | Sim | FK para o processo | \-  | Controle Interno | FK ptrab_CadastroProcesso → CadastroProcessoId |
| CPF | VARCHAR(11) | Sim | CPF do trabalhador | cpfTrab | ideTrab | 11 dígitos obrigatório |
| Nome | VARCHAR(70) | Não | Nome do trabalhador | nmTrab | ideTrab | Nome completo |
| DataNascimento | DATETIME | Não | Data de nascimento | dtNascto | ideTrab | Data nascimento |
| ideSeqTrab | INT | Não | Sequencial do trabalhador | ideSeqTrab | ideTrab | Sequencial por processo |

**Campos de Auditoria:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| UsuarioInclusao | VARCHAR(200) | Sim | Usuário que incluiu | \-  | Controle Interno | Auditoria |
| DataInclusao | DATETIME | Sim | Data/hora inclusão | \-  | Controle Interno | Automático |
| UsuarioAlteracao | VARCHAR(200) | Não | Usuário alteração | \-  | Controle Interno | Auditoria |
| DataAlteracao | DATETIME | Não | Data/hora alteração | \-  | Controle Interno | Auditoria |
| UsuarioEnvioTransmissao | VARCHAR(200) | Não | Usuário Envio Transmissão | \-  | Controle Interno | Auditoria |
| DataEnvioTransmissao | DATETIME | Não | Data/hora envio Transmissão | \-  | Controle Interno | Auditoria |
|     |     |     |     |     |     |     |

**3.4 S-2500: Processo Trabalhista Detalhado**

**ptrab_InformacaoContrato**

**Finalidade**: Detalhamento completo do processo trabalhista por trabalhador (Evento S-2500)

**Campos de Controle:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| InformacaoContratoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| ProcessoTrabalhistaId | INT | Sim | FK para trabalhador | \-  | Controle Interno | FK ptrab_ProcessoTrabalhista → ProcessoTrabalhistaId |
| StatusId | INT | Sim | Status do processo | \-  | Controle Interno | FK ptrab_status → StatusId |

**Informações do Contrato (infoContr):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoContratoId | INT | Sim | Tipo do contrato | tpContr | infoContr | FK ptrab_TipoContrato → ContratoCodigo |
| IndicadorContrato | CHAR(1) | Sim | Alteração contrato | indContr | infoContr | S=Sim, N=Não |
| DataAdmissaoOriginal | DATETIME | Não | Data admissão original | dtAdmOrig | infoContr | Data admissão original do vínculo |
| IndicadorReintegracao | CHAR(1) | Não | Reintegração/readmissão | indReint | infoContr | S=Sim, N=Não |
| IndicadorCategoria | CHAR(1) | Não | Alteração categoria | indCateg | infoContr | S=Sim, N=Não |
| IndicadorNaturezaAtividade | CHAR(1) | Sim | Alteração natureza atividade | indNatAtiv | infoContr | S=Sim, N=Não |
| IndicadorMotivoDesligamento | CHAR(1) | Sim | Alteração motivo desligamento | indMotDeslig | infoContr | S=Sim, N=Não |
| Matricula | VARCHAR(30) | Não | Matrícula do funcionário | matricula | infoContr | Matrícula do trabalhador |
| CategoriaId | INT | Não | Categoria do trabalhador | codCateg | infoContr | FK esoc_Categoria → CategoriaCodigo |
| DataInicioTSVE | DATETIME | Não | Data início TSVE | dtInicio | infoContr | Para TSVE sem vínculo |

**Informações Complementares (infoCompl):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CodigoCBO | VARCHAR(6) | Não | Código CBO | codCBO | infoCompl | Classificação Brasileira de Ocupações |
| TipoNaturezaAtividadeId | INT | Não | Natureza da atividade | natAtividade | infoCompl | FK ptrab_TipoNaturezaAtividade → NaturezaAtividadeCodigo |

**Remuneração:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DataRemuneracao | DATETIME | Não | Data da remuneração | dtRemun | infoCompl/remuneracao | Data base da remuneração |
| ValorSalarioFixo | MONEY | Não | Valor do salário fixo | vrSalFx | infoCompl/remuneracao | Valor em moeda corrente |
| TipoUnidadePagamentoId | INT | Não | Unidade do salário fixo | undSalFixo | infoCompl/remuneracao | FK ptrab_TipoUnidadePagamento → TipoUnidadePagamentoCodigo |
| DescricaoSalarioVariavel | VARCHAR(999) | Não | Descrição salário variável | dscSalVar | infoCompl/remuneracao | Descrição do salário variável |

**Informações do Vínculo (infoVinc):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoRegimeTrabalhistaId | INT | Não | Regime trabalhista | tpRegTrab | infoVinc | FK ptrab_TipoRegimeTrabalhista → TipoRegimeTrabalhistaCodigo |
| TipoRegimePrevidenciarioId | INT | Não | Regime previdenciário | tpRegPrev | infoVinc | FK ptrab_TipoRegimePrevidenciario → TipoRegimePrevidenciarioCodigo |
| DataAdmissao | DATETIME | Não | Data de admissão | dtAdm | infoVinc | Data de admissão |
| TipoContratoTempoParcialId | INT | Não | Tipo de contrato em tempo parcial | tmpParc | infoVinc | FK TipoContratoTempoParcial →  TipoContratoTempoParcialCodigo|

**Duração do Contrato (duracao):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TipoDuracaoContratoId | INT | Não | Tipo duração contrato | tpContr | duracao | FK ptrab_TipoDuracaoContrato → TipoDuracaoContratoCodigo |
| DataTermino | DATETIME | Não | Data de término | dtTerm | duracao | Data término contrato |
| ClausulaAssecuratoria | CHAR(1) | Não | Cláusula assecuratória | clauAssec | duracao | S=Sim, N=Não |
| ObjetoDeterminante | VARCHAR(255) | Não | Objeto determinante | objDet | duracao | Descrição do objeto |

**Sucessão de Vínculo (sucessaoVinc):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| SucessaoTipoInscricaoId | INT | Não | Tipo inscrição sucessora | tpInsc | sucessaoVinc | FK ptrab_TipoInscricao → TipoInscricaoCodigo |
| SucessaoNumeroInscricao | VARCHAR(14) | Não | Número inscrição sucessora | nrInsc | sucessaoVinc | CNPJ/CPF sucessora |
| SucessaoMatriculaAnterior | VARCHAR(30) | Não | Matrícula anterior | matricAnt | sucessaoVinc | Matrícula na empresa anterior |
| SucessaoDataTransferencia | DATETIME | Não | Data transferência | dtTransf | sucessaoVinc | Data da transferência |

**Informações de Desligamento (infoDeslig):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DataDesligamento | DATETIME | Não | Data de desligamento | dtDeslig | infoDeslig | Último dia trabalhado |
| MotivoDesligamentoId | INT | Não | Motivo do desligamento | mtvDeslig | infoDeslig | FK esoc_MotivoDesligamento → MotivoDesligamentoCodigo |
| DataProjetadaFimAviso | DATETIME | Não | Data projetada fim aviso | dtProjFimAPI | infoDeslig | Data fim aviso prévio |
| TipoPensaoAlimenticiaId | INT | Não | Tipo pensão alimentícia | pensAlim | infoDeslig | FK ptrab_TipoPensaoAlimenticia → TipoPensaoAlimenticiaC |

ódigo | | PercentualAlimenticia | DECIMAL(5,2) | Não | Percentual alimentícia | percAliment | infoDeslig | Percentual da pensão | | ValorAlimenticia | MONEY | Não | Valor alimentícia | vrAlim | infoDeslig | Valor fixo da pensão |

**Informações de Término TSVE (infoTerm):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DataTerminoTSVE | DATETIME | Não | Data término TSVE | dtTerm | infoTerm | Data término TSVE |
| TipoMotivoDesligamentoTSVId | INT | Não | Motivo do término TSVE | mtvDesligTSV | infoTerm | FK ptrab_TipoMotivoDesligamentoTSV → TipoMotivoDesligamentoTSVCodigo |

**Mudança de Categoria/Atividade (mudCategAtiv):**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CategoriaIdMudanca | INT | Não | Nova categoria | codCateg | mudCategAtiv | FK esoc_Categoria → CategoriaCodigo |
| TipoNaturezaAtividadeIdMudanca | INT | Não | Nova natureza atividade | natAtividade | mudCategAtiv | FK ptrab_TipoNaturezaAtividade → NaturezaAtividadeCodigo |
| DataMudancaCategoria | DATETIME | Não | Data mudança categoria | dtMudCategAtiv | mudCategAtiv | Data da mudança |

**Campos de Auditoria:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| UsuarioInclusao | VARCHAR(200) | Sim | Usuário que incluiu | \-  | Controle Interno | Auditoria |
| DataInclusao | DATETIME | Sim | Data/hora inclusão | \-  | Controle Interno | GETDATE() padrão |
| UsuarioAlteracao | VARCHAR(200) | Não | Usuário alteração | \-  | Controle Interno | Auditoria |
| DataAlteracao | DATETIME | Não | Data/hora alteração | \-  | Controle Interno | Auditoria |

**3.5 Tabelas Complementares S-2500**

**ptrab_UnicidadeContratual**

**Finalidade**: Informações de unicidade contratual

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| UnicidadeContratualId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| InformacaoContratoId | INT | Sim | FK informação contrato | \-  | Controle Interno | FK ptrab_InformacaoContrato → InformacaoContratoId |
| MatriculaIncorporada | VARCHAR(30) | Não | Matrícula incorporada | matUnic | unicContr | Matrícula unificada |
| CategoriaId | INT | Não | Categoria incorporada | codCateg | unicContr | FK esoc_Categoria → CategoriaCodigo |
| DataInicio | DATETIME | Não | Data de início | dtInicio | unicContr | Data início unicidade |

**ptrab_EstabelecimentoPagamento**

**Finalidade**: Estabelecimento responsável pelo pagamento

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| EstabelecimentoPagamentoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| InformacaoContratoId | INT | Sim | FK informação contrato | \-  | Controle Interno | FK ptrab_InformacaoContrato → InformacaoContratoId |
| TipoInscricaoId | INT | Sim | Tipo de inscrição | tpInsc | ideEstab | FK ptrab_TipoInscricao → TipoInscricaoCodigo |
| NumeroInscricao | VARCHAR(14) | Sim | Número da inscrição | nrInsc | ideEstab | CNPJ/CEI do estabelecimento |

**ptrab_PeriodoValores**

**Finalidade**: Períodos e valores do processo

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| PeriodoValoresId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| EstabelecimentoPagamentoId | INT | Sim | FK estabelecimento | \-  | Controle Interno | FK ptrab_EstabelecimentoPagamento → EstabelecimentoPagamentoId |
| CompetenciaInicio | VARCHAR(7) | Sim | Competência inicial | compIni | infoValores | YYYY-MM |
| CompetenciaFim | VARCHAR(7) | Sim | Competência final | compFim | infoValores | YYYY-MM |
| IndicadorRepercussao | INT | Não | Indicador de repercussão | indReperc | infoValores | FK ptrab_TipoIndicativoRepercussao → TipoIndicativoRepercussaoCodigo |
| IndenizacaoSubstitutiva | CHAR(1) | Não | Indenização substitutiva | indenSD | infoValores | S=Sim, N=Não |
| IndenizacaoAbono | CHAR(1) | Não | Indenização abono | indenAbono | infoValores | S=Sim, N=Não |

**ptrab_AbonoSalarial**

**Finalidade**: Informações de abono salarial

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| AbonoSalarialId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoValoresId | INT | Sim | FK período valores | \-  | Controle Interno | FK ptrab_PeriodoValores → PeriodoValoresId |
| AnoBase | VARCHAR(4) | Sim | Ano base do abono | anoBase | abono | YYYY |

**ptrab_PeriodoApuracao**

**Finalidade**: Períodos de apuração

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| PeriodoApuracaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoValoresId | INT | Sim | FK período valores | \-  | Controle Interno | FK ptrab_PeriodoValores → PeriodoValoresId |
| PeriodoReferencia | VARCHAR(7) | Sim | Período referência | perRef | idePeriodo | YYYY-MM |

**ptrab_BaseCalculoPrevidencia**

**Finalidade**: Bases de cálculo previdenciárias

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| BaseCalculoPrevidenciaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoApuracaoId | INT | Sim | FK período apuração | \-  | Controle Interno | FK ptrab_PeriodoApuracao → PeriodoApuracaoId |
| ValorBaseMensal | MONEY | Sim | Valor base mensal | vrBcCpMensal | basesCp | Valor >= 0 |
| ValorBase13 | MONEY | Sim | Valor base 13º | vrBcCp13 | basesCp | Valor >= 0 |

**ptrab_AgenteNocivo**

**Finalidade**: Informações de agentes nocivos

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| AgenteNocivoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| BaseCalculoPrevidenciaId | INT | Sim | FK base cálculo previdência | \-  | Controle Interno | FK ptrab_BaseCalculoPrevidencia → BaseCalculoPrevidenciaId |
| TipoInfoAgNocivoId | VARCHAR(1) | Sim | Grau de exposição | grauExp | infoAgNocivo | FK ptrab_TipoInfoAgNocivoId → BaseCalculoPrevidenciaCodigo |

**ptrab_BaseCalculoFGTS**

**Finalidade**: Bases de cálculo FGTS

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| BaseCalculoFGTSId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoApuracaoId | INT | Sim | FK período apuração | \-  | Controle Interno | FK ptrab_PeriodoApuracao → PeriodoApuracaoId |
| ValorBaseCalculoFGTS | MONEY | Sim | Valor base FGTS | vrBcFGTS | infoFGTS | Valor >= 0 |
| ValorBaseCalculoFGTSSefip | MONEY | Não | Valor base FGTS SEFIP | vrBcFgtsGuia | infoFGTS | Valor >= 0 |
| ValorBaseCalculoFGTSDecAnt | MONEY | Não | Valor base FGTS dec anterior | vrBcFGTSDecAnt | infoFGTS | Valor >= 0 |

**ptrab_BaseCalculoMudancaCategoria**

**Finalidade**: Bases de cálculo por mudança de categoria

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| BaseCalculoMudancaCategoriaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoApuracaoId | INT | Sim | FK período apuração | \-  | Controle Interno | FK ptrab_PeriodoApuracao → PeriodoApuracaoId |
| CategoriaIdOriginal | INT | Sim | Categoria original | codCateg | baseMudCateg | FK esoc_Categoria → CategoriaCodigo |
| ValorBasePrevidenciario | MONEY | Sim | Valor base previdenciário | vrBcCpMensal | baseMudCateg | Valor >= 0 |

**ptrab_infoIntermitente**

**Finalidade**: Informações relativas ao trabalho intermitente

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| InfoIntermitenteId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| PeriodoApuracaoId | INT | Sim | FK período apuração | \-  | Controle Interno | FK ptrab_PeriodoApuracao → PeriodoApuracaoId |
| DiaTrabalho | INT | Sim | Dia do trabalho | dia | infoInterm | 0-31 (0=não trabalhou) |
| HorasTrabalhadasDia | VARCHAR(4) | Condicional | Horas trabalhadas | hrsTrab | infoInterm | HHMM - obrigatório se dia > 0 |

**3.6 S-2501: Tributos Decorrentes**

**ptrab_TributosProcessoHeader**

**Finalidade**: Cabeçalho dos tributos por competência (S-2501)

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TributosProcessoHeaderId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CadastroProcessoId | INT | Sim | FK processo | \-  | Controle Interno | FK ptrab_CadastroProcesso → CadastroProcessoId |
| CompetenciaPagamento | VARCHAR(7) | Sim | Competência pagamento | perApurPgto | evtCS (raiz) | YYYY-MM |
| ObservacoesPagamento | VARCHAR(999) | Não | Observações | obs | evtCS (raiz) | Observações do pagamento |
| StatusEnvio | INT | Sim | Status do envio | \-  | Controle Interno | 1=Pendente, 2=Enviado, 3=Processado, 4=Erro |

**Campos de Auditoria:**

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| UsuarioInclusao | VARCHAR(200) | Sim | Usuário que incluiu | \-  | Controle Interno | Auditoria |
| DataInclusao | DATETIME | Sim | Data/hora inclusão | \-  | Controle Interno | GETDATE() padrão |
| UsuarioAlteracao | VARCHAR(200) | Não | Usuário alteração | \-  | Controle Interno | Auditoria |
| DataAlteracao | DATETIME | Não | Data/hora alteração | \-  | Controle Interno | Auditoria |
| UsuarioEnvioTransmissao | VARCHAR(200) | Não | Usuário envio | \-  | Controle Interno | Controle transmissão |
| DataEnvioTransmissao | DATETIME | Não | Data/hora envio | \-  | Controle Interno | Controle transmissão |

**ptrab_TributosTrabalhador**

**Finalidade**: Trabalhadores com tributos

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| TributosTrabalhadorId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TributosProcessoHeaderId | INT | Sim | FK header tributos | \-  | Controle Interno | FK ptrab_TributosProcessoHeader → TributosProcessoHeaderId |
| ProcessoTrabalhistaId | INT | Sim | FK trabalhador | \-  | Controle Interno | FK ptrab_ProcessoTrabalhista → ProcessoTrabalhistaId |

**ptrab_CalculoTributosPeriodo**

**Finalidade**: Cálculos de tributos por período

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| CalculoTributosPeriodoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TributosTrabalhadorId | INT | Sim | FK tributos trabalhador | \-  | Controle Interno | FK ptrab_TributosTrabalhador → TributosTrabalhadorId |
| PeriodoReferencia | VARCHAR(7) | Sim | Período referência | perRef | calcTrib | YYYY-MM |
| ValorBaseCalculoMensal | MONEY | Sim | Base cálculo mensal | vrBcCpMensal | calcTrib | Valor >= 0 |
| ValorBaseCalculo13 | MONEY | Sim | Base cálculo 13º | vrBcCp13 | calcTrib | Valor >= 0 |

**ptrab_ContribuicaoCodigoReceita**

**Finalidade**: Contribuições por código de receita

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| ContribuicaoCodigoReceitaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| CalculoTributosPeriodoId | INT | Sim | FK cálculo tributos | \-  | Controle Interno | FK ptrab_CalculoTributosPeriodo → CalculoTributosPeriodoId |
| CodigoReceitaReclamatoriaTrabalhistaId | INT | Sim | Código da receita | tpCR | infoCRContrib | FK esoc_CodigoReceitaReclamatoriaTrabalhista → CodigoReceitaReclamatoriaTrabalhistaId|
| ValorContribuicaoMensal | MONEY | Sim | Valor contribuição mensal | vrCr | infoCRContrib | Valor >= 0 |
| ValorContribuicao13 | MONEY | Sim | Valor contribuição 13º | vrCr13 | infoCRContrib | Valor >= 0 |
| ValorTotal | AS  | Não | Campo calculado | \-  | Controle Interno | Soma mensal + 13º |

**ptrab_IRRFCodigoReceita**

**Finalidade**: IRRF por código de receita

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| IRRFCodigoReceitaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TributosTrabalhadorId | INT | Sim | FK tributos trabalhador | \-  | Controle Interno | FK ptrab_TributosTrabalhador → TributosTrabalhadorId |
| TipoCodigoReceitaIRRF | VARCHAR(6) | Sim | FK para Código da receita IRRF | tpCR | infoCRIRRF | FK  esoc_TipoCodigoReceitaIRRF → CodigoReceitaIRRF|
| ValorIRRF | MONEY | Sim | Valor do IRRF | vrIrrf | infoCRIRRF | Valor >= 0 |

**ptrab_InformacaoIRRF**

**Finalidade**: Informações complementares relativas ao IRRF

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| InformacaoIRRFId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | \-  | Controle Interno | FK ptrab_IRRFCodigoReceita → IRRFCodigoReceitaId |
| ValorRendimentoTributavel | MONEY | Não | Valor rendimento tributável | vrRendTrib | infoIR | Valor >= 0 |
| ValorRendimentoTributavel13 | MONEY | Não | Valor rendimento tributável 13º | vrRendTrib13 | infoIR | Valor >= 0 |
| ValorRendimentoMolestiGrave | MONEY | Não | Valor rendimento moléstia grave | vrRendMoleGrave | infoIR | Valor >= 0 |
| ValorRendimentoIsentos65 | MONEY | Não | Valor rendimento isentos 65 anos | vrRendIsen65 | infoIR | Valor >= 0 |
| ValorJurosMora | MONEY | Não | Valor juros de mora | vrJurosMora | infoIR | Valor >= 0 |
| ValorRendimentoIsentoNaoTributavel | MONEY | Não | Valor rendimento isento não tributável | vrRendIsenNTrib | infoIR | Valor >= 0 |
| DescricaoIsentoNaoTributavel | VARCHAR(60) | Não | Descrição isento não tributável | descIsenNTrib | infoIR | Descrição obrigatória se vrRendIsenNTrib preenchido |
| ValorPrevidenciaOficial | MONEY | Não | Valor previdência oficial | vrPrevOficial | infoIR | Valor >= 0 |

**ptrab_RendimentosRRA**

**Finalidade**: Rendimentos recebidos acumuladamente

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| RendimentosRRAId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | \-  | Controle Interno | FK ptrab_IRRFCodigoReceita → IRRFCodigoReceitaId |
| DescricaoRRA | VARCHAR(50) | Sim | Descrição RRA | descRRA | infoRRA | Descrição obrigatória |
| QuantidadeMesesRRA | INT | Sim | Quantidade meses RRA | qtdMesesRRA | infoRRA | Número > 0 |

**ptrab_DespesasProcessoJudicial**

**Finalidade**: Despesas de processo judicial

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DespesasProcessoJudicialId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| RendimentosRRAId | INT | Sim | FK rendimentos RRA | \-  | Controle Interno | FK ptrab_RendimentosRRA → RendimentosRRAId |
| ValorDespesasCustas | MONEY | Sim | Valor despesas custas | vlrDespCustas | despProcJud | Valor >= 0 |
| ValorDespesasAdvogados | MONEY | Sim | Valor despesas advogados | vlrDespAdv | despProcJud | Valor >= 0 |

**ptrab_AdvogadosRRA**

**Finalidade**: Identificação dos advogados

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| AdvogadosRRAId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| RendimentosRRAId | INT | Sim | FK rendimentos RRA | \-  | Controle Interno | FK ptrab_RendimentosRRA → RendimentosRRAId |
| TipoInscricaoId | INT | Sim | Tipo de inscrição | tpInsc | ideAdv | FK ptrab_TipoInscricao → TipoInscricaoCodigo |
| NumeroInscricao | VARCHAR(14) | Sim | Número da inscrição | nrInsc | ideAdv | CPF/CNPJ do advogado |
| ValorDespesaAdvogado | MONEY | Não | Valor despesa advogado | vlrAdv | ideAdv | Valor >= 0 |

**ptrab_DeducaoDependentes**

**Finalidade**: Dedução de dependentes

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DeducaoDependentesId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | \-  | Controle Interno | FK ptrab_IRRFCodigoReceita → IRRFCodigoReceitaId |
| TipoRendimentoId | INT | Sim | Tipo rendimento | tpRend | dedDepen | FK ptrab_TipoRendimento → TipoRendimentoCodigo |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep | dedDepen | 11 dígitos |
| ValorDeducao | MONEY | Sim | Valor da dedução | vlrDedDep | dedDepen | Valor >= 0 |

**ptrab_PensaoAlimenticia**

**Finalidade**: Pensão alimentícia

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| PensaoAlimenticiaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | \-  | Controle Interno | FK ptrab_IRRFCodigoReceita → IRRFCodigoReceitaId |
| TipoRendimentoId | INT | Sim | Tipo rendimento | tpRend | penAlim | FK ptrab_TipoRendimento → TipoRendimentoCodigo |
| CPFBeneficiario | VARCHAR(11) | Sim | CPF do beneficiário | cpfBenef | penAlim | 11 dígitos |
| ValorPensao | MONEY | Sim | Valor da pensão | vlrPensao | penAlim | Valor >= 0 |

**ptrab_ProcessoRetencao**

**Finalidade**: Processos de retenção

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| ProcessoRetencaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFCodigoReceitaId | INT | Sim | FK IRRF código receita | \-  | Controle Interno | FK ptrab_IRRFCodigoReceita → IRRFCodigoReceitaId |
| TipoProcessoId | INT | Sim | Tipo processo | tpProcRet | infoProcRet | FK ptrab_TipoProcesso → TipoProcessoCodigo |
| NumeroProcesso | VARCHAR(21) | Sim | Número do processo | nrProcRet | infoProcRet | Número do processo de retenção |
| IndicativoSuspensaoId | INT | Não | FK Codigo Indicativo Suspensão | codSusp | infoProcRet | FK IndicativoSuspensao → IndicativoSuspensaoCodigo |

**ptrab_ValoresRetencao**

**Finalidade**: Valores de retenção

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| ValoresRetencaoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| ProcessoRetencaoId | INT | Sim | FK processo retenção | \-  | Controle Interno | FK ptrab_ProcessoRetencao → ProcessoRetencaoId |
| TipoIndicativoApuracaoId | INT | Sim | Fk Indicador apuração | indApuracao | infoValores (retenção) | FK ptrab_TipoIndicativoApuracao → TipoIndicativoApuracaoCodigo |
| ValorNaoRetido | MONEY | Não | Valor não retido | vlrNRetido | infoValores (retenção) | Valor >= 0 |
| ValorDepositoJudicial | MONEY | Não | Valor depósito judicial | vlrDepJud | infoValores (retenção) | Valor >= 0 |
| ValorCompetenciaAnoCivil | MONEY | Não | Valor competência ano civil | vlrCmpAnoCivil | infoValores (retenção) | Valor >= 0 |
| ValorCompetenciaAnoAnterior | MONEY | Não | Valor competência ano anterior | vlrCmpAnoAnt | infoValores (retenção) | Valor >= 0 |
| ValorRendimentoSuspenso | MONEY | Não | Valor rendimento suspenso | vlrRendSusp | infoValores (retenção) | Valor >= 0 |

**ptrab_DeducoesSuspensas**

**Finalidade**: Deduções suspensas

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| DeducoesSuspensasId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| ProcessoRetencaoId | INT | Sim | FK processo retenção | \-  | Controle Interno | FK ptrab_ProcessoRetencao → ProcessoRetencaoId |
| IndicadorTipoDeducao | INT | Sim | Indicativo tipo dedução | indTpDeducao | dedSusp | 1=Previdência, 5=Pensão alimentícia, 7=Dependentes |
| ValorDeducaoSuspensa | MONEY | Sim | Valor dedução suspensa | vlrDedSusp | dedSusp | Valor >= 0 |

**ptrab_BeneficiariosPensaoSuspensa**

**Finalidade**: Beneficiários de pensão suspensa

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| BeneficiariosPensaoSuspensaId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| DeducoesSuspensasId | INT | Sim | FK deduções suspensas | \-  | Controle Interno | FK ptrab_DeducoesSuspensas → DeducoesSuspensasId |
| CPFBeneficiario | VARCHAR(11) | Sim | CPF do beneficiário | cpfBenef | benefPen | 11 dígitos |
| ValorDependenteSuspenso | MONEY | Sim | Valor dependente suspenso | vlrDepenSusp | benefPen | Valor >= 0 |

**ptrab_IRRFComplementar**

**Finalidade**: Informações complementares de IRRF

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| IRRFComplementarId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| TributosTrabalhadorId | INT | Sim | FK tributos trabalhador | \-  | Controle Interno | FK ptrab_TributosTrabalhador → TributosTrabalhadorId |
| DataLaudo | DATETIME | Não | Data do laudo médico | dtLaudo | infoIRComplem | Data do laudo |

**ptrab_InfoDepNaoCadastrado**

**Finalidade**: Informações de dependentes não cadastrados pelo S-2200/S-2205/S-2300

| **Campo** | **Tipo** | **Obrigatório** | **Descrição** | **CampoXML** | **Grupo XML** | **Observação** |
| --- | --- | --- | --- | --- | --- | --- |
| InfoDepNaoCadastradoId | INT IDENTITY | Sim | Chave primária | \-  | Controle Interno | ID interno |
| IRRFComplementarId | INT | Sim | FK IRRF complementar | \-  | Controle Interno | FK ptrab_IRRFComplementar → IRRFComplementarId |
| CPFDependente | VARCHAR(11) | Sim | CPF do dependente | cpfDep | infoDep | 11 dígitos |
| NomeDependente | VARCHAR(70) | Sim | Nome do dependente | nome | infoDep | Nome completo |
| DataNascimento | DATETIME | Sim | Data nascimento dependente | dtNascto | infoDep | Data nascimento |
| DependenteIRRF | VARCHAR(1) | Não | Dependente para fins de IRRF | depIRRF | infoDep | S=Sim, N=Não |
| TipoDependente | VARCHAR(2) | Sim | Tipo de dependente | tpDep | infoDep | FK TipoDependente → TipoDependenteCodigo |
| DescricaoDependente | VARCHAR(60) | Condicional | Descrição da dependência | descrDep | infoDep | Obrigatório se tpDep = 99 |

**4\. Relacionamentos e Constraints Importantes**

**4.1 Chaves Estrangeiras com CASCADE DELETE**

```
sql
-- Relacionamentos principais com CASCADE DELETE
ptrab_CadastroProcesso (1) ←→ (N) ptrab_ProcessoTrabalhista
ptrab_ProcessoTrabalhista (1) ←→ (N) ptrab_InformacaoContrato
ptrab_InformacaoContrato (1) ←→ (N) ptrab_EstabelecimentoPagamento
ptrab_EstabelecimentoPagamento (1) ←→ (N) ptrab_PeriodoValores
ptrab_PeriodoValores (1) ←→ (N) ptrab_PeriodoApuracao

```

_\-- Relacionamentos S-2501_

```
sql
-- Para processos judiciais (TipoOrigemId = 1)
DataSentenca IS NOT NULL
UFVara IS NOT NULL AND LEN(UFVara) = 2
CodigoMunicipio IS NOT NULL

-- Para processos CCP/NINTER (TipoOrigemId = 2)
DataCCP IS NOT NULL

```

**4.2 Constraints de Validação Específicas**

**Validações por Origem do Processo:**

```
sql

_\-- Para processos judiciais (TipoOrigemId = 1)_

DataSentenca IS NOT NULL

UFVara IS NOT NULL AND LEN(UFVara) = 2

CodigoMunicipio IS NOT NULL

_\-- Para processos CCP/NINTER (TipoOrigemId = 2)_

DataCCP IS NOT NULL

```

**Validações de Formato:**

```
sql

_\-- CPF sempre 11 dígitos_

LEN(CPF) = 11

_\-- Competências formato YYYY-MM_

CompetenciaInicio LIKE '\[0-9\]\[0-9\]\[0-9\]\[0-9\]-\[0-1\]\[0-9\]'

_\-- Valores monetários não negativos_

ValorSalarioFixo >= 0

```

**Validações Condicionais:**

```
sql

_\-- Trabalho intermitente: se DiaTrabalho > 0, HorasTrabalhadasDia obrigatório_

(DiaTrabalho = 0) OR (DiaTrabalho > 0 AND HorasTrabalhadasDia IS NOT NULL)

_\-- Dependente tipo 99: DescricaoDependente obrigatório_

(TipoDependente != '99') OR (TipoDependente = '99' AND DescricaoDependente IS NOT NULL)

_\-- Rendimento isento não tributável: descrição obrigatória se valor preenchido_

(ValorRendimentoIsentoNaoTributavel IS NULL) OR

(ValorRendimentoIsentoNaoTributavel IS NOT NULL AND DescricaoIsentoNaoTributavel IS NOT NULL)

```

**4.3 Índices de Performance**

**Índices Principais:**

```
sql

_\-- Por processo_

CREATE INDEX IDX_ProcessoTrabalhista_CadastroProcessoId

ON ptrab_ProcessoTrabalhista (CadastroProcessoId)

_\-- Por CPF_

CREATE INDEX IDX_ProcessoTrabalhista_CPF

ON ptrab_ProcessoTrabalhista (CPF)

_\-- Por competência_

CREATE INDEX IDX_PeriodoValores_Competencias

ON ptrab_PeriodoValores (CompetenciaInicio, CompetenciaFim)

_\-- Por status_

CREATE INDEX IDX_CadastroProcesso_StatusId

ON ptrab_CadastroProcesso (StatusId)

_\-- Tributos por competência_

CREATE INDEX IDX_TributosHeader_Competencia

ON ptrab_TributosProcessoHeader (CompetenciaPagamento)

_\-- IRRF por trabalhador_

CREATE INDEX IDX_IRRFCodigoReceita_TrabalhadorId

ON ptrab_IRRFCodigoReceita (TributosTrabalhadorId)

```

**5\. Campos de Auditoria Padrão**

**5.1 Estrutura Padrão de Auditoria**

Todas as tabelas principais possuem os seguintes campos:

| **Campo** | **Tipo** | **Descrição** | **Uso** |
| --- | --- | --- | --- |
| UsuarioInclusao | VARCHAR(200) | Usuário que criou o registro | Obrigatório na criação |
| DataInclusao | DATETIME | Data/hora da criação | Automático (GETDATE()) |
| UsuarioAlteracao | VARCHAR(200) | Usuário da última alteração | Preenchido em updates |
| DataAlteracao | DATETIME | Data/hora da última alteração | Automático em updates |
| UsuarioEnvioTransmissao | VARCHAR(200) | Usuário que enviou para o eSocial | Processo de transmissão |
| DataEnvioTransmissao | DATETIME | Data/hora do envio | Processo de transmissão |

**5.2 Status de Processamento**

| **Código** | **Descrição** | **Tipo** | **Uso** |
| --- | --- | --- | --- |
| EM_PREENCHIMENTO | Em Preenchimento | GERAL | Registro inicial |
| ATIVO | Registro Ativo para uso | PROCESSO | Processo ativo |
| INATIVO | Registro Inativo para uso | PROCESSO | Processo inativo |
| COM_PENDENCIAS | Com Pendências de Cadastro | Trabalhador | Dados incompletos |
| AGUARDANDO_TRANSMISSAO | Aguardando Transmissão | Trabalhador | Pronto para envio |
| ENVIADO_TRANSMISSAO | Enviado para Transmissão | Trabalhador | Transmitido |
| IRRF_CALCULADO | IRRF Calculado | IRRF | Cálculo finalizado |
| IRRF_PENDENTE | IRRF Pendente de Cálculo | IRRF | Aguardando cálculo |
| IRRF_PROCESSADO | IRRF Processado | IRRF | Processamento concluído |
| IRRF_ERRO | Erro no Cálculo IRRF | IRRF | Erro no processamento |

**6\. Considerações de Implementação**

**6.1 Transmissão Individual por Trabalhador**

- Cada trabalhador é transmitido separadamente no S-2500
- Mesmo processo pode ter múltiplas transmissões
- Controle individual de status por trabalhador
- Relacionamento 1:N entre processo e trabalhadores

**6.2 Competências S-2501**

- Uma competência por transmissão S-2501
- Múltiplos trabalhadores por competência
- Relacionamento direto com S-2500 correspondente
- Controle de integridade entre eventos

**6.3 Validações de Negócio Críticas**

**Hierarquia Obrigatória:**

1. Processo deve existir antes dos trabalhadores
2. S-2500 deve existir antes do S-2501
3. Competências devem estar dentro do período do processo
4. CPF único por processo

**Regras de Origem:**

- **Processo Judicial**: DataSentenca, UFVara, CodigoMunicipio obrigatórios
- **CCP/NINTER**: DataCCP obrigatória

**Regras de IRRF:**

- Código de receita deve ser válido na tabela correspondente
- Valores monetários sempre não negativos
- Dependentes com CPF válido (11 dígitos)
- Descrições obrigatórias quando valores específicos preenchidos

**6.4 Performance e Otimização**

**Particionamento Sugerido:**

```
sql

_\-- Por ano/competência para tabelas grandes_

PARTITION BY RANGE (YEAR(DataInclusao))

_\-- Por status para consultas frequentes_

INDEX (StatusId, DataInclusao)

```

**Consultas Otimizadas:**

```
sql

_\-- Busca por processo_

SELECT \* FROM ptrab_CadastroProcesso WHERE NumeroProcesso = @numero

_\-- Trabalhadores por processo_

SELECT \* FROM ptrab_ProcessoTrabalhista WHERE CadastroProcessoId = @id

_\-- Tributos por competência_

SELECT \* FROM ptrab_TributosProcessoHeader WHERE CompetenciaPagamento = @competencia

_\-- IRRF por trabalhador_

SELECT \* FROM ptrab_IRRFCodigoReceita WHERE TributosTrabalhadorId = @id

```

**7\. Scripts de Manutenção Recomendados**

**7.1 Limpeza de Dados Órfãos**


```
sql

_\-- Verificar integridade referencial_

SELECT COUNT(\*) FROM ptrab_ProcessoTrabalhista pt

LEFT JOIN ptrab_CadastroProcesso cp ON pt.CadastroProcessoId = cp.CadastroProcessoId

WHERE cp.CadastroProcessoId IS NULL

_\-- Verificar tributos sem processo base_

SELECT COUNT(\*) FROM ptrab_TributosProcessoHeader th

LEFT JOIN ptrab_CadastroProcesso cp ON th.CadastroProcessoId = cp.CadastroProcessoId

WHERE cp.CadastroProcessoId IS NULL

```

**7.2 Monitoramento de Performance**

```
sql

_\-- Processos com muitos trabalhadores_

SELECT CadastroProcessoId, COUNT(\*) as QtdTrabalhadores

FROM ptrab_ProcessoTrabalhista

GROUP BY CadastroProcessoId

HAVING COUNT(\*) > 100

_\-- Tributos por competência_

SELECT CompetenciaPagamento, COUNT(\*) as QtdTributos

FROM ptrab_TributosProcessoHeader

GROUP BY CompetenciaPagamento

ORDER BY CompetenciaPagamento DESC

```

**7.3 Auditoria de Transmissões**

```
sql

_\-- Processos enviados por período_

SELECT COUNT(\*) as QtdEnviados, CAST(DataEnvioTransmissao AS DATE) as DataEnvio

FROM ptrab_CadastroProcesso

WHERE DataEnvioTransmissao IS NOT NULL

GROUP BY CAST(DataEnvioTransmissao AS DATE)

ORDER BY DataEnvio DESC

_\-- Status de tributos por competência_

SELECT th.CompetenciaPagamento, th.StatusEnvio, COUNT(\*) as Quantidade

FROM ptrab_TributosProcessoHeader th

GROUP BY th.CompetenciaPagamento, th.StatusEnvio

ORDER BY th.CompetenciaPagamento DESC, th.StatusEnvio

```

**8\. Mapeamento Grupos XML por Evento**

**8.1 Grupos XML S-2500 (evtProcTrab)**

- **evtProcTrab** (raiz): Dados básicos do processo
- **ideEmpregador**: Identificação do empregador
- **ideResp**: Identificação do responsável indireto
- **infoProcJud**: Informações do processo judicial
- **infoCCP**: Informações do CCP/NINTER
- **ideTrab**: Identificação do trabalhador
- **infoContr**: Informações do contrato
- **infoCompl**: Informações complementares
- **remuneracao**: Dados de remuneração
- **infoVinc**: Informações do vínculo
- **duracao**: Duração do contrato
- **sucessaoVinc**: Sucessão de vínculo
- **infoDeslig**: Informações de desligamento
- **infoTerm**: Informações de término TSVE
- **mudCategAtiv**: Mudança de categoria/atividade
- **unicContr**: Unicidade contratual
- **ideEstab**: Estabelecimento responsável
- **infoValores**: Períodos e valores
- **abono**: Abono salarial
- **idePeriodo**: Período de apuração
- **basesCp**: Bases de cálculo previdenciárias
- **infoAgNocivo**: Agentes nocivos
- **infoFGTS**: Bases de cálculo FGTS
- **baseMudCateg**: Bases por mudança categoria
- **infoInterm**: Trabalho intermitente

**8.2 Grupos XML S-2501 (evtCS)**

- **evtCS** (raiz): Dados básicos dos tributos
- **ideTrab**: Identificação do trabalhador
- **calcTrib**: Cálculo de tributos
- **infoCRContrib**: Contribuições por código receita
- **infoCRIRRF**: IRRF por código receita
- **infoIR**: Informações complementares IRRF
- **infoRRA**: Rendimentos RRA
- **despProcJud**: Despesas processo judicial
- **ideAdv**: Identificação advogados
- **dedDepen**: Dedução dependentes
- **penAlim**: Pensão alimentícia
- **infoProcRet**: Processo de retenção
- **infoValores** (retenção): Valores de retenção
- **dedSusp**: Deduções suspensas
- **benefPen**: Beneficiários pensão suspensa
- **infoIRComplem**: IRRF complementar
- **infoDep**: Dependentes não cadastrados

**Observações Importantes:**

1. **Nomenclatura XML**: Os campos CampoXML correspondem exatamente às tags XML do eSocial conforme Manual Técnico v1.3
2. **Grupos XML**: A coluna "Grupo XML" indica o grupo/contexto onde cada campo aparece no XML
3. **Chaves Estrangeiras**: Todas as FKs referenciam o campo de código da tabela de domínio, não o ID interno
4. **Validações**: Constraints implementadas conforme regras de negócio do eSocial
5. **Performance**: Índices otimizados para consultas frequentes por processo, CPF e competência
6. **Auditoria**: Rastreabilidade completa desde cadastro até transmissão
7. **Integridade**: CASCADE DELETE para manter consistência hierárquica dos dados
8. **Mapeamento XML**: Relacionamento direto entre estrutura do banco e estrutura XML dos eventos