using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SPOT.users.ADMIN.popups
{
    public partial class MonitorSystemLogs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { LoadLogs(); }
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];
            if (eventTarget == "ShowAccountDetails" && !string.IsNullOrEmpty(eventArgument))
            {
                ShowAccountDetails(eventArgument);
            }
        }

        protected string FormatDate(object logDate)
        {
            if (logDate != DBNull.Value)
            {
                DateTime date = Convert.ToDateTime(logDate);
                return date.ToString("MMMM dd, yyyy").ToUpper(); // Example: APRIL 16, 2025
            }
            return "";
        }

        protected string FormatTime(object dateTime)
        {
            if (dateTime != DBNull.Value)
            {
                DateTime time = Convert.ToDateTime(dateTime);

                // Skip default/placeholder time like 01/01/1900
                if (time.Date == DateTime.MinValue || time.Date == new DateTime(1900, 1, 1))
                {
                    return "";
                }

                return time.ToString("h:mm tt"); // Example: 8:35 AM
            }
            return "";
        }

        private void LoadLogs()
        {
            string query = "SELECT AccLogID, Serial, LogDate, CheckInTime, CheckOutTime FROM AccountLogSheet order by AccLogID desc";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptLogs.DataSource = dt;
                    rptLogs.DataBind();
                }
            }
        }

        private void ShowAccountDetails(string serial)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
            {
                string accountQuery = "SELECT FullName, dob, PhoneNumber, Email, acccreateat, role, alias FROM accounts WHERE Serial = @Serial";
                string imageQuery = "SELECT Img FROM images WHERE Serial = @Serial";

                conn.Open();

                // Get account info
                SqlCommand accountCmd = new SqlCommand(accountQuery, conn);
                accountCmd.Parameters.AddWithValue("@Serial", serial);
                SqlDataReader reader = accountCmd.ExecuteReader();
                string fullName = "", age = "", phone = "", email = "", acccreated = "", alias = "", role = "";
                if (reader.Read())
                {
                    fullName = reader["FullName"].ToString();

                    if (reader["dob"] != DBNull.Value)
                    {
                        DateTime dob = Convert.ToDateTime(reader["dob"]);
                        int calculatedAge = DateTime.Now.Year - dob.Year;
                        if (DateTime.Now < dob.AddYears(calculatedAge)) calculatedAge--;
                        age = calculatedAge.ToString();
                    }
                    else
                    {
                        age = "N/A";
                    }

                    alias = reader["alias"].ToString();
                    role = reader["role"].ToString();
                    phone = reader["PhoneNumber"].ToString();
                    email = reader["Email"].ToString();
                    acccreated = reader["acccreateat"].ToString();

                }

                reader.Close();

                // Get image
                SqlCommand imgCmd = new SqlCommand(imageQuery, conn);
                imgCmd.Parameters.AddWithValue("@Serial", serial);
                string imageUrl = "~/images/default-profile.png";
                object imgResult = imgCmd.ExecuteScalar();
                if (imgResult != null && imgResult != DBNull.Value)
                {
                    byte[] imgBytes = (byte[])imgResult;
                    imageUrl = "data:image/png;base64," + Convert.ToBase64String(imgBytes);
                }

                // Populate controls
                lblFullName.Text = "Fullname: " + (!string.IsNullOrWhiteSpace(fullName) ? fullName : "N / A");
                lblAlias.Text = alias;
                lblRole.Text = role;
                lblAge.Text = "Age: " + age;
                lblPhone.Text = "Phone: " + phone;
                lblEmail.Text = "Email: " + email;
                imgProfile.ImageUrl = imageUrl;
                lblAccountCreated.Text = "Account Created at: " + acccreated;
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "ShowAccountPopup", "openPopup('accountPopup');", true);
        }
    }
}