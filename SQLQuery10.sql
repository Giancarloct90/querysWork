/****** Script for SelectTopNRows command from SSMS  ******/

/************************ Storaged Procedure TO KNOW SUELDO y DEDUC ************/
CREATE PROCEDURE getSalary
  @nombre nvarchar(30),
  @apellido nvarchar(30)
AS
SELECT DISTINCT No_Empleado AS "ID Empleado", Nombre_Empleado AS "Nombre", Sueldo_Periodo AS "Sueldo", Deducciones AS "Deducciones"
FROM PLEMH.dbo.RH_Empleado, PLEMH.dbo.tmp_mov_emp
WHERE Nombre_Empleado LIKE '%' +@nombre+ '%'
  AND PLEMH.dbo.RH_Empleado.No_Empleado = PLEMH.dbo.tmp_mov_emp.Cod_Emp

DROP PROCEDURE getSalary
exec getSalary @nombre = "GIANCARLO", @apellido = "CARCAMO"
/*********************************************************************/

/*****************SUELDO TOTAL CON EMPLEADO TOTAL********************/
SELECT COUNT(No_Empleado), SUM(Sueldo_Periodo) AS TOTAL

FROM RH_Empleado
WHERE Activo = 1 AND
  Nombramiento = 'C'
/********************************************************************/

/*********************SUELDO CON DEDUCCIONES**********************/
SELECT DISTINCT [Cod_Emp]
      , [Nombre]
      , [Deducciones]
	  , RH_Empleado.Sueldo_Periodo
	  , RH_Empleado.Sueldo_Periodo-Deducciones AS 'SUELDO NETO'
FROM [PLEMH].[dbo].[tmp_mov_emp], RH_Empleado
WHERE Nombre LIKE '%Jack%' AND
  Nombre LIKE '%Daniels%'
  AND RH_Empleado.No_Empleado = tmp_mov_emp.Cod_Emp
/*****************************************************************/

/*******************************************************************/

/**************************** SUELDO TOTAL POR RAMA ****************/

SELECT *
FROM RH_Empleado

SELECT COUNT(No_Empleado) AS 'Total Emplado', SUM(Sueldo_Periodo) AS 'Total Dinero'
FROM RH_Empleado
WHERE Activo = 1
  AND RAMA = 'A'
/*******************************************************************/

/************************ STORAGED PROCEDURE TO VIEW  **************/
CREATE PROCEDURE getTotalEmpleados
AS
SELECT No_Empleado, Nombre_Empleado
FROM RH_Empleado
WHERE Activo = 1

DROP PROCEDURE getTotalEmpleados
EXECUTE getTotalEmpleados

/*********** get toatles aux o ofic o subofi ***************************/
CREATE PROCEDURE getTotalAOS
  @nombramiento nvarchar(30)
AS
SELECT COUNT(No_Empleado) AS "total"
FROM RH_Empleado
WHERE Activo = 1
  AND Nombramiento = @nombramiento

DROP PROCEDURE getTotalAOS
EXECUTE getTotalAOS @nombramiento = 'C'
/*********************************/

/* Oficiales que recibe tipo de nombramiento y rama */
CREATE PROCEDURE getOfiSubNomRam
  @nombramiento nvarchar(30),
  @rama nvarchar(30)
AS
SELECT COUNT(No_Empleado) AS "total"
FROM RH_Empleado
WHERE Nombramiento = @nombramiento
  AND Rama = @rama
  AND Activo = 1

DROP PROCEDURE getOfiSubNomRam
EXECUTE getOfiSubNomRam @nombramiento = 'A', @rama = 'E'


/*******************************************************************/


/********************* FIND A AUXILIAR *********************/
SELECT No_Empleado, Nombre_Empleado, Nombramiento, Rama, Cod_Depto, Cod_Puesto, Cod_Unidad
FROM RH_Empleado
WHERE Nombre_Empleado LIKE '%CARLOS%'
  AND Nombre_Empleado LIKE '%MIRANDA%'
  AND Activo = 1
/**************************************************************************/

/************************SABER OFICIALES DE LAS FUERZAS*********/
SELECT COUNT(No_Empleado) AS "OFICIALES NAVALES"
FROM RH_Empleado
WHERE Activo = 1
  AND Nombramiento = 'A'
  AND Rama = 'A'
/**************************************************************/

/**********************************************/
SELECT COUNT(No_Empleado)
FROM RH_Empleado
WHERE Activo = 1
  AND Nombramiento = 'C'
  AND Rama = 'N'
/**************************************************************/

SELECT No_Empleado, Nombre_Empleado
FROM RH_Empleado
WHERE Activo = 1


/************************** Detalles de deducciones ************************************/
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT FORMAT(Fecha, 'MMMM', 'es-es') AS MES, Valor_Pago AS "Decuccion Mes"
FROM [PLEMH].[dbo].[pl_detplani]
WHERE No_Empleado = '36385'
  /*AND  MONTH(Fecha) = '11'*/
  AND YEAR(Fecha) = '2019'
  AND Cod_Pago = 38
ORDER BY MONTH(Fecha)

/***************************************************************************************/

/*********************** Decuciones ********************************/
/** Dont Touch **/
DECLARE @Cod_Emp nvarchar(30)
SET @Cod_Emp = '38521'
SELECT pl_detplani.No_Empleado AS "CODIGO"
, RH_Empleado.Nombre_Empleado AS "Nombre" 
, Valor_Pago AS "Deduccion", pl_Pagded.Nombre AS "Nombre"
FROM pl_detplani, pl_Pagded, RH_Empleado
WHERE pl_detplani.No_Empleado = @Cod_Emp
  AND YEAR(Fecha) = '2019'
  AND MONTH(Fecha) = '11'
  AND pl_detplani.Cod_Pago = pl_Pagded.Codigo
  AND RH_Empleado.No_Empleado = pl_detplani.No_Empleado

SELECT SUM(Valor_Pago) AS "Total Deducciones"
FROM pl_detplani
WHERE No_Empleado = @Cod_Emp
  AND YEAR(Fecha) = '2019'
  AND MONTH(Fecha) = '11'

/**********************************************************************/

/************************ Storaged Procedure ***********************************************/
/**Dont Touch*/
CREATE PROCEDURE getEmplDeduc
  @cod_emp nvarchar(30)
AS
SELECT pl_detplani.No_Empleado AS "Codigo", Nombre_Empleado AS "Nombre"
  , Valor_Pago AS "deduccionNombre", pl_Pagded.Nombre AS "deduccionPago"
  , Sueldo_Periodo AS "sueldoNominal", (SELECT SUM(Valor_Pago) AS "totalDeducciones"
  FROM pl_detplani
  WHERE pl_detplani.No_Empleado = '37389' AND MONTH(Fecha) = 11
    AND YEAR(Fecha) = 2019), (sueldoNominal - totalDeducciones)
FROM RH_Empleado, pl_detplani, pl_Pagded
WHERE RH_Empleado.No_Empleado = pl_detplani.No_Empleado
  AND pl_detplani.Cod_Pago = pl_Pagded.Codigo
  AND RH_Empleado.No_Empleado = '37389'
  AND MONTH(Fecha) = 11
  AND YEAR(Fecha) = 2019

DROP PROCEDURE getEmplDeduc
/******************************************************************/

SELECT pl_detplani.No_Empleado

SELECT *
FROM pl_detplani

/****************************** dont  ******************************************/
WHERE No_Empleado = '37389'


/******************************** THE LAST QUERY  ***************************/
CREATE PROCEDURE getReporteEmpleado
AS
SELECT
  (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'A'
    AND Rama = 'E' ) AS "totalOE"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'A'
    AND Rama = 'A') AS "totalOA"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'A'
    AND Rama = 'N') AS "totalON"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'B'
    AND Rama = 'E') AS "totalSUBE"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = '1'
    AND Nombramiento = 'B'
    AND Rama = 'A') AS "totalSUBA"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'B'
    AND Rama = 'N') AS "totalSUBN"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'C') AS "totalAUX"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = '1'
    AND Nombramiento = 'A') AS "totalO"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'B') AS "totalSUB"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'P') AS "totalCON"
  , (SELECT COUNT(No_Empleado)
  FROM RH_Empleado
  WHERE Activo = 1) AS "totalEMP"

DROP PROCEDURE getReporteEmpleado

EXECUTE getReporteEmpleado
/****************************************************************************/


/******************************************/
/** Constancia DONT TOUCH **/
CREATE PROCEDURE getConstancia
  @codigo nvarchar(30)
AS
SELECT DISTINCT tmp_mov_emp.Cod_Emp AS "codigo"
  , RH_Empleado.Nombre_Empleado AS "nombreEmpleado"
  , FORMAT(RH_Empleado.Sueldo_Periodo, 'N2') AS "sueldoNominal"
  , FORMAT(tmp_mov_emp.Deducciones, 'N2') AS "totalDeducciones"
  , FORMAT(RH_Empleado.Sueldo_Periodo - tmp_mov_emp.Deducciones, 'N2') AS "totalSueldoNeto"
  , DAY(GETDATE()) AS "dia"
  , FORMAT(GETDATE(),'MMMM', 'es-es') AS "mes"
  , FORMAT(GETDATE(), 'yyyy') AS "anio"
  , FORMAT(Fecha_Ingreso, 'dd De MMMM Del yyyy', 'es-es') AS "fechaIngreso"
  , DATEDIFF(YEAR, Fecha_Ingreso, GETDATE()) AS "antiguedad"
  , RH_Puestos.Descripcion_Puesto as "puesto"
  , RH_Deptos.Desc_Depto AS "asignado"
  , [dbo].[CantidadConLetra](RH_Empleado.Sueldo_Periodo) AS "salarioLetras"
FROM RH_Empleado, tmp_mov_emp, RH_Puestos, RH_Deptos
WHERE tmp_mov_emp.Cod_Emp = @codigo
  AND RH_Deptos.Cod_Depto = RH_Empleado.Cod_Depto
  AND RH_Deptos.Cod_Unidad = RH_Empleado.Cod_Unidad
  AND RH_Puestos.Cod_Puesto = RH_Empleado.Cod_Puesto
  AND tmp_mov_emp.Cod_Emp = RH_Empleado.No_Empleado

DROP PROCEDURE getConstancia

EXECUTE getConstancia '37389'


/*********** Para saber la edad del cliente **************/
/** Dont touch */
SELECT No_Empleado, Nombre_Empleado, DATEDIFF(YEAR, Fecha_Nacimiento ,GETDATE()) AS "Edad", Fecha_Nacimiento
FROM RH_Empleado
WHERE No_Empleado = '37389'
/***********************************/

SELECT No_Empleado, Fecha_Ingreso
FROM RH_Empleado
WHERE Activo = 1

SELECT GETDATE()

SELECT *
FROM RH_Empleado
WHERE No_Empleado = '27485'


/***************************************************************/
/* Total Sueldo pagado */
/*dont touch*/
SELECT (SELECT FORMAT(SUM(Sueldo_Periodo) , 'C', 'hn-HN')
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'A') AS "Total Pagado Oficiales"
, (SELECT FORMAT(SUM(Sueldo_Periodo) , 'C', 'hn-HN')
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'B') AS "Total Pagado SubOficiales"
, (SELECT FORMAT(SUM(Sueldo_Periodo) , 'C', 'hn-HN')
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'C') AS "Total Pagado Auxiliares"
, (SELECT FORMAT(SUM(Sueldo_Periodo) , 'C', 'hn-HN')
  FROM RH_Empleado
  WHERE Activo = 1
    AND Nombramiento = 'P') AS "Total Pagado Contratos"
, (SELECT FORMAT(SUM(Sueldo_Periodo) , 'C', 'hn-HN')
  FROM RH_Empleado
  WHERE Activo = 1 ) AS "Total Pagado"

/********/

/************** getDeduciones **********************/

/*** dont touch please ***/
CREATE PROCEDURE getDeduciones
  @codigo nvarchar(30),
  @mes nvarchar(30),
  @anio nvarchar(30)
AS
SELECT No_Empleado AS "codigo"
 , Nombre AS "nombreDeduc"
 , FORMAT(Valor_Pago,  'N2') AS "monto"
FROM pl_detplani, pl_Pagded
WHERE No_Empleado = @codigo
  AND pl_detplani.Cod_Pago = pl_Pagded.Codigo
  AND MONTH(Fecha) = @mes
  AND YEAR(Fecha) = @anio
GO

DROP PROCEDURE getDeduciones

EXECUTE getDeduciones '5353', '11', 2019
/*******************************************************/

/**********************************************************/

/********** para saber quien es el mas antiguo  ****************/
/*** dont touch ***/
SELECT No_Empleado, Nombre_Empleado, MAX(DATEDIFF(YEAR, Fecha_Ingreso, GETDATE())) AS "antiguedad"
FROM RH_Empleado
WHERE Activo = 1
GROUP BY No_Empleado, Nombre_Empleado
ORDER BY MAX(DATEDIFF(YEAR, Fecha_Ingreso, GETDATE())) DESC
/***********************************************************************/

/*** Who gain more ******/

SELECT No_Empleado AS "Codigo", Nombre_Empleado AS "Nombre", MAX(Sueldo_Periodo) AS "Sueldo"
FROM RH_Empleado
WHERE Activo = 1
GROUP BY No_Empleado, Nombre_Empleado
ORDER BY  MAX(Sueldo_Periodo) DESC
/******************************************************/

/************************ QUERY HOSPITAL MILITAR  ****************************************/
/*dont touch*/
SELECT No_Empleado AS "Codigo" 
 , Nombre_Empleado AS "Nombre"
 , FORMAT(Sueldo_Periodo, 'C', 'hn-HN') AS "Sueldo"
 , No_Identidad AS "No. Identidad"
 , No_Cta_Banco AS "No. Cuenta"
 , FORMAT(Fecha_Ingreso, 'dd MMMM yyyy', 'es-es') AS "Fecha Ingreso"
 , MAX(DATEDIFF(YEAR, Fecha_Ingreso, GETDATE())) AS "antiguedad"
 , RH_Puestos.Descripcion_Puesto AS "Puesto"
FROM RH_Empleado, RH_Puestos
WHERE Cod_Unidad = 'HM01'
  AND Activo  = 1
  AND RH_Puestos.Cod_Puesto = RH_Empleado.Cod_Puesto
GROUP BY No_Empleado, Nombre_Empleado, No_Cta_Banco, Fecha_Ingreso, No_Identidad, Sueldo_Periodo, RH_Puestos.Descripcion_Puesto
ORDER BY MAX(DATEDIFF(YEAR, Fecha_Ingreso, GETDATE())) DESC
/******************************************************************************/

/*********************************************************************************/
SELECT No_Empleado, Nombre_Empleado
FROM RH_Empleado
WHERE Activo = 0
  AND Nombre_Empleado LIKE '%MARVIN%'
  AND Nombre_Empleado LIKE '%SANCHEZ%'
/**********************************************************************************/

SELECT No_Empleado, Nombre_Empleado, RH_Puestos.Descripcion_Puesto
FROM RH_Empleado, RH_Puestos
WHERE No_Empleado = '37389'
  AND RH_Puestos.Cod_Puesto = RH_Empleado.Cod_Puesto
/************************************************************************************/

/**************************************************************************************/

SELECT No_Empleado AS "Codigo"
, Nombre_Empleado AS "Nombre"
FROM RH_Empleado, pl_Grados
WHERE No_Empleado = '17324'
  AND RH_Empleado.Grado = pl_Grados.Cod_Grado


SELECT TOP 1000
  [Nombramiento]
      , [Cod_Grado]
      , [Desc_Grado]
      , [Antiguedad]
FROM [PLEMH].[dbo].[pl_Grados]


/****************************************************************/
/*IPM SO IMPORTANT*/
SELECT No_Empleado
  , Nombre_Empleado
  , No_Identidad
  , Fecha_Ingreso
  , Sueldo_Periodo
  , pl_Grados.Desc_Grado
  , DATEDIFF(YEAR, Fecha_Ingreso ,GETDATE()) AS "Antiguedad"
FROM RH_Empleado, pl_Grados
WHERE Activo = 1
  AND pl_Grados.Nombramiento = RH_Empleado.Nombramiento
  AND pl_Grados.Cod_Grado = RH_Empleado.Grado
  AND RH_Empleado.Nombramiento  = 'B'
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-02-21' AS date)
ORDER BY Fecha_Ingreso ASC


SELECT No_Empleado
  , Nombre_Empleado
  , No_Identidad
  , Fecha_Ingreso
  , Sueldo_Periodo
  , pl_Grados.Desc_Grado
FROM RH_Empleado, pl_Grados
WHERE Activo = 1
  AND pl_Grados.Nombramiento = RH_Empleado.Nombramiento
  AND RH_Empleado.Nombramiento  = 'C'
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-02-21' AS date)
ORDER BY Fecha_Ingreso ASC

SELECT No_Empleado
  , Nombre_Empleado
  , No_Identidad
  , Fecha_Ingreso
  , Sueldo_Periodo
FROM RH_Empleado
WHERE Activo = 1
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-02-21' AS date)

SELECT No_Empleado
  , Nombre_Empleado
  , No_Identidad
  , Fecha_Ingreso
  , Sueldo_Periodo
FROM RH_Empleado
WHERE Activo = 1
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-03-31' AS date)

SELECT COUNT(No_Empleado) AS "Cantidad hasta el 2007 marzo 31"
FROM RH_Empleado
WHERE Activo = 1
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-03-31' AS date)

SELECT COUNT(No_Empleado) AS "Cantidad hasta el 2007 febrero 21"
FROM RH_Empleado
WHERE Activo = 1
  AND CAST(Fecha_Ingreso AS date) <= CAST('2007-02-21' AS date)


SELECT *
FROM RH_Empleado
WHERE Nombre_Empleado LIKE '%JAVIER%'
  AND Activo = 1
  AND Nombramiento = 'P'