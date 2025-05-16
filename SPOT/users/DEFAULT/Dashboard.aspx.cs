using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;


namespace SPOT.users.DEFAULT
{
    public partial class Dashboard : Page
    {
     

        protected void Page_Load(object sender, EventArgs e)    
        {
            btnUnlock.Visible = false;
            btnSysUnlock.Visible = false;

            if (Session["FullName"] == null)
            {
                System.Diagnostics.Debug.WriteLine("Session expired. Redirecting to login.");
                Response.Redirect("~/log_in/login.aspx", true);
                return;
            }

            try
            {
                if (Session["Serial"] == null)
                {
                    System.Diagnostics.Debug.WriteLine("Session['Serial'] is null.");
                    Response.Write("<script>alert('User session invalid. Please log in again.');</script>");
                    Response.Redirect("~/log_in/login.aspx", true);
                    return;
                }

                int serial = Convert.ToInt32(Session["Serial"]);
                bool isLocked = IsAccountLocked(serial);
                lockBlurProtectionCard.Visible = lockCard.Visible = isLocked;
                System.Diagnostics.Debug.WriteLine($"Page_Load: lockCard.Visible = {lockCard.Visible}");

                // Start timer on first load if not locked
                if (!IsPostBack && !isLocked)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "StartInactivityPolling",
                        "startInactivityPolling();", true);
                }

                BindSidebarMenu();  
                BindDashboardBoxes();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in Page_Load: {ex.Message}");
                Response.Write("<script>alert('Error loading data: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }

        private bool IsAccountLocked(int serial)
        {
            string connString = ConfigurationManager.ConnectionStrings["accounts"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'accounts' is missing or invalid.");
                throw new Exception("Database connection configuration is missing.");
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT isLocked FROM accountlocked WHERE serial = @serial";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        bool isLocked = result != null && Convert.ToBoolean(result);
                        if (isLocked) { btnUnlock.Visible = true; }
                        return isLocked;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error in IsAccountLocked: {ex.Message}");
                        return false;
                    }
                }
            }
        }

        protected void btnSystemUnlock_Click(object sender, EventArgs e)
        {
            // Implement system unlock logic if needed
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["Serial"] == null)
                {
                    lblError.Text = "Session expired. Please log in again.";
                    lblError.Visible = true;
                    Response.Redirect("~/log_in/login.aspx", true);
                    return;
                }

                int serial = Convert.ToInt32(Session["Serial"]);
                string pin = txtPin.Text.Trim();

                if (string.IsNullOrEmpty(pin))
                {
                    lblError.Text = "Please enter a PIN.";
                    lblError.Visible = true;
                    return;
                }

                if (ValidatePin(serial, pin))
                {
                    UnlockAccount(serial);
                    if (lockCard != null)
                    {
                        lockCard.Visible = false;
                        lockBlurProtectionCard.Visible = false;
                        GetCalendarDateMarkup("CALENDAR");


                    }
                }
                else
                {
                    lblError.Text = "Invalid PIN.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnUnlock_Click: {ex.Message}");
                lblError.Text = "An error occurred while unlocking the account.";
                lblError.Visible = true;
            }

        }

        private bool ValidatePin(int serial, string pin)
        {
            string connString = ConfigurationManager.ConnectionStrings["accounts"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'accounts' is missing or invalid.");
                return false;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM accounts WHERE serial = @serial AND pin = @pin";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    cmd.Parameters.AddWithValue("@pin", pin);
                    try
                    {
                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error in ValidatePin: {ex.Message}");
                        return false;
                    }
                }
            }
        }

        private void UnlockAccount(int serial)
        {
            string connString = ConfigurationManager.ConnectionStrings["accounts"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'accounts' is missing or invalid.");
                throw new Exception("Database connection configuration is missing.");
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "UPDATE accountlocked SET isLocked = 0 WHERE serial = @serial";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void LockAccount(int serial)
        {
            string connString = ConfigurationManager.ConnectionStrings["accounts"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'accounts' is missing or invalid.");
                throw new Exception("Database connection configuration is missing.");
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "UPDATE accountlocked SET isLocked = 1 WHERE serial = @serial";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnAccountLOCK_Click(object sender, EventArgs e)
        {
            btnSysUnlock.Visible = false;
            btnUnlock.Visible = true;
            try
            {
                if (Session["Serial"] == null)
                {
                    Response.Write("<script>alert('Session expired. Please log in again.');</script>");
                    Response.Redirect("~/log_in/login.aspx", true);
                    return;
                }

                int serial = Convert.ToInt32(Session["Serial"]);
                LockAccount(serial);
                if (lockCard != null)
                {
                    lockCard.Visible = true;
                    lockBlurProtectionCard.Visible = true;
                }
                           }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnAccountLOCK_Click: {ex.Message}");
                Response.Write("<script>alert('Error locking account: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["Serial"] == null)
                {

                    Response.Write("<script>alert('Session expired. Please log in again.');</script>");
                    Response.Redirect("~/log_in/login.aspx", true);
                    return;
                }

                int serial = Convert.ToInt32(Session["Serial"]);
                UnlockAccount(serial); // Unlock the account if locked
                if (lockCard != null)
                {
                    lockCard.Visible = false;
                    lockBlurProtectionCard.Visible = false;
                }

                // Redirect to logout.aspx without abandoning session
                Response.Redirect("~/log_in/logout.aspx");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnLogout_Click: {ex.Message}");
                Response.Write("<script>alert('Error logging out: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }



        [WebMethod]
        public static object UpdateCircles()
        {
            try
            {
                var result = new
                {
                    university = GetPendingUniversityVehiclesCount(),
                    visitors = GetPendingVisitorsCount(),
                    vehicles = GetPendingVehiclesCount()
                };
                System.Diagnostics.Debug.WriteLine($"UpdateCircles: {Newtonsoft.Json.JsonConvert.SerializeObject(result)}");
                return result;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in UpdateCircles: {ex.Message}");
                throw;
            }
        }

        private void BindSidebarMenu()
        {
            var menuItems = new List<object>
            {
                new { Title = "Dashboard", Icon = "icon-dashboard", Url = "Dashboard.aspx" },
                new { Title = "Program Info", Icon = "icon-info", Url = "popups/ProgramInfoPopup.aspx" },
                new { Title = "Meet DeVs", Icon = "icon-logout", Url = "/users/Sidebar_master/meetTheTeam.aspx" }
            };

            if (SidebarMenu != null)
            {
                SidebarMenu.DataSource = menuItems;
                SidebarMenu.DataBind();
                System.Diagnostics.Debug.WriteLine("SidebarMenu bound successfully.");
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("SidebarMenu is null.");
            }
        }

        private void BindDashboardBoxes()
        {
            int pendingUniversityVehicles = GetPendingUniversityVehiclesCount();
            int pendingVisitors = GetPendingVisitorsCount();
            int pendingVehicles = GetPendingVehiclesCount();

            var dashboardItems = new List<object>
            {
                new { Title = "VISITORS", Url = "popups/Visitors.aspx" },
                new { Title = "KEYS", Url = "popups/Keys.aspx" },
                new { Title = "CALENDAR", Url = "/users/Popup_master/CALENDAR.aspx" },
                new { Title = "VEHICLE", Url = "popups/VehicleLog.aspx" },
                new { Title = $"PENDING|{pendingUniversityVehicles}|{pendingVisitors}|{pendingVehicles}", Url = "popups/Pending.aspx" },
                new { Title = "LOGS", Url = "popups/Logs.aspx" }
            };

            if (DashboardBoxes != null)
            {
                DashboardBoxes.DataSource = dashboardItems;
                DashboardBoxes.DataBind();
                System.Diagnostics.Debug.WriteLine($"DashboardBoxes bound with {dashboardItems.Count} items.");
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("DashboardBoxes is null.");
            }
        }

        private static int GetPendingUniversityVehiclesCount()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'LogsDB' is missing or invalid.");
                return 0;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM UniversityVehiclesLogs WHERE Arrive IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error in GetPendingUniversityVehiclesCount: {ex.Message}");
                        return 0;
                    }
                }
            }
        }

        private static int GetPendingVisitorsCount()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'LogsDB' is missing or invalid.");
                return 0;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM VisitorLogs WHERE TimeOut IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error in GetPendingVisitorsCount: {ex.Message}");
                        return 0;
                    }
                }
            }
        }

        private static int GetPendingVehiclesCount()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"]?.ConnectionString;
            if (string.IsNullOrEmpty(connString))
            {
                System.Diagnostics.Debug.WriteLine("Connection string 'LogsDB' is missing or invalid.");
                return 0;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM VehicleLog WHERE TimeOut IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error in GetPendingVehiclesCount: {ex.Message}");
                        return 0;
                    }
                }
            }
        }

        protected string GetPendingCircles(string title)
        {
            if (!title.Contains("PENDING")) return "";

            string[] parts = title.Split('|');
            if (parts.Length != 4) return "";

            string circle1Class = parts[1] == "0" ? "circle green" : "circle";
            string circle2Class = parts[2] == "0" ? "circle green" : "circle";
            string circle3Class = parts[3] == "0" ? "circle green" : "circle";

            return $@"
                <div class='pending-circles-container'>
                    <span class='{circle1Class}'>{parts[1]}</span>
                    <span class='{circle2Class}'>{parts[2]}</span>
                    <span class='{circle3Class}'>{parts[3]}</span>
                </div>";
        }

        protected string GetCalendarDateMarkup(string title)
        {
            if (title == "CALENDAR")
            {
                return $@"<div class='calendar-date' style='padding-top: 10px; line-height: 1; text-align: center; margin-bottom:-110px;'>
                    <span style='color: red;'>{DateTime.Now:dddd}</span><br/>
                    <span style='font-size: 80px;'>{DateTime.Now:dd}</span>
                </div>";
            }
            return "";
        }
    }
}