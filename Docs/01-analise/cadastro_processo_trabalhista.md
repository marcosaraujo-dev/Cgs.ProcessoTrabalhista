# Cadastro de Processo Trabalhista - Requisitos e Critérios de Aceite

## Visão Geral

Este documento define os requisitos funcionais e critérios de aceite para o cadastro do processo trabalhista propriamente dito, onde são vinculados trabalhadores ao processo judicial e definidas as informações contratuais específicas do evento S-2500.

## Objetivos

- Vincular trabalhadores a processos judiciais já cadastrados
- Registrar informações específicas do contrato de trabalho objeto do processo
- Permitir diferentes tipos de situações contratuais conforme eSocial
- Manter integridade referencial entre processo e trabalhadores

## Escopo Funcional

### RF001 - Seleção e Vinculação ao Processo Judicial
**Como** usuário do sistema  
**Quero** selecionar um processo judicial existente para vincular trabalhadores  
**Para que** possa registrar as informações contratuais específicas de cada trabalhador envolvido

#### Critérios de Aceite:
- **CA001.1** - Sistema deve exibir lista de processos judiciais cadastrados e ativos
- **CA001.2** - Deve permitir busca por número do processo
- **CA001.3** - Deve exibir informações resumidas do processo (número, data, empregador)
- **CA001.4** - Deve impedir seleção de processos já enviados ou cancelados
- **CA001.5** - Deve carregar automaticamente dados do processo selecionado

### RF002 - Cadastro de Dados do Trabalhador
**Como** usuário do sistema  
**Quero** informar ou buscar dados do trabalhador envolvido no processo  
**Para que** seja possível identificar corretamente o trabalhador no eSocial

#### Critérios de Aceite:
- **CA002.1** - Sistema deve permitir informar CPF do trabalhador (11 dígitos)
- **CA002.2** - Deve validar CPF com algoritmo de dígitos verificadores
- **CA002.3** - Deve permitir busca no banco integrado de trabalhadores
- **CA002.4** - Ao localizar trabalhador, deve preencher nome e data de nascimento
- **CA002.5** - Deve permitir cadastro manual quando trabalhador não encontrado
- **CA002.6** - Para cadastro manual: nome obrigatório (até 70 caracteres)
- **CA002.7** - Para cadastro manual: data nascimento obrigatória (entre 01/01/1890 e data atual)

### RF003 - Seleção do Tipo de Contrato
**Como** usuário do sistema  
**Quero** selecionar o tipo de contrato que se aplica ao caso específico  
**Para que** o sistema apresente os campos adequados para cada situação

#### Critérios de Aceite:
- **CA003.1** - Sistema deve apresentar lista com os tipos de contrato válidos:
  - Tipo 1: Vínculo formalizado sem alteração de datas
  - Tipo 2: Vínculo formalizado com alteração na data de admissão
  - Tipo 3: Vínculo formalizado com inclusão/alteração data desligamento
  - Tipo 4: Vínculo formalizado com alteração nas duas datas
  - Tipo 5: Reconhecimento de vínculo empregatício
  - Tipo 6: TSVE sem reconhecimento de vínculo
  - Tipo 7: Vínculo formalizado em período anterior ao eSocial
  - Tipo 8: Responsabilidade indireta
  - Tipo 9: Unicidade contratual
- **CA003.2** - Deve exibir descrição detalhada de cada tipo
- **CA003.3** - Deve validar que apenas um tipo pode ser selecionado por vez
- **CA003.4** - Deve alterar dinamicamente os campos obrigatórios conforme tipo selecionado

### RF004 - Cadastro de Informações Contratuais Básicas
**Como** usuário do sistema  
**Quero** informar os dados básicos do contrato de trabalho  
**Para que** sejam registradas as informações fundamentais do vínculo

#### Critérios de Aceite:
- **CA004.1** - Sistema deve permitir informar matrícula do trabalhador (até 30 caracteres)
- **CA004.2** - Deve validar que matrícula não contenha "eSocial" nas 7 primeiras posições
- **CA004.3** - Deve permitir seleção da categoria do trabalhador (Tabela 01 eSocial)
- **CA004.4** - Deve permitir informar data de admissão original
- **CA004.5** - Data admissão deve ser posterior à data de nascimento
- **CA004.6** - Deve permitir seleção de CBO - Código Brasileiro de Ocupações
- **CA004.7** - Deve permitir seleção da natureza da atividade (Urbano/Rural)

### RF005 - Cadastro de Informações de Regime Trabalhista
**Como** usuário do sistema  
**Quero** informar detalhes do regime trabalhista  
**Para que** sejam registradas informações específicas do tipo de vínculo

#### Critérios de Aceite:
- **CA005.1** - Deve permitir seleção do tipo de regime trabalhista
- **CA005.2** - Deve permitir seleção do tipo de regime previdenciário
- **CA005.3** - Deve permitir informar tipo de jornada de trabalho
- **CA005.4** - Para contratos por prazo determinado:
  - Permitir informar data de término
  - Indicar se há cláusula assecuratória
  - Informar objeto determinante da contratação
- **CA005.5** - Deve validar compatibilidade entre regime e categoria selecionada

### RF006 - Informações de Desligamento (Quando Aplicável)
**Como** usuário do sistema  
**Quero** informar dados do desligamento quando relevante ao processo  
**Para que** sejam registradas alterações nas datas ou inclusão de desligamento

#### Critérios de Aceite:
- **CA006.1** - Campo deve aparecer conforme tipo de contrato selecionado
- **CA006.2** - Deve permitir informar data de desligamento
- **CA006.3** - Data desligamento deve ser posterior à data de admissão
- **CA006.4** - Deve permitir seleção do motivo de desligamento (Tabela 19 eSocial)
- **CA006.5** - Deve permitir informar data projetada para término de aviso prévio
- **CA006.6** - Deve permitir informar se houve aviso prévio indenizado

### RF007 - Informações de Sucessão de Vínculo
**Como** usuário do sistema  
**Quero** registrar informações de sucessão quando aplicável  
**Para que** sejam identificadas transferências entre empregadores

#### Critérios de Aceite:
- **CA007.1** - Seção deve aparecer quando selecionados tipos específicos de admissão
- **CA007.2** - Deve permitir informar tipo de inscrição do empregador anterior
- **CA007.3** - Deve permitir informar número de inscrição do empregador anterior
- **CA007.4** - Deve validar que inscrição anterior seja diferente da atual
- **CA007.5** - Deve permitir informar matrícula no empregador anterior
- **CA007.6** - Deve permitir informar data da transferência

### RF008 - Observações e Informações Complementares
**Como** usuário do sistema  
**Quero** registrar observações relevantes sobre o contrato  
**Para que** informações adicionais sejam preservadas

#### Critérios de Aceite:
- **CA008.1** - Deve permitir registrar múltiplas observações
- **CA008.2** - Cada observação pode ter até 999 caracteres
- **CA008.3** - Deve permitir adicionar/remover observações dinamicamente
- **CA008.4** - Deve numerar automaticamente as observações

### RF009 - Validações Específicas por Tipo de Contrato
**Como** sistema  
**Quero** aplicar validações específicas para cada tipo de contrato  
**Para que** seja garantida consistência dos dados conforme regras eSocial

#### Critérios de Aceite:
- **CA009.1** - Para Tipo 1 (sem alteração): não permitir alteração em datas originais
- **CA009.2** - Para Tipo 2 (alteração admissão): obrigar nova data de admissão
- **CA009.3** - Para Tipo 3 (inclusão desligamento): obrigar data e motivo desligamento
- **CA009.4** - Para Tipo 4 (alteração ambas): obrigar ambas as datas alteradas
- **CA009.5** - Para Tipo 5 (reconhecimento): validar que não existe vínculo formal anterior
- **CA009.6** - Para cada tipo, validar campos obrigatórios específicos

### RF010 - Múltiplos Trabalhadores por Processo
**Como** usuário do sistema  
**Quero** vincular múltiplos trabalhadores ao mesmo processo  
**Para que** processos coletivos sejam adequadamente registrados

#### Critérios de Aceite:
- **CA010.1** - Deve permitir adicionar múltiplos trabalhadores ao mesmo processo
- **CA010.2** - Cada trabalhador pode ter tipo de contrato diferente
- **CA010.3** - Deve exibir lista dos trabalhadores já vinculados
- **CA010.4** - Deve permitir editar informações de cada trabalhador individualmente
- **CA010.5** - Deve permitir remover trabalhadores antes do envio
- **CA010.6** - Deve validar que não há CPFs duplicados no mesmo processo

## Regras de Negócio

### RN001 - Obrigatoriedade Condicional de Campos
- Campos obrigatórios variam conforme o tipo de contrato selecionado
- Sistema deve aplicar validações dinâmicas baseadas no tipo escolhido

### RN002 - Consistência de Datas
- Data de admissão sempre posterior à data de nascimento
- Data de desligamento sempre posterior à data de admissão
- Data de transferência sempre posterior à data de admissão original

### RN003 - Unicidade de CPF por Processo
- Não é permitido vincular o mesmo CPF múltiplas vezes ao mesmo processo
- Diferentes processos podem conter o mesmo trabalhador

### RN004 - Validação de Categorias
- Categoria do trabalhador deve ser compatível com tipo de regime selecionado
- Algumas combinações de categoria e regime são mutuamente exclusivas

### RN005 - Integridade Referencial
- Trabalhador só pode ser vinculado a processo judicial existente e ativo
- Processo deve manter referência válida durante toda a operação

## Interface de Usuário

### Fluxo de Navegação
1. Seleção do processo judicial
2. Busca/cadastro do trabalhador
3. Seleção do tipo de contrato
4. Preenchimento de dados contratuais (wizard dinâmico)
5. Revisão e confirmação
6. Possibilidade de adicionar mais trabalhadores

### Características da Interface
- Formulário dinâmico que se adapta ao tipo de contrato
- Campos obrigatórios claramente identificados
- Validações em tempo real
- Progress bar indicando etapas concluídas
- Possibilidade de salvar rascunho

## Cenários de Teste

### CT001 - Vínculo Trabalhador Tipo 1 (Sem Alteração)
**Dado que** selecionei processo judicial válido  
**E** informei CPF de trabalhador existente  
**Quando** seleciono "Tipo 1 - Vínculo sem alteração"  
**E** preencho dados contratuais básicos  
**E** salvo o registro  
**Então** trabalhador deve ser vinculado com sucesso  
**E** não devem aparecer campos de alteração de datas

### CT002 - Vínculo Trabalhador Tipo 5 (Reconhecimento)
**Dado que** selecionei processo judicial válido  
**E** informei CPF de trabalhador não cadastrado  
**Quando** seleciono "Tipo 5 - Reconhecimento de vínculo"  
**E** preencho dados do novo trabalhador  
**E** informo dados contratuais do reconhecimento  
**Então** sistema deve criar registro de trabalhador  
**E** deve vincular ao processo como reconhecimento de vínculo

### CT003 - Múltiplos Trabalhadores
**Dado que** tenho processo com um trabalhador já vinculado  
**Quando** clico em "Adicionar outro trabalhador"  
**E** informo CPF diferente do primeiro  
**E** completo cadastro do segundo trabalhador  
**Então** processo deve conter dois trabalhadores vinculados  
**E** cada um com suas informações específicas

### CT004 - Validação CPF Duplicado
**Dado que** processo já possui trabalhador com CPF "12345678901"  
**Quando** tento adicionar outro trabalhador com mesmo CPF  
**Então** sistema deve exibir erro "Trabalhador já vinculado a este processo"  
**E** não deve permitir prosseguir

## Dependências e Integrações

- **Cadastro de Processo Judicial**: Dependência obrigatória
- **Banco de Trabalhadores**: Para busca automática
- **Tabelas do eSocial**: Categorias, CBOs, Motivos de Desligamento
- **Validador de CPF**: Para validação de documentos
- **Sistema de Auditoria**: Para log de alterações

## Considerações Técnicas

- Implementar factory pattern para criar formulários dinâmicos por tipo de contrato
- Utilizar validação em cascata baseada no tipo selecionado
- Implementar cache para tabelas auxiliares frequentemente acessadas
- Garantir transações atômicas para vinculação de múltiplos trabalhadores
