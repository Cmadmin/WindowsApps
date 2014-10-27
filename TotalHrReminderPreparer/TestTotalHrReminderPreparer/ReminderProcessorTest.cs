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

            string currentFilePath = string.Format(ReminderProcessor.logFile, DateTime.Now.Day , DateTime.Now.Month , DateTime.Now.Year);

            using (StreamWriter sw = File.AppendText(currentFilePath))
            {
                foreach (string key in errors.Keys)
                {
                    sw.WriteLine(DateTime.Now.ToString() + " - " + key + ": " + errors[key]  );
                }
            }
        }
    }
}
