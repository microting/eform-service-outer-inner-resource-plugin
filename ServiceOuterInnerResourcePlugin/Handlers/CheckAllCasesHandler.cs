using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microting.eForm.Dto;
using Microting.eFormOuterInnerResourceBase.Infrastructure.Data;
using Rebus.Bus;
using Rebus.Handlers;
using ServiceOuterInnerResourcePlugin.Infrastucture.Helpers;
using ServiceOuterInnerResourcePlugin.Messages;

namespace ServiceOuterInnerResourcePlugin.Handlers;

public class CheckAllCasesHandler : IHandleMessages<CheckAllCases>
{
    private readonly eFormCore.Core _sdkCore;
    private readonly OuterInnerResourcePnDbContext _dbContext;
    private readonly IBus _bus;

    public CheckAllCasesHandler(eFormCore.Core sdkCore, DbContextHelper dbContextHelper, IBus bus)
    {
        _dbContext = dbContextHelper.GetDbContext();
        _sdkCore = sdkCore;
        _bus = bus;
    }
        
    public async Task Handle(CheckAllCases message)
    {
        Console.WriteLine("[DBG] CheckAllCasesHandler.Handle: called");

        var timeZone = "Europe/Copenhagen";

        TimeZoneInfo timeZoneInfo;

        try
        {
            timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
        }
        catch
        {
            timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("E. Europe Standard Time");
        }
        List<Case> list = await _sdkCore.CaseReadAll(message.eFormId, null, null, timeZoneInfo).ConfigureAwait(false);
        Console.WriteLine($"[DBG] CheckAllCasesHandler.Handle: CaseReadAll returned number of cases: {list.Count}");

        foreach (Case @case in list)
        {
            WriteLogEntry($"CheckAllCasesHandler.Handle: Dispatching eFormCompleted for @case.MicrotingUId {@case.MicrotingUId} @case.CheckUIid {@case.CheckUIid}");
            if (@case.MicrotingUId != null && @case.CheckUIid != null)
            {
                await _bus.SendLocal(new eFormCompleted((int) @case.MicrotingUId, (int) @case.CheckUIid)).ConfigureAwait(false);
            }
        }
    }

    private void WriteLogEntry(string message)
    {
        var oldColor = Console.ForegroundColor;
        Console.ForegroundColor = ConsoleColor.Gray;
        Console.WriteLine("[DBG] " + message);
        Console.ForegroundColor = oldColor;
    }
}