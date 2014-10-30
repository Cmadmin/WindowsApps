using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GenEmailingService
{
    public class SheduledEmailProcessor
    {
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
                        command.Parameters.AddWithValue("timeoffset", 10);
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
            DataTable tabSchedule = ds.Tables[0];
            DataTable tabRecipients = ds.Tables[1];
            EmailUtil mailUtil = new EmailUtil();

            foreach (DataRow dr in tabRecipients.Rows)
            {
                mailUtil.SendEmail(dr["RecipientEmail"].ToString(), dr["RecipientName"].ToString(), 
                    tabSchedule.Rows[0]["SenderEmail"].ToString(),  tabSchedule.Rows[0]["SenderName"].ToString(), 
                    dr["MessageTitle"].ToString(), dr["MessageBody"].ToString());
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
