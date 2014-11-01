using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace TotalHrReminderPreparer
{
    public partial class Service1 : ServiceBase
    {
        System.Timers.Timer createOrderTimer;

        public int TimerInterval
        {
            get { return Convert.ToInt32(ConfigurationManager.AppSettings["TimerInterval"]); }
        }

        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            createOrderTimer = new System.Timers.Timer();
            createOrderTimer.Elapsed += new System.Timers.ElapsedEventHandler(PrepareData);
            createOrderTimer.Interval = TimerInterval;
            createOrderTimer.Enabled = true;
            createOrderTimer.AutoReset = true;
            createOrderTimer.Start();
        }

        public void PrepareData(object sender, System.Timers.ElapsedEventArgs args)
        {
            
            Dictionary<string, string> errors = (new ReminderProcessor()).ProcessAllEvents();

            if (errors == null || errors.Keys.Count < 1)
                return;

            
            using (StreamWriter sw = File.AppendText(ReminderProcessor.logFile))
            {
                foreach (string key in errors.Keys)
                {
                    sw.WriteLine(DateTime.Now.ToString() + " - " + key + ": " + errors[key]);
                }
            }

        }

        protected override void OnStop()
        {
            Utils.DumpContentToFile(ReminderProcessor.logFile, string.Format("Service stopped at {0}", DateTime.Now));
        }
    }
}
