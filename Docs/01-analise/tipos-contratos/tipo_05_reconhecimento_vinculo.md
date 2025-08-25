# Tipo 05 - Reconhecimento de Vínculo Empregatício - Requisitos Específicos

## Definição

**Tipo de Contrato 5**: Empregado com reconhecimento de vínculo empregatício.

Este tipo contempla situações onde o processo trabalhista reconhece a existência de vínculo empregatício que não foi formalizado previamente no eSocial, criando um novo registro de contrato de trabalho com base na decisão judicial.

## Cenários de Aplicação

### Cenário Principal
Trabalhador prestou serviços sem vínculo formalizado onde:
- Não existe registro S-2200 (Admissão) no eSocial
- Processo judicial reconhece existência de vínculo empregatício
- Necessário criar novo registro de contrato de trabalho
- Estabelecer datas de início e término do vínculo reconhecido

### Cenário Secundário - Trabalhador com Outros Vínculos
Trabalhador possui cadastro no eSocial por outros contratos, mas:
- Processo se refere a vínculo diferente não declarado
- Reconhecimento de vínculo paralelo ou anterior
- Necessário adicionar novo contrato ao mesmo CPF

### Exemplos Práticos
- Trabalho sem carteira assinada reconhecido judicialmente
- Prestação de serviços caracterizada como vínculo empregatício
- Trabalho informal posteriormente reconhecido
- Relação de trabalho mascarada como prestação de serviços
- Reconhecimento de vínculo em cooperativa de trabalho
- Trabalho doméstico não registrado
- Atividade rural sem formalização

## Requisitos Específicos

### RF501 - Validação de Inexistência de Vínculo
**Como** sistema  
**Quero** confirmar que não existe vínculo formalizado para o período  
**Para que** seja justificado o reconhecimento de novo vínculo

#### Critérios de Aceite:
- **CA501.1** - Sistema deve verificar inexistência de S-2200 para o período
- **CA501.2** - Deve validar que não há sobreposição com vínculos existentes
- **CA501.3** - Pode existir outros vínculos do mesmo CPF em períodos diferentes
- **CA501.4** - Deve alertar se existe vínculo ativo conflitante
- **CA501.5** - Deve validar se trabalhador está cadastrado no eSocial

### RF502 - Campos para Novo Vínculo Empregatício
**Como** usuário do sistema  
**Quero** criar completamente novo vínculo de trabalho  
**Para que** seja registrado contrato reconhecido judicialmente

#### Critérios de Aceite:
- **CA502.1** - Campo tpContr deve ser fixo = 5
- **CA502.2** - Campo indContr deve ser "N" (novo contrato)
- **CA502.3** - Matrícula deve ser criada especificamente para este vínculo
- **CA502.4** - Categoria profissional é obrigatória
- **CA502.5** - Data de admissão é obrigatória (início do vínculo reconhecido)
- **CA502.6** - Data de desligamento é obrigatória (término do vínculo)

### RF503 - Informações Contratuais Completas
**Como** usuário do sistema  
**Quero** registrar todas as informações do contrato reconhecido  
**Para que** sejam documentadas condições de trabalho identificadas

#### Critérios de Aceite:
- **CA503.1** - CBO é obrigatório conforme função exercida
- **CA503.2** - Salário/remuneração conforme apurado no processo
- **CA503.3** - Regime trabalhista (CLT, estatutário) conforme reconhecimento
- **CA503.4** - Natureza da atividade (urbano/rural) conforme caso
- **CA503.5** - Tipo de contrato (determinado/indeterminado) conforme situação
- **CA503.6** - Jornada de trabalho conforme apuração judicial

### RF504 - Dados do Trabalhador
**Como** usuário do sistema  
**Quero** registrar ou confirmar dados pessoais do trabalhador  
**Para que** seja criado ou vinculado cadastro correto

#### Critérios de Aceite:
- **CA504.1** - CPF é obrigatório e deve ser válido
- **CA504.2** - Nome completo é obrigatório
- **CA504.3** - Data de nascimento é obrigatória
- **CA504.4** - Se trabalhador já existe no eSocial, carregar dados existentes
- **CA504.5** - Se novo trabalhador, criar cadastro completo
- **CA504.6** - Validar consistência dos dados informados

### RF505 - Informações Específicas do Reconhecimento
**Como** usuário do sistema  
**Quero** registrar características específicas do reconhecimento  
**Para que** sejam documentadas particularidades do caso

#### Critérios de Aceite:
- **CA505.1** - Indicar se houve reconhecimento de categoria diferente
- **CA505.2** - Registrar se houve reconhecimento de natureza de atividade diferente
- **CA505.3** - Informar se reconhecimento incluiu período de experiência
- **CA505.4** - Documentar se houve reconhecimento de função específica
- **CA505.5** - Registrar peculiaridades da prestação de serviços

## Regras de Negócio Específicas

### RN501 - Criação de Novo Vínculo
- Sistema DEVE criar novo registro S-2200 virtual
- Matrícula deve ser única para o empregador/trabalhador
- Não pode conflitar com vínculos existentes no mesmo período
- Dados contratuais devem ser completos e consistentes

### RN502 - Validação Temporal
- Data admissão deve ser anterior à data desligamento
- Período não pode sobrepor vínculos já formalizados
- Datas devem ser consistentes com apuração do processo
- Deve respeitar limites temporais da legislação trabalhista

### RN503 - Consistência de Dados
- Categoria deve ser compatível com função exercida
- Salário deve ser condizente com mercado da época
- CBO deve corresponder à atividade efetivamente exercida
- Regime trabalhista deve ser apropriado ao tipo de serviço

### RN504 - Integração com Cadastro Existente
- Se trabalhador já existe, não duplicar dados pessoais
- Manter histórico de todos os vínculos do trabalhador
- Respeitar sequência cronológica dos contratos
- Validar consistência com outros vínculos do mesmo CPF

## Interface Específica

### Seção Identificação do Trabalhador
- **CPF**: Campo obrigatório com validação
- **Buscar trabalhador**: Botão para busca no eSocial
- **Nome completo**: Obrigatório se não encontrado
- **Data nascimento**: Obrigatória se novo trabalhador
- **Status cadastro**: Indicar se existe ou será criado

### Seção Dados do Novo Vínculo
- **Matrícula**: Gerada automaticamente ou informada pelo usuário
- **Data admissão**: Início do vínculo reconhecido
- **Data desligamento**: Término do vínculo reconhecido
- **Período reconhecido**: Cálculo automático da duração
- **Categoria profissional**: Lista da Tabela 01 eSocial

### Seção Informações Contratuais
- **CBO**: Código da função efetivamente exercida
- **Salário/Remuneração**: Valor apurado no processo
- **Regime trabalhista**: CLT, estatutário, etc.
- **Tipo contrato**: Determinado/indeterminado
- **Natureza atividade**: Urbano/rural
- **Jornada trabalho**: Horas/dia conforme apuração

### Seção Características do Reconhecimento
- **Motivo reconhecimento**: Fundamentação legal
- **Particularidades**: Campo para detalhes específicos
- **Documentação**: Anexos comprobatórios
- **Observações**: Campo livre para anotações

### Seção Validações e Alertas
- **Status validação**: Indicadores visuais de consistência
- **Conflitos**: Lista de possíveis inconsistências
- **Sugestões**: Recomendações automáticas

## Cenários de Teste Específicos

### CT501 - Reconhecimento Vínculo Trabalhador Inexistente
**Dado que** CPF "12345678901" não existe no eSocial  
**E** processo reconhece vínculo de "01/01/2023 a 31/12/2023"  
**Quando** seleciono tipo "5 - Reconhecimento vínculo"  
**E** informo dados completos do trabalhador e contrato  
**Então** sistema deve criar novo trabalhador  
**E** deve criar novo vínculo associado  
**E** deve validar todos os dados obrigatórios

### CT502 - Reconhecimento para Trabalhador Existente
**Dado que** trabalhador já possui outros vínculos no eSocial  
**E** processo reconhece novo vínculo não sobreposto  
**Quando** informo CPF existente  
**Então** sistema deve carregar dados pessoais automaticamente  
**E** deve permitir criar novo vínculo adicional  
**E** deve validar não sobreposição de períodos

### CT503 - Sobreposição com Vínculo Existente
**Dado que** trabalhador possui vínculo ativo de "01/06/2023 a 31/12/2023"  
**Quando** tento reconhecer vínculo de "01/11/2023 a 31/01/2024"  
**Então** sistema deve alertar "Sobreposição com vínculo existente"  
**E** deve mostrar período conflitante  
**E** deve impedir cadastro até resolução

### CT504 - Data Desligamento Anterior à Admissão
**Dado que** informei data admissão "01/06/2023"  
**Quando** informo data desligamento "31/05/2023" (anterior)  
**Então** sistema deve exibir erro "Desligamento deve ser posterior à admissão"  
**E** deve impedir prosseguimento  
**E** deve destacar campos conflitantes

### CT505 - Matrícula Duplicada
**Dado que** empregador já possui matrícula "001" para outro trabalhador  
**Quando** tento usar mesma matrícula "001" para reconhecimento  
**Então** sistema deve alertar "Matrícula já existe para este empregador"  
**E** deve sugerir próxima matrícula disponível  
**E** deve permitir correção

## Validações Avançadas Específicas

### Validação de Reconhecimento Legal
- Verificar se categoria permite reconhecimento retroativo
- Validar se período é plausível para a função
- Checar se remuneração é compatível com mercado da época
- Confirmar se regime trabalhista é apropriado

### Validação de Trabalhador
- Se novo: validar dados pessoais completos
- Se existente: confirmar consistência com dados cadastrados
- Verificar idade mínima para trabalho no período
- Validar capacidade legal para exercer a função

### Validação de Empregador
- Confirmar se empresa estava ativa no período reconhecido
- Verificar se CNAE permitia a atividade
- Validar existência do estabelecimento
- Checar capacidade de ter empregados na época

### Validação de Período
- Confirmar viabilidade temporal do reconhecimento
- Verificar se legislação da época permitia a situação
- Validar se não há conflitos com obrigações já cumpridas
- Checar consistência com outros eventos do período

## Integração com eSocial

### Criação Virtual de Eventos
- Simular criação de S-2200 (Admissão)
- Preparar S-2299 (Desligamento) se aplicável
- Considerar necessidade de S-1200 (Folha) retroativas
- Planejar sequência de envio dos eventos

### Consultas Necessárias
- Verificar trabalhador existente
- Validar vínculos conflitantes
- Consultar tabelas vigentes no período
- Confirmar situação do empregador

### Impactos em Outros Sistemas
- Integração com folha de pagamento
- Cálculo de contribuições retroativas
- Geração de guias de recolhimento
- Atualização de controles internos

## Considerações Especiais

### Aspectos Legais Críticos
- Reconhecimento deve ter fundamentação judicial sólida
- Efeitos retroativos devem ser claramente definidos
- Prescrição de direitos deve ser considerada
- Responsabilidades fiscais devem ser avaliadas

### Aspectos Operacionais
- Processo mais complexo que outros tipos
- Requer validação jurídica rigorosa
- Necessita aprovação de nível superior
- Demanda documentação extensa

### Aspectos Técnicos
- Criação de registros retroativos
- Cálculos complexos de verbas e contribuições
- Integração com múltiplos sistemas
- Controle de versionamento específico

### Fluxo de Aprovação Especial
- Análise jurídica obrigatória
- Validação contábil/fiscal
- Aprovação de diretoria
- Comunicação formal aos órgãos competentes

### Monitoramento Pós-Reconhecimento
- Acompanhar aceitação pelo eSocial
- Verificar cálculo de contribuições
- Monitorar impactos em outros trabalhadores
- Validar correção de todos os registros relacionados
