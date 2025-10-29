# Tipo 07 - Período Anterior ao eSocial - Requisitos Específicos

## Definição

**Tipo de Contrato 7**: Trabalhador com vínculo de emprego formalizado em período anterior ao eSocial.

Este tipo contempla situações onde o processo trabalhista envolve vínculos que existiram antes do início da obrigatoriedade do envio dos eventos não periódicos do eSocial, cujo encerramento ocorreu antes da vigência do sistema.

## Marco Temporal do eSocial

### Início da Obrigatoriedade por Grupo
- **Grandes empresas** (receita > R$ 78 milhões): Janeiro/2018
- **Demais empresas privadas**: Julho/2018  
- **Simples Nacional**: Janeiro/2019
- **Empregadores domésticos**: Outubro/2015
- **Órgãos públicos**: Conforme cronograma específico

### Período Pré-eSocial
Vínculos iniciados e/ou encerrados antes das datas acima são considerados "período anterior ao eSocial" para fins deste tipo de contrato.

## Cenários de Aplicação

### Cenário Principal
Trabalhador possui vínculo encerrado antes do eSocial onde:
- Admissão e desligamento ocorreram antes da obrigatoriedade
- Não foi enviado evento S-2200 para este vínculo
- Processo trabalhista reconhece direitos ou altera dados
- Necessário registrar vínculo histórico no eSocial

### Cenário com Alteração de Datas
Trabalhador teve vínculo pré-eSocial onde processo determina:
- Alteração na data de admissão original
- Alteração na data de desligamento original  
- Correção de dados contratuais da época
- Reconhecimento de período adicional

### Exemplos Práticos
- Vínculo de 2015-2017 com processo julgado em 2024
- Contrato encerrado em 2016 com diferenças salariais reconhecidas
- Vínculo anterior ao eSocial com data de admissão incorreta
- Processo que reconhece período adicional pré-eSocial
- Correção de categoria profissional de vínculo histórico
- Reconhecimento de função de confiança em período anterior

## Requisitos Específicos

### RF701 - Validação de Período Pré-eSocial
**Como** sistema  
**Quero** confirmar que vínculo é realmente anterior ao eSocial  
**Para que** seja aplicado tratamento adequado para vínculos históricos

#### Critérios de Aceite:
- **CA701.1** - Sistema deve validar data de desligamento anterior ao eSocial obrigatório
- **CA701.2** - Deve considerar cronograma específico por tipo de empregador
- **CA701.3** - Deve verificar que não existe S-2200 para este vínculo
- **CA701.4** - Deve confirmar que vínculo estava encerrado na data de obrigatoriedade
- **CA701.5** - Deve alertar se há inconsistência temporal com obrigatoriedade

### RF702 - Campos para Vínculo Histórico
**Como** usuário do sistema  
**Quero** registrar vínculo que existiu antes do eSocial  
**Para que** sejam documentadas informações históricas necessárias

#### Critérios de Aceite:
- **CA702.1** - Campo tpContr deve ser fixo = 7
- **CA702.2** - Campo indContr deve ser "N" (novo registro histórico)
- **CA702.3** - Data de admissão é obrigatória e deve ser pré-eSocial
- **CA702.4** - Data de desligamento é obrigatória e deve ser pré-eSocial
- **CA702.5** - Categoria profissional conforme vigente na época
- **CA702.6** - Matrícula deve ser criada especificamente

### RF703 - Informações Contratuais Históricas
**Como** usuário do sistema  
**Quero** registrar dados contratuais válidos para época do vínculo  
**Para que** sejam preservadas informações adequadas ao período

#### Critérios de Aceite:
- **CA703.1** - CBO deve ser válido conforme tabela da época
- **CA703.2** - Salário deve ser compatível com valores históricos
- **CA703.3** - Regime trabalhista conforme legislação vigente
- **CA703.4** - Categoria deve existir na tabela do período
- **CA703.5** - Natureza atividade (urbano/rural) conforme situação
- **CA703.6** - Tipo contrato adequado às regras da época

### RF704 - Validações Temporais Específicas
**Como** sistema  
**Quero** aplicar validações adequadas ao período histórico  
**Para que** sejam respeitadas regras vigentes na época do vínculo

#### Critérios de Aceite:
- **CA704.1** - Validar idade mínima para trabalho conforme lei da época
- **CA704.2** - Verificar se categoria era permitida no período
- **CA704.3** - Confirmar se empresa estava ativa nas datas informadas
- **CA704.4** - Validar se legislação trabalhista permitia a situação
- **CA704.5** - Checar se não há conflito com outros vínculos históricos

### RF705 - Alterações em Vínculo Histórico
**Como** usuário do sistema  
**Quero** poder alterar dados de vínculo pré-eSocial quando determinado  
**Para que** sejam corrigidas informações conforme processo judicial

#### Critérios de Aceite:
- **CA705.1** - Permitir alteração de data de admissão se determinado
- **CA705.2** - Permitir alteração de data de desligamento se necessário
- **CA705.3** - Permitir correção de categoria profissional
- **CA705.4** - Permitir ajuste de salário conforme reconhecimento
- **CA705.5** - Manter consistência temporal após alterações
- **CA705.6** - Registrar todas as alterações para auditoria

## Regras de Negócio Específicas

### RN701 - Validação do Marco Temporal
- Sistema DEVE verificar cronograma específico por tipo de empregador
- Data de desligamento deve ser anterior à obrigatoriedade eSocial
- Não pode existir S-2200 cadastrado para o vínculo
- Deve considerar prorrogações e alterações de prazo oficiais

### RN702 - Legislação Vigente na Época
- Aplicar regras trabalhistas válidas no período do vínculo
- Considerar alterações constitucionais relevantes
- Respeitar categorias profissionais existentes na época
- Usar tabelas de referência históricas quando disponíveis

### RN703 - Registros Históricos
- Criar vínculo como registro histórico no eSocial
- Não gerar obrigações acessórias retroativas automaticamente
- Preservar características originais do contrato
- Documentar origem das informações (processo judicial)

### RN704 - Impactos Tributários
- Não gerar automaticamente obrigações de FGTS retroativo
- Considerar prescrição de direitos conforme época
- Avaliar impactos previdenciários conforme legislação vigente
- Alertar sobre possíveis reflexos fiscais

## Interface Específica

### Seção Identificação do Período
- **Marco eSocial**: Data obrigatória para o empregador
- **Status do vínculo**: "Histórico - Anterior ao eSocial"  
- **Período do contrato**: Datas de admissão e desligamento
- **Validação temporal**: Confirmação de período pré-eSocial

### Seção Dados do Vínculo Histórico
- **Matrícula histórica**: Gerada para o registro
- **Categoria na época**: Conforme tabelas vigentes
- **CBO histórico**: Código válido no período
- **Salário da época**: Valor compatível com período
- **Regime trabalhista**: Conforme legislação vigente

### Seção Informações do Processo
- **Data do processo**: Quando foi iniciado/julgado
- **Alterações determinadas**: O que deve ser modificado
- **Documentação**: Comprovantes do vínculo histórico
- **Justificativa**: Razões para registro retroativo

### Seção Validações Históricas
- **Legislação da época**: Regras aplicáveis ao período
- **Compatibilidade**: Verificação de dados vs época
- **Conflitos**: Sobreposições com outros vínculos
- **Impactos**: Consequências do registro histórico

### Seção Observações e Alertas
- **Prescrição**: Alertas sobre direitos prescritos
- **Tributação**: Impactos fiscais potenciais
- **Documentação**: Necessidade de comprovação adicional
- **Recomendações**: Sugestões automáticas do sistema

## Cenários de Teste Específicos

### CT701 - Vínculo Totalmente Pré-eSocial
**Dado que** empresa tem obrigatoriedade eSocial desde "01/01/2018"  
**E** vínculo foi "01/01/2015 a 31/12/2017" (anterior)  
**Quando** seleciono tipo "7 - Período anterior eSocial"  
**E** informo dados do vínculo histórico  
**Então** sistema deve aceitar como pré-eSocial  
**E** deve criar registro histórico  
**E** não deve gerar obrigações automáticas

### CT702 - Vínculo com Desligamento Pós-eSocial
**Dado que** obrigatoriedade eSocial é "01/01/2018"  
**Quando** informo vínculo "01/01/2015 a 31/03/2018" (desligamento pós)  
**Então** sistema deve alertar "Desligamento posterior ao eSocial"  
**E** deve sugerir verificação de tipo adequado  
**E** pode permitir prosseguir com justificativa

### CT703 - Alteração de Datas em Vínculo Histórico
**Dado que** vínculo histórico original era "01/06/2016 a 31/12/2016"  
**E** processo determina período real "01/04/2016 a 15/01/2017"  
**Quando** informo alterações determinadas  
**Então** sistema deve aceitar mudanças  
**E** deve manter característica pré-eSocial  
**E** deve calcular diferenças para o período

### CT704 - Categoria Inexistente na Época
**Dado que** categoria "Menor Aprendiz" só existe após "01/01/2020"  
**Quando** tento usar esta categoria para vínculo de "2017"  
**Então** sistema deve alertar "Categoria não existia neste período"  
**E** deve sugerir categorias válidas para época  
**E** deve impedir prosseguimento até correção

### CT705 - Empregador com Cronograma Diferente
**Dado que** empregador é "Simples Nacional" (obrigatoriedade 2019)  
**E** vínculo foi "01/01/2018 a 30/06/2018"  
**Quando** seleciono tipo 7  
**Então** sistema deve considerar cronograma específico  
**E** deve aceitar como pré-eSocial para este empregador  
**E** deve aplicar regras adequadas

## Validações Avançadas Específicas

### Validação de Marco Temporal por Empregador
- Consultar cronograma específico na base de dados
- Considerar porte da empresa na data do vínculo  
- Verificar possíveis prorrogações ou antecipações
- Alertar sobre mudanças de enquadramento

### Validação de Legislação Histórica
- Verificar regras trabalhistas vigentes no período
- Consultar alterações constitucionais relevantes
- Validar categorias profissionais existentes
- Confirmar salários mínimos da época

### Validação de Documentação
- Exigir comprovação do vínculo histórico
- Validar consistência com registros da época
- Verificar autenticidade de documentos apresentados
- Confirmar dados com fontes oficiais quando possível

### Cálculo de Impactos
- Estimar reflexos tributários do registro
- Calcular possível FGTS retroativo (se aplicável)
- Verificar prescrição de direitos por período
- Alertar sobre obrigações acessórias

## Integração com eSocial

### Registros Específicos
- Criar S-2200 com característica histórica
- Gerar S-2299 para desligamento histórico
- Marcar eventos como "período anterior"
- Não processar automaticamente obrigações acessórias

### Consultas Necessárias
- Verificar inexistência de registros para o período
- Consultar cronograma de obrigatoriedade
- Validar dados do empregador na época
- Confirmar tabelas vigentes no período

### Alertas e Restrições
- Sinalizar natureza histórica dos registros
- Alertar sobre limitações de processamento
- Informar sobre não geração automática de obrigações
- Orientar sobre necessidade de análises específicas

## Considerações Especiais

### Aspectos Legais Críticos
- Prescrição de direitos conforme época do vínculo
- Aplicação de legislação vigente no período
- Responsabilidade por informações históricas
- Impactos de alterações retroativas

### Aspectos Tributários
- Não automação de cálculo de tributos históricos
- Necessidade de análise específica por especialista
- Consideração de anistias e programas especiais
- Avaliação de reflexos em outros períodos

### Aspectos Operacionais
- Processo mais complexo que vínculos normais
- Exigência de documentação robusta
- Necessidade de aprovação especializada
- Controles diferenciados para registros históricos

### Limitações do Sistema
- Não calcula automaticamente obrigações retroativas
- Requer análise manual de impactos tributários
- Limitado pelas tabelas históricas disponíveis
- Pode não cobrir todas as nuances legais da época

### Fluxo Diferenciado
- Análise jurídica obrigatória mais rigorosa
- Validação contábil/fiscal especializada  
- Aprovação de nível superior ou consultoria
- Documentação e justificativas extensas obrigatórias

### Monitoramento Específico
- Acompanhar processamento diferenciado no eSocial
- Verificar se sistema aceita registros históricos
- Monitorar retornos e validações especiais
- Avaliar necessidade de ações complementares
