using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Spire.Doc;
using Spire.Doc.Documents;

namespace SPOT.users.ADMIN.popups
{
    public partial class Logs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = "Logs";

            if (!IsPostBack)
            {
                LoadLogs();
                // Set current date and time in txtDateTime
                txtDateTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
        }

        protected void rptLogs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ShowAccountDetails" && !string.IsNullOrEmpty(e.CommandArgument?.ToString()))
            {
                ShowAccountDetails(e.CommandArgument.ToString());
            }
        }

        private void ShowAccountDetails(string serial)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
                {
                    string accountQuery = "SELECT FullName, dob, PhoneNumber, Email, acccreateat, role, alias FROM accounts WHERE Serial = @Serial";
                    string imageQuery = "SELECT Img FROM images WHERE Serial = @Serial";

                    conn.Open();

                    // Get account info
                    using (SqlCommand accountCmd = new SqlCommand(accountQuery, conn))
                    {
                        accountCmd.Parameters.AddWithValue("@Serial", serial);
                        using (SqlDataReader reader = accountCmd.ExecuteReader())
                        {
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

                            // Populate controls
                            lblFullName.Text = "Fullname: " + (!string.IsNullOrWhiteSpace(fullName) ? fullName : "N/A");
                            lblAlias.Text = "Alias: " + (!string.IsNullOrWhiteSpace(alias) ? alias : "N/A");
                            lblRole.Text = "Role: " + (!string.IsNullOrWhiteSpace(role) ? role : "N/A");
                            lblAge.Text = "Age: " + age;
                            lblPhone.Text = "Phone: " + (!string.IsNullOrWhiteSpace(phone) ? phone : "N/A");
                            lblEmail.Text = "Email: " + (!string.IsNullOrWhiteSpace(email) ? email : "N/A");
                            lblAccountCreated.Text = "Account Created at: " + (!string.IsNullOrWhiteSpace(acccreated) ? acccreated : "N/A");
                        }
                    }

                    // Get image
                    string imageUrl = "~/images/default-profile.png";
                    using (SqlCommand imgCmd = new SqlCommand(imageQuery, conn))
                    {
                        imgCmd.Parameters.AddWithValue("@Serial", serial);
                        object imgResult = imgCmd.ExecuteScalar();
                        if (imgResult != null && imgResult != DBNull.Value)
                        {
                            byte[] imgBytes = (byte[])imgResult;
                            imageUrl = "data:image/png;base64," + Convert.ToBase64String(imgBytes);
                        }
                    }

                    imgProfile.ImageUrl = imageUrl;
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "ShowAccountPopup", "openPopup('accountPopup');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Error", $"alert('Error loading account details: {ex.Message}');", true);
            }
        }

        private void LoadLogs()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT HistoryLogID, LogDate, LogTime, LogType, Action, reference_id, LoggedBy FROM HistoryLogs ORDER BY LogDate DESC, LogTime DESC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            rptLogs.DataSource = dt;
                            rptLogs.DataBind();
                            lblNoLogs.Visible = dt.Rows.Count == 0;
                            Session["LogData"] = dt; // Store in session for GenerateProtectedDoc
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblNoLogs.Text = "Error loading logs: " + ex.Message;
                    lblNoLogs.Visible = true;
                }
            }
        }

        [System.Web.Services.WebMethod]
        public static void GenerateProtectedDoc(string savePath)
        {
            try
            {
                Document doc = new Document();
                Section section = doc.AddSection();
                Paragraph para = section.AddParagraph();
                para.AppendText("This is a protected log file.");

                DataTable logData = (DataTable)HttpContext.Current.Session["LogData"];
                if (logData != null)
                {
                    foreach (DataRow row in logData.Rows)
                    {
                        string logLine = $"{row["LogDate"]} {row["LogTime"]} - {row["LogType"]} - {row["Action"]} (Ref: {row["reference_id"]})";
                        section.AddParagraph().AppendText(logLine);
                    }
                }

                doc.Protect(ProtectionType.AllowOnlyReading, "SPOTMODE!@#");
                doc.SaveToFile(savePath, FileFormat.Docx);
            }
            catch (Exception ex)
            {
                throw new Exception("Error generating protected document: " + ex.Message);
            }
        }
    }
}