using System;
using System.Data.SqlClient;
using System.Configuration;
using SPOT.users.DEFAULT.popups.masterFunctions;

namespace SPOT.users.DEFAULT.popups
{
    public partial class Visitors : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    txtDate.Text = DateTime.Now.ToString("MMM dd, yyyy");
                    timeIn.Text = DateTime.Now.ToString("hh:mm:ss tt");
                    timeOut.Text = DateTime.Now.ToString("hh:mm:ss tt");
                }
                catch (Exception ex)
                {
                    LogError(ex);
                    ShowAlert("Error initializing form: " + ex.Message);
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtFullName.Text.Trim();
                string contact = txtContact.Text.Trim();
                string date = txtDate.Text;
                string timeIn = this.timeIn.Text;
                string reason = txtReason.Text.Trim();

                if (string.IsNullOrEmpty(fullName) || !System.Text.RegularExpressions.Regex.IsMatch(fullName, @"^[a-zA-Z\s]{2,}$"))
                {
                    ShowAlert("Please enter a valid full name.");
                    return;
                }

                if (string.IsNullOrEmpty(contact) || !System.Text.RegularExpressions.Regex.IsMatch(contact, @"^\+63\d{10}$"))
                {
                    ShowAlert("Please enter a valid PH mobile number.");
                    return;
                }

                if (string.IsNullOrEmpty(reason) || reason.Length < 5)
                {
                    ShowAlert("Please enter a valid reason (min 5 chars).");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"]?.ConnectionString;
                if (string.IsNullOrEmpty(connStr))
                {
                    ShowAlert("Database configuration error.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "INSERT INTO VisitorLogs (FullName, ContactNumber, VisitDate, TimeIn, Purpose) " +
                                 "OUTPUT INSERTED.VisitorId " +
                                 "VALUES (@FullName, @ContactNumber, @VisitDate, @TimeIn, @Purpose)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@ContactNumber", contact);
                        cmd.Parameters.AddWithValue("@VisitDate", date);
                        cmd.Parameters.AddWithValue("@TimeIn", timeIn);
                        cmd.Parameters.AddWithValue("@Purpose", reason);

                        int visitorId = (int)cmd.ExecuteScalar();

                        string userSerial = Session["serial"]?.ToString() ?? "2500002";
                        string action = $"Visitor '{fullName}' arrived for: {reason}";
                        LogHistory.Write("Visitor", action, visitorId.ToString(), userSerial);
                    }
                }

                ShowAlert("Visitor added!");
                clearForm();
            }
            catch (SqlException sqlEx)
            {
                LogError(sqlEx);
                ShowAlert("Database error: " + sqlEx.Message);
            }
            catch (Exception ex)
            {
                LogError(ex);
                ShowAlert("Error: " + ex.Message);
            }
        }

        private void clearForm()
        {
            txtFullName.Text = "";
            txtContact.Text = "+63";
            txtReason.Text = "";
        }

        private void ShowAlert(string message)
        {
            string safeMessage = message.Replace("'", "\\'");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{safeMessage}');", true);
        }

        private void LogError(Exception ex)
        {
            string userSerial = Session["serial"]?.ToString() ?? "2500002";
            LogHistory.Write("Error", $"Error in Visitors page: {ex.Message}", "0", userSerial);
        }
    }
}