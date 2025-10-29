# Queries para Geração dos Eventos eSocial
## PostgreSQL - Sistema Processo Trabalhista

**Objetivo:** Documentar as queries SQL necessárias para extrair dados do banco PostgreSQL e montar os XMLs dos eventos eSocial  
**Eventos:** S-2500, S-2501, S-2555, S-3500  
**Versão eSocial:** S-1.3  
**SGBD:** PostgreSQL 12+

---

## Índice
1. [S-2500 - Processo Trabalhista](#1-s-2500---processo-trabalhista)
2. [S-2501 - Informações de Tributos](#2-s-2501---informações-de-tributos)
3. [S-2555 - Consolidação](#3-s-2555---consolidação)
4. [S-3500 - Exclusão de Eventos](#4-s-3500---exclusão-de-eventos)
5. [Queries de Apoio](#5-queries-de-apoio)
6. [Índices Recomendados](#6-índices-recomendados)

---

## 1. S-2500 - PROCESSO TRABALHISTA

### 1.1 Query Principal - Dados do Processo

```sql
-- =============================================
-- S-2500: DADOS PRINCIPAIS DO PROCESSO
-- Retorna informações básicas do processo trabalhista
-- =============================================
SELECT 
    -- Identificação do Evento
    pt.uuid as id_evento,
    pt.numero_processo,
    
    -- Empregador (ideEmpregador)
    ti_emp.codigo as empregador_tp_insc,
    pt.empregador_numero_inscricao as empregador_nr_insc,
    
    -- Responsável Indireto (ideResp) - OPCIONAL
    ti_resp.codigo as responsavel_tp_insc,
    pt.responsavel_numero_inscricao as responsavel_nr_insc,
    pt.responsavel_data_admissao as responsavel_dt_adm_resp_dir,
    pt.responsavel_matricula as responsavel_mat_resp_dir,
    
    -- Processo (infoProcesso)
    op.codigo as origem_processo,
    pt.observacoes_processo as obs_proc_trab,
    
    -- Dados Judiciais (infoProcJud) - SE origem = 1
    pj.data_sentenca as dt_sent,
    pj.uf_vara,
    pj.codigo_municipio as cod_munic,
    pj.identificador_vara as id_vara,
    
    -- Dados CCP (infoCCP) - SE origem = 2
    pc.data_ccp as dt_ccp,
    tc.codigo as tp_ccp,
    pc.cnpj_ccp,
    
    -- Auditoria
    pt.data_criacao,
    pt.usuario_criacao,
    pt.status_id

FROM processotrabalhista.processos_trabalhistas pt

-- JOINs obrigatórios
INNER JOIN processotrabalhista.tipos_inscricao ti_emp 
    ON pt.empregador_tipo_inscricao_id = ti_emp.id
INNER JOIN processotrabalhista.origens_processo op 
    ON pt.origem_processo_id = op.id

-- JOINs opcionais
LEFT JOIN processotrabalhista.tipos_inscricao ti_resp 
    ON pt.responsavel_tipo_inscricao_id = ti_resp.id
LEFT JOIN processotrabalhista.processos_judiciais pj 
    ON pt.id = pj.processo_trabalhista_id
LEFT JOIN processotrabalhista.processos_ccp pc 
    ON pt.id = pc.processo_trabalhista_id
LEFT JOIN processotrabalhista.tipos_ccp tc 
    ON pc.tipo_ccp_id = tc.id

WHERE pt.id = $1 -- ID do processo
  AND pt.status_ativo = true;
```

### 1.2 Query Trabalhadores do Processo

```sql
-- =============================================
-- S-2500: TRABALHADORES DO PROCESSO (ideTrab)
-- Retorna lista de trabalhadores de um processo
-- =============================================
SELECT 
    -- Trabalhador (ideTrab)
    tp.id as trabalhador_processo_id,
    tp.cpf as cpf_trab,
    tp.nome as nm_trab,
    tp.data_nascimento as dt_nascto,
    tp.sequencia_trabalhador as ide_seq_trab,
    
    -- Controle
    tp.codigo_sistema_origem, -- Para integração externa
    tp.data_criacao,
    tp.status_ativo

FROM processotrabalhista.trabalhadores_processo tp

WHERE tp.processo_trabalhista_id = $1 -- ID do processo
  AND tp.status_ativo = true

ORDER BY tp.cpf, tp.sequencia_trabalhador;
```

### 1.3 Query Contratos do Trabalhador

```sql
-- =============================================
-- S-2500: CONTRATOS DO TRABALHADOR (infoContr)
-- Retorna informações contratuais completas
-- =============================================
SELECT 
    -- Contrato (infoContr)
    cp.id as contrato_processo_id,
    tc.codigo as tp_contr,
    cp.indicador_contrato as ind_contr,
    cp.data_admissao_original as dt_adm_orig,
    cp.indicador_reintegracao as ind_reint,
    cp.indicador_categoria as ind_categ,
    cp.indicador_natureza_atividade as ind_nat_ativ,
    cp.indicador_motivo_desligamento as ind_mot_deslig,
    cp.matricula,
    cp.codigo_categoria as cod_categ,
    cp.data_inicio_tsve as dt_inicio,
    
    -- Informações Complementares (infoCompl)
    cc.codigo_cbo as cod_cbo,
    cc.natureza_atividade as nat_atividade,
    cc.quantidade_dias_trabalho as qtd_dias_trab,
    
    -- Estabelecimento (ideEstab)
    ti_est.codigo as estabelecimento_tp_insc,
    ep.numero_inscricao as estabelecimento_nr_insc

FROM processotrabalhista.contratos_processo cp

-- JOINs obrigatórios
INNER JOIN processotrabalhista.tipos_contrato tc 
    ON cp.tipo_contrato_id = tc.id
INNER JOIN processotrabalhista.estabelecimentos_processo ep 
    ON cp.id = ep.contrato_processo_id
INNER JOIN processotrabalhista.tipos_inscricao ti_est 
    ON ep.tipo_inscricao_id = ti_est.id

-- JOINs opcionais
LEFT JOIN processotrabalhista.contratos_complementares cc 
    ON cp.id = cc.contrato_processo_id

WHERE cp.trabalhador_processo_id = $1 -- ID do trabalhador
  AND cp.status_ativo = true

ORDER BY cp.id;
```

### 1.4 Query Remuneração

```sql
-- =============================================
-- S-2500: REMUNERAÇÃO (remuneracao)
-- Retorna dados de remuneração do contrato
-- =============================================
SELECT 
    rp.id as remuneracao_id,
    rp.data_remuneracao as dt_remun,
    rp.valor_salario_fixo as vr_sal_fx,
    usf.codigo as und_sal_fixo,
    rp.descricao_salario_variavel as dsc_sal_var

FROM processotrabalhista.remuneracoes_processo rp

-- JOINs obrigatórios
INNER JOIN processotrabalhista.unidades_salario_fixo usf 
    ON rp.unidade_salario_fixo_id = usf.id

WHERE rp.contrato_processo_id = $1 -- ID do contrato
  AND rp.status_ativo = true

ORDER BY rp.data_remuneracao DESC;
```

### 1.5 Query Vínculo e Duração

```sql
-- =============================================
-- S-2500: VÍNCULO E DURAÇÃO (infoVinc/duracao)
-- Retorna informações do vínculo trabalhista
-- =============================================
SELECT 
    -- Vínculo (infoVinc)
    vp.id as vinculo_processo_id,
    trt.codigo as tp_reg_trab,
    trp.codigo as tp_reg_prev,
    vp.data_admissao as dt_adm,
    vp.tipo_jornada as tp_jornada,
    vp.tempo_parcial as tmp_parc,
    
    -- Duração (duracao)
    dc.tipo_contrato as duracao_tp_contr,
    dc.data_termino as dt_term,
    dc.clausula_assecuratoria as clau_assec,
    dc.objeto_determinante as obj_det,
    
    -- Sucessão (sucessaoVinc)
    ti_suc.codigo as sucessao_tp_insc,
    sv.numero_inscricao as sucessao_nr_insc,
    sv.matricula_anterior as matric_ant,
    sv.data_transferencia as dt_transf,
    
    -- Desligamento (infoDeslig)
    dp.data_desligamento as dt_deslig,
    dp.motivo_desligamento as mtv_deslig,
    dp.data_projetada_fim_aviso as dt_proj_fim_api,
    dp.pensao_alimenticia as pens_alim,
    dp.percentual_alimenticia as perc_aliment,
    dp.valor_alimenticia as vr_alim

FROM processotrabalhista.vinculos_processo vp

-- JOINs obrigatórios
INNER JOIN processotrabalhista.tipos_regime_trabalhista trt 
    ON vp.tipo_regime_trabalhista_id = trt.id
INNER JOIN processotrabalhista.tipos_regime_previdenciario trp 
    ON vp.tipo_regime_previdenciario_id = trp.id

-- JOINs opcionais
LEFT JOIN processotrabalhista.duracoes_contrato dc 
    ON vp.id = dc.vinculo_processo_id
LEFT JOIN processotrabalhista.sucessoes_vinculo sv 
    ON vp.id = sv.vinculo_processo_id
LEFT JOIN processotrabalhista.tipos_inscricao ti_suc 
    ON sv.tipo_inscricao_id = ti_suc.id
LEFT JOIN processotrabalhista.desligamentos_processo dp 
    ON vp.id = dp.vinculo_processo_id

WHERE vp.contrato_processo_id = $1 -- ID do contrato
  AND vp.status_ativo = true;
```

### 1.6 Query Observações do Contrato

```sql
-- =============================================
-- S-2500: OBSERVAÇÕES (observacoes)
-- Retorna observações do contrato (1:N)
-- =============================================
SELECT 
    oc.id as observacao_id,
    oc.observacao

FROM processotrabalhista.observacoes_contratos oc
INNER JOIN processotrabalhista.vinculos_processo vp ON oc.vinculo_processo_id = vp.id

WHERE vp.contrato_processo_id = $1 -- ID do contrato
  AND oc.status_ativo = true

ORDER BY oc.id;
```

### 1.7 Query Mudanças de Categoria/Atividade

```sql
-- =============================================
-- S-2500: MUDANÇAS CATEGORIA/ATIVIDADE (mudCategAtiv)
-- Retorna mudanças de categoria (1:N)
-- =============================================
SELECT 
    mca.id as mudanca_id,
    mca.codigo_categoria as cod_categ,
    mca.natureza_atividade as nat_atividade,
    mca.data_mudanca_categoria as dt_mud_categ_ativ

FROM processotrabalhista.mudancas_categoria_atividade mca

WHERE mca.contrato_processo_id = $1 -- ID do contrato
  AND mca.status_ativo = true

ORDER BY mca.data_mudanca_categoria;
```

### 1.8 Query Unicidade Contratual

```sql
-- =============================================
-- S-2500: UNICIDADE CONTRATUAL (unicContr)
-- Retorna contratos unificados (1:N)
-- =============================================
SELECT 
    uc.id as unicidade_id,
    uc.matricula_unificada as mat_unic,
    uc.codigo_categoria as cod_categ,
    uc.data_inicio as dt_inicio

FROM processotrabalhista.unicidades_contratuais uc

WHERE uc.contrato_processo_id = $1 -- ID do contrato
  AND uc.status_ativo = true

ORDER BY uc.data_inicio;
```

### 1.9 Query Término TSVE

```sql
-- =============================================
-- S-2500: TÉRMINO TSVE (infoTerm)
-- Retorna informações de término TSVE
-- =============================================
SELECT 
    tt.id as termino_id,
    tt.data_termino as dt_term,
    tt.motivo_desligamento_tsv as mtv_deslig_tsv

FROM processotrabalhista.terminos_tsve tt

WHERE tt.contrato_processo_id = $1 -- ID do contrato
  AND tt.status_ativo = true;
```

### 1.10 Query Períodos e Valores

```sql
-- =============================================
-- S-2500: PERÍODOS E VALORES (infoVlr)
-- Retorna períodos e valores do estabelecimento
-- =============================================
SELECT 
    -- Períodos e Valores (infoVlr)
    pv.id as periodo_valores_id,
    pv.competencia_inicio as comp_ini,
    pv.competencia_fim as comp_fim,
    pv.indicador_repercussao as ind_reperc,
    pv.indenizacao_substitutiva as inden_sd,
    pv.indenizacao_abono as inden_abono,
    
    -- Abonos (abono) - Collection
    STRING_AGG(DISTINCT ap.ano_base::text, ',') as anos_base_abono

FROM processotrabalhista.periodos_valores pv
INNER JOIN processotrabalhista.estabelecimentos_processo ep ON pv.estabelecimento_processo_id = ep.id
LEFT JOIN processotrabalhista.abonos_processo ap ON pv.id = ap.periodo_valores_id

WHERE ep.contrato_processo_id = $1 -- ID do contrato
  AND pv.status_ativo = true

GROUP BY pv.id, pv.competencia_inicio, pv.competencia_fim, pv.indicador_repercussao, 
         pv.indenizacao_substitutiva, pv.indenizacao_abono

ORDER BY pv.competencia_inicio;
```

### 1.11 Query Identificações de Período

```sql
-- =============================================
-- S-2500: IDENTIFICAÇÕES DE PERÍODO (idePeriodo)
-- Retorna períodos específicos com bases de cálculo
-- =============================================
SELECT 
    -- Identificação Período (idePeriodo)
    ip.id as identificacao_periodo_id,
    ip.periodo_referencia as per_ref,
    
    -- Base Cálculo (baseCalculo)
    bcp.valor_bc_cp_mensal as vr_bc_cp_mensal,
    bcp.valor_bc_cp_13 as vr_bc_cp_13,
    bcp.grau_exposicao_agente_nocivo as grau_exp,
    
    -- FGTS (infoFGTS)
    fp.valor_bc_fgts_proc_trab as vr_bc_fgts_proc_trab,
    fp.valor_bc_fgts_sefip as vr_bc_fgts_sefip,
    fp.valor_bc_fgts_dec_ant as vr_bc_fgts_dec_ant,
    
    -- Base Mudança Categoria (baseMudCateg)
    bmc.codigo_categoria as base_mud_cod_categ,
    bmc.valor_bc_c_prev as vr_bc_c_prev

FROM processotrabalhista.identificacoes_periodo ip

-- JOINs opcionais
LEFT JOIN processotrabalhista.bases_calculo_processo bcp 
    ON ip.id = bcp.identificacao_periodo_id
LEFT JOIN processotrabalhista.fgts_processo fp 
    ON ip.id = fp.identificacao_periodo_id
LEFT JOIN processotrabalhista.bases_mudanca_categoria bmc 
    ON ip.id = bmc.identificacao_periodo_id

WHERE ip.periodo_valores_id = $1 -- ID do período valores
  AND ip.status_ativo = true

ORDER BY ip.periodo_referencia;
```

### 1.12 Query Trabalho Intermitente

```sql
-- =============================================
-- S-2500: TRABALHO INTERMITENTE (infoInterm)
-- Retorna informações de trabalho intermitente (1:N)
-- =============================================
SELECT 
    ti.id as intermitente_id,
    ti.dia,
    ti.horas_trabalhadas as hrs_trab

FROM processotrabalhista.trabalho_intermitente ti

WHERE ti.identificacao_periodo_id = $1 -- ID da identificação período
  AND ti.status_ativo = true

ORDER BY ti.dia;
```

---

## 2. S-2501 - INFORMAÇÕES DE TRIBUTOS

### 2.1 Query Principal - Tributos do Processo

```sql
-- =============================================
-- S-2501: DADOS PRINCIPAIS DOS TRIBUTOS
-- Retorna informações básicas dos tributos
-- =============================================
SELECT 
    -- Identificação do Evento
    tp.uuid as id_evento,
    tp.numero_processo as nr_proc_trab,
    tp.periodo_apuracao_pagamento as per_apur_pgto,
    tp.sequencia_processo as ide_seq_proc,
    tp.observacoes as obs,
    
    -- Trabalhador (via FK)
    tpr.cpf as cpf_trab,
    
    -- Controle
    tp.status_id,
    tp.data_criacao,
    tp.usuario_criacao

FROM processotrabalhista.tributos_processo tp

-- JOIN para obter CPF do trabalhador
INNER JOIN processotrabalhista.trabalhadores_processo tpr 
    ON tp.trabalhador_processo_id = tpr.id

WHERE tp.id = $1 -- ID do tributo processo
  AND tp.status_ativo = true;
```

### 2.2 Query Cálculo de Tributos

```sql
-- =============================================
-- S-2501: CÁLCULO DE TRIBUTOS (calcTrib)
-- Retorna períodos e bases de cálculo (1:N)
-- =============================================
SELECT 
    ct.id as calculo_tributo_id,
    ct.periodo_referencia as per_ref,
    ct.valor_bc_cp_mensal as vr_bc_cp_mensal,
    ct.valor_bc_cp_13 as vr_bc_cp_13

FROM processotrabalhista.calculo_tributos ct

WHERE ct.tributo_processo_id = $1 -- ID do tributo processo
  AND ct.status_ativo = true

ORDER BY ct.periodo_referencia;
```

### 2.3 Query Códigos de Receita - Contribuições Sociais

```sql
-- =============================================
-- S-2501: CONTRIBUIÇÕES SOCIAIS (infoCRContrib)
-- Retorna códigos de receita para contribuições (1:N)
-- =============================================
SELECT 
    crcs.id as contrib_social_id,
    crcs.tipo_cr as tp_cr,
    crcs.valor_cr as vr_cr

FROM processotrabalhista.codigos_receita_contrib_social crcs

WHERE crcs.calculo_tributo_id = $1 -- ID do cálculo tributo
  AND crcs.status_ativo = true

ORDER BY crcs.tipo_cr;
```

### 2.4 Query Códigos de Receita - IRRF

```sql
-- =============================================
-- S-2501: CÓDIGOS RECEITA IRRF (infoCRIRRF)
-- Retorna códigos de receita para IRRF (1:N)
-- =============================================
SELECT 
    cri.id as irrf_codigo_receita_id,
    cri.tipo_cr as tp_cr,
    cri.valor_cr as vr_cr,
    cri.valor_cr_13 as vr_cr_13

FROM processotrabalhista.codigos_receita_irrf cri

WHERE cri.tributo_processo_id = $1 -- ID do tributo processo
  AND cri.status_ativo = true

ORDER BY cri.tipo_cr;
```

### 2.5 Query Informações de IR

```sql
-- =============================================
-- S-2501: INFORMAÇÕES IR (infoIR)
-- Retorna informações complementares de IR
-- =============================================
SELECT 
    -- Informações IR (infoIR)
    iir.id as informacao_ir_id,
    iir.valor_rendimento_tributavel as vr_rend_trib,
    iir.valor_rendimento_tributavel_13 as vr_rend_trib_13,
    iir.valor_rendimento_molestia_grave as vr_rend_mole_grave,
    iir.valor_rendimento_molestia_grave_13 as vr_rend_mole_grave_13,
    iir.valor_rendimento_isento_65 as vr_rend_isen_65,
    iir.valor_rendimento_isento_65_dec as vr_rend_isen_65_dec,
    iir.valor_juros_mora as vr_juros_mora,
    iir.valor_juros_mora_13 as vr_juros_mora_13,
    iir.valor_rendimento_isento_nao_tributavel as vr_rend_isen_n_trib,
    iir.descricao_isento_nao_tributavel as desc_isen_n_trib,
    iir.valor_previdencia_oficial as vr_prev_oficial,
    iir.valor_previdencia_oficial_13 as vr_prev_oficial_13,
    
    -- Rendimentos Isentos 0561 (rendIsen0561)
    ri0561.valor_diarias as vlr_diarias,
    ri0561.valor_ajuda_custo as vlr_ajuda_custo,
    ri0561.valor_indenizacao_rescisao as vlr_ind_res_contrato,
    ri0561.valor_abono_pecuniario as vlr_abono_pec,
    ri0561.valor_auxilio_moradia as vlr_aux_moradia

FROM processotrabalhista.informacoes_ir iir

-- JOINs opcionais
LEFT JOIN processotrabalhista.rendimentos_isentos_0561 ri0561 
    ON iir.id = ri0561.informacao_ir_id

WHERE iir.codigo_receita_irrf_id = $1 -- ID do código receita IRRF
  AND iir.status_ativo = true;
```

### 2.6 Query Informações RRA

```sql
-- =============================================
-- S-2501: INFORMAÇÕES RRA (infoRRA)
-- Retorna informações de RRA
-- =============================================
SELECT 
    -- RRA (infoRRA)
    irra.id as informacao_rra_id,
    irra.descricao_rra as desc_rra,
    irra.quantidade_meses_rra as qtd_meses_rra,
    
    -- Despesas Processo Judicial (despProcJud)
    dpj.valor_despesas_custas as vlr_desp_custas,
    dpj.valor_despesas_advogados as vlr_desp_advogados

FROM processotrabalhista.informacoes_rra irra

-- JOINs opcionais
LEFT JOIN processotrabalhista.despesas_processo_judicial dpj 
    ON irra.id = dpj.informacao_rra_id

WHERE irra.codigo_receita_irrf_id = $1 -- ID do código receita IRRF
  AND irra.status_ativo = true;
```

### 2.7 Query Advogados

```sql
-- =============================================
-- S-2501: ADVOGADOS (ideAdv)
-- Retorna identificação dos advogados (1:N)
-- =============================================
SELECT 
    adv.id as advogado_id,
    ti.codigo as tp_insc,
    adv.numero_inscricao as nr_insc,
    adv.valor_advogado as vlr_adv

FROM processotrabalhista.advogados adv

-- JOINs obrigatórios
INNER JOIN processotrabalhista.tipos_inscricao ti 
    ON adv.tipo_inscricao_id = ti.id

WHERE adv.despesa_processo_judicial_id = $1 -- ID da despesa processo judicial
  AND adv.status_ativo = true

ORDER BY adv.numero_inscricao;
```

### 2.8 Query Deduções Dependentes

```sql
-- =============================================
-- S-2501: DEDUÇÕES DEPENDENTES (dedDepen)
-- Retorna deduções por dependentes (1:N)
-- =============================================
SELECT 
    dd.id as deducao_dependente_id,
    dd.tipo_rendimento as tp_rend,
    dd.cpf_dependente as cpf_dep,
    dd.valor_deducao as vlr_deducao

FROM processotrabalhista.deducoes_dependentes dd

WHERE dd.codigo_receita_irrf_id = $1 -- ID do código receita IRRF
  AND dd.status_ativo = true

ORDER BY dd.cpf_dependente, dd.tipo_rendimento;
```

### 2.9 Query Pensão Alimentícia

```sql
-- =============================================
-- S-2501: PENSÃO ALIMENTÍCIA (penAlim)
-- Retorna informações de pensão alimentícia (1:N)
-- =============================================
SELECT 
    pa.id as pensao_alimenticia_id,
    pa.tipo_rendimento as tp_rend,
    pa.cpf_beneficiario as cpf_dep,
    pa.valor_pensao as vlr_pensao

FROM processotrabalhista.pensoes_alimenticias pa

WHERE pa.codigo_receita_irrf_id = $1 -- ID do código receita IRRF
  AND pa.status_ativo = true

ORDER BY pa.cpf_beneficiario, pa.tipo_rendimento;
```

### 2.10 Query Processos de Retenção

```sql
-- =============================================
-- S-2501: PROCESSOS RETENÇÃO (infoProcRet)
-- Retorna processos relacionados à não retenção (1:N)
-- =============================================
SELECT 
    pr.id as processo_retencao_id,
    pr.tipo_processo_retencao as tp_proc_ret,
    pr.numero_processo_retencao as nr_proc_ret,
    pr.codigo_suspensao as cod_susp

FROM processotrabalhista.processos_retencao pr

WHERE pr.codigo_receita_irrf_id = $1 -- ID do código receita IRRF
  AND pr.status_ativo = true

ORDER BY pr.numero_processo_retencao;
```

### 2.11 Query Valores de Retenção

```sql
-- =============================================
-- S-2501: VALORES RETENÇÃO (infoValores)
-- Retorna valores relacionados aos processos (1:N)
-- =============================================
SELECT 
    vpr.id as valores_processo_retencao_id,
    vpr.indicativo_apuracao as ind_apuracao,
    vpr.valor_nao_retido as vlr_n_retido,
    vpr.valor_deposito_judicial as vlr_dep_jud,
    vpr.valor_compensacao_ano_calendario as vlr_cmp_ano_cal,
    vpr.valor_compensacao_anos_anteriores as vlr_cmp_ano_ant,
    vpr.valor_rendimento_suspenso as vlr_rend_susp

FROM processotrabalhista.valores_processos_retencao vpr

WHERE vpr.processo_retencao_id = $1 -- ID do processo retenção
  AND vpr.status_ativo = true

ORDER BY vpr.indicativo_apuracao;
```

### 2.12 Query Deduções Suspensas

```sql
-- =============================================
-- S-2501: DEDUÇÕES SUSPENSAS (dedSusp)
-- Retorna deduções com exigibilidade suspensa (1:N)
-- =============================================
SELECT 
    ds.id as deducao_suspensa_id,
    ds.indicativo_tipo_deducao as ind_tp_deducao,
    ds.valor_deducao_suspensa as vlr_ded_susp

FROM processotrabalhista.deducoes_suspensas ds

WHERE ds.valores_processo_retencao_id = $1 -- ID dos valores processo retenção
  AND ds.status_ativo = true

ORDER BY ds.indicativo_tipo_deducao;
```

### 2.13 Query Beneficiários Pensão Suspensa

```sql
-- =============================================
-- S-2501: BENEFICIÁRIOS PENSÃO SUSPENSA (benefPen)
-- Retorna beneficiários com dedução suspensa (1:N)
-- =============================================
SELECT 
    bps.id as beneficiario_pensao_suspensa_id,
    bps.cpf_beneficiario as cpf_dep,
    bps.valor_dependente_suspenso as vlr_depen_susp

FROM processotrabalhista.beneficiarios_pensao_suspensa bps

WHERE bps.deducao_suspensa_id = $1 -- ID da dedução suspensa
  AND bps.status_ativo = true

ORDER BY bps.cpf_beneficiario;
```

### 2.14 Query IR Complementar

```sql
-- =============================================
-- S-2501: IR COMPLEMENTAR (infoIRComplem)
-- Retorna informações complementares de IR
-- =============================================
SELECT 
    -- IR Complementar (infoIRComplem)
    irc.id as informacao_ir_complementar_id,
    irc.data_laudo as dt_laudo

FROM processotrabalhista.informacoes_ir_complementares irc

WHERE irc.tributo_processo_id = $1 -- ID do tributo processo
  AND irc.status_ativo = true;
```

### 2.15 Query Dependentes Não Cadastrados

```sql
-- =============================================
-- S-2501: DEPENDENTES NÃO CADASTRADOS (infoDep)
-- Retorna dependentes não cadastrados no eSocial (1:N)
-- =============================================
SELECT 
    dnc.id as dependente_nao_cadastrado_id,
    dnc.cpf_dependente as cpf_dep,
    dnc.data_nascimento as dt_nascto,
    dnc.nome,
    dnc.dependente_irrf as dep_irrf,
    dnc.tipo_dependente as tp_dep,
    dnc.descricao_dependencia as descr_dep

FROM processotrabalhista.dependentes_nao_cadastrados dnc

WHERE dnc.informacao_ir_complementar_id = $1 -- ID da informação IR complementar
  AND dnc.status_ativo = true

ORDER BY dnc.nome;
```

---

## 3. S-2555 - CONSOLIDAÇÃO

### 3.1 Query Principal - Consolidação

```sql
-- =============================================
-- S-2555: CONSOLIDAÇÃO DE TRIBUTOS
-- Retorna dados para consolidação
-- =============================================
SELECT 
    -- Identificação do Evento
    ct.uuid as id_evento,
    ct.numero_processo as nr_proc_trab,
    ct.periodo_apuracao_pagamento as per_apur_pgto,
    
    -- Controle
    ct.observacoes,
    ct.status_id,
    ct.data_criacao,
    ct.usuario_criacao

FROM processotrabalhista.consolidacoes_tributos ct

WHERE ct.id = $1 -- ID da consolidação
  AND ct.status_ativo = true;
```

---

## 4. S-3500 - EXCLUSÃO DE EVENTOS

### 4.1 Query Principal - Exclusão

```sql
-- =============================================
-- S-3500: EXCLUSÃO DE EVENTOS
-- Retorna dados para exclusão de evento
-- =============================================
SELECT 
    -- Identificação do Evento
    ee.uuid as id_evento,
    ee.tipo_evento as tp_evento,
    ee.numero_recibo_evento as nr_rec_evt,
    
    -- Processo (ideProcTrab)
    ee.numero_processo as nr_proc_trab,
    ee.cpf_trabalhador as cpf_trab,
    ee.periodo_apuracao_pagamento as per_apur_pgto,
    ee.sequencia_processo as ide_seq_proc,
    
    -- Controle
    ee.observacoes,
    ee.status_id,
    ee.data_criacao,
    ee.usuario_criacao

FROM processotrabalhista.exclusoes_eventos ee

WHERE ee.id = $1 -- ID da exclusão
  AND ee.status_ativo = true;
```

---

## 5. QUERIES DE APOIO

### 5.1 Query Lista de Processos

```sql
-- =============================================
-- APOIO: LISTA DE PROCESSOS
-- Para seleção em telas de consulta
-- =============================================
SELECT 
    pt.id,
    pt.numero_processo,
    op.descricao as origem_descricao,
    pt.empregador_numero_inscricao,
    pt.empregador_razao_social,
    st.descricao as status_descricao,
    pt.data_criacao,
    
    -- Contagem de trabalhadores
    COUNT(DISTINCT tp.id) as total_trabalhadores,
    
    -- Contagem de tributos
    COUNT(DISTINCT trp.id) as total_tributos

FROM processotrabalhista.processos_trabalhistas pt

-- JOINs
INNER JOIN processotrabalhista.origens_processo op ON pt.origem_processo_id = op.id
INNER JOIN processotrabalhista.status_sistema st ON pt.status_id = st.id
LEFT JOIN processotrabalhista.trabalhadores_processo tp ON pt.id = tp.processo_trabalhista_id
LEFT JOIN processotrabalhista.tributos_processo trp ON tp.id = trp.trabalhador_processo_id

WHERE pt.status_ativo = true

GROUP BY pt.id, pt.numero_processo, op.descricao, pt.empregador_numero_inscricao,
         pt.empregador_razao_social, st.descricao, pt.data_criacao

ORDER BY pt.data_criacao DESC;
```

### 5.2 Query Validação Pré-Envio S-2500

```sql
-- =============================================
-- APOIO: VALIDAÇÃO PRÉ-ENVIO S-2500
-- Verifica se processo está completo para envio
-- =============================================
SELECT 
    pt.id as processo_id,
    pt.numero_processo,
    
    -- Validações obrigatórias
    CASE WHEN pt.empregador_numero_inscricao IS NOT NULL THEN 'OK' ELSE 'FALTA_EMPREGADOR' END as validacao_empregador,
    CASE WHEN tp.cpf IS NOT NULL THEN 'OK' ELSE 'FALTA_TRABALHADOR' END as validacao_trabalhador,
    CASE WHEN cp.id IS NOT NULL THEN 'OK' ELSE 'FALTA_CONTRATO' END as validacao_contrato,
    CASE WHEN rp.id IS NOT NULL THEN 'OK' ELSE 'FALTA_REMUNERACAO' END as validacao_remuneracao,
    CASE WHEN vp.id IS NOT NULL THEN 'OK' ELSE 'FALTA_VINCULO' END as validacao_vinculo,
    CASE WHEN ep.id IS NOT NULL THEN 'OK' ELSE 'FALTA_ESTABELECIMENTO' END as validacao_estabelecimento,
    CASE WHEN pv.id IS NOT NULL THEN 'OK' ELSE 'FALTA_PERIODOS_VALORES' END as validacao_periodos,
    
    -- Validação final
    CASE 
        WHEN pt.empregador_numero_inscricao IS NOT NULL 
         AND tp.cpf IS NOT NULL 
         AND cp.id IS NOT NULL 
         AND rp.id IS NOT NULL 
         AND vp.id IS NOT NULL 
         AND ep.id IS NOT NULL 
         AND pv.id IS NOT NULL 
        THEN 'APTO_PARA_ENVIO' 
        ELSE 'PENDENCIAS' 
    END as status_validacao

FROM processotrabalhista.processos_trabalhistas pt

-- JOINs para validação
LEFT JOIN processotrabalhista.trabalhadores_processo tp ON pt.id = tp.processo_trabalhista_id
LEFT JOIN processotrabalhista.contratos_processo cp ON tp.id = cp.trabalhador_processo_id
LEFT JOIN processotrabalhista.remuneracoes_processo rp ON cp.id = rp.contrato_processo_id
LEFT JOIN processotrabalhista.vinculos_processo vp ON cp.id = vp.contrato_processo_id
LEFT JOIN processotrabalhista.estabelecimentos_processo ep ON cp.id = ep.contrato_processo_id
LEFT JOIN processotrabalhista.periodos_valores pv ON ep.id = pv.estabelecimento_processo_id

WHERE pt.id = $1 -- ID do processo
  AND pt.status_ativo = true;
```

### 5.3 Query Validação Pré-Envio S-2501

```sql
-- =============================================
-- APOIO: VALIDAÇÃO PRÉ-ENVIO S-2501
-- Verifica se tributo está completo para envio
-- =============================================
SELECT 
    tp.id as tributo_id,
    tp.numero_processo,
    tp.periodo_apuracao_pagamento,
    
    -- Validações obrigatórias
    CASE WHEN tpr.cpf IS NOT NULL THEN 'OK' ELSE 'FALTA_TRABALHADOR' END as validacao_trabalhador,
    CASE WHEN ct.id IS NOT NULL THEN 'OK' ELSE 'FALTA_CALCULO' END as validacao_calculo,
    CASE WHEN (crcs.id IS NOT NULL OR cri.id IS NOT NULL) THEN 'OK' ELSE 'FALTA_RECEITAS' END as validacao_receitas,
    
    -- Validação específica para S-2500 pré-requisito
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM processotrabalhista.controle_envio_xml cex 
            WHERE cex.tipo_evento = 'S-2500' 
              AND cex.trabalhador_processo_id = tp.trabalhador_processo_id 
              AND cex.status_envio = 'PROCESSADO'
        ) THEN 'OK' 
        ELSE 'FALTA_S2500_ENVIADO' 
    END as validacao_pre_requisito,
    
    -- Validação final
    CASE 
        WHEN tpr.cpf IS NOT NULL 
         AND ct.id IS NOT NULL 
         AND (crcs.id IS NOT NULL OR cri.id IS NOT NULL)
         AND EXISTS (
            SELECT 1 FROM processotrabalhista.controle_envio_xml cex 
            WHERE cex.tipo_evento = 'S-2500' 
              AND cex.trabalhador_processo_id = tp.trabalhador_processo_id 
              AND cex.status_envio = 'PROCESSADO'
        )
        THEN 'APTO_PARA_ENVIO' 
        ELSE 'PENDENCIAS' 
    END as status_validacao

FROM processotrabalhista.tributos_processo tp

-- JOINs para validação
INNER JOIN processotrabalhista.trabalhadores_processo tpr ON tp.trabalhador_processo_id = tpr.id
LEFT JOIN processotrabalhista.calculo_tributos ct ON tp.id = ct.tributo_processo_id
LEFT JOIN processotrabalhista.codigos_receita_contrib_social crcs ON ct.id = crcs.calculo_tributo_id
LEFT JOIN processotrabalhista.codigos_receita_irrf cri ON tp.id = cri.tributo_processo_id

WHERE tp.id = $1 -- ID do tributo
  AND tp.status_ativo = true;
```

### 5.4 Query Controle de Envio

```sql
-- =============================================
-- APOIO: CONTROLE DE ENVIO
-- Monitora status dos envios
-- =============================================
SELECT 
    cex.id,
    cex.uuid,
    cex.tipo_evento,
    cex.numero_processo,
    cex.status_envio,
    cex.data_envio,
    cex.data_processamento,
    cex.numero_recibo,
    cex.mensagem_retorno,
    
    -- Dados específicos por tipo de evento
    CASE 
        WHEN cex.tipo_evento = 'S-2500' THEN tp.cpf
        WHEN cex.tipo_evento = 'S-2501' THEN tpr.cpf
        ELSE NULL 
    END as cpf_trabalhador,
    
    CASE 
        WHEN cex.tipo_evento = 'S-2501' THEN trp.periodo_apuracao_pagamento
        WHEN cex.tipo_evento = 'S-2555' THEN ct.periodo_apuracao_pagamento
        ELSE NULL 
    END as periodo_apuracao

FROM processotrabalhista.controle_envio_xml cex

-- JOINs condicionais por tipo de evento
LEFT JOIN processotrabalhista.trabalhadores_processo tp 
    ON cex.trabalhador_processo_id = tp.id
LEFT JOIN processotrabalhista.tributos_processo trp 
    ON cex.tributo_processo_id = trp.id
LEFT JOIN processotrabalhista.trabalhadores_processo tpr 
    ON trp.trabalhador_processo_id = tpr.id
LEFT JOIN processotrabalhista.consolidacoes_tributos ct 
    ON cex.consolidacao_tributo_id = ct.id

WHERE cex.status_ativo = true
  AND ($1 IS NULL OR cex.tipo_evento = $1) -- Filtro opcional por tipo evento
  AND ($2 IS NULL OR cex.numero_processo = $2) -- Filtro opcional por processo

ORDER BY cex.data_criacao DESC;
```

---

## 6. ÍNDICES RECOMENDADOS

```sql
-- =============================================
-- ÍNDICES PARA PERFORMANCE
-- Recomendações para otimizar as queries
-- =============================================

-- Índices principais já criados no script base
-- Aqui estão índices adicionais para performance das queries

-- Para queries de busca por período
CREATE INDEX IF NOT EXISTS idx_tributos_processo_periodo 
    ON processotrabalhista.tributos_processo(periodo_apuracao_pagamento);

CREATE INDEX IF NOT EXISTS idx_calculo_tributos_periodo 
    ON processotrabalhista.calculo_tributos(periodo_referencia);

CREATE INDEX IF NOT EXISTS idx_identificacao_periodo_referencia 
    ON processotrabalhista.identificacoes_periodo(periodo_referencia);

-- Para queries de controle de envio
CREATE INDEX IF NOT EXISTS idx_controle_envio_tipo_status 
    ON processotrabalhista.controle_envio_xml(tipo_evento, status_envio);

CREATE INDEX IF NOT EXISTS idx_controle_envio_data_envio 
    ON processotrabalhista.controle_envio_xml(data_envio);

-- Para queries de relacionamento trabalhador/processo
CREATE INDEX IF NOT EXISTS idx_trabalhadores_processo_cpf_status 
    ON processotrabalhista.trabalhadores_processo(cpf, status_ativo);

-- Para queries de auditoria
CREATE INDEX IF NOT EXISTS idx_processos_data_usuario 
    ON processotrabalhista.processos_trabalhistas(data_criacao, usuario_criacao);

CREATE INDEX IF NOT EXISTS idx_tributos_data_usuario 
    ON processotrabalhista.tributos_processo(data_criacao, usuario_criacao);

-- Para queries de validação
CREATE INDEX IF NOT EXISTS idx_controle_envio_trabalhador_tipo 
    ON processotrabalhista.controle_envio_xml(trabalhador_processo_id, tipo_evento);
```

---

## 7. NOTAS DE IMPLEMENTAÇÃO

### 7.1 Parâmetros das Queries

- **$1, $2, etc.** - Parâmetros preparados para evitar SQL Injection
- Sempre usar parâmetros preparados em produção
- Validar tipos de dados antes de executar

### 7.2 Tratamento de Nulos

- Muitos campos são opcionais conforme documentação eSocial
- Tratar NULLs adequadamente na montagem do XML
- Usar COALESCE quando valores padrão forem necessários

### 7.3 Performance

- Queries otimizadas para PostgreSQL
- JOINs apenas nos dados necessários
- Índices nas colunas mais consultadas
- Considerar particionamento para grandes volumes

### 7.4 Transações

- Usar transações para operações que envolvem múltiplas tabelas
- Implementar rollback em caso de erro na geração do XML
- Manter consistência entre dados e controle de envio

---

**Documento gerado:** Agosto 2025  
**Versão:** 1.0  
**Status:** Queries Validadas para PostgreSQL