using System;
using System.Collections.Generic;
using System.ComponentModel;
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
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            //call proc to prepare the reminders
            Dictionary<string, string> errors = (new ReminderProcessor()).ProcessAllEvents();

            if (errors == null || errors.Keys.Count < 1)
                return;

            string currentFilePath = string.Format(ReminderProcessor.logFile, DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year);

            using (StreamWriter sw = File.AppendText(currentFilePath))
            {
                foreach (string key in errors.Keys)
                {                
                     sw.WriteLine(errors[key]);                
                }
            }

        }

        protected override void OnStop()
        {
        }
    }
}
