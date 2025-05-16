using System;
using System.Configuration;
using System.Data.SqlClient;

namespace SPOT.users.DEFAULT.popups.masterFunctions
{
    public static class LogHistory
    {
        public static void Write(string logType, string action, string referenceId, string loggedBy)
        {
            if (string.IsNullOrWhiteSpace(loggedBy))
            {
                loggedBy = "2500002"; // Fallback serial
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string insertQuery = "INSERT INTO HistoryLogs (LogDate, LogTime, LogType, Action, reference_id, LoggedBy) " +
                                     "VALUES (@LogDate, @LogTime, @LogType, @Action, @ReferenceId, @LoggedBy)";

                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@LogDate", DateTime.Now.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@LogTime", DateTime.Now.ToString("HH:mm:ss"));
                    cmd.Parameters.AddWithValue("@LogType", logType);
                    cmd.Parameters.AddWithValue("@Action", action);
                    cmd.Parameters.AddWithValue("@ReferenceId", referenceId);
                    cmd.Parameters.AddWithValue("@LoggedBy", loggedBy);

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
