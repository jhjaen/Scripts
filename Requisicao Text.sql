SELECT
  REQUISITANTE,
  REQUISICAO,
  PEDIDO,
  code_aprovacao,
  codigo,
  --CONTRATO,
  STATUS_REQUISICAO,
  ESTRATEGIA_APROVACAO,
  req_subitem,
  dt_criacao,
  tp_requisicao,
  estrategia,
  NIVEL_APROVACAO_ATUAL,
  NIVEIS_APROVACAO,
  area,
  (
    SELECT
      adp1.NAME_TEXT
    FROM
      SAPABAPERP.SWW_WI2OBJ swi
      LEFT OUTER JOIN (
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
          AND c.OBJECTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
          AND c.VALUE_NEW = '03'
      ) tbalt ON (tbalt.data_max IS NOT NULL)
      LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swha1 ON (
        swha1.CLIENT = swi.CLIENT
        AND swha1.WI_ID = swi.WI_ID
        AND swha1.WI_CHCKWI = swi.TOP_WI_ID
        AND swha1.WI_TYPE = 'W'
        AND swha1.WI_RHTEXT IN ('Liberação da requisição de compra')
        AND swha1.WI_STAT = 'COMPLETED'
      )
      LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swhb1 ON (
        swhb1.CLIENT = swi.CLIENT
        AND swhb1.WI_CHCKWI = swi.TOP_WI_ID
        AND swhb1.WI_TYPE = 'W'
        AND swhb1.WI_TEXT LIKE ('%liberada%')
        AND swhb1.WI_TEXT LIKE ('%ReqC%')
        AND swhb1.WI_TEXT LIKE ('%{{$.trigger.headers.pedidoORcontrato}}%')
        --AND swhb1.WI_RHTEXT in ('Liberação reqC foi executada') 
        AND swhb1.WI_STAT = 'READY'
        AND swhb1.WI_CHCKWI = swha1.WI_CHCKWI
        AND (
          (
            swhb1.WI_RH_TASK = 'TS00007986'
            AND swhb1.HANDLE <> '000000000000'
          )
          OR (swhb1.WI_RH_TASK = 'TS00008018')
        )
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv1 ON (
        usapv1.MANDT = swha1.CLIENT
        AND usapv1.BNAME = swha1.WI_AAGENT
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp1 ON (
        adp1.CLIENT = usapv1.MANDT
        AND adp1.PERSNUMBER = usapv1.PERSNUMBER
      )
    WHERE
      swi.CLIENT = '300'
      AND swi.INSTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
      AND swi.WI_RH_TASK IN ('TS00007986', 'TS00008018')
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
      AND swi.INSTID LIKE '%' || req_subitem
  ) AS APROVACAO_1,
  -- DATA
  (
    SELECT
      to_char (
        TO_TIMESTAMP (swhb1.wi_cd || swhb1.wi_ct, 'YYYYMMDDhh24miss'),
        'dd/MM/YYYY hh24:mi:ss'
      ) AS data_aprov
    FROM
      SAPABAPERP.SWW_WI2OBJ swi
      LEFT OUTER JOIN (
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
          AND c.OBJECTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
          AND c.VALUE_NEW = '03'
      ) tbalt ON (tbalt.data_max IS NOT NULL)
      LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swha1 ON (
        swha1.CLIENT = swi.CLIENT
        AND swha1.WI_ID = swi.WI_ID
        AND swha1.WI_CHCKWI = swi.TOP_WI_ID
        AND swha1.WI_TYPE = 'W'
        AND swha1.WI_RHTEXT IN ('Liberação da requisição de compra')
        AND swha1.WI_STAT = 'COMPLETED'
      )
      LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swhb1 ON (
        swhb1.CLIENT = swi.CLIENT
        AND swhb1.WI_CHCKWI = swi.TOP_WI_ID
        AND swhb1.WI_TYPE = 'W'
        AND swhb1.WI_TEXT LIKE ('%liberada%')
        AND swhb1.WI_TEXT LIKE ('%ReqC%')
        AND swhb1.WI_TEXT LIKE CASE
          WHEN LENGTH ('{{$.trigger.headers.pedidoORcontrato}}') > 8 then '%' || SUBSTR_AFTER ('{{$.trigger.headers.pedidoORcontrato}}', 00) || '%'
          ELSE '%' || '{{$.trigger.headers.pedidoORcontrato}}' || '%'
        END
        --AND swhb1.WI_RHTEXT in ('Liberação reqC foi executada') 
        AND swhb1.WI_STAT = 'READY'
        AND swhb1.WI_CHCKWI = swha1.WI_CHCKWI
        AND (
          (
            swhb1.WI_RH_TASK = 'TS00007986'
            AND swhb1.HANDLE <> '000000000000'
          )
          OR (swhb1.WI_RH_TASK = 'TS00008018')
        )
      )
      LEFT OUTER JOIN SAPABAPERP.USR21 usapv1 ON (
        usapv1.MANDT = swha1.CLIENT
        AND usapv1.BNAME = swha1.WI_AAGENT
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adp1 ON (
        adp1.CLIENT = usapv1.MANDT
        AND adp1.PERSNUMBER = usapv1.PERSNUMBER
      )
    WHERE
      swi.CLIENT = '300'
      AND swi.INSTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
      AND swi.WI_RH_TASK IN ('TS00007986', 'TS00008018')
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
      AND swi.INSTID LIKE '%' || req_subitem
  ) AS DATA_APROV
  --max(APROVACAO_1) AS APROVACAO_1
  --max(APROVACAO_2) AS APROVACAO_2 
FROM
  (
    SELECT
      to_char (eb.BADAT, 'dd/MM/YYYY') AS dt_criacao,
      ek.KOSTL AS centro_custo,
      eb.BSART AS tp_requisicao,
      eb.FRGST AS code_aprovacao,
      ts.FRGC1 AS codigo,
      adpcria.NAME_TEXT AS requisitante,
      eb.BANFN AS requisicao,
      eb.BNFPO AS req_subitem,
      eb.EBELN AS pedido,
      eb.KONNR AS contrato,
      tu.FKZTX AS status_requisicao,
      (eb.FRGGR || '-' || eb.FRGST || '-' || eb.FRGKZ) AS estrategia_aprovacao,
      LENGTH (eb.FRGZU) AS nivel_aprovacao_atual,
      LENGTH (
        (
          t1.FRGA1 || t1.FRGA2 || t1.FRGA3 || t1.FRGA4 || t1.FRGA5 || t1.FRGA6 || t1.FRGA7 || t1.FRGA8
        )
      ) AS niveis_aprovacao,
      /* frgc1.FRGCO ||' - '|| frgc1.FRGCT AS aprovacao_1, 
      CASE aprov.seq_hist WHEN 1 THEN aprov.aprovador END AS aprovador_real_1,
      CASE aprov.seq_hist WHEN 1 THEN aprov.data_aprovacao END AS data_aprovacao_1,
      CASE aprov.seq_hist WHEN 1 THEN aprov.hora_aprovacao END AS hora_aprovacao_1,
      frgc2.FRGCO||' - '|| frgc2.FRGCT AS aprovacao_2,
      CASE aprov.seq_hist WHEN 2 THEN aprov.aprovador END AS aprovador_real_2,
      CASE aprov.seq_hist WHEN 2 THEN aprov.data_aprovacao END AS data_aprovacao_2,
      CASE aprov.seq_hist WHEN 2 THEN aprov.hora_aprovacao END AS hora_aprovacao_2 */
      frgc1.FRGCO estrategia,
      frgc1.FRGCT AS area,
      /*ifnull(CASE aprov.seq_hist WHEN 1 THEN aprov.aprovador END,adp1.NAME_TEXT) || ' - '||
      CASE aprov.seq_hist WHEN 1 THEN (to_char(TO_TIMESTAMP(aprov.data_aprovacao||aprov.hora_aprovacao,'YYYYMMDDhh24miss'),'dd/MM/YYYY hh24:mi:ss')) END */
      aprov.hora_aprovacao hr_aprov,
      frgc2.FRGCO || ' - ' || frgc2.FRGCT || ' - ' || ifnull (
        CASE aprov.seq_hist
          WHEN 2 THEN aprov.aprovador
        END,
        adp2.NAME_TEXT
      ) || ' - ' || CASE aprov.seq_hist
        WHEN 2 THEN (
          to_char (
            TO_TIMESTAMP (
              max(aprov.data_aprovacao) || max(aprov.hora_aprovacao),
              'YYYYMMDDhh24miss'
            ),
            'dd/MM/YYYY hh24:mi:ss'
          )
        )
      END AS aprovacao_2
    FROM
      SAPABAPERP.eban eb
      INNER JOIN SAPABAPERP.T161S t1s ON (
        t1s.MANDT = eb.MANDT
        AND t1s.FRGKZ = eb.FRGKZ
      )
      --Chave do status da requisição
      INNER JOIN SAPABAPERP.T161U tu ON (
        tu.MANDT = t1s.MANDT
        AND tu.SPRAS = 'P'
        AND tu.FRGKZ = t1s.FRGKZ
      )
      --Valor (descrição) do status da requisição
      INNER JOIN SAPABAPERP.t16fk t ON (
        t.MANDT = eb.MANDT
        AND t.FRGGR = eb.FRGGR
        AND t.FRGSX = eb.FRGST
        AND t.frgkx = eb.FRGKZ
        AND (
          t.FRGA1 || t.FRGA2 || t.FRGA3 || t.FRGA4 || t.FRGA5 || t.FRGA6 || t.FRGA7 || t.FRGA8
        ) = eb.FRGZU
      )
      INNER JOIN SAPABAPERP.t16fk t1 ON (
        t1.MANDT = eb.MANDT
        AND t1.FRGGR = eb.FRGGR
        AND t1.FRGSX = eb.FRGST
        AND t1.frgkx = 'B'
      )
      LEFT OUTER JOIN SAPABAPERP.t16fs ts ON (
        ts.MANDT = t.MANDT
        AND ts.FRGGR = t.FRGGR
        AND ts.frgsx = t.FRGSX
      )
      LEFT OUTER JOIN SAPABAPERP.T16FT tt ON (
        tt.MANDT = eb.MANDT
        AND tt.FRGGR = 'RC'
        AND tt.FRGSX = 'HR'
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
      LEFT OUTER JOIN SAPABAPERP.USR21 usrcria ON (
        usrcria.MANDT = eb.MANDT
        AND usrcria.BNAME = eb.ERNAM
      )
      LEFT OUTER JOIN SAPABAPERP.ADRP adpcria ON (
        adpcria.CLIENT = usrcria.MANDT
        AND adpcria.PERSNUMBER = usrcria.PERSNUMBER
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv1 ON (
        aprv1.MANDT = ts.MANDT
        AND aprv1.FRGGR = TS.FRGGR
        AND aprv1.FRGCO = ts.FRGC1
        AND (
          aprv1.WERKS = eb.WERKS
          OR aprv1.werks = ''
        )
      )
      LEFT OUTER JOIN SAPABAPERP.EBKN ek ON (
        ek.MANDT = eb.MANDT
        AND ek.BANFN = eb.BANFN
      )
      LEFT OUTER JOIN SAPABAPERP.t16fw aprv2 ON (
        aprv2.MANDT = ts.MANDT
        AND aprv2.FRGGR = TS.FRGGR
        AND aprv2.FRGCO = ts.FRGC2
        AND (
          aprv2.WERKS = eb.WERKS
          OR aprv2.werks = ''
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
      LEFT OUTER JOIN SAPABAPERP.T16FD td ON (
        td.MANDT = ts.MANDT
        AND td.SPRAS = 'P'
        AND td.FRGGR = 'RC'
        AND td.FRGCO = 'JH'
      )
      LEFT OUTER JOIN (
        SELECT
          ROW_NUMBER() OVER (
            ORDER BY
              swi.INSTID,
              swi.top_WI_ID ASC
          ) AS seq_hist,
          swi.INSTID AS requisicao,
          adp1.NAME_TEXT AS aprovador,
          (swhb1.wi_cd) AS data_aprovacao,
          (swhb1.wi_ct) AS hora_aprovacao
        FROM
          SAPABAPERP.SWW_WI2OBJ swi
          LEFT OUTER JOIN (
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
              AND c.OBJECTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
              AND c.VALUE_NEW = '03'
          ) tbalt ON (tbalt.data_max IS NOT NULL)
          LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swha1 ON (
            swha1.CLIENT = swi.CLIENT
            AND swha1.WI_ID = swi.WI_ID
            AND swha1.WI_CHCKWI = swi.TOP_WI_ID
            AND swha1.WI_TYPE = 'W'
            AND swha1.WI_RHTEXT IN ('Liberação da requisição de compra')
            AND swha1.WI_STAT = 'COMPLETED'
          )
          LEFT OUTER JOIN SAPABAPERP.SWWWIHEAD swhb1 ON (
            swhb1.CLIENT = swi.CLIENT
            AND swhb1.WI_CHCKWI = swi.TOP_WI_ID
            AND swhb1.WI_TYPE = 'W'
            AND swhb1.WI_TEXT LIKE ('%liberada%')
            AND swhb1.WI_TEXT LIKE ('%ReqC%')
            AND swhb1.WI_TEXT LIKE ('%10068114%')
            --AND swhb1.WI_RHTEXT in ('Liberação reqC foi executada') 
            AND swhb1.WI_STAT = 'READY'
            AND swhb1.WI_CHCKWI = swha1.WI_CHCKWI
            AND (
              (
                swhb1.WI_RH_TASK = 'TS00007986'
                AND swhb1.HANDLE <> '000000000000'
              )
              OR (swhb1.WI_RH_TASK = 'TS00008018')
            )
          )
          LEFT OUTER JOIN SAPABAPERP.USR21 usapv1 ON (
            usapv1.MANDT = swha1.CLIENT
            AND usapv1.BNAME = swha1.WI_AAGENT
          )
          LEFT OUTER JOIN SAPABAPERP.ADRP adp1 ON (
            adp1.CLIENT = usapv1.MANDT
            AND adp1.PERSNUMBER = usapv1.PERSNUMBER
          )
        WHERE
          swi.CLIENT = '300'
          AND swi.INSTID LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
          AND swi.WI_RH_TASK IN ('TS00007986', 'TS00008018')
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
      ) AS aprov ON (aprov.requisicao LIKE '%' || eb.BANFN || '%')
    WHERE
      eb.MANDT = '300'
      --AND eb.BNFPO = '00010'
      AND eb.loekz = ''
      AND eb.BANFN LIKE '%{{$.trigger.headers.pedidoORcontrato}}%'
      --Requisição
    GROUP BY
      td.FRGCT,
      tt.FRGSX,
      eb.FRGST,
      ts.FRGC1,
      adpcria.NAME_TEXT,
      eb.BANFN,
      eb.BNFPO,
      eb.EBELN,
      eb.KONNR,
      tu.FKZTX,
      eb.FRGGR,
      eb.FRGST,
      eb.FRGKZ,
      eb.FRGZU,
      t1.FRGA1,
      t1.FRGA2,
      t1.FRGA3,
      t1.FRGA4,
      t1.FRGA5,
      t1.FRGA6,
      t1.FRGA7,
      t1.FRGA8,
      frgc1.FRGCO,
      frgc1.FRGCT,
      adp1.NAME_TEXT,
      aprov.hora_aprovacao,
      frgc2.FRGCO,
      frgc2.FRGCT,
      aprov.seq_hist,
      aprov.aprovador,
      adp2.NAME_TEXT,
      aprov.data_aprovacao,
      eb.BADAT,
      eb.BSART,
      ek.KOSTL
  )
GROUP BY
  REQUISITANTE,
  REQUISICAO,
  REQ_SUBITEM,
  PEDIDO,
  CONTRATO,
  STATUS_REQUISICAO,
  ESTRATEGIA_APROVACAO,
  codigo,
  estrategia,
  NIVEL_APROVACAO_ATUAL,
  NIVEIS_APROVACAO,
  code_aprovacao,
  area,
  APROVACAO_2,
  dt_criacao,
  tp_requisicao