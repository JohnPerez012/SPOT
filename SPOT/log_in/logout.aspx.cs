using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace SPOT.log_in
{
    public partial class logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            // Get the serial from session
            if (Session["Serial"] != null)
            {
                int serial = Convert.ToInt32(Session["Serial"]);
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
                    {
                        string query = @"
                        	 UPDATE Officers_ON_DUTY SET isDuty = 0, dutyInTimeStamp = null, prevInTimeStamp = CURRENT_TIMESTAMP WHERE officersSerial = @Serial;
                            UPDATE AccountLogSheet
                            SET CheckOutTime = CURRENT_TIMESTAMP
                            WHERE AccLogID = (
                                SELECT TOP 1 AccLogID 
                                FROM AccountLogSheet 
                                WHERE Serial = @Serial AND CheckOutTime IS NULL 
                                ORDER BY AccLogID DESC
                            )";

                        SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Serial", serial);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                //}
            }

            // Clear all session variables
            Session.Clear();
            Session.Abandon();

            // Expire session cookie
            HttpCookie authCookie = new HttpCookie("ASP.NET_SessionId", "")
            {
                Expires = DateTime.Now.AddDays(-1)
            };
            Response.Cookies.Add(authCookie);
        }
    }
}