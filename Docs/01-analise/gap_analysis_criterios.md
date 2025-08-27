# Análise de Lacunas - Critérios de Aceite eSocial

## 📋 RESUMO EXECUTIVO

Após análise comparativa entre os documentos do projeto e a documentação oficial do eSocial S-1.3, foram identificadas **27 lacunas críticas** nos critérios de aceite que precisam ser implementadas.

---

## 🚨 LACUNAS CRÍTICAS IDENTIFICADAS

### 1. VALIDAÇÕES DE CAMPOS OBRIGATÓRIOS FALTANTES

#### 1.1 Evento S-2500
| Campo | Validação Oficial | Status no Projeto | Impacto |
|-------|------------------|-------------------|---------|
| **ideSeqTrab** | Obrigatório quando múltiplos S-2500 para mesmo CPF/processo | ❌ Faltando | Alto |
| **nmTrab** | Obrigatório se indContr = "N" | ⚠️ Parcial | Alto |
| **dtNascto** | Obrigatório se indContr = "N" | ⚠️ Parcial | Alto |
| **codCBO** | Obrigatório exceto para categorias [901, 903, 904] | ❌ Faltando | Médio |
| **natAtividade** | Obrigatório para categorias específicas | ❌ Faltando | Médio |

#### 1.2 Evento S-2501
| Campo | Validação Oficial | Status no Projeto | Impacto |
|-------|------------------|-------------------|---------|
| **ideSeqProc** | Obrigatório quando múltiplos S-2501 | ❌ Faltando | Alto |
| **vrCR13** | Obrigatório quando > 0 para 13º salário | ❌ Faltando | Alto |
| **dtLaudo** | Obrigatório para moléstia grave | ❌ Faltando | Médio |

### 2. REGRAS DE VALIDAÇÃO ESPECÍFICAS AUSENTES

#### 2.1 Validações de Compatibilidade
```
❌ REGRA_COMPATIBILIDADE_CATEGORIA_CLASSTRIB
❌ REGRA_COMPATIB_CATEG_EVENTO  
❌ REGRA_VALIDA_MATRICULA
❌ REGRA_UNICIDADE_CONTRATUAL
❌ REGRA_MUDANCA_CATEG_NAT_ATIV
```

#### 2.2 Validações Temporais Complexas
- **Período vs Desligamento**: Sistema deve alertar se `perRef` for posterior ao desligamento
- **Datas de Transferência**: Validação específica para `sucessaoVinc/dtTransf`
- **Períodos de FGTS**: Validação se `perRef` é anterior ao início do FGTS Digital

#### 2.3 Validações de Valores
- **Base IRRF vs Rendimento**: `vrRendSusp` não pode ser maior que `vrRendTrib`
- **Pensão Alimentícia**: Percentual deve ser ≤ 100%
- **FGTS**: Soma dos campos deve ser > 0

### 3. CRITÉRIOS DE ACEITE POR TIPO DE CONTRATO

#### 3.1 Tipo 6 - TSVE (Lacunas Identificadas)
```yaml
CA606.1: ❌ Sistema deve validar que categoria está na lista TSVE [721,722,723,731,734,738,761,771]
CA606.2: ❌ Campo dtInicio é obrigatório para TSVE
CA606.3: ❌ Validar que não há subordinação (regra de negócio)
CA606.4: ❌ Validar que não há habitualidade caracterizada
```

#### 3.2 Tipo 9 - Unicidade Contratual (Crítico)
```yaml
CA901.6: ❌ Validar que contratos selecionados são cronologicamente consecutivos
CA902.7: ❌ Sistema deve validar sobreposição temporal entre contratos
CA903.7: ❌ Calcular automaticamente período total sem gaps
CA904.7: ❌ Validar que intervalos são ≤ 90 dias (configurável)
```

### 4. VALIDAÇÕES DE IRRF E TRIBUTOS FALTANTES

#### 4.1 Códigos de Receita IRRF
| Código | Validação Oficial | Status |
|--------|------------------|---------|
| **593656** | IRRF - Decisão Justiça Trabalho | ✅ Mapeado |
| **056152** | IRRF - CCP/NINTER | ✅ Mapeado |
| **188951** | IRRF - RRA (validações específicas) | ⚠️ Incompleto |

#### 4.2 Validações RRA (188951)
```yaml
❌ CA-RRA-01: Se tpCR = [188951], grupo infoRRA é obrigatório
❌ CA-RRA-02: Campos dedDepen e infoProcRet são proibidos para RRA
❌ CA-RRA-03: Campo penAlim deve ter tpRend = [18] para RRA
```

### 5. VALIDAÇÕES DE TRABALHO INTERMITENTE

```yaml
❌ CA-INT-01: Campo dia deve estar entre 0-31 conforme calendário
❌ CA-INT-02: hrsTrab obrigatório se classTrib = [22]
❌ CA-INT-03: hrsTrab formato HHMM com validação MM ≤ 59
❌ CA-INT-04: Alerta se dia = 0 (sem trabalho no mês)
```

### 6. VALIDAÇÕES DE ESTABELECIMENTO

```yaml
❌ CA-EST-01: Se tpInsc = [3] (CAEPF), validar 9 primeiros dígitos do CPF + 00000
❌ CA-EST-02: Inscrição deve pertencer ao ideEmpregador/nrInsc
❌ CA-EST-03: Para doméstico, formato específico de CAEPF
```

### 7. CAMPOS COM VALIDAÇÕES CONDICIONAIS FALTANTES

#### 7.1 Dependentes e Pensão Alimentícia
```yaml
❌ CA-DEP-01: cpfDep deve existir no eSocial OU no grupo infoDep
❌ CA-DEP-02: vlrDeducao ≤ valor legal por dependente
❌ CA-PEN-01: penAlim obrigatório para CLT (tpRegTrab = [1])
```

#### 7.2 Processos de Retenção
```yaml
❌ CA-PROC-01: nrProcRet deve existir na Tabela de Processos (S-1070)
❌ CA-PROC-02: codSusp obrigatório se existir em S-1070
❌ CA-PROC-03: vlrDepJud só permitido se indDeposito = [S] em S-1070
```

---

## 🎯 RECOMENDAÇÕES IMEDIATAS

### Fase 1 - Crítico (Implementar AGORA)
1. **Adicionar validações obrigatórias** para campos nmTrab/dtNascto
2. **Implementar validações de ideSeqTrab/ideSeqProc**
3. **Criar validações por tipo de contrato específicas**
4. **Implementar validações de IRRF por código**

### Fase 2 - Alto Impacto
1. **Validações de trabalho intermitente**
2. **Regras de estabelecimento**
3. **Validações de dependentes e pensão**
4. **Processos de retenção**

### Fase 3 - Conformidade Completa
1. **Regras de compatibilidade categoria**
2. **Validações temporais complexas**
3. **Validações específicas RRA**
4. **Todas as regras de negócio restantes**

---

## 📊 IMPACTO NO PROJETO

| Categoria | Lacunas | Impacto | Esforço |
|-----------|---------|---------|---------|
| **Campos Obrigatórios** | 8 | Alto | 2 semanas |
| **Validações Específicas** | 12 | Alto | 3 semanas |
| **Tipos de Contrato** | 7 | Médio | 2 semanas |
| **Total** | **27** | **Alto** | **7 semanas** |

---

## ⚠️ RISCOS IDENTIFICADOS

1. **Rejeição pelo eSocial**: Falta de validações obrigatórias
2. **Dados Inválidos**: Campos sem validação adequada
3. **Inconsistências**: Falta de regras de compatibilidade
4. **Compliance**: Não conformidade com manual oficial

---

## 🔧 PRÓXIMOS PASSOS

1. **Revisar e aprovar** esta análise com a equipe
2. **Priorizar implementações** por impacto/risco
3. **Atualizar documentação** de requisitos
4. **Implementar validações** em ordem de prioridade
5. **Criar testes específicos** para cada validação