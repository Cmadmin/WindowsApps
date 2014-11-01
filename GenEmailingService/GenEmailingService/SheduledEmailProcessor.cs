using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GenEmailingService
{
    public class SheduledEmailProcessor
    {


        public int TimerOffsetForReminders
        {
            get { return Convert.ToInt32(ConfigurationManager.AppSettings["TimerOffsetForReminders"]); }
        }

        public Result ProcessAllScheduledEmails()
        {
            try
            {
                DataTable allEventToProcess = null;
                string connectionString = ConfigurationManager.ConnectionStrings["TotalHRConn"].ToString();
                //
                // create connection and prepare reminders.
                //
                using (var con = new SqlConnection(connectionString))
                {

                    using (var command = new SqlCommand())
                    {
                        
                        DataSet ds = new DataSet();

                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.CommandText = "GetNextScheduledEmail";
                        command.Parameters.AddWithValue("timeoffset", TimerOffsetForReminders);
                        SqlDataAdapter adapter = new SqlDataAdapter(command);

                        con.Open();
                        adapter.Fill(ds);
                       

                        if (ds != null && ds.Tables != null && ds.Tables.Count == 2)
                        {
                            ProcessSchedule(ds);                           
                        }
                        adapter.Dispose();
                       
                    }

                }
                return new Result { ReturnedObject = allEventToProcess, ReturnId = 1 };
            }
            catch (Exception ex)
            {
                return new Result { ReturnId = -1, ReturnedError = ex.ToString() };
            }
        }

        private void ProcessSchedule(DataSet ds)
        {
            DataRow tabScheduleRow = ds.Tables[0].Rows[0];
            DataTable tabRecipients = ds.Tables[1];
            EmailUtil mailUtil = new EmailUtil();

            //wait until it is time to send email
            DateTime sendate = Convert.ToDateTime(tabScheduleRow["SendDate"]);
            TimeSpan difference = sendate.Subtract(DateTime.Now);
            int ScheduleId = Convert.ToInt32(tabScheduleRow["ScheduleId"]);
            int minsleft = difference.Minutes;

            foreach (DataRow dr in tabRecipients.Rows)
            {
                mailUtil.toAddresses[dr["RecipientEmail"].ToString()] = dr["RecipientName"].ToString();
            }           

            //send it without further delay as email messages sometimes get delayed.
            bool result = mailUtil.SendMultipleEmail(tabScheduleRow["SenderEmail"].ToString(), tabScheduleRow["SenderName"].ToString(),
                    tabScheduleRow["MessageTitle"].ToString(), tabScheduleRow["MessageBody"].ToString());

            if (result)
            {
                RemoveSchedule(ScheduleId);
            }
        }

        public void RemoveSchedule(int scheduleid)
        {
            try
            {
               
                string connectionString = ConfigurationManager.ConnectionStrings["TotalHRConn"].ToString();
               
                using (var con = new SqlConnection(connectionString))
                {

                    using (var command = new SqlCommand())
                    {

                        DataSet ds = new DataSet();

                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.Text;
                        command.CommandText = string.Format(@"
                            declare @recipientlistid int

                            select @recipientlistid = RecipientListId
                            from ScheduledNotifications where id = {0}

                            delete from Recipient
                            where RecipientListId = @recipientlistid

                            delete from RecipientList
                            where id = @recipientlistid

                            Delete from ScheduledNotifications
                            where id = {0}

                        ", scheduleid);                    
                       

                        con.Open();
                        command.ExecuteNonQuery();
                    }

                }
                
            }
            catch (Exception ex)
            {
                using (StreamWriter sw = File.AppendText(EmailUtil.LogFile))
                {
                    sw.WriteLine(DateTime.Now.ToString() + " - " + ex.Message);
                }
            }
        }

    }
    
    public class Result
        {
            public int ReturnId { get; set; }
            public object ReturnedObject { get; set; }
            public string ReturnedError { get; set; }
        }
}
