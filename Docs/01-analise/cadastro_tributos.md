# Cadastro de Tributos Decorrentes - Requisitos e Critérios de Aceite

## Visão Geral

Este documento define os requisitos funcionais e critérios de aceite para o cadastro de tributos decorrentes de processos trabalhistas, contemplando o evento S-2501 do eSocial.

## Objetivos

- Registrar tributos e contribuições decorrentes de decisões de processos trabalhistas
- Calcular bases de cálculo e valores de tributos conforme legislação
- Permitir informação detalhada por período de apuração
- Garantir consistência com os dados do processo trabalhista relacionado

## Escopo Funcional

### RF001 - Seleção do Processo e Trabalhador
**Como** usuário do sistema  
**Quero** selecionar um processo trabalhista e trabalhador específico  
**Para que** possa registrar os tributos decorrentes da decisão judicial

#### Critérios de Aceite:
- **CA001.1** - Sistema deve exibir apenas processos com status adequado para cadastro de tributos
- **CA001.2** - Deve listar trabalhadores vinculados ao processo selecionado
- **CA001.3** - Deve exibir informações resumidas do processo (número, data, empregador)
- **CA001.4** - Deve carregar dados contratuais do trabalhador para referência
- **CA001.5** - Deve validar se trabalhador possui dados contratuais completos

### RF002 - Definição do Período de Apuração
**Como** usuário do sistema  
**Quero** definir o período de apuração dos tributos  
**Para que** sejam organizados corretamente por competência fiscal

#### Critérios de Aceite:
- **CA002.1** - Deve permitir informar período no formato AAAA-MM
- **CA002.2** - Período deve estar dentro do intervalo válido do contrato
- **CA002.3** - Deve validar que período não seja futuro em relação à data atual
- **CA002.4** - Deve permitir múltiplos períodos para o mesmo trabalhador/processo
- **CA002.5** - Deve alertar se já existem tributos para o mesmo período

### RF003 - Cadastro de Informações de Remuneração
**Como** usuário do sistema  
**Quero** informar os valores de remuneração que originaram os tributos  
**Para que** sejam registradas as bases de cálculo corretas

#### Critérios de Aceite:
- **CA003.1** - Deve permitir informar valor da remuneração base
- **CA003.2** - Deve aceitar valores decimais com até 2 casas
- **CA003.3** - Deve validar que valores sejam positivos
- **CA003.4** - Deve permitir informar diferentes tipos de remuneração:
  - Remuneração fixa
  - Remuneração variável  
  - 13º salário
  - Férias
  - Verbas rescisórias
- **CA003.5** - Deve calcular automaticamente totais quando aplicável

### RF004 - Cadastro de Bases de Cálculo Previdenciárias
**Como** usuário do sistema  
**Quero** informar as bases de cálculo para contribuições previdenciárias  
**Para que** sejam calculados corretamente os valores devidos

#### Critérios de Aceite:
- **CA004.1** - Deve permitir informar base de cálculo INSS empregado
- **CA004.2** - Deve permitir informar base de cálculo INSS empregador
- **CA004.3** - Deve validar que bases não excedam tetos legais
- **CA004.4** - Deve aplicar reduções quando cabíveis
- **CA004.5** - Deve calcular automaticamente valor do INSS com alíquotas corretas
- **CA004.6** - Deve considerar faixas progressivas de contribuição

### RF005 - Cadastro de Bases de Cálculo FGTS
**Como** usuário do sistema  
**Quero** informar bases de cálculo do FGTS  
**Para que** sejam calculados depósitos e multas devidas

#### Critérios de Aceite:
- **CA005.1** - Deve permitir informar base FGTS depósito (8%)
- **CA005.2** - Deve permitir informar base FGTS multa rescisória (40% ou 20%)
- **CA005.3** - Deve calcular automaticamente valores com alíquotas corretas
- **CA005.4** - Deve permitir informar FGTS sobre valores já declarados anteriormente
- **CA005.5** - Deve validar consistência entre bases informadas

### RF006 - Cadastro de Informações de IRRF
**Como** usuário do sistema  
**Quero** informar dados para cálculo do Imposto de Renda Retido na Fonte  
**Para que** seja calculada corretamente a retenção devida

#### Critérios de Aceite:
- **CA006.1** - Deve permitir informar base de cálculo do IRRF
- **CA006.2** - Deve aplicar tabela progressiva vigente no período
- **CA006.3** - Deve considerar número de dependentes informado
- **CA006.4** - Deve permitir informar deduções cabíveis
- **CA006.5** - Deve calcular automaticamente valor a reter
- **CA006.6** - Deve validar se há obrigatoriedade de retenção

### RF007 - Informações de Contribuições Sobre Terceiros
**Como** usuário do sistema  
**Quero** registrar contribuições devidas a terceiros  
**Para que** sejam calculados valores para sistema S, sindicatos, etc.

#### Critérios de Aceite:
- **CA007.1** - Deve permitir informar base para contribuições terceiros
- **CA007.2** - Deve identificar automaticamente entidades beneficiárias
- **CA007.3** - Deve aplicar alíquotas conforme configuração da empresa
- **CA007.4** - Deve calcular valores por entidade (SESI, SENAI, SEBRAE, etc.)
- **CA007.5** - Deve permitir informar contribuição sindical quando devida

### RF008 - Detalhamento por Código de Receita
**Como** usuário do sistema  
**Quero** especificar códigos de receita para cada tributo  
**Para que** seja possível identificar corretamente os recolhimentos

#### Critérios de Aceite:
- **CA008.1** - Deve permitir seleção de códigos de receita válidos
- **CA008.2** - Deve validar compatibilidade entre código e tipo de tributo
- **CA008.3** - Deve sugerir códigos mais comuns conforme contexto
- **CA008.4** - Deve permitir busca por descrição do código
- **CA008.5** - Deve manter histórico de códigos utilizados

### RF009 - Cálculos Automáticos e Validações
**Como** sistema  
**Quero** calcular automaticamente valores de tributos  
**Para que** sejam aplicadas corretamente alíquotas e regras vigentes

#### Critérios de Aceite:
- **CA009.1** - Deve aplicar alíquotas vigentes no período de competência
- **CA009.2** - Deve considerar mudanças de legislação por período
- **CA009.3** - Deve validar tetos e limites mínimos
- **CA009.4** - Deve calcular juros e multas quando aplicável
- **CA009.5** - Deve recalcular automaticamente quando bases forem alteradas
- **CA009.6** - Deve validar consistência entre diferentes tributos

### RF010 - Informações Complementares
**Como** usuário do sistema  
**Quero** registrar informações complementares relevantes  
**Para que** sejam preservados detalhes importantes do cálculo

#### Critérios de Aceite:
- **CA010.1** - Deve permitir informar observações sobre os cálculos
- **CA010.2** - Deve registrar base legal utilizada
- **CA010.3** - Deve permitir anexar documentos comprobatórios
- **CA010.4** - Deve registrar data de vencimento dos tributos
- **CA010.5** - Deve permitir informar forma de pagamento

### RF011 - Múltiplos Períodos e Consolidação
**Como** usuário do sistema  
**Quero** gerenciar tributos de múltiplos períodos  
**Para que** seja possível consolidar informações quando necessário

#### Critérios de Aceite:
- **CA011.1** - Deve permitir copiar informações entre períodos similares
- **CA011.2** - Deve exibir resumo consolidado por trabalhador
- **CA011.3** - Deve identificar períodos que necessitam consolidação (S-2555)
- **CA011.4** - Deve calcular totais gerais do processo
- **CA011.5** - Deve validar consistência entre períodos

## Regras de Negócio

### RN001 - Períodos Válidos
- Período de apuração deve estar dentro do intervalo do contrato de trabalho
- Não é permitido informar tributos para períodos futuros
- Períodos já consolidados não podem ser alterados

### RN002 - Bases de Cálculo
- Base de FGTS não pode ser superior à base previdenciária
- Base de IRRF deve considerar apenas valores sujeitos à retenção
- Bases devem respeitar tetos legais vigentes no período

### RN003 - Alíquotas e Cálculos
- Sistema deve aplicar alíquotas vigentes na competência informada
- Mudanças de legislação devem ser consideradas automaticamente
- Valores calculados devem ser arredondados conforme regras fiscais

### RN004 - Consistência com Processo
- Tributos só podem ser cadastrados para trabalhadores vinculados ao processo
- Valores devem ser consistentes com informações contratuais
- Alterações no processo podem impactar tributos já cadastrados

### RN005 - Controle de Versões
- Cada alteração deve gerar nova versão do registro
- Versões anteriores devem ser preservadas para auditoria
- Envios para eSocial devem "travar" a versão atual

## Interface de Usuário

### Organização das Telas
- Wizard com etapas bem definidas
- Calculadora integrada para valores complexos
- Tabelas resumo por período e por tributo
- Gráficos para visualização de totais

### Características Específicas
- Campos monetários com formatação automática
- Validação em tempo real de tetos e limites
- Sugestões baseadas em histórico
- Templates para situações recorrentes

## Cenários de Teste

### CT001 - Cadastro Tributos Período Único
**Dado que** selecionei processo e trabalhador válidos  
**Quando** informo período "2024-01" e valores de remuneração  
**E** sistema calcula automaticamente tributos  
**E** salvo o registro  
**Então** tributos devem ser cadastrados corretamente  
**E** valores devem estar dentro dos limites legais

### CT002 - Validação Teto Previdenciário
**Dado que** estou cadastrando tributos para período "2024-12"  
**Quando** informo base INSS superior ao teto vigente  
**Então** sistema deve aplicar automaticamente o teto  
**E** deve exibir alerta sobre limitação aplicada

### CT003 - Múltiplos Períodos Mesmo Trabalhador
**Dado que** trabalhador já possui tributos para "2024-01"  
**Quando** cadastro tributos para "2024-02"  
**E** valores são similares ao período anterior  
**Então** sistema deve sugerir cópia dos dados  
**E** deve permitir ajustes específicos do período

### CT004 - Cálculo IRRF com Dependentes
**Dado que** informei base IRRF de R$ 5.000,00  
**E** trabalhador possui 2 dependentes  
**Quando** sistema calcula IRRF  
**Então** deve aplicar deduções corretas  
**E** deve utilizar tabela progressiva vigente

## Dependências e Integrações

- **Cadastro de Processo Trabalhista**: Dependência obrigatória
- **Tabelas Tributárias**: Alíquotas, tetos, códigos de receita
- **Motor de Cálculo Fiscal**: Para cálculos automáticos
- **Sistema de Legislação**: Para regras vigentes por período
- **Validador Fiscal**: Para consistência de cálculos

## Considerações Técnicas

- Implementar motor de cálculo configurável por legislação
- Utilizar factory pattern para diferentes tipos de tributo  
- Implementar cache para tabelas fiscais frequentemente acessadas
- Garantir precisão decimal para cálculos financeiros
- Implementar versionamento automático de registros
