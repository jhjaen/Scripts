SELECT y.ordem
     , y.tipo_ordem
     , y.texto_breve
     , y.empresa
     , y.centro_custo
     , y.moeda
     , y.valor_total
     , y.realizado
     , y.requerente
     , y.objeto
     , y.data_entrada
     , y.liberacao
     , y.liberada
     , CASE WHEN y.realizado IS NULL THEN y.valor_total
       ELSE y.saldo END AS SALDO
FROM 
(SELECT
  x.*,
  (
    SELECT
      SUM(ba.WTJHR)
    FROM
      SAPABAPERP.COAS cs
      INNER JOIN SAPABAPERP.BPJA ba ON (
        ba.MANDT = cs.MANDT
        AND ba.OBJNR = cs.OBJNR
      )
    WHERE
      cs.AUFNR like '%{{$.trigger.headers.pedidoORcontrato}}'
      AND BA.WTJHR <> 0
      and ba.WRTTP = '41'
  ) - (
    SELECT
      SUM(ba.WTJHR)
    FROM
      SAPABAPERP.COAS cs
      INNER JOIN SAPABAPERP.BPJA ba ON (
        ba.MANDT = cs.MANDT
        AND ba.OBJNR = cs.OBJNR
      )
    WHERE
      cs.AUFNR like '%{{$.trigger.headers.pedidoORcontrato}}'
      AND BA.WTJHR <> 0
      and ba.WRTTP = '42'
  ) AS SALDO
FROM
  (
    SELECT
      cs.AUFNR AS ORDEM,
      cs.AUART AS TIPO_ORDEM,
      cs.KTEXT AS TEXTO_BREVE,
      cs.BUKRS AS EMPRESA,
      cs.KOSTV AS CENTRO_CUSTO,
      cs.WAERS AS MOEDA,
      --	be.WTGES 
      (
        SELECT
          SUM(ba.WTJHR)
        FROM
          SAPABAPERP.COAS cs
          INNER JOIN SAPABAPERP.BPJA ba ON (
            ba.MANDT = cs.MANDT
            AND ba.OBJNR = cs.OBJNR
          )
        WHERE
          cs.AUFNR like '%{{$.trigger.headers.pedidoORcontrato}}'
          AND BA.WTJHR <> 0
          and ba.WRTTP = '41'
      ) AS VALOR_TOTAL,
      --ba.WTJHR 
      (
        SELECT
          SUM(ba.WTJHR)
        FROM
          SAPABAPERP.COAS cs
          INNER JOIN SAPABAPERP.BPJA ba ON (
            ba.MANDT = cs.MANDT
            AND ba.OBJNR = cs.OBJNR
          )
        WHERE
          cs.AUFNR like '%{{$.trigger.headers.pedidoORcontrato}}'
          AND BA.WTJHR <> 0
          and ba.WRTTP = '42'
      ) AS REALIZADO,
      cs.USER0 AS REQUERENTE,
      cs.OBJNR AS OBJETO,
      cs.ERDAT AS DATA_ENTRADA,
      cs.IDAT1 AS LIBERACAO,
      cs.PHAS1 AS LIBERADA
    FROM
      SAPABAPERP.COAS cs
      INNER JOIN SAPABAPERP.BPJA ba ON (
        ba.MANDT = cs.MANDT
        AND ba.OBJNR = cs.OBJNR
        AND ba.VORGA IN ('KBFC','KBUD')
      )
      INNER JOIN SAPABAPERP.BPGE be ON (
        be.MANDT = cs.MANDT
        AND be.OBJNR = cs.OBJNR
      )
    WHERE
      cs.AUFNR like '%{{$.trigger.headers.pedidoORcontrato}}'
      AND BA.WTJHR <> 0
  ) x
GROUP BY
  ORDEM,
  TIPO_ORDEM,
  TEXTO_BREVE,
  EMPRESA,
  CENTRO_CUSTO,
  MOEDA,
  VALOR_TOTAL,
  REALIZADO,
  REQUERENTE,
  OBJETO,
  DATA_ENTRADA,
  LIBERACAO,
  LIBERADA) y