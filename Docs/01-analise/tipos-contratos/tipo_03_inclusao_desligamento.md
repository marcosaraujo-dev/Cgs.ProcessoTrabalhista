# Tipo 03 - Inclusão/Alteração de Desligamento - Requisitos Específicos

## Definição

**Tipo de Contrato 3**: Trabalhador com vínculo formalizado, com inclusão ou alteração de data de desligamento.

Este tipo contempla situações onde o processo trabalhista determina alteração na data de desligamento (antecipação ou postergação) ou inclusão de desligamento em vínculo ainda ativo, mantendo a data de admissão inalterada.

## Cenários de Aplicação

### Cenário Principal - Alteração de Desligamento
Trabalhador possui vínculo com desligamento registrado onde:
- Data de desligamento original está incorreta
- Processo judicial reconhece data diferente de término
- Data de admissão permanece inalterada
- Necessário alterar data de desligamento

### Cenário Alternativo - Inclusão de Desligamento
Trabalhador possui vínculo ainda ativo onde:
- Não há desligamento registrado no eSocial
- Processo judicial determina data específica de término
- Necessário incluir desligamento no vínculo ativo
- Data de admissão permanece inalterada

### Exemplos Práticos
- Demissão com data incorreta no eSocial
- Reconhecimento de justa causa em data anterior
- Determinação de reintegração até data específica
- Correção de data de término de contrato determinado
- Inclusão de desligamento por decisão judicial
- Alteração de motivo e data de desligamento
- Reconhecimento de abandono de emprego em data específica

## Requisitos Específicos

### RF301 - Identificação do Tipo de Operação
**Como** sistema  
**Quero** identificar se é inclusão ou alteração de desligamento  
**Para que** sejam aplicadas validações e campos adequados

#### Critérios de Aceite:
- **CA301.1** - Sistema deve detectar se vínculo possui desligamento no eSocial
- **CA301.2** - Se não possui: modo "Inclusão de Desligamento"
- **CA301.3** - Se possui: modo "Alteração de Desligamento"
- **CA301.4** - Interface deve adaptar-se ao modo identificado
- **CA301.5** - Validações devem ser específicas para cada modo

### RF302 - Campos para Inclusão de Desligamento
**Como** usuário do sistema  
**Quero** incluir desligamento em vínculo ativo  
**Para que** seja registrado término determinado judicialmente

#### Critérios de Aceite:
- **CA302.1** - Campo tpContr deve ser fixo = 3
- **CA302.2** - Campo indContr deve ser "S" (vínculo já cadastrado)
- **CA302.3** - Data de desligamento é obrigatória
- **CA302.4** - Motivo de desligamento é obrigatório (Tabela 19)
- **CA302.5** - Data deve ser posterior à data de admissão
- **CA302.6** - Data não pode ser futura (exceto casos específicos)

### RF303 - Campos para Alteração de Desligamento
**Como** usuário do sistema  
**Quero** alterar desligamento já existente  
**Para que** seja corrigida data/motivo conforme decisão judicial

#### Critérios de Aceite:
- **CA303.1** - Deve exibir dados originais do desligamento para comparação
- **CA303.2** - Nova data de desligamento é obrigatória
- **CA303.3** - Novo motivo pode ser diferente do original
- **CA303.4** - Deve calcular e exibir diferença entre datas
- **CA303.5** - Nova data deve respeitar limites temporais válidos

### RF304 - Validações de Data de Desligamento
**Como** sistema  
**Quero** validar consistência temporal do desligamento  
**Para que** sejam evitadas inconsistências nos dados

#### Critérios de Aceite:
- **CA304.1** - Data deve ser posterior à data de admissão
- **CA304.2** - Para alteração: nova data pode ser anterior ou posterior à original
- **CA304.3** - Data não pode conflitar com eventos posteriores já enviados
- **CA304.4** - Deve validar se empresa estava ativa na data
- **CA304.5** - Deve verificar consistência com afastamentos registrados

### RF305 - Informações Complementares do Desligamento
**Como** usuário do sistema  
**Quero** registrar informações detalhadas do desligamento  
**Para que** sejam documentadas circunstâncias específicas

#### Critérios de Aceite:
- **CA305.1** - Aviso prévio: trabalhado, indenizado ou dispensado
- **CA305.2** - Data projetada para término do aviso prévio (se aplicável)
- **CA305.3** - Indicação se pensão alimentícia deve ser suspensa
- **CA305.4** - Novo grupo dirigente (se aplicável)
- **CA305.5** - Observações específicas sobre o desligamento
- **CA305.6** - Documentação de suporte obrigatória

## Regras de Negócio Específicas

### RN301 - Validação por Tipo de Operação
- **Inclusão**: Vínculo deve estar ativo no eSocial
- **Alteração**: Vínculo deve possuir desligamento registrado
- Sistema deve detectar automaticamente o tipo necessário
- Validações específicas para cada situação

### RN302 - Consistência Temporal
- Data desligamento sempre posterior à admissão
- Para alteração: pode ser anterior ou posterior à data original
- Não pode conflitar com eventos já processados posteriormente
- Deve considerar prazos de aviso prévio quando aplicável

### RN303 - Motivos de Desligamento
- Motivo deve ser válido conforme Tabela 19 eSocial
- Alteração de motivo pode impactar cálculos de verbas
- Alguns motivos têm regras específicas de aplicação
- Sistema deve validar compatibilidade motivo vs circunstâncias

### RN304 - Impacto em Eventos Relacionados
- Alteração pode afetar eventos S-2299 já enviados
- Pode impactar cálculo de verbas rescisórias
- Pode afetar homologação de rescisão
- Sistema deve alertar sobre possíveis conflitos

## Interface Específica

### Seção Identificação da Operação
- **Tipo detectado**: "Inclusão" ou "Alteração" automaticamente
- **Status atual**: Informações do vínculo no eSocial
- **Ação a realizar**: Descrição clara da operação

### Seção Dados do Desligamento Atual (se alteração)
- **Data original**: Campo somente leitura
- **Motivo original**: Descrição do motivo atual
- **Status**: Situação atual no eSocial

### Seção Novos Dados do Desligamento
- **Nova data desligamento**: Campo obrigatório com validações
- **Novo motivo**: Lista da Tabela 19 eSocial
- **Diferença**: Cálculo automático (para alterações)
- **Justificativa**: Campo obrigatório para fundamentação

### Seção Informações Complementares
- **Aviso prévio**: Opções conforme legislação
- **Data projetada API**: Se aviso prévio indenizado
- **Pensão alimentícia**: Indicador de suspensão
- **Observações**: Campo livre para detalhes

### Seção Validações e Impactos
- **Status validação**: Indicadores visuais
- **Eventos afetados**: Lista de possíveis impactos
- **Ações sugeridas**: Recomendações automáticas

## Cenários de Teste Específicos

### CT301 - Inclusão em Vínculo Ativo
**Dado que** trabalhador possui vínculo ativo sem desligamento  
**E** processo determina término em "31/12/2023"  
**Quando** seleciono tipo "3 - Inclusão desligamento"  
**E** informo data "31/12/2023" e motivo "01 - Dispensa sem justa causa"  
**Então** sistema deve aceitar inclusão  
**E** deve validar data posterior à admissão  
**E** deve permitir registrar aviso prévio indenizado

### CT302 - Alteração Data Anterior
**Dado que** vínculo tem desligamento em "31/12/2023"  
**E** processo determina término real em "15/12/2023"  
**Quando** seleciono tipo "3 - Alteração desligamento"  
**E** informo nova data "15/12/2023"  
**Então** sistema deve aceitar alteração  
**E** deve calcular diferença: "16 dias antecipados"  
**E** deve alertar sobre possível impacto em verbas

### CT303 - Alteração Data Posterior
**Dado que** vínculo tem desligamento em "15/12/2023"  
**E** processo determina prorrogação até "31/12/2023"  
**Quando** informo nova data "31/12/2023"  
**Então** sistema deve aceitar postergação  
**E** deve calcular diferença: "16 dias prorrogados"  
**E** deve sugerir verificação de eventos do período

### CT304 - Data Inconsistente com Admissão
**Dado que** data admissão é "01/06/2023"  
**Quando** tento informar desligamento "01/05/2023" (anterior)  
**Então** sistema deve exibir erro "Desligamento não pode ser anterior à admissão"  
**E** deve impedir prosseguimento  
**E** deve destacar as datas em conflito

### CT305 - Conflito com Eventos Posteriores
**Dado que** existe evento S-1200 posterior à nova data desligamento  
**Quando** tento salvar alteração  
**Então** sistema deve alertar "Existem eventos posteriores à nova data"  
**E** deve listar eventos conflitantes  
**E** deve solicitar confirmação para prosseguir

## Validações Avançadas Específicas

### Validação de Motivos de Desligamento
- **Justa causa**: Requer documentação específica
- **Pedido de demissão**: Validar se procedimentos foram seguidos
- **Término de contrato**: Validar se contrato era determinado
- **Aposentadoria**: Verificar idade e tempo de contribuição
- **Morte**: Requer documentação oficial

### Validação de Aviso Prévio
- **Trabalhado**: Calcular período efetivamente trabalhado
- **Indenizado**: Calcular valor devido e data projetada
- **Dispensado**: Verificar se legalmente possível
- **Redução**: Aplicar regras de redução de jornada

### Validação de Verbas Rescisórias
- Calcular impacto da alteração de data nas verbas
- Verificar proporcionais (férias, 13º salário)
- Validar FGTS e multa rescisória
- Checar prazos de homologação

## Integração com eSocial

### Consultas Específicas
- Status atual do vínculo (ativo/encerrado)
- Dados do desligamento atual (se houver)
- Eventos relacionados no período
- Validação de tabelas por competência

### Eventos Relacionados
- **S-2299**: Desligamento original (se houver)
- **S-1200**: Folhas que podem ser afetadas
- **S-2220**: Afastamentos no período
- **S-2230**: Afastamentos por motivo de saúde

### Impactos Calculados
- Diferença em dias de trabalho
- Impacto em verbas rescisórias
- Alteração em totalizadores
- Efeitos em médias salariais

## Considerações Especiais

### Aspectos Legais
- Alteração requer fundamentação judicial clara
- Prazos prescricionais devem ser respeitados
- Efeitos fiscais devem ser considerados
- Homologação pode ser necessária

### Aspectos Operacionais
- Recálculo de verbas rescisórias
- Ajuste em guias de recolhimento
- Comunicação com sindicatos
- Atualização de controles internos

### Aspectos Técnicos
- Reprocessamento de cálculos relacionados
- Ajuste em eventos dependentes
- Sincronização com sistemas integrados
- Preservação do histórico de alterações

### Fluxo de Aprovação
- Validação jurídica obrigatória
- Aprovação de supervisor necessária
- Documentação de suporte anexa
- Comunicação aos interessados
