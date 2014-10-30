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
            createOrderTimer = new System.Timers.Timer();
            createOrderTimer.Elapsed += new System.Timers.ElapsedEventHandler(GetMail);
            createOrderTimer.Interval = TimerInterval;
            createOrderTimer.Enabled = true;
            createOrderTimer.AutoReset = true;
            createOrderTimer.Start(); 
        }

        protected override void OnStop()
        {
            DumpContentToFile(LogFilePath, string.Format("Service stopped at {0}", DateTime.Now));
        }

        public void GetMail(object sender, System.Timers.ElapsedEventArgs args)
        {
            DumpContentToFile(LogFilePath, DateTime.Now.ToString(CultureInfo.InvariantCulture));
            return;
            //NetworkCredential cred = new NetworkCredential("admin@cyberminds.co.uk", "steelpan60");
            //MailMessage msg = new MailMessage();
            //msg.To.Add("joe_bolla@yahoo.com");
            //msg.Subject = "Welcome To the test service";

            //msg.Body = "You Have Successfully Entered to Cyberminds's World!!!";
            //msg.From = new MailAddress("admin@cyberminds.co.uk"); // Your Email Id
            //SmtpClient client = new SmtpClient("mail.cyberminds.co.uk");
            ////SmtpClient client1 = new SmtpClient("smtp.mail.yahoo.com", 465);
            //client.Credentials = cred;
            //client.EnableSsl = true;
            //client.Send(msg);
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
