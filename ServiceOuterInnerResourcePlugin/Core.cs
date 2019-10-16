/*
The MIT License (MIT)
Copyright (c) 2007 - 2019 Microting A/S
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

using System;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using Castle.MicroKernel.Registration;
using Castle.Windsor;
using Microsoft.EntityFrameworkCore;
using Microting.eForm.Dto;
using Microting.eFormMachineAreaBase.Infrastructure.Data;
using Microting.eFormMachineAreaBase.Infrastructure.Data.Factories;
using Microting.WindowsService.BasePn;
using Rebus.Bus;
using ServiceOuterInnerResourcePlugin.Installers;
using ServiceOuterInnerResourcePlugin.Messages;

namespace ServiceOuterInnerResourcePlugin
{
    [Export(typeof(ISdkEventHandler))]
    public class Core : ISdkEventHandler
    {
        #region var
        private Tools t = new Tools();
        private eFormCore.Core _sdkCore;
        private IWindsorContainer _container;
        public IBus _bus;
        private bool _coreThreadRunning = false;
        private bool _coreStatChanging = false;
        private bool _coreAvailable = false;
        private string _serviceLocation;
        private int _maxParallelism = 1;
        private int _numberOfWorkers = 1;
        private MachineAreaPnDbContext _dbContext;
        #endregion
        
        public void CoreEventException(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void UnitActivated(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void eFormProcessed(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void eFormProcessingError(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void eFormRetrived(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void CaseCompleted(object sender, EventArgs args)
        {
            Case_Dto trigger = (Case_Dto)sender;

            int? caseId = trigger.MicrotingUId;
            int? checkId = trigger.CheckUId;
            if (checkId != null && caseId != null) {
                _bus.SendLocal(new eFormCompleted((int) caseId, (int) checkId));
            }
        }

        public void CaseDeleted(object sender, EventArgs args)
        {
            // Do nothing
        }

        public void NotificationNotFound(object sender, EventArgs args)
        {
            // Do nothing
        }

        public bool Start(string sdkConnectionString, string serviceLocation)
        {
            Console.WriteLine("ServiceOuterInnerResourcePlugin start called");
            try
            {
                string dbNameSection;
                string dbPrefix;
                if (sdkConnectionString.ToLower().Contains("convert zero datetime"))
                {
                    dbNameSection = Regex.Match(sdkConnectionString, @"(Database=\w*;)").Groups[0].Value;
                    dbPrefix = Regex.Match(sdkConnectionString, @"Database=(\d*)_").Groups[1].Value;
                } else
                {
                    dbNameSection = Regex.Match(sdkConnectionString, @"(Initial Catalog=\w*;)").Groups[0].Value;
                    dbPrefix = Regex.Match(sdkConnectionString, @"Initial Catalog=(\d*)_").Groups[1].Value;
                }
                
                
                string pluginDbName = $"Initial Catalog={dbPrefix}_eform-angular-outer-inner-resource-plugin;";
                string connectionString = sdkConnectionString.Replace(dbNameSection, pluginDbName);


                if (!_coreAvailable && !_coreStatChanging)
                {
                    _serviceLocation = serviceLocation;
                    _coreStatChanging = true;
                    
                    if (string.IsNullOrEmpty(_serviceLocation))
                        throw new ArgumentException("serviceLocation is not allowed to be null or empty");

                    if (string.IsNullOrEmpty(connectionString))
                        throw new ArgumentException("serverConnectionString is not allowed to be null or empty");

                    MachineAreaPnContextFactory contextFactory = new MachineAreaPnContextFactory();

                    _dbContext = contextFactory.CreateDbContext(new[] { connectionString });
                    _dbContext.Database.Migrate();

                    _coreAvailable = true;
                    _coreStatChanging = false;

                    startSdkCoreSqlOnly(sdkConnectionString);
                    
                    string temp = _dbContext.PluginConfigurationValues
                        .SingleOrDefault(x => x.Name == "OuterInnerResourceSettings:MaxParallelism")?.Value;
                    _maxParallelism = string.IsNullOrEmpty(temp) ? 1 : int.Parse(temp);

                    temp = _dbContext.PluginConfigurationValues
                        .SingleOrDefault(x => x.Name == "OuterInnerResourceSettings:NumberOfWorkers")?.Value;
                    _numberOfWorkers = string.IsNullOrEmpty(temp) ? 1 : int.Parse(temp);

                    _container = new WindsorContainer();
                    _container.Register(Component.For<MachineAreaPnDbContext>().Instance(_dbContext));
                    _container.Register(Component.For<eFormCore.Core>().Instance(_sdkCore));
                    _container.Install(
                        new RebusHandlerInstaller()
                        , new RebusInstaller(connectionString, _maxParallelism, _numberOfWorkers)
                    );

                    _bus = _container.Resolve<IBus>();
                    
                    temp = _dbContext.PluginConfigurationValues
                        .SingleOrDefault(x => x.Name == "OuterInnerResourceSettings:ShouldCheckAllCases")?.Value;
                    
                    Console.WriteLine("[DBG] ServiceOuterInnerResourcePlugin.Start: ShouldCheckAllCases set to: " + temp);

                    if (temp.ToLower() == "true")
                    {
                        temp = _dbContext.PluginConfigurationValues
                            .SingleOrDefault(x => x.Name == "OuterInnerResourceSettings:SdkeFormId")?.Value;
                        
                        Console.WriteLine("[DBG] ServiceOuterInnerResourcePlugin.Start: SdkeFormId set to: " + temp);
                        _bus.SendLocal(new CheckAllCases(int.Parse(temp)));
                    }
                }
                Console.WriteLine("ServiceOuterInnerResourcePlugin started");
                return true;
            }
            catch(Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.DarkRed;
                Console.WriteLine("[ERR] ServiceOuterInnerResourcePlugin.Start: Start failed " + ex.Message);
                throw ex;
            }
        }

        public bool Stop(bool shutdownReallyFast)
        {
            try
            {
                if (_coreAvailable && !_coreStatChanging)
                {
                    _coreStatChanging = true;

                    _coreAvailable = false;

                    int tries = 0;
                    while (_coreThreadRunning)
                    {
                        Thread.Sleep(100);
                        _bus.Dispose();
                        tries++;
                    }
                    _sdkCore.Close();

                    _coreStatChanging = false;
                }
            }
            catch (ThreadAbortException)
            {
                //"Even if you handle it, it will be automatically re-thrown by the CLR at the end of the try/catch/finally."
                Thread.ResetAbort(); //This ends the re-throwning
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }

        public bool Restart(int sameExceptionCount, int sameExceptionCountMax, bool shutdownReallyFast)
        {
            return true;
        }
        
        public void startSdkCoreSqlOnly(string sdkConnectionString)
        {
            _sdkCore = new eFormCore.Core();

            _sdkCore.StartSqlOnly(sdkConnectionString);
        }
    }
}