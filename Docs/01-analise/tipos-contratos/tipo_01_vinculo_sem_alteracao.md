# Tipo 01 - Vínculo sem Alteração - Requisitos Específicos

## Definição

**Tipo de Contrato 1**: Trabalhador com vínculo formalizado, sem alteração nas datas de admissão e de desligamento.

Este tipo contempla situações onde o processo trabalhista reconhece direitos ou valores adicionais, mas não altera as datas originais de admissão ou desligamento do contrato já formalizado no eSocial.

## Cenários de Aplicação

### Cenário Principal
Trabalhador possui vínculo já cadastrado no eSocial com:
- Data de admissão correta e inalterada
- Data de desligamento correta (se aplicável) e inalterada
- Processo judicial reconhece apenas valores/direitos adicionais
- Não há alteração em datas contratuais

### Exemplos Práticos
- Diferenças salariais não pagas durante o contrato
- Horas extras não computadas adequadamente
- Adicional de insalubridade não pago
- Comissões devidas mas não pagas
- Equiparação salarial determinada judicialmente
- Reintegração com pagamento de período anterior

## Requisitos Específicos

### RF101 - Validação de Vínculo Existente
**Como** sistema  
**Quero** validar que o trabalhador possui vínculo formalizado no eSocial  
**Para que** seja confirmada a existência prévia do contrato

#### Critérios de Aceite:
- **CA101.1** - Sistema deve verificar existência de evento S-2200 (Admissão) para o CPF
- **CA101.2** - Deve validar que matrícula informada corresponde à registrada no eSocial
- **CA101.3** - Deve confirmar que categoria do trabalhador está compatível
- **CA101.4** - Deve verificar se vínculo está ativo ou adequadamente encerrado
- **CA101.5** - Sistema deve aplicar REGRA_VALIDA_MATRICULA
- **CA101.6** - Deve verificar status do vínculo no momento do processo
- **CA101.7** - Deve validar período do processo vs período do vínculo


### RF102 - Campos Obrigatórios Específicos
**Como** usuário do sistema  
**Quero** preencher apenas campos relevantes para este tipo  
**Para que** seja mantida simplicidade e consistência dos dados

#### Critérios de Aceite:
- **CA102.1** - Campo tpContr deve ser fixo = 1
- **CA102.2** - Campo indContr deve ser fixo = "S" (vínculo já cadastrado)
- **CA102.3** - Campo matricula é obrigatório e deve corresponder ao eSocial
- **CA102.4** - Campos de alteração de datas devem ser ocultos/desabilitados
- **CA102.5** - Campo codCateg deve corresponder ao já informado no vínculo
- **CA102.6** - nmTrab é opcional (carregado automaticamente do eSocial)
- **CA102.7** - dtNascto é opcional (carregada automaticamente do eSocial)
- **CA102.8** - Sistema deve aplicar validação condicional dos campos

### RF103 - Restrições de Dados
**Como** sistema  
**Quero** impedir alteração de informações contratuais básicas  
**Para que** seja mantida consistência com dados já enviados ao eSocial

#### Critérios de Aceite:
- **CA103.1** - Data de admissão não pode ser alterada
- **CA103.2** - Data de desligamento não pode ser alterada
- **CA103.3** - Categoria profissional deve permanecer a mesma
- **CA103.4** - Matrícula deve corresponder exatamente à do eSocial
- **CA103.5** - Sistema deve carregar dados do vínculo existente automaticamente

### RF104 - Validações Específicas
**Como** sistema  
**Quero** aplicar validações adequadas a este tipo de contrato  
**Para que** sejam evitados erros de cadastramento

#### Critérios de Aceite:
- **CA104.1** - Deve validar que não há conflito com outros eventos S-2500 do mesmo CPF/matrícula
- **CA104.2** - Deve verificar se período do processo é compatível com período do vínculo
- **CA104.3** - Deve validar que trabalhador não possui outro S-2500 tipo 1 pendente
- **CA104.4** - Deve confirmar que dados básicos (nome, CPF, nascimento) são consistentes
- **CA104.5** - Deve aplicar REGRA_COMPATIBILIDADE_CATEGORIA_CLASSTRIB
- **CA104.6** - Deve aplicar REGRA_COMPATIB_CATEG_EVENTO

### RF105 - Validações de Categoria e CBO
**Como** sistema
**Quero** validar compatibilidade entre categoria e CBO
**Para que** sejam respeitadas regras específicas do eSocial

#### Critérios de Aceite:

- **CA105.1** - codCBO é obrigatório exceto para categorias [901, 903, 904]
- **CA105.2** - Sistema deve validar se CBO é compatível com categoria informada
- **CA105.3** - Deve aplicar tabela de compatibilidade CBO vs Categoria
- **CA105.4** - Deve alertar se CBO não é adequado para a função
- **CA105.5** - Para categorias especiais, aplicar regras específicas de CBO

### RF106 - Informações Complementares Permitidas
**Como** usuário do sistema  
**Quero** poder registrar informações adicionais relevantes  
**Para que** sejam documentadas peculiaridades do caso

#### Critérios de Aceite:
- **CA106.1** - Deve permitir múltiplas observações sobre o processo
- **CA106.2** - Deve permitir informar mudanças de categoria durante o contrato (mudCategAtiv)
- **CA106.3** - Deve permitir registrar alterações de natureza da atividade
- **CA106.4** - Campos de sucessão de vínculo devem estar disponíveis se aplicável
- **CA106.5** - Deve permitir informações sobre responsabilidade indireta

### RF107 - Carregamento Automático de Dados eSocial
**Como** sistema
**Quero** carregar automaticamente dados do eSocial
**Para que** seja garantida consistência e reduzido trabalho manual

#### Critérios de Aceite:

- **CA107.1** - Sistema deve buscar automaticamente dados do vínculo no eSocial
- **CA107.2** - Deve carregar: nome, CPF, data nascimento, categoria, data admissão
- **CA107.3** - Deve carregar data desligamento se vínculo encerrado
- **CA107.4** - Deve validar se dados carregados são consistentes
- **CA107.5** - Deve alertar se há divergências entre informado vs eSocial
- **CA107.6** - Deve permitir refresh/recarregamento dos dados

## Regras de Negócio Específicas

### RN101 - Obrigatoriedade do Vínculo Prévio
- Trabalhador DEVE possuir vínculo já cadastrado no eSocial
- Não é permitido criar novo vínculo com este tipo
- Sistema deve buscar e carregar dados do vínculo existente

### RN102 - Imutabilidade das Datas Contratuais
- Datas de admissão e desligamento não podem ser alteradas
- Qualquer alteração nestas datas requer uso de tipos específicos (2, 3 ou 4)
- Sistema deve bloquear edição destes campos

### RN103 - Consistência com Dados do eSocial
- Informações básicas devem ser idênticas às já enviadas
- Discrepâncias devem gerar alertas e impedir prosseguimento
- Sistema deve sincronizar com base do eSocial quando possível

### RN104 - Unicidade por Processo
- Mesmo trabalhador/matrícula não pode ter múltiplos registros tipo 1 no mesmo processo
- Diferentes processos podem conter o mesmo trabalhador tipo 1
- Sistema deve validar unicidade dentro do escopo do processo

### RN105 - Validação de Matrícula
- Matrícula deve existir e estar ativa no eSocial do empregador
- Não pode conter "eSocial" nas 7 primeiras posições
- Deve corresponder exatamente ao registro original
- Sistema deve aplicar REGRA_VALIDA_MATRICULA

### RN106 - Compatibilidade Categoria
- Categoria deve ser compatível com o registrado no eSocial
- Deve aplicar REGRA_COMPATIBILIDADE_CATEGORIA_CLASSTRIB
- CBO deve ser adequado à categoria (exceto [901, 903, 904])
- Sistema deve validar tabelas de compatibilidade

### RN107 - Carregamento Automático
- Sistema deve carregar dados automaticamente do eSocial
- Campos nmTrab e dtNascto são opcionais para tipo 1
- Dados carregados têm prioridade sobre informação manual
- Divergências devem gerar alertas para o usuário

## Interface Específica

### Campos Visíveis
- Dados do trabalhador (CPF, nome, nascimento) - somente leitura
- Matrícula - obrigatório, deve corresponder ao eSocial
- Categoria profissional - carregada automaticamente
- Observações do processo - opcional, múltiplas
- Mudanças de categoria/atividade - opcional
- Informações de sucessão - se aplicável

### Campos Ocultos/Desabilitados
- Data de admissão (carregada automaticamente)
- Data de desligamento (carregada automaticamente) 
- Indicadores de alteração de datas
- Campos específicos de reconhecimento de vínculo
- Opções de TSVE

### Validações em Tempo Real
- Verificação de matrícula vs eSocial
- Validação de CPF vs dados já cadastrados
- Consistência de categoria profissional
- Verificação de duplicidade no processo

### Seção Integração eSocial
- Botão refresh: Para recarregar dados do eSocial
- Alertas de divergência: Se houver inconsistências

## Cenários de Teste Específicos

### CT101 - Cadastro Tipo 1 Válido
**Dado que** trabalhador possui vínculo ativo no eSocial  
**E** processo judicial não altera datas contratuais  
**Quando** seleciono tipo de contrato "1 - Sem alteração"  
**E** informo matrícula correspondente ao eSocial  
**Então** sistema deve carregar dados automaticamente  
**E** deve permitir cadastro apenas de informações adicionais  
**E** deve salvar com sucesso

### CT102 - Validação Matrícula Inexistente 
**Dado que** informei matrícula que não existe no eSocial  
**Quando** tento prosseguir com tipo 1  
**Então**  sistema deve aplicar REGRA_VALIDA_MATRICULA
**E** sistema deve exibir erro "Matrícula não encontrada no eSocial"  
**E** deve impedir prosseguimento  
**E** deve sugerir verificação da matrícula

### CT103 - Carregamento Automático Dados eSocial
**Dado que** informei matrícula válida do eSocial
**Quando** campo perde foco
**Então** sistema deve buscar dados automaticamente
**E** deve preencher: nome, CPF, nascimento, categoria
**E** deve carregar data admissão e desligamento (se houver)
**E** deve exibir confirmação "Dados carregados do eSocial"
**E** deve marcar campos como somente leitura

### CT104 - Tentativa Alteração Data
**Dado que** estou cadastrando trabalhador tipo 1  
**Quando** sistema carrega data de admissão do eSocial  
**Então** campo deve estar visível mas desabilitado  
**E** não deve permitir alteração manual  
**E** deve manter valor original durante todo o processo

### CT105 - Duplicidade no Processo
**Dado que** processo já possui trabalhador tipo 1 com CPF "12345678901"  
**Quando** tento adicionar mesmo CPF novamente como tipo 1  
**Então** sistema deve exibir erro "Trabalhador já cadastrado neste processo"  
**E** deve oferecer opção de editar registro existente  
**E** não deve permitir criação de duplicata

### CT106 - Validação CBO por Categoria
**Dado que** categoria carregada é "101 - Empregado geral"
**E** informo CBO incompatível com esta categoria
**Quando** sistema valida informações
**Então** deve aplicar REGRA_COMPATIB_CATEG_EVENTO
**E** deve alertar "CBO incompatível com categoria 101"
**E** deve sugerir CBOs adequados

### CT107 - Categoria Especial sem CBO (NOVO)
**Dado que** trabalhador possui categoria "901 - Dirigente sindical"
**Quando** não informo CBO
**Então** sistema deve aceitar (CBO opcional para [901, 903, 904])
**E** não deve exibir erro de CBO obrigatório
**E** deve processar normalmente

### CT108 - Carregamento Automático de Dados
**Dado que** informei código do funci   
**Quando** campo perde foco  
**Então** sistema deve buscar dados automaticamente  
**E** deve preencher: nome, CPF, nascimento, categoria  
**E** deve carregar data admissão e desligamento (se houver)  
**E** deve exibir confirmação "Dados carregados do eSocial"

## Integração com eSocial

### Consultas Necessárias
- Verificação de existência do vínculo (S-2200)
- Consulta de dados básicos do trabalhador
- Validação de matrícula ativa
- Verificação de eventos relacionados

### Dados Sincronizados
- Informações pessoais do trabalhador
- Dados contratuais básicos
- Datas de admissão e desligamento
- Categoria profissional atual

### Validações Cruzadas
- Consistência entre processo e vínculo eSocial
- Períodos de validade dos dados
- Compatibilidade de categorias e regimes
- Verificação de eventos conflitantes

## Considerações Especiais

### Histórico e Auditoria
- Registrar origem dos dados (eSocial vs manual)
- Manter log de sincronizações realizadas
- Preservar versões dos dados carregados
- Registrar discrepâncias identificadas

### Performance
- Cache de consultas ao eSocial
- Validações otimizadas para este tipo
- Carregamento assíncrono de dados externos
- Timeout adequado para consultas

### Manutenibilidade
- Separação clara entre dados editáveis e somente leitura
- Componentes reutilizáveis para integração eSocial
- Configuração flexível para diferentes ambientes
- Tratamento robusto de erros de comunicação
