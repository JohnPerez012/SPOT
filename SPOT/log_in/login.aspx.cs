


using SPOT.users.DEFAULT.popups;
using System;
using System.ComponentModel;
using System.Configuration;
using System.Data.Common;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Drawing.Printing;
using System.Drawing;
using System.Reflection;
using System.Security.Policy;
using System.Web.Mvc;
using System.Web.UI;
using static System.Net.Mime.MediaTypeNames;
using System.Web.UI.WebControls;
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.VariantTypes;

namespace SPOT.log_in
{
    public partial class login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {


            string serial = (serial1.Text.Trim() + serial2.Text.Trim() + serial3.Text.Trim() + serial4.Text.Trim() + serial5.Text.Trim() + serial6.Text.Trim());
            string pin = (pin1.Text.Trim() + pin2.Text.Trim() + pin3.Text.Trim() + pin4.Text.Trim() + pin5.Text.Trim() + pin6.Text.Trim());

            System.Diagnostics.Debug.WriteLine($"Entered Serial: '{serial}'");
            System.Diagnostics.Debug.WriteLine($"Entered PIN: '{pin}'");

            // Check if serial and pin are numeric
            if (!IsNumeric(serial) || !IsNumeric(pin))
            {
                lblMessage.Text = "<script>alert('⚠️ Serial and PIN must contain only numbers!');</script>";
                lblMessage.Visible = true;
                return;
            }

            if (AuthenticateUser(serial, pin))
            {

                checkDuties();

                string userRole = GetUserRole(serial);
                Session["UserRole"] = userRole;

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
                {
                    string query = "INSERT INTO AccountLogSheet (Serial, LogDate, CheckInTime) VALUES (@Serial, @LogDate, @CheckInTime);" +
                        "UPDATE Officers_ON_DUTY SET isDuty = 1, dutyInTimeStamp = CURRENT_TIMESTAMP WHERE officersSerial = @Serial;" +
                        "UPDATE Officers_ON_DUTY SET isDuty = 0, dutyInTimeStamp = null WHERE dutyInTimeStamp = (SELECT MIN(dutyInTimeStamp) FROM Officers_ON_DUTY WHERE isDuty = 1 ) and ((SELECT COUNT(*) FROM Officers_ON_DUTY WHERE isDuty = 1) >= 3 )";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Serial", Convert.ToInt32(serial));
                    cmd.Parameters.AddWithValue("@LogDate", DateTime.Today);
                    cmd.Parameters.AddWithValue("@CheckInTime", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                if (userRole == "Admin")
                {
                    Response.Redirect("~/users/ADMIN/Dashboard.aspx");
                }
                else
                {
                    Response.Redirect("~/users/DEFAULT/Dashboard.aspx");
                    checkDuties();

                }
            }
            else
            {
                lblMessage.Text = "<script>showIncorrect();</script>";
                lblMessage.Visible = true;
            }
        }

        private void checkDuties()
        {

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accounts"].ConnectionString))
            {
                string query = "UPDATE Officers_ON_DUTY SET isDuty = 0, dutyInTimeStamp = null, prevInTimeStamp = null WHERE dutyInTimeStamp = (SELECT MIN(dutyInTimeStamp) FROM Officers_ON_DUTY WHERE isDuty = 1 ) and ((SELECT COUNT(*) FROM Officers_ON_DUTY WHERE isDuty = 1) >= 3 )";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

        }
        private bool IsNumeric(string input)
        {
            return int.TryParse(input, out _);
        }



        private string GetUserRole(string serial)
        {
            string role = null;
            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT role FROM accounts WHERE serial = @serial";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    role = result?.ToString();
                }
            }
            return role;
        }

        private bool AuthenticateUser(string serial, string pin)
        {
            bool isValidUser = false;
            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT serial, fname, lname, mname, fullname, dob, address, phonenumber, email, acccreateat, role " +
                               "FROM accounts WHERE serial = @serial AND pin = @pin";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    cmd.Parameters.AddWithValue("@pin", pin);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Store user information in session variables


                        Session["Serial"] = reader["serial"].ToString();
                        Session["FirstName"] = reader["fname"].ToString();
                        Session["LastName"] = reader["lname"].ToString();
                        Session["MiddleInitial"] = string.IsNullOrEmpty(reader["mname"].ToString()) ? "" : reader["mname"].ToString()[0] + "."; // Store middle initial
                        Session["FullName"] = reader["fullname"].ToString().ToUpper(); // Capitalized full name
                        Session["DOB"] = reader["dob"].ToString();
                        Session["Address"] = reader["address"].ToString();
                        Session["PhoneNumber"] = reader["phonenumber"].ToString();
                        Session["Email"] = reader["email"].ToString();
                        Session["AccCreated"] = reader["acccreateat"].ToString();


                        isValidUser = true;
                    }
                }
            }

            return isValidUser;
        }


    }
}










