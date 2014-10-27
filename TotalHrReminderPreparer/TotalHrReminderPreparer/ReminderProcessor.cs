using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Collections;
using System.IO;

namespace TotalHrReminderPreparer
{
    public class Utils
    {
        public static string GetConfigString(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }

    public class Result
    {
        public int ReturnId { get; set; }
        public object ReturnedObject{get;set;}
        public string ReturnedError { get; set; }
    }

    public class ReminderProcessor
    {
        public const string logFile = @"C:\Projects\Applications\WindowsApps\TotalHrReminderPreparer\logs\Rem_{0}{1}{2}.txt";

        public Result RemoveScheduleReminderRequestFromDB(int evtScheduleRequestId)
        {
            try
            {
                int norows = 0;
                string connectionString = ConfigurationManager.ConnectionStrings["TotalHRConn"].ToString();
               
                using (var con = new SqlConnection(connectionString))
                {

                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.Text;
                        command.CommandText = string.Format("Delete from eventtoschedule where id = {0}", evtScheduleRequestId);
                        con.Open();
                        norows = command.ExecuteNonQuery();
                    }

                }
                if (norows < 1)
                    throw new
                    Exception("RemoveScheduleReminderRequestFromDB: No row has been deleted id#:" + evtScheduleRequestId);

                return new Result {  ReturnId = norows };
            }
            catch (Exception ex)
            {
                return new Result { ReturnId = -1, ReturnedError = ex.ToString() };
            }
        }

        public Dictionary<string, string> ProcessAllEvents()
        {
            DataTable allEvents = null;
            Dictionary<string, string> retErrors = new Dictionary<string, string>();
            string currentFilePath = string.Format(logFile, DateTime.Now.Day , DateTime.Now.Month , DateTime.Now.Year);

            try
            {
                Result result = GetEventToProcess();

                if(result.ReturnId < 0){
                  retErrors["EventProcessFailed"] = "1";
                    return retErrors;
                }

                allEvents = (DataTable)result.ReturnedObject;

                foreach (DataRow dr in allEvents.Rows)
                {
                    Result result2 = BuildCalEventReminderRecipientList(dr);

                    //we need a valid recipient list id
                    if (result2.ReturnId < 1)//error
                    {
                        using (StreamWriter sw = File.AppendText(currentFilePath))
                        {
                            sw.WriteLine(result2.ReturnedError);
                        }
                    }
                    else //else process reminders with recipient list id
                    {
                        Result result3 = ProcessRemindersForEvent(result2.ReturnId);

                        if (result3.ReturnId > 0)//remove the process request
                        {
                            Result result4 = RemoveScheduleReminderRequestFromDB(Convert.ToInt32(dr["id"]));
                            if (result4.ReturnId < 1)
                            {
                                using (StreamWriter sw = File.AppendText(currentFilePath))
                                {
                                    sw.WriteLine(result2.ReturnedError);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                retErrors["Error"] = ex.ToString();
            }

            return retErrors;
        }

        public Result GetEventToProcess()
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
                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.Text;
                        command.CommandText = "select * from eventtoschedule";
                        con.Open();
                        var reader = command.ExecuteReader();
                        allEventToProcess = new DataTable();
                        allEventToProcess.Load(reader);
                    }

                }
                return new Result { ReturnedObject = allEventToProcess, ReturnId = 1 };
            }
            catch (Exception ex)
            {
                return new Result { ReturnId = -1, ReturnedError = ex.ToString() };
            }
        }

        public Result BuildCalEventReminderRecipientList(DataRow dr)
        {
            return BuildCalEventReminderRecipientList(
                Convert.ToInt32(dr["eventid"]),
                Convert.ToInt32(dr["companyid"]),
                dr["RecipientListName"].ToString(),
                (dr["description"] != DBNull.Value)? dr["description"].ToString() : "",
                Convert.ToInt32(dr["CreatedBy"])
                );
        }

        public Result BuildCalEventReminderRecipientList(int eventid, int companyid, string RecipientListName,
            string description, int CreatedBy)
        {
           
            try
            {
                int RecipientlistId = 0;
                string connectionString = ConfigurationManager.ConnectionStrings["TotalHRConn"].ToString();
                //
                // create connection and prepare reminders.
                //
                using (var con = new SqlConnection(connectionString))
                {                   

                    using (var command = new SqlCommand())
                    {                       

                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.CommandText = "BuildCalEventReminderRecipientList";
                        command.Parameters.Add(new SqlParameter("eventid", eventid));
                        command.Parameters.Add(new SqlParameter("companyid", companyid));
                        command.Parameters.Add(new SqlParameter("RecipientListName", RecipientListName));
                        command.Parameters.Add(new SqlParameter("description", description));
                        command.Parameters.Add(new SqlParameter("CreatedBy", CreatedBy));

                        con.Open();
                        RecipientlistId = Convert.ToInt32(command.ExecuteScalar());
                    }

                }
                return new Result { ReturnId = RecipientlistId };
            }
            catch (Exception ex)
            {
                return new Result { ReturnId = -1, ReturnedError = ex.ToString() };
            }
        }

        public Result ProcessRemindersForEvent(int RecipientListId)
        {
            try
            {
                int norows = 0;
                string connectionString = ConfigurationManager.ConnectionStrings["TotalHRConn"].ToString();
                //
                // create connection and prepare reminders.
                //
                using (var con = new SqlConnection(connectionString))
                {

                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.CommandText = "PrepareCalendarEventScheduledReminder";

                        command.Parameters.Add(new SqlParameter("SenderName", Utils.GetConfigString("SenderName")));
                        command.Parameters.Add(new SqlParameter("SenderEmail",Utils.GetConfigString("SenderEmail")));
                        command.Parameters.Add(new SqlParameter("RecipientListId", RecipientListId));

                        con.Open();
                        norows = command.ExecuteNonQuery();
                    }

                }
                return new Result { ReturnId = norows };
            }
            catch (Exception ex)
            {
                return new Result { ReturnedError = ex.ToString(), ReturnId = -1 };
            }
        }


    }
}
