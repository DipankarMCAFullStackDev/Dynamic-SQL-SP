USE [Database1]
GO
/****** Object:  StoredProcedure [dbo].[retdata2]    Script Date: 27-03-2023 22:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[retdata2] (@frmdate varchar(50),@todate varchar(50)) As 

begin

 Declare @Ssql nvarchar(4000) 
 Declare @Ssql2 nvarchar(4000)
 Declare @frmdate2 varchar(50)
 Declare @todate2 varchar(50)
 Declare @Mname varchar(max)
 
 set @frmdate2=@frmdate
 set @todate2=@todate

Declare @output varchar(max)
set @output = ''
SET @Ssql2 = '(SELECT @output=STRING_AGG(DATENAME(MONTH, DATEADD(MONTH, x.number, ''' + convert(varchar(10), @frmdate2, 120) + ''')),''' + ',' + ''')
FROM    master.dbo.spt_values x
WHERE   x.type = ''' + 'P' + '''        
AND     x.number <= DATEDIFF(MONTH, ''' + convert(varchar(10), @frmdate2, 120) + ''', ''' + convert(varchar(10), @todate2, 120) + '''))'
Execute sp_executesql @Ssql2, N'@output varchar(max) output', @output = @output OUTPUT
--select @output As ReturnedName

set @Mname=@output
print @Mname

--Set @Ssql='select SUM(t1.Amount) As SalAmount,s1.Salary_Comp_Code As SalCompCode, s1.Salary_Comp_Name As Component,t1.Salary_Month As SalMonth,t1.Salary_Year As SalYear from mstSalaryComponent s1, trnPayout t1 where s1.Salary_Comp_Code=t1.Salary_Comp_Code and t1.Salary_Date between ''' + convert(varchar(10), @frmdate2, 120) + ''' and ''' + convert(varchar(10), @todate2, 120) + ''' group by s1.Salary_Comp_Code, s1.Salary_Comp_Name,t1.Salary_Month, t1.Salary_Year order by t1.Salary_Year,t1.Salary_Month'
 Set @Ssql='select Component, ' + @Mname + ' from (select s1.Salary_Comp_Name As Component,
Max(case when t1.Salary_Month=1 then t1.Amount end) as January,
Max(case when t1.Salary_Month=2 then t1.Amount end) as February,
Max(case when t1.Salary_Month=3 then t1.Amount end) as March,
Max(case when t1.Salary_Month=4 then t1.Amount end)  as April,
Max(case when t1.Salary_Month=5 then t1.Amount end) as May,
Max(case when t1.Salary_Month=6 then t1.Amount end) as June,
Max(case when t1.Salary_Month=7 then t1.Amount end) as July,
Max(case when t1.Salary_Month=8 then t1.Amount end) as August,
Max(case when t1.Salary_Month=9 then t1.Amount end) as September,
Max(case when t1.Salary_Month=10 then t1.Amount end) as October,
Max(case when t1.Salary_Month=11 then t1.Amount end)  as November,
Max(case when t1.Salary_Month=12 then t1.Amount end) as December,
s1.Salary_Comp_Code As SalCompCode from mstSalaryComponent s1, trnPayout t1
where
s1.Salary_Comp_Code=t1.Salary_Comp_Code 
and t1.Salary_Date between ''' + convert(varchar(10), @frmdate2, 120) + ''' and ''' + convert(varchar(10), @todate2, 120) + '''
group by s1.Salary_Comp_Code, s1.Salary_Comp_Name) As Tb1 '


 Execute sp_executesql @Ssql, N'@frmdate2 varchar(50)',N'@todate2 varchar(50)'

end