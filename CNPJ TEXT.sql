SELECT
  tab1.REQUISICAO AS REQUISICAO,
  tab1.CONTRATO,
  tab1.PEDIDO_COMPRA,
  tab1.TEXTO_PEDIDO,
  tab1.ORDEM_INTERNA_NR,
  tab1.ORDEM_INTERNA_DESC,
  tab1.VALOR_TOTAL_PEDIDO AS VALOR_TOTAL_PEDIDO,
  tab1.STATUS_PEDIDO,
  tab1.COMPRADOR,
  tab1.DATA_PEDIDO,
  tab1.FORN_COD,
  tab1.FORN_NOME,
  tab1.FORN_CNPJ,
  tab1.REQUISITANTE,
  tab1.COD_EMPRESA,
  tab1.NOME_EMPRESA,
  tab1.COD_UNIDADE,
  tab1.NOME_UNIDADE,
  tab1.ESTRATEGIA_APROVACAO,
  tab1.NIVEL_APROVACAO_ATUAL,
  tab1.NIVEIS_APROVACAO,
  tab1.aprovacao_1,
  ifnull (max(tab1.aprovador_real_1), tab1.aprovador_1) AS aprovador_1,
  max(data_aprovacao_1) AS data_aprovacao_1,
  max(hora_aprovacao_1) AS hora_aprovacao_1,
  tab1.aprovacao_2,
  ifnull (max(tab1.aprovador_real_2), tab1.aprovador_2) AS aprovador_2,
  max(data_aprovacao_2) AS data_aprovacao_2,
  max(hora_aprovacao_2) AS hora_aprovacao_2,
  tab1.aprovacao_3,
  ifnull (max(tab1.aprovador_real_3), tab1.aprovador_3) AS aprovador_3,
  max(data_aprovacao_3) AS data_aprovacao_3,
  max(hora_aprovacao_3) AS hora_aprovacao_3,
  tab1.aprovacao_4,
  ifnull (max(tab1.aprovador_real_4), tab1.aprovador_4) AS aprovador_4,
  max(data_aprovacao_4) AS data_aprovacao_4,
  max(hora_aprovacao_4) AS hora_aprovacao_4,
  tab1.aprovacao_5,
  ifnull (max(tab1.aprovador_real_5), tab1.aprovador_5) AS aprovador_5,
  max(data_aprovacao_5) AS data_aprovacao_5,
  max(hora_aprovacao_5) AS hora_aprovacao_5,
  tab1.aprovacao_6,
  ifnull (max(tab1.aprovador_real_6), tab1.aprovador_6) AS aprovador_6,
  max(data_aprovacao_6) AS data_aprovacao_6,
  max(hora_aprovacao_6) AS hora_aprovacao_6,
  tab1.aprovacao_7,
  ifnull (max(tab1.aprovador_real_7), tab1.aprovador_7) AS aprovador_7,
  max(data_aprovacao_7) AS data_aprovacao_7,
  max(hora_aprovacao_7) AS hora_aprovacao_7,
  tab1.aprovacao_8,
  ifnull (max(tab1.aprovador_real_8), tab1.aprovador_8) AS aprovador_8,
  max(data_aprovacao_8) AS data_aprovacao_8,
  max(hora_aprovacao_8) AS hora_aprovacao_8
FROM
  (
    SELECT
      CASE aprov.seq_hist
        WHEN 1 THEN aprov.aprovador
      END AS aprovador_real_1,
      CASE aprov.seq_hist
        WHEN 1 THEN aprov.data_aprovacao
      END AS data_aprovacao_1,
      CASE aprov.seq_hist
        WHEN 1 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_1,
      CASE aprov.seq_hist
        WHEN 2 THEN aprov.aprovador
      END AS aprovador_real_2,
      CASE aprov.seq_hist
        WHEN 2 THEN aprov.data_aprovacao
      END AS data_aprovacao_2,
      CASE aprov.seq_hist
        WHEN 2 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_2,
      CASE aprov.seq_hist
        WHEN 3 THEN aprov.aprovador
      END AS aprovador_real_3,
      CASE aprov.seq_hist
        WHEN 3 THEN aprov.data_aprovacao
      END AS data_aprovacao_3,
      CASE aprov.seq_hist
        WHEN 3 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_3,
      CASE aprov.seq_hist
        WHEN 4 THEN aprov.aprovador
      END AS aprovador_real_4,
      CASE aprov.seq_hist
        WHEN 4 THEN aprov.data_aprovacao
      END AS data_aprovacao_4,
      CASE aprov.seq_hist
        WHEN 4 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_4,
      CASE aprov.seq_hist
        WHEN 5 THEN aprov.aprovador
      END AS aprovador_real_5,
      CASE aprov.seq_hist
        WHEN 5 THEN aprov.data_aprovacao
      END AS data_aprovacao_5,
      CASE aprov.seq_hist
        WHEN 5 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_5,
      CASE aprov.seq_hist
        WHEN 6 THEN aprov.aprovador
      END AS aprovador_real_6,
      CASE aprov.seq_hist
        WHEN 6 THEN aprov.data_aprovacao
      END AS data_aprovacao_6,
      CASE aprov.seq_hist
        WHEN 6 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_6,
      CASE aprov.seq_hist
        WHEN 7 THEN aprov.aprovador
      END AS aprovador_real_7,
      CASE aprov.seq_hist
        WHEN 7 THEN aprov.data_aprovacao
      END AS data_aprovacao_7,
      CASE aprov.seq_hist
        WHEN 7 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_7,
      CASE aprov.seq_hist
        WHEN 8 THEN aprov.aprovador
      END AS aprovador_real_8,
      CASE aprov.seq_hist
        WHEN 8 THEN aprov.data_aprovacao
      END AS data_aprovacao_8,
      CASE aprov.seq_hist
        WHEN 8 THEN aprov.hora_aprovacao
      END AS hora_aprovacao_8,
      aprov.seq_hist,
      ep.BANFN AS requisicao,
      ep.konnr AS contrato,
      ep.EBELN AS pedido_compra,
      ep.EBELP AS pedido_subitem,
      to_char (esl.LONGTEXT) AS texto_pedido,
      ak.AUFNR AS ordem_interna_nr,
      ak.KTEXT AS ordem_interna_desc,
      (
        CASE en.vproz
          WHEN 0 THEN 1
          ELSE en.vproz / 100
        END
      ) AS rateio,
      /*ek.RLWRT*/
      CASE
        WHEN ek.EBELN LIKE '46%' THEN ek.RLWRT
        ELSE (
          SELECT
            sum(ep1.BRTWR)
          FROM
            sapabaperp.ekpo ep1
          where
            ep1.MANDT = '300'
            AND ep1.EBELN = '{{$.trigger.headers.pedidoORcontrato}}'
            AND ep1.LOEKZ = ''
        )
      END AS valor_total_pedido,
      ep.BRTWR * (
        CASE en.vproz
          WHEN 0 THEN 1
          ELSE en.vproz / 100
        END
      ) AS valor_pedido_subitem_c_imposto,
      d7.DDTEXT AS status_pedido,
      ep.MATNR AS material_cod,
      ep.TXZ01 AS material_desc,
      tc.EKNAM AS comprador,
      to_date (ek.AEDAT, 'yyyymmdd') AS data_pedido,
      to_date (ep.AEDAT, 'yyyymmdd') AS data_pedido_item,
      ek.LIFNR AS forn_cod,
      l.NAME1 AS forn_nome,
      l.STCD1 AS forn_cnpj,
      cs.KOSTL AS centro_custo,
      ck.ltext AS centro_custo_desc,
      cs.VERAK AS dono_centro_custo,
      sk.SAKNR AS conta_contabil_cod,
      sk.TXT20 AS conta_contabil_desc,
      ep.AFNAM AS requisitante,
      ek.BUKRS AS cod_empresa,
      emp.BUTXT AS nome_empresa,
      ep.WERKS AS cod_unidade,
      tw.NAME1 AS nome_unidade,
      (ek.FRGGR || '-' || ek.FRGSX || '-' || ek.FRGKE) AS estrategia_aprovacao,
      LENGTH (ek.FRGZU) AS nivel_aprovacao_atual,
      length (
        (
          t1.FRGA1 || t1.FRGA2 || t1.FRGA3 || t1.FRGA4 || t1.FRGA5 || t1.FRGA6 || t1.FRGA7 || t1.FRGA8
        )
      ) AS niveis_aprovacao,
      frgc1.FRGCO || ' - ' || frgc1.FRGCT AS aprovacao_1,
      adp1.NAME_TEXT AS aprovador_1,
      frgc2.FRGCO || ' - ' || frgc2.FRGCT AS aprovacao_2,
      adp2.NAME_TEXT AS aprovador_2,
      frgc3.FRGCO || ' - ' || frgc3.FRGCT AS aprovacao_3,
      adp3.NAME_TEXT AS aprovador_3,
      frgc4.FRGCO || ' - ' || frgc4.FRGCT AS aprovacao_4,
      adp4.NAME_TEXT AS aprovador_4,
      frgc5.FRGCO || ' - ' || frgc5.FRGCT AS aprovacao_5,
      adp5.NAME_TEXT AS aprovador_5,
      frgc6.FRGCO || ' - ' || frgc6.FRGCT AS aprovacao_6,
      adp6.NAME_TEXT AS aprovador_6,
      frgc7.FRGCO || ' - ' || frgc7.FRGCT AS aprovacao_7,
      adp7.NAME_TEXT AS aprovador_7,
      frgc8.FRGCO || ' - ' || frgc8.FRGCT AS aprovacao_8,
      adp8.NAME_TEXT AS aprovador_8,
      aprv1.OBJID
    FROM
      sapabaperp.ekko ek
      LEFT JOIN SAPABAPERP.ESH_SR_LTXT esl ON (
        esl.MANDT = ek.MANDT
        AND esl.TDNAME = ek.EBELN
        AND esl.TDOBJECT = 'EKKO'
        AND esl.TDSPRAS = 'P'
      )
      LEFT JOIN sapabaperp.ekpo ep ON (
        ep.MANDT = ek.MANDT
        AND ep.EBELN = ek.EBELN
      )
      INNER JOIN SAPABAPERP.t001w tw ON (
        tw.MANDT = ep.MANDT
        AND tw.WERKS = ep.werks
      )
      LEFT OUTER JOIN SAPABAPERP.t16fk t ON (
        t.MANDT = ek.MANDT
        AND t.FRGGR = ek.FRGGR
        AND t.FRGSX = ek.frgsx
        AND t.frgkx = ek.frgke
        AND (
          t.FRGA1 || t.FRGA2 || t.FRGA3 || t.FRGA4 || t.FRGA5 || t.FRGA6 || t.FRGA7 || t.FRGA8
        ) = ek.FRGZU
      )
      LEFT OUTER JOIN SAPABAPERP.t16fk t1 ON (
        t1.MANDT = ek.MANDT
        AND t1.FRGGR = ek.FRGGR
        AND t1.FRGSX = ek.frgsx
        AND t1.frgkx in ('3', '1')
      )
      LEFT OUTER JOIN SAPABAPERP.t16fs ts ON (
        ts.MANDT = t.MANDT
        AND ts.FRGGR = t.FRGGR
        AND ts.frgsx = t.FRGSX
      )
      LEFT OUTER JOIN SAPABAPERP.ekkn en ON (
        en.MANDT = ep.MANDT
        AND en.EBELN = ep.EBELN
        AND en.EBELP = ep.EBELP
        AND en.LOEKZ = ''
      )
      LEFT OUTER JOIN sapabaperp.skat sk ON (
        sk.mandt = ek.mandt
        AND sk.spras = ek.SPRAS
        AND sk.SAKNR = en.SAKTO
        AND sk.KTOPL = 'YCOA'
      )
      LEFT OUTER JOIN sapabaperp.CSKS cs ON (
        cs.MANDT = ek.MANDT
        AND cs.KOKRS = en.KOKRS
        AND cs.KOSTL = en.KOSTL
      )
      LEFT OUTER JOIN sapabaperp.cskt ck ON (
        ck.MANDT = cs.MANDT
        AND ck.KOSTL = cs.KOSTL
      )
      LEFT OUTER JOIN sapabaperp.aufk ak ON (
        ak.MANDT = ek.MANDT
        AND ak.AUFNR = en.AUFNR
        AND en.LOEKZ = ''
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc1 ON (
        frgc1.MANDT = ts.MANDT
        AND frgc1.SPRAS = 'P'
        AND ts.FRGGR = frgc1.FRGGR
        AND frgc1.FRGCO = ts.FRGC1
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc2 ON (
        frgc2.MANDT = ts.MANDT
        AND frgc2.SPRAS = 'P'
        AND ts.FRGGR = frgc2.FRGGR
        AND frgc2.FRGCO = ts.FRGC2
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc3 ON (
        frgc3.MANDT = ts.MANDT
        AND frgc3.SPRAS = 'P'
        AND ts.FRGGR = frgc3.FRGGR
        AND frgc3.FRGCO = ts.FRGC3
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc4 ON (
        frgc4.MANDT = ts.MANDT
        AND frgc4.SPRAS = 'P'
        AND ts.FRGGR = frgc4.FRGGR
        AND frgc4.FRGCO = ts.FRGC4
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc5 ON (
        frgc5.MANDT = ts.MANDT
        AND frgc5.SPRAS = 'P'
        AND ts.FRGGR = frgc5.FRGGR
        AND frgc5.FRGCO = ts.FRGC5
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc6 ON (
        frgc6.MANDT = ts.MANDT
        AND frgc6.SPRAS = 'P'
        AND ts.FRGGR = frgc6.FRGGR
        AND frgc6.FRGCO = ts.FRGC6
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc7 ON (
        frgc7.MANDT = ts.MANDT
        AND frgc7.SPRAS = 'P'
        AND ts.FRGGR = frgc7.FRGGR
        AND frgc7.FRGCO = ts.FRGC7
      )
      LEFT OUTER JOIN SAPABAPERP.T16FD frgc8 ON (
        frgc8.MANDT = ts.MANDT
        AND frgc8.SPRAS = 'P'
        AND ts.FRGGR = frgc8.FRGGR
        AND frgc8.FRGCO = ts.FRGC8
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv1 ON (
        aprv1.MANDT = ts.MANDT
        AND aprv1.FRGGR = TS.FRGGR
        AND aprv1.FRGCO = ts.FRGC1
        and (
          aprv1.WERKS = tw.WERKS
          or aprv1.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv2 ON (
        aprv2.MANDT = ts.MANDT
        AND aprv2.FRGGR = TS.FRGGR
        AND aprv2.FRGCO = ts.FRGC2
        and (
          aprv2.WERKS = tw.WERKS
          or aprv2.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv3 ON (
        aprv3.MANDT = ts.MANDT
        AND aprv3.FRGGR = TS.FRGGR
        AND aprv3.FRGCO = ts.FRGC3
        and (
          aprv3.WERKS = tw.WERKS
          or aprv3.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv4 ON (
        aprv4.MANDT = ts.MANDT
        AND aprv4.FRGGR = TS.FRGGR
        AND aprv4.FRGCO = ts.FRGC4
        and (
          aprv4.WERKS = tw.WERKS
          or aprv4.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv5 ON (
        aprv5.MANDT = ts.MANDT
        AND aprv5.FRGGR = TS.FRGGR
        AND aprv5.FRGCO = ts.FRGC5
        and (
          aprv5.WERKS = tw.WERKS
          or aprv5.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv6 ON (
        aprv6.MANDT = ts.MANDT
        AND aprv6.FRGGR = TS.FRGGR
        AND aprv6.FRGCO = ts.FRGC6
        and (
          aprv6.WERKS = tw.WERKS
          or aprv6.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv7 ON (
        aprv7.MANDT = ts.MANDT
        AND aprv7.FRGGR = TS.FRGGR
        AND aprv7.FRGCO = ts.FRGC7
        and (
          aprv7.WERKS = tw.WERKS
          or aprv7.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv8 ON (
        aprv8.MANDT = ts.MANDT
        AND aprv8.FRGGR = TS.FRGGR
        AND aprv8.FRGCO = ts.FRGC8
        and (
          aprv8.WERKS = tw.WERKS
          or aprv8.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv1 ON (
        usapv1.MANDT = aprv1.MANDT
        AND usapv1.BNAME = aprv1.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp1 ON (
        adp1.CLIENT = usapv1.MANDT
        AND adp1.PERSNUMBER = usapv1.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv2 ON (
        usapv2.MANDT = aprv2.MANDT
        AND usapv2.BNAME = aprv2.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp2 ON (
        adp2.CLIENT = usapv2.MANDT
        AND adp2.PERSNUMBER = usapv2.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv3 ON (
        usapv3.MANDT = aprv3.MANDT
        AND usapv3.BNAME = aprv3.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp3 ON (
        adp3.CLIENT = usapv3.MANDT
        AND adp3.PERSNUMBER = usapv3.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv4 ON (
        usapv4.MANDT = aprv4.MANDT
        AND usapv4.BNAME = aprv4.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp4 ON (
        adp4.CLIENT = usapv4.MANDT
        AND adp4.PERSNUMBER = usapv4.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv5 ON (
        usapv5.MANDT = aprv5.MANDT
        AND usapv5.BNAME = aprv5.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp5 ON (
        adp5.CLIENT = usapv5.MANDT
        AND adp5.PERSNUMBER = usapv5.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv6 ON (
        usapv6.MANDT = aprv6.MANDT
        AND usapv6.BNAME = aprv6.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp6 ON (
        adp6.CLIENT = usapv6.MANDT
        AND adp6.PERSNUMBER = usapv6.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv7 ON (
        usapv7.MANDT = aprv7.MANDT
        AND usapv7.BNAME = aprv7.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp7 ON (
        adp7.CLIENT = usapv7.MANDT
        AND adp7.PERSNUMBER = usapv7.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv8 ON (
        usapv8.MANDT = aprv8.MANDT
        AND usapv8.BNAME = aprv8.OBJID
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp8 ON (
        adp8.CLIENT = usapv8.MANDT
        AND adp8.PERSNUMBER = usapv8.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.dd07t d7 ON (
        d7.DOMNAME = 'MEPROCSTATE'
        AND d7.DDLANGUAGE = 'P'
        AND d7.DOMVALUE_L = ek.procstat
      )
      LEFT OUTER JOIN SAPABAPERP.t024 tc ON (
        tc.MANDT = ek.MANDT
        AND tc.EKGRP = ek.EKGRP
      )
      LEFT OUTER JOIN SAPABAPERP.lfa1 l ON (
        l.MANDT = ek.MANDT
        AND l.lifnr = ek.LIFNR
      )
      LEFT OUTER JOIN SAPABAPERP.t001 emp ON (
        emp.mandt = ek.mandt
        AND emp.bukrs = ek.BUKRS
      )
      LEFT OUTER JOIN (
        SELECT
          ROW_NUMBER() OVER (
            ORDER BY
              swi.INSTID,
              swi.top_WI_ID ASC
          ) AS seq_hist,
          swi.INSTID AS pedido,
          adp1.NAME_TEXT AS aprovador,
          (swhb1.wi_cd) AS data_aprovacao,
          (swhb1.wi_ct) AS hora_aprovacao
        FROM
          SAPABAPERP.SWW_WI2OBJ swi
          LEFT outer JOIN (
            SELECT
              max(
                TO_TIMESTAMP (concat (cdh.UDATE, cdh.UTIME), 'YYYYMMDDHH24miss')
              ) AS data_max
            FROM
              SAPABAPERP.cdpos c
              INNER JOIN SAPABAPERP.cdhdr cdh ON (cdh.CHANGENR = c.CHANGENR)
            WHERE
              c.MANDANT = '300'
              AND c.FNAME = 'PROCSTAT'
              AND c.TABNAME = 'EKKO'
              AND c.OBJECTID = '{{$.trigger.headers.pedidoORcontrato}}'
              AND c.VALUE_NEW = '03'
          ) tbalt ON (tbalt.data_max IS NOT null)
          LEFT outer JOIN SAPABAPERP.SWWWIHEAD swha1 ON (
            swha1.CLIENT = swi.CLIENT
            AND swha1.WI_ID = swi.WI_ID
            AND swha1.WI_CHCKWI = swi.TOP_WI_ID
            AND swha1.WI_ID = swi.WI_ID
            AND swha1.WI_TYPE = 'W'
            AND swha1.WI_RHTEXT IN ('Liberação pedido', 'Liberação contrato')
            AND swha1.WI_STAT = 'COMPLETED'
            AND (
              swha1.HANDLE <> '000000000000'
              OR swi.INSTID LIKE '46%'
            )
          )
          LEFT outer JOIN SAPABAPERP.SWWWIHEAD swhb1 ON (
            swhb1.CLIENT = swi.CLIENT
            AND swhb1.WI_CHCKWI = swi.TOP_WI_ID
            AND swhb1.WI_TYPE = 'W'
            AND swhb1.WI_RHTEXT in (
              'A liberação de pedido foi executada',
              'Liberação de contrato foi efetuada'
            )
            AND swhb1.WI_STAT = 'READY'
            AND swhb1.WI_CHCKWI = swha1.WI_CHCKWI
            AND (
              (
                swhb1.WI_RH_TASK = 'TS20000168'
                AND swhb1.HANDLE <> '000000000000'
              )
              OR (swhb1.WI_RH_TASK = 'TS20000174')
            )
          )
          LEFT OUTER JOIN SAPABAPERP.USR21 usapv1 ON (
            usapv1.MANDT = swha1.CLIENT
            AND usapv1.BNAME = swha1.WI_AAGENT
          )
          LEFT outer JOIN SAPABAPERP.ADRP adp1 ON (
            adp1.CLIENT = usapv1.MANDT
            AND adp1.PERSNUMBER = usapv1.PERSNUMBER
          )
        where
          swi.CLIENT = '300'
          AND swi.INSTID = '{{$.trigger.headers.pedidoORcontrato}}'
          AND swi.WI_RH_TASK IN ('TS20000166', 'TS20000172')
          AND (
            (
              TO_TIMESTAMP (
                SUBSTRING(to_char (swi.crea_tmp), 1, 14),
                'YYYYMMDDHH24miss'
              ) >= tbalt.data_max
            )
            OR (tbalt.data_max IS NULL)
          )
          AND swha1.CLIENT IS NOT NULL
      ) AS aprov ON (aprov.pedido = ek.EBELN)
    WHERE
      ek.MANDT = '300'
      AND l.STCD1 = '{{$.trigger.headers.pedidoORcontrato}}' -- CNPJ FORNECEDOR
      AND ep.EBELP = '00010'
  ) tab1
GROUP by
  tab1.REQUISICAO,
  tab1.CONTRATO,
  tab1.PEDIDO_COMPRA,
  tab1.TEXTO_PEDIDO,
  tab1.ORDEM_INTERNA_NR,
  tab1.ORDEM_INTERNA_DESC,
  tab1.VALOR_TOTAL_PEDIDO,
  tab1.STATUS_PEDIDO,
  tab1.COMPRADOR,
  tab1.DATA_PEDIDO,
  tab1.FORN_COD,
  tab1.FORN_NOME,
  tab1.FORN_CNPJ,
  tab1.REQUISITANTE,
  tab1.COD_EMPRESA,
  tab1.NOME_EMPRESA,
  tab1.COD_UNIDADE,
  tab1.NOME_UNIDADE,
  tab1.ESTRATEGIA_APROVACAO,
  tab1.NIVEL_APROVACAO_ATUAL,
  tab1.NIVEIS_APROVACAO,
  tab1.aprovacao_1,
  tab1.aprovacao_2,
  tab1.aprovacao_3,
  tab1.aprovacao_4,
  tab1.aprovacao_5,
  tab1.aprovacao_6,
  tab1.aprovacao_7,
  tab1.aprovacao_8,
  tab1.aprovador_1,
  tab1.aprovador_2,
  tab1.aprovador_3,
  tab1.aprovador_4,
  tab1.aprovador_5,
  tab1.aprovador_6,
  tab1.aprovador_7
  tab1.aprovador_8