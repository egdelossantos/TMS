CREATE PROCEDURE dbo.GetMapActivityDetail
	@dateFrom date = null,
	@dateTo date = null
AS
BEGIN
	if (@dateFrom is null)
	begin
		select @dateFrom = '1900-01-01'
	end

	if (@dateTo is null)
	begin
		select @dateTo = '2999-12-31'
	end

	SELECT ca.Id, ca.CallGroupId, cg.CallGroupName, cg.GroupCode, p.Name, ca.DateReleased, ca.DateReturned, ct.CallTypeName, cy.CycleName
	FROM CallActivity ca
		INNER JOIN CallGroup cg ON ca.CallGroupId = cg.Id
		INNER JOIN Publisher p ON ca.ReleasedToPublisherId = p.Id
		INNER JOIN CallType ct ON ca.CallTypeId = ct.Id
		LEFT JOIN Cycle cy ON ca.CycleId = cy.Id
	WHERE CAST(ca.DateReleased AS DATE) BETWEEN @dateFrom AND @dateTo
END
GO
