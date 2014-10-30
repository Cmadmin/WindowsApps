using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using GenEmailingService;

namespace ScheduledEmailProcessorTest
{
    [TestClass]
    public class ScheduledEmailProcessorTest
    {
        [TestMethod]
        public void ProcessAllScheduledEmailsTest()
        {

            Result result = (new SheduledEmailProcessor()).ProcessAllScheduledEmails();

            Assert.IsTrue(result.ReturnId > 0);
        }
    }
}
