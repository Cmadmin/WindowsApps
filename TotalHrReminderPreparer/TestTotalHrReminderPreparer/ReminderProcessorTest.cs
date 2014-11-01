using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.IO;
using TotalHrReminderPreparer;

namespace TestTotalHrReminderPreparer
{
    [TestClass]
    public class ReminderProcessorTest
    {
        [TestMethod]
        public void TestProcessAllEvents()
        {
            Dictionary<string, string> errors = (new ReminderProcessor()).ProcessAllEvents();

            if (errors == null || errors.Keys.Count < 1)
                return;
           
            using (StreamWriter sw = File.AppendText(ReminderProcessor.logFile))
            {
                foreach (string key in errors.Keys)
                {
                    sw.WriteLine(DateTime.Now.ToString() + " - " + key + ": " + errors[key]  );
                }
            }
        }
    }
}
