using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace GenEmailingService
{
    public partial class Service1 : ServiceBase
    {
        System.Timers.Timer createOrderTimer;

        public Service1()
        {
            InitializeComponent();
        }

        public string LogFilePath
        {
            get { return System.IO.Path.GetFullPath(ConfigurationManager.AppSettings["logfile"].ToString()); }
        }

        public int TimerInterval
        {
            get { return Convert.ToInt32(ConfigurationManager.AppSettings["TimerInterval"]); }
        }

        protected override void OnStart(string[] args)
        {
            /** do this in sql server, it will be more efficient */
            createOrderTimer = new System.Timers.Timer();
            createOrderTimer.Elapsed += new System.Timers.ElapsedEventHandler(Process);
            createOrderTimer.Interval = TimerInterval;
            createOrderTimer.Enabled = true;
            createOrderTimer.AutoReset = true;
            createOrderTimer.Start(); 
        }

        private void Process(object sender, System.Timers.ElapsedEventArgs args)
        {
            SheduledEmailProcessor processor = new SheduledEmailProcessor();
            processor.ProcessAllScheduledEmails();
        }

        protected override void OnStop()
        {
            DumpContentToFile(LogFilePath, string.Format("Service stopped at {0}", DateTime.Now));
        }       

        public void DumpContentToFile(string fileName, string content)
        {
            using (var file = new System.IO.StreamWriter(fileName))
            {
                file.WriteLine(content);
            }
        }
    }
}
