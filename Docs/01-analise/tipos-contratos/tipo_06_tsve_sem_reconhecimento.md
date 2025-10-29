# Tipo 06 - TSVE sem Reconhecimento de Vínculo - Requisitos Específicos

## Definição

**Tipo de Contrato 6**: Trabalhador sem vínculo de emprego/estatutário (TSVE), sem reconhecimento de vínculo empregatício.

Este tipo contempla situações onde o processo trabalhista envolve pagamentos a trabalhador que prestou serviços sem vínculo empregatício formal, mantendo a natureza de prestação de serviços, mas determinando pagamento de verbas específicas.

## Conceito de TSVE

### Definição Legal
TSVE - Trabalhador Sem Vínculo de Emprego/Estatutário:
- Pessoa física que presta serviços sem subordinação
- Não caracteriza vínculo empregatício
- Recebe por projeto, tarefa ou resultado
- Mantém autonomia na execução dos serviços
- Não tem horário rígido de trabalho

### Categorias Típicas de TSVE
- Prestadores de serviços autônomos
- Profissionais liberais em atividades pontuais
- Consultores e assessores temporários
- Prestadores de serviços técnicos especializados
- Colaboradores eventuais ou esporádicos

## Cenários de Aplicação

### Cenário Principal
Trabalhador prestou serviços como TSVE onde:
- Não existe reconhecimento de vínculo empregatício
- Processo determina pagamento de verbas específicas
- Mantém característica de prestação de serviços
- Não há subordinação nem habitualidade caracterizadas

### Exemplos Práticos
- Consultor que teve honorários não pagos
- Prestador de serviços com verbas em atraso
- Profissional autônomo com direitos reconhecidos
- Colaborador eventual com pagamentos devidos
- Técnico especializado com remuneração pendente
- Assessor temporário com valores não quitados

## Requisitos Específicos

### RF601 - Validação de Natureza TSVE
**Como** sistema  
**Quero** confirmar que se trata efetivamente de TSVE  
**Para que** seja aplicado tratamento adequado sem vínculo empregatício

#### Critérios de Aceite:
- **CA601.1** - Sistema deve validar ausência de subordinação
- **CA601.2** - Deve confirmar natureza de prestação de serviços
- **CA601.3** - Deve verificar inexistência de vínculo empregatício
- **CA601.4** - Deve validar que não há habitualidade caracterizada
- **CA601.5** - Deve confirmar autonomia na prestação dos serviços

### RF602 - Campos Específicos para TSVE
**Como** usuário do sistema  
**Quero** registrar informações adequadas a prestação de serviços  
**Para que** sejam documentadas condições específicas do TSVE

#### Critérios de Aceite:
- **CA602.1** - Campo tpContr deve ser fixo = 6
- **CA602.2** - Campo indContr deve ser "N" (novo registro)
- **CA602.3** - Categoria deve ser específica de TSVE
- **CA602.4** - CPF do prestador é obrigatório
- **CA602.5** - Período de prestação dos serviços é obrigatório
- **CA602.6** - Descrição dos serviços prestados é obrigatória

### RF603 - Informações da Prestação de Serviços
**Como** usuário do sistema  
**Quero** detalhar características da prestação de serviços  
**Para que** sejam registradas especificidades do trabalho executado

#### Critérios de Aceite:
- **CA603.1** - Tipo de serviço prestado (consultoria, assessoria, etc.)
- **CA603.2** - Período de execução dos serviços
- **CA603.3** - Local de prestação dos serviços (se relevante)
- **CA603.4** - Forma de pagamento acordada (por projeto, hora, etc.)
- **CA603.5** - Valor dos serviços conforme acordado
- **CA603.6** - Documentos que regem a prestação (contrato, proposta, etc.)

### RF604 - Dados do Prestador TSVE
**Como** usuário do sistema  
**Quero** registrar dados do prestador de serviços  
**Para que** seja identificado corretamente o beneficiário

#### Critérios de Aceite:
- **CA604.1** - CPF é obrigatório e deve ser válido
- **CA604.2** - Nome completo é obrigatório
- **CA604.3** - Data de nascimento é obrigatória
- **CA604.4** - Qualificação profissional (se relevante)
- **CA604.5** - Especialidade técnica (se aplicável)
- **CA604.6** - Dados de contato (se necessário)

### RF605 - Valores e Verbas Devidas
**Como** usuário do sistema  
**Quero** registrar valores determinados pelo processo  
**Para que** sejam calculados tributos e pagamentos corretos

#### Critérios de Aceite:
- **CA605.1** - Valor principal dos serviços
- **CA605.2** - Acréscimos determinados judicialmente
- **CA605.3** - Correção monetária aplicável
- **CA605.4** - Juros conforme determinação judicial
- **CA605.5** - Honorários advocatícios (se devidos)
- **CA605.6** - Outros valores específicos do processo

## Regras de Negócio Específicas

### RN601 - Natureza Jurídica
- Não caracteriza vínculo empregatício em nenhuma hipótese
- Mantém natureza de prestação de serviços autônomos
- Não gera direitos trabalhistas típicos
- Sujeita apenas a obrigações fiscais específicas

### RN602 - Categorias Aplicáveis
- Deve usar categorias específicas de TSVE na Tabela 01
- Categorias típicas: 721, 722, 723, 731, 734, 738, 761, 771
- Categoria deve ser compatível com tipo de serviço
- Não pode usar categorias de empregados

### RN603 - Tributação Específica
- Sujeito a retenção de INSS conforme categoria
- Pode haver retenção de IRRF conforme valor
- Não há incidência de FGTS
- Não há contribuição para terceiros típica de empregados

### RN604 - Período de Prestação
- Deve ser definido conforme execução dos serviços
- Pode ser irregular ou descontínuo
- Não segue regras de jornada de trabalho
- Baseado em entrega de resultado ou projeto

## Interface Específica

### Seção Identificação do Prestador
- **CPF**: Campo obrigatório com validação
- **Nome completo**: Obrigatório
- **Data nascimento**: Obrigatória  
- **Qualificação**: Profissão/especialidade
- **Status no eSocial**: Verificar se já cadastrado

### Seção Características da Prestação
- **Categoria TSVE**: Lista específica de categorias
- **Tipo de serviço**: Descrição da atividade
- **Período execução**: Início e término dos serviços
- **Local prestação**: Se relevante para o caso
- **Modalidade**: Presencial, remoto, misto

### Seção Dados Contratuais
- **Base contratual**: Contrato, proposta, acordo verbal
- **Forma pagamento**: Por hora, projeto, resultado
- **Valor acordado**: Remuneração original
- **Periodicidade**: Se havia pagamentos regulares
- **Documentação**: Anexos comprobatórios

### Seção Valores do Processo
- **Valor principal**: Montante básico devido
- **Correção monetária**: Atualização aplicada
- **Juros**: Conforme determinação judicial
- **Honorários**: Se incluídos na condenação
- **Total devido**: Cálculo automático

### Seção Informações Fiscais
- **Base INSS**: Valor para cálculo de contribuição
- **Base IRRF**: Se aplicável retenção
- **Códigos receita**: Para recolhimentos
- **Observações fiscais**: Detalhes relevantes

## Cenários de Teste Específicos

### CT601 - TSVE Consultor Autônomo
**Dado que** prestador categoria "721 - Diretor não empregado"  
**E** prestou consultoria de "01/06/2023 a 30/09/2023"  
**Quando** seleciono tipo "6 - TSVE sem reconhecimento"  
**E** informo dados da prestação de serviços  
**Então** sistema deve aceitar como TSVE  
**E** deve aplicar tributação específica da categoria  
**E** não deve gerar direitos trabalhistas

### CT602 - Validação Categoria Incompatível
**Dado que** tento usar categoria "101 - Empregado geral"  
**Quando** seleciono tipo TSVE  
**Então** sistema deve exibir erro "Categoria incompatível com TSVE"  
**E** deve sugerir categorias válidas para TSVE  
**E** deve impedir prosseguimento

### CT603 - Período Irregular de Prestação
**Dado que** serviços foram prestados em períodos alternados  
**E** não houve continuidade temporal  
**Quando** informo múltiplos períodos de execução  
**Então** sistema deve aceitar períodos descontínuos  
**E** deve calcular tributação por período  
**E** deve validar que não caracteriza habitualidade

### CT604 - Valores com Correção e Juros
**Dado que** valor original dos serviços era R$ 10.000,00  
**E** processo determinou correção e juros totalizando R$ 15.000,00  
**Quando** informo valores do processo  
**Então** sistema deve calcular tributos sobre valor atualizado  
**E** deve separar valor principal de acréscimos  
**E** deve aplicar tributação adequada

### CT605 - TSVE já Cadastrado no eSocial
**Dado que** prestador já possui cadastro TSVE para outro tomador  
**Quando** informo CPF existente  
**Então** sistema deve carregar dados pessoais  
**E** deve permitir nova prestação para empregador diferente  
**E** deve validar não sobreposição inadequada

## Validações Específicas para TSVE

### Validação de Autonomia
- Verificar se havia subordinação na prestação
- Confirmar autonomia técnica e operacional
- Validar se prestador tinha liberdade de horários
- Checar se resultado era mais importante que meio

### Validação de Habitualidade
- Confirmar que prestação não era habitual
- Verificar se não havia exclusividade
- Validar se prestador atendia outros tomadores
- Checar periodicidade dos serviços

### Validação Fiscal
- Aplicar alíquotas específicas da categoria TSVE
- Calcular INSS conforme tabela apropriada
- Verificar incidência de IRRF se aplicável
- Validar códigos de receita adequados

### Validação Contratual
- Verificar se documentação suporta natureza TSVE
- Confirmar que não há cláusulas empregatícias
- Validar forma de remuneração (por resultado)
- Checar ausência de subordinação contratual

## Integração com eSocial

### Eventos Relacionados
- **S-2300**: Início de TSVE (se não existir)
- **S-2399**: Término de TSVE (se aplicável)
- **S-1200**: Folha de pagamento TSVE
- **S-1210**: Pagamentos de TSVE

### Consultas Necessárias
- Verificar se TSVE já está cadastrado
- Consultar tabelas específicas para TSVE
- Validar categorias permitidas
- Confirmar alíquotas aplicáveis

### Cálculos Específicos
- INSS sobre remuneração TSVE
- IRRF se valor exceder limite
- Sem incidência de FGTS
- Sem contribuições para terceiros

## Considerações Especiais

### Aspectos Legais
- Decisão deve ser clara sobre natureza não empregatícia
- Fundamentação legal específica para TSVE
- Distinção clara de vínculo empregatício
- Observância de jurisprudência sobre caracterização

### Aspectos Fiscais
- Tributação diferenciada de empregados
- Regras específicas por categoria TSVE
- Possibilidade de dedução de despesas
- Tratamento fiscal adequado dos pagamentos

### Aspectos Operacionais
- Processo mais simples que reconhecimento de vínculo
- Menor complexidade tributária
- Documentação focada na prestação de serviços
- Controles específicos para TSVE

### Diferenças dos Outros Tipos
- Não cria vínculo empregatício
- Tributação específica e reduzida
- Sem direitos trabalhistas típicos
- Foco em prestação de serviços autônomos

### Cuidados Especiais
- Evitar caracterização de vínculo por acidente
- Documentar bem a autonomia do prestador
- Manter evidências da natureza não empregatícia  
- Cuidar com habitualidade que possa caracterizar emprego
