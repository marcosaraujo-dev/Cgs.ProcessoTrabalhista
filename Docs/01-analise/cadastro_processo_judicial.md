# Cadastro de Processo Judicial - Requisitos e Critérios de Aceite

## Visão Geral

Este documento define os requisitos funcionais e critérios de aceite para o cadastro de processos judiciais no sistema eSocial de Processos Trabalhistas, contemplando os dados essenciais do evento S-2500.

## Objetivos

- Permitir o cadastro completo dos dados do processo judicial
- Garantir a integridade e validação dos dados conforme especificação eSocial
- Possibilitar o reuso de processos para múltiplos trabalhadores
- Manter rastreabilidade e auditoria de todas as operações

## Escopo Funcional

### RF001 - Cadastro de Dados Básicos do Processo
**Como** usuário do sistema  
**Quero** cadastrar os dados essenciais de um processo judicial trabalhista  
**Para que** possa vincular trabalhadores e posteriormente gerar os XMLs do eSocial

#### Critérios de Aceite:
- **CA001.1** - Sistema deve permitir informar número do processo com formato NNNNNNN-NN.AAAA.N.NN.NNNN (20 dígitos)
- **CA001.2** - Deve validar se o número do processo é único no sistema
- **CA001.3** - Sistema deve permitir informar observações do processo (até 999 caracteres)
- **CA001.4** - Deve permitir definir origem como "Processo Judicial"

### RF002 - Cadastro de Dados do Empregador
**Como** usuário do sistema  
**Quero** informar os dados do empregador responsável pelo processo  
**Para que** seja possível identificar corretamente o declarante no eSocial

#### Critérios de Aceite:
- **CA002.1** - Sistema deve permitir selecionar tipo de inscrição (CNPJ ou CPF)
- **CA002.2** - Para CNPJ: deve validar formato com 14 dígitos e dígitos verificadores
- **CA002.3** - Para CPF: deve validar formato com 11 dígitos e dígitos verificadores
- **CA002.4** - Deve permitir preenchimento manual ou busca no banco integrado de empresas
- **CA002.5** - Ao buscar empresa, deve preencher automaticamente razão social e inscrição

### RF003 - Cadastro de Dados do Responsável Indireto (Opcional)
**Como** usuário do sistema  
**Quero** informar dados do responsável indireto quando aplicável  
**Para que** seja possível identificar responsabilidade indireta no processo

#### Critérios de Aceite:
- **CA003.1** - Campo opcional que pode ser preenchido quando há responsabilidade indireta
- **CA003.2** - Deve validar tipo de inscrição (CNPJ ou CPF)
- **CA003.3** - Deve validar formato da inscrição conforme tipo selecionado
- **CA003.4** - Deve permitir busca no banco integrado de empresas

### RF004 - Cadastro de Dados Específicos do Processo Judicial
**Como** usuário do sistema  
**Quero** informar os dados específicos da decisão judicial  
**Para que** seja possível registrar corretamente as informações da sentença

#### Critérios de Aceite:
- **CA004.1** - Sistema deve obrigar preenchimento da data da sentença
- **CA004.2** - Data da sentença não pode ser superior à data atual
- **CA004.3** - Deve permitir seleção da UF da Vara (lista com estados brasileiros)
- **CA004.4** - Deve permitir seleção do código do município (integração com tabela IBGE)
- **CA004.5** - Deve permitir informar identificação da Vara (até 50 caracteres)

### RF005 - Controle de Status e Auditoria
**Como** usuário do sistema  
**Quero** acompanhar o status do processo e ter controle de auditoria  
**Para que** seja possível rastrear todas as alterações e o ciclo de vida do processo

#### Critérios de Aceite:
- **CA005.1** - Sistema deve registrar automaticamente usuário e data de inclusão
- **CA005.2** - Deve manter histórico de alterações com usuário e data
- **CA005.3** - Deve controlar status: Cadastrado, Em Processamento, Enviado, Erro, Cancelado
- **CA005.4** - Deve permitir apenas usuários autorizados a alterar registros
- **CA005.5** - Deve registrar usuário e data de envio para transmissão quando aplicável

### RF006 - Validações de Negócio
**Como** sistema  
**Quero** aplicar todas as validações necessárias conforme regras do eSocial  
**Para que** seja garantida a integridade dos dados antes do envio

#### Critérios de Aceite:
- **CA006.1** - Deve validar se todos os campos obrigatórios foram preenchidos
- **CA006.2** - Deve aplicar validações de formato para todos os campos
- **CA006.3** - Deve validar compatibilidade entre dados informados
- **CA006.4** - Deve exibir mensagens de erro claras e específicas
- **CA006.5** - Deve impedir salvamento enquanto houver erros de validação

## Regras de Negócio

### RN001 - Unicidade do Processo
- Cada número de processo deve ser único no sistema
- Não é permitido cadastrar o mesmo número de processo mais de uma vez

### RN002 - Obrigatoriedade por Origem
- Para processos judiciais, são obrigatórios: data da sentença, UF da Vara, código do município
- Identificação da Vara é opcional mas recomendada

### RN003 - Validações de Datas
- Data da sentença deve ser igual ou anterior à data atual
- Data de inclusão é automaticamente definida pelo sistema
- Data de alteração é atualizada a cada modificação

### RN004 - Controle de Acesso
- Apenas usuários com perfil adequado podem cadastrar processos
- Histórico de auditoria não pode ser alterado por usuários
- Processos enviados não podem ser excluídos, apenas cancelados

## Interface de Usuário

### Organização das Informações
- Agrupamento em abas ou seções lógicas
- Campos obrigatórios claramente identificados
- Validações em tempo real durante preenchimento
- Mensagens de erro contextuais

### Navegação
- Wizard com passos bem definidos
- Possibilidade de salvar rascunho a qualquer momento
- Navegação entre etapas sem perda de dados
- Confirmação antes de operações críticas

## Cenários de Teste

### CT001 - Cadastro Completo Válido
**Dado que** estou na tela de cadastro de processo judicial  
**Quando** preencho todos os campos obrigatórios com dados válidos  
**E** clico em salvar  
**Então** o processo deve ser cadastrado com sucesso  
**E** deve receber um ID único  
**E** status deve ser "Cadastrado"

### CT002 - Validação de Processo Duplicado
**Dado que** existe um processo com número "1234567-89.2024.5.02.1234"  
**Quando** tento cadastrar outro processo com o mesmo número  
**Então** sistema deve exibir erro "Número de processo já cadastrado"  
**E** não deve permitir o salvamento

### CT003 - Integração com Cadastro de Empresas
**Dado que** estou informando dados do empregador  
**Quando** clico em "Buscar Empresa"  
**E** informo CNPJ válido existente no banco integrado  
**Então** sistema deve preencher automaticamente razão social  
**E** deve manter o CNPJ informado

### CT004 - Validação de Campos Obrigatórios
**Dado que** estou cadastrando um processo judicial  
**Quando** tento salvar sem preencher data da sentença  
**Então** sistema deve exibir erro "Data da sentença é obrigatória"  
**E** deve posicionar cursor no campo  
**E** não deve permitir prosseguir

## Dependências e Integrações

- **Banco de Empresas**: Para busca automática de dados de empregadores
- **Tabela de Municípios IBGE**: Para validação de códigos de município
- **Sistema de Auditoria**: Para registro de logs de alterações
- **Validador de Documentos**: Para validação de CNPJ/CPF

## Considerações Técnicas

- Implementar validações tanto no frontend quanto no backend
- Utilizar componentes reutilizáveis para campos de documento (CNPJ/CPF)
- Implementar máscara de formatação para campos específicos
- Garantir responsividade da interface para diferentes resoluções
