# Tipo 08 - Responsabilidade Indireta - Requisitos Específicos

## Definição

**Tipo de Contrato 8**: Situações com responsabilidade indireta ao declarante.

Este tipo contempla casos onde o declarante (empregador que está enviando o evento) não é o empregador direto do trabalhador, mas foi responsabilizado indiretamente pela Justiça do Trabalho por obrigações trabalhistas, seja por terceirização, grupo econômico, sucessão empresarial ou outras formas de responsabilidade solidária/subsidiária.

## Conceito de Responsabilidade Indireta

### Definição Legal
Responsabilidade que surge não do contrato direto de trabalho, mas de:
- **Responsabilidade Solidária**: Ambos respondem integralmente
- **Responsabilidade Subsidiária**: Responde se o principal não pagar
- **Sucessão Empresarial**: Por continuidade de atividades
- **Grupo Econômico**: Por unidade de comando/controle

### Fundamentos Jurídicos
- Art. 2º, §2º da CLT (grupo econômico)
- Súmula 331 do TST (terceirização)
- Art. 10 da CLT (sucessão)
- Art. 942 do CC (responsabilidade solidária)

## Cenários de Aplicação

### Cenário Principal - Terceirização
Empresa contratante responsabilizada por trabalhador de empresa terceirizada:
- Trabalhador tinha vínculo com empresa terceirizada
- Processo condenou tomadora por responsabilidade subsidiária
- Necessário registrar no eSocial da empresa condenada
- Manter referência ao empregador direto

### Cenário Grupo Econômico
Empresa do grupo responsabilizada por trabalhador de outra:
- Trabalhador vinculado à empresa A do grupo
- Processo condenou empresa B do mesmo grupo
- Caracterizada unidade de comando/controle
- Responsabilidade solidária reconhecida

### Cenário Sucessão Empresarial
Empresa sucessora responsabilizada por débitos da antecessora:
- Trabalhador vinculado à empresa original (sucedida)
- Nova empresa (sucessora) assumiu atividades
- Processo reconheceu sucessão trabalhista
- Sucessora responde por débitos anteriores

### Exemplos Práticos
- Banco condenado por terceirizada de limpeza
- Construtora responsável por débitos de subempreiteira
- Empresa do grupo condenada solidariamente
- Hospital responsável por cooperativa médica
- Sucessora industrial por débitos da antecessora
- Franqueadora por débitos de franqueado

## Requisitos Específicos

### RF801 - Identificação da Responsabilidade Indireta
**Como** sistema  
**Quero** caracterizar corretamente a responsabilidade indireta  
**Para que** sejam registradas informações adequadas à situação jurídica

#### Critérios de Aceite:
- **CA801.1** - Sistema deve identificar tipo de responsabilidade (solidária/subsidiária)
- **CA801.2** - Deve registrar fundamento legal da responsabilização
- **CA801.3** - Deve distinguir empregador direto de responsável indireto
- **CA801.4** - Deve permitir informar dados do empregador originário
- **CA801.5** - Deve validar se declarante é realmente responsável indireto

### RF802 - Dados do Empregador Direto
**Como** usuário do sistema  
**Quero** registrar dados do empregador que tinha vínculo direto  
**Para que** seja preservada informação sobre relação original

#### Critérios de Aceite:
- **CA802.1** - Campo tpContr deve ser fixo = 8
- **CA802.2** - Campo indContr depende se vínculo existe no eSocial
- **CA802.3** - CNPJ/CPF do empregador direto é obrigatório
- **CA802.4** - Nome/razão social do empregador direto é obrigatório
- **CA802.5** - Período do vínculo original é obrigatório
- **CA802.6** - Matrícula no empregador direto (se conhecida)

### RF803 - Caracterização da Responsabilidade
**Como** usuário do sistema  
**Quero** especificar o tipo e fundamento da responsabilidade  
**Para que** seja documentada base legal da condenação

#### Critérios de Aceite:
- **CA803.1** - Tipo de responsabilidade (solidária, subsidiária, sucessão)
- **CA803.2** - Fundamento legal específico (súmula, artigo de lei)
- **CA803.3** - Descrição da relação entre empresas
- **CA803.4** - Período da responsabilidade (se limitado)
- **CA803.5** - Percentual de responsabilidade (se parcial)
- **CA803.6** - Ordem de preferência no pagamento

### RF804 - Dados do Trabalhador na Situação Original
**Como** usuário do sistema  
**Quero** registrar informações do vínculo original do trabalhador  
**Para que** sejam preservados dados da relação primária

#### Critérios de Aceite:
- **CA804.1** - CPF e dados pessoais do trabalhador
- **CA804.2** - Função exercida no empregador direto
- **CA804.3** - Período de trabalho original
- **CA804.4** - Salário e condições contratuais originais
- **CA804.5** - Categoria profissional no vínculo direto
- **CA804.6** - Motivo do desligamento (se aplicável)

### RF805 - Valores e Responsabilidade Financeira
**Como** usuário do sistema  
**Quero** registrar valores pelos quais o declarante foi responsabilizado  
**Para que** sejam calculados tributos adequados à responsabilidade

#### Critérios de Aceite:
- **CA805.1** - Valor total da condenação
- **CA805.2** - Parcela de responsabilidade do declarante
- **CA805.3** - Valores já pagos pelo empregador direto
- **CA805.4** - Saldo remanescente de responsabilidade
- **CA805.5** - Natureza das verbas (salários, indenizações, etc.)
- **CA805.6** - Correção monetária e juros aplicáveis

## Regras de Negócio Específicas

### RN801 - Validação da Responsabilidade Indireta
- Declarante NÃO pode ser o empregador direto do trabalhador
- Deve haver fundamento legal claro para responsabilização
- Responsabilidade deve estar expressamente reconhecida em decisão
- Sistema deve validar lógica da responsabilização

### RN802 - Relação entre Empresas
- Deve ser comprovada relação jurídica/econômica entre empresas
- Terceirização deve estar caracterizada adequadamente
- Grupo econômico deve ter elementos configuradores
- Sucessão deve ter transferência de atividades/estabelecimento

### RN803 - Tributação na Responsabilidade Indireta
- Tributos calculados sobre valores efetivamente pagos
- Base de cálculo limitada à responsabilidade do declarante
- Considerar contribuições já recolhidas pelo empregador direto
- Evitar bitributação sobre mesmos fatos geradores

### RN804 - Ordem de Responsabilidade
- Responsabilidade subsidiária: após esgotamento do principal
- Responsabilidade solidária: qualquer responsável pode ser executado
- Sucessão: responsabilidade plena pelos débitos transferidos
- Sistema deve respeitar ordem legal/judicial estabelecida

## Interface Específica

### Seção Identificação da Responsabilidade
- **Tipo responsabilidade**: Solidária, subsidiária, sucessão
- **Fundamento legal**: Base jurídica da responsabilização
- **Relação empresarial**: Terceirização, grupo, sucessão, outros
- **Período responsabilidade**: Se há limitação temporal

### Seção Empregador Direto
- **CNPJ/CPF**: Identificação do empregador original
- **Razão social**: Nome da empresa empregadora
- **Período atividade**: Quando empregou o trabalhador
- **Status atual**: Se ainda existe ou foi extinta
- **Relacionamento**: Como se relaciona com declarante

### Seção Dados do Vínculo Original
- **Matrícula original**: No empregador direto
- **Período trabalho**: Início e fim do vínculo
- **Função exercida**: CBO e descrição
- **Condições contratuais**: Salário, regime, jornada
- **Motivo desligamento**: Se aplicável

### Seção Responsabilidade Financeira
- **Valor total condenação**: Montante integral
- **Percentual responsabilidade**: Quota do declarante
- **Valores pagos terceiros**: Já quitados por outros
- **Saldo declarante**: Valor devido pelo responsável indireto
- **Natureza verbas**: Classificação dos valores

### Seção Informações Processuais
- **Número processo**: Que reconheceu responsabilidade
- **Data decisão**: Quando foi reconhecida
- **Trânsito julgado**: Se decisão é definitiva
- **Execução**: Status do cumprimento
- **Documentação**: Anexos comprobatórios

## Cenários de Teste Específicos

### CT801 - Responsabilidade Subsidiária Terceirização
**Dado que** banco contratou empresa de limpeza como terceirizada  
**E** processo reconheceu responsabilidade subsidiária do banco  
**E** trabalhador tinha vínculo direto com empresa de limpeza  
**Quando** seleciono tipo "8 - Responsabilidade indireta"  
**E** informo dados do empregador direto e fundamento legal  
**Então** sistema deve aceitar como responsabilidade subsidiária  
**E** deve registrar dados do vínculo original  
**E** deve calcular tributos sobre valores pagos pelo banco

### CT802 - Responsabilidade Solidária Grupo Econômico
**Dado que** empresas A e B formam grupo econômico  
**E** trabalhador vinculado à empresa A  
**E** processo condenou solidariamente empresa B  
**Quando** registro responsabilidade da empresa B  
**Então** sistema deve aceitar responsabilidade solidária  
**E** deve permitir tributação sobre valor integral  
**E** deve manter referência ao empregador direto

### CT803 - Sucessão Empresarial
**Dado que** empresa X foi sucedida pela empresa Y  
**E** trabalhador tinha vínculo com empresa X (extinta)  
**E** empresa Y assumiu atividades e foi condenada  
**Quando** informo sucessão empresarial  
**Então** sistema deve registrar como sucessora  
**E** deve aceitar responsabilidade integral  
**E** deve documentar transferência de atividades

### CT804 - Declarante Igual Empregador Direto
**Dado que** tento registrar responsabilidade indireta  
**Quando** informo mesmo CNPJ como empregador direto e declarante  
**Então** sistema deve exibir erro "Declarante não pode ser empregador direto"  
**E** deve sugerir uso de outro tipo de contrato  
**E** deve impedir prosseguimento

### CT805 - Validação Período Responsabilidade
**Dado que** contrato terceirização foi de "01/01/2023 a 31/12/2023"  
**E** vínculo trabalhador foi de "01/06/2022 a 30/06/2024"  
**Quando** informo responsabilidade por todo período do vínculo  
**Então** sistema deve alertar "Responsabilidade limitada ao período contratual"  
**E** deve sugerir ajuste para período da terceirização  
**E** deve permitir correção

## Validações Avançadas Específicas

### Validação de Fundamento Legal
- Verificar se fundamento citado existe e é aplicável
- Validar se tipo de responsabilidade condiz com fundamento
- Confirmar se relação empresarial justifica responsabilização
- Checar jurisprudência aplicável ao caso

### Validação de Relação Empresarial
- Verificar se existe/existiu relação entre empresas
- Confirmar período de vigência da relação
- Validar natureza da relação (terceirização, grupo, etc.)
- Checar documentação comprobatória da relação

### Validação de Valores e Tributação
- Verificar consistência de valores da condenação
- Calcular tributos evitando bitributação
- Confirmar bases de cálculo adequadas
- Validar códigos de receita específicos

### Validação Temporal
- Verificar período de responsabilidade vs período do vínculo
- Confirmar datas de início/fim da relação empresarial
- Validar se responsabilidade cobre período alegado
- Checar prescrição de direitos

## Integração com eSocial

### Eventos Relacionados
- **S-2500**: Com indicação de responsabilidade indireta
- **S-2501**: Tributos sobre valores efetivamente pagos
- **Consulta vínculos**: Do empregador direto
- **Validação empresas**: Status e relacionamento

### Informações Especiais
- Identificação clara de responsabilidade indireta
- Referência ao empregador direto original
- Fundamento legal da responsabilização
- Limitação de responsabilidade se aplicável

### Cálculos Diferenciados
- Base tributária limitada à responsabilidade
- Evitar dupla incidência com empregador direto
- Considerar contribuições já recolhidas
- Aplicar regras específicas de responsabilidade

## Considerações Especiais

### Aspectos Jurídicos Complexos
- Responsabilidade pode ser limitada temporalmente
- Fundamentos legais variam conforme situação
- Jurisprudência em constante evolução
- Necessária análise caso a caso

### Aspectos Tributários Específicos
- Evitar bitributação sobre mesmos fatos
- Considerar recolhimentos já efetuados
- Calcular apenas sobre responsabilidade efetiva
- Usar códigos de receita adequados

### Aspectos Operacionais
- Processo mais complexo que vínculos diretos
- Exige documentação robusta da relação
- Necessita análise jurídica especializada
- Requer controles diferenciados

### Limitações e Cuidados
- Sistema não valida automaticamente fundamento legal
- Requer análise manual da relação empresarial
- Não calcula automaticamente limitações de responsabilidade
- Exige validação jurídica caso a caso

### Fluxo Especializado
- Análise jurídica obrigatória mais aprofundada
- Validação da relação empresarial
- Aprovação de nível superior
- Documentação extensiva da responsabilização

### Impactos Sistêmicos
- Pode afetar estatísticas de vínculos diretos
- Requer tratamento diferenciado em relatórios
- Necessita controles específicos de auditoria
- Demanda acompanhamento jurídico contínuo
