using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;

namespace SPOT.users.ADMIN
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FullName"] == null)
            {
                System.Diagnostics.Debug.WriteLine("Session expired. Redirecting to login.");
                Response.Redirect("~/log_in/login.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    BindSidebarMenu();
                    BindDashboardBoxes();
                    BindDashboardBoxes_Side();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error loading data: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
        }


        protected void Logo_Click(object sender, EventArgs e)
        {
            // Option 1: Re-run Page_Load logic
            Page_Load(sender, e); // Directly call Page_Load to refresh the page

            // Option 2: Perform a specific action (e.g., refresh dashboard data)
            // BindSidebarMenu();
            // BindDashboardBoxes();
            // Response.Write("<script>alert('Dashboard refreshed!');</script>");
        }



        private void BindSidebarMenu()
        {
            var menuItems = new List<object>
            {
                new { Title = "Dashboard", Icon = "icon-dashboard", Url = "Dashboard.aspx" },
                new { Title = "User Management", Icon = "icon-users", Url = "/users/ADMIN/adminSidebar/UserManagement.aspx" },
                new { Title = "History", Icon = "icon-history", Url = "popups/HistoryPopup.aspx" },
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
            var dashboardItems = new List<object>
            {
                new { Title = "OFFICERS ON DUTY", Url = "popups/OfficersPopup.aspx" },
                new { Title = "HISTORY", Url = "popups/Logs.aspx" },
                new { Title = "CHECK SYSTEM LOGS", Url = "popups/MonitorSystemLogs.aspx" },
            };

            DashboardBoxes.DataSource = dashboardItems;
            DashboardBoxes.DataBind();
        }

        private void BindDashboardBoxes_Side()
        {
            var sidedashboartItems = new List<object>
            {
                new { Title = "CALENDAR", Url = "/users/Popup_master/CALENDAR.aspx" },
                new { Title = "UNIVERSITY ENTITIES", Url = "popups/Logs.aspx" },
            };

            DashboardBoxes_Side.DataSource = sidedashboartItems;
            DashboardBoxes_Side.DataBind();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/log_in/logout.aspx");
        }

        protected string GetCalendarDateMarkup(string title)
        {
            if (title == "CALENDAR")
            {
                return $@"<div class='calendar-date' style='padding-top: 10px; line-height: 1; text-align: center; margin-bottom:-110px;'>
                    <span style='font-size: 35px; color: red;'>{DateTime.Now:dddd}</span><br/>
                    <span style='font-size: 140px;'>{DateTime.Now:dd}</span>
                </div>";
            }
            return "";
        }

        protected string CountOndutyOfficers(string title)
        {
            if (title == "OFFICERS ON DUTY")
            {
                int count = 0;

                string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "select count(*) as number from Officers_ON_DUTY where isDuty = 1 and dutyInTimeStamp is not null";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                count = reader.GetInt32(0);
                            }
                        }
                    }
                }
                return $@"<span style='font-size: 10px; margin-left:60px; '>TOTAL PERSON</span>
<span class='officer-count'>{count}</span>";

            } return " ";
        }
        protected string GetOnDutyOfficers(string title)
        {
            if (title == "OFFICERS ON DUTY")
            {
                //"<div class='onDuty-officer-container'>
                StringBuilder officerHtml = new StringBuilder();
                officerHtml.Append("<div class='onDuty-officer-container'>");

                string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT a.lastName + ', ' + a.firstName as 'Officers Name', a.isDuty, i.Img  FROM Officers_ON_DUTY a LEFT JOIN [accounts].[dbo].[images] i ON a.officersSerial = i.serial WHERE a.isDuty = 1";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string officerName = reader["Officers Name"].ToString();
                                string imageSrc = "/images/default-profile.png"; // Simplified fallback

                                if (reader["Img"] != DBNull.Value)
                                {
                                    byte[] imageBytes = (byte[])reader["Img"];
                                    imageSrc = $"data:image/jpeg;base64,{Convert.ToBase64String(imageBytes)}";
                                }
                                officerHtml.Append($@"<div class='onDuty-officer-box'>
                                    <img class='onDuty-officer-profile-picture' src='{imageSrc}' alt='Officer Profile' />
                                        <span style='margin-left: 15px; color: black;'> | </span>
                                    <div class='onDuty-officer-name'>{officerName.ToUpper()}</div>
                                </div>");
                            }
                        }
                    }
                }
                officerHtml.Append("</div>");
                return officerHtml.ToString();
            }

            return "";
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

        protected string FormatDateForHistory(object logDate)
        {
            if (logDate != DBNull.Value)
            {
                DateTime date = Convert.ToDateTime(logDate);
                return date.ToString("MMMM dd, yyyy").ToUpper(); // e.g., MAY 14, 2025
            }
            return "";
        }
        protected string FormatTimeForHistory(object logTime)
        {
            if (logTime != DBNull.Value)
            {
                if (logTime is TimeSpan timeSpan)
                {
                    // Convert TimeSpan to DateTime for formatting
                    DateTime time = DateTime.Today.Add(timeSpan);
                    return time.ToString("h:mm tt"); // e.g., 9:44 PM
                }
                else if (logTime is DateTime dateTime)
                {
                    if (dateTime.Date == DateTime.MinValue || dateTime.Date == new DateTime(1900, 1, 1))
                        return "";

                    return dateTime.ToString("h:mm tt");
                }
            }

            return "";
        }
        protected string showHistoryViewState(string title)
        {

            if (title != "HISTORY") return "";

            DataTable logsTable = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT HistoryLogID, LogDate, LogTime, LogType, reference_id FROM HistoryLogs ORDER BY LogDate desc, LogTime desc";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(logsTable);
                    }
                }

            }

            if (logsTable.Rows.Count == 0) return "<div>No logs available.</div>";

            StringBuilder html = new StringBuilder();
            html.Append("<div class='CSLViewingbox'>");
            html.Append("<table class='log-table'>");
            html.Append("<thead><tr><th>HistoryLogID</th><th>LogDate</th><th>LogTime</th><th>LogType</th><th>reference_id</th></tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in logsTable.Rows)
            {
                html.Append("<tr>");
                html.Append($"<td>{row["HistoryLogID"]}</td>");
                html.Append($"<td>{FormatDateForHistory(row["LogDate"])}</td>");
                html.Append($"<td>{FormatTimeForHistory(row["LogTime"])}</td>");
                html.Append($"<td>{row["LogType"]}</td>");
                html.Append($"<td>{row["reference_id"]}</td>");
                html.Append("</tr>");
            }

            html.Append("</tbody></table></div>");

            return html.ToString();
        }

        protected string SysLogs(string title)
        {
            if (title != "CHECK SYSTEM LOGS") return "";

            DataTable logsTable = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT AccLogID, Serial, LogDate, CheckInTime, CheckOutTime FROM AccountLogSheet ORDER BY AccLogID DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(logsTable);
                    }
                }
            }

            if (logsTable.Rows.Count == 0) return "<div>No logs available.</div>";

            StringBuilder html = new StringBuilder();
            html.Append("<div class='CSLViewingbox'>");
            html.Append("<table class='log-table'>");
            html.Append("<thead><tr><th>Account Log ID</th><th>Serial</th><th>LogDate</th><th>Check In Time</th><th>Check Out Time</th></tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in logsTable.Rows)
            {
                html.Append("<tr>");
                html.Append($"<td>{row["AccLogID"]}</td>");
                html.Append($"<td>{row["Serial"]}</td>");
                html.Append($"<td>{FormatDate(row["LogDate"])}</td>");
                html.Append($"<td>{FormatTime(row["CheckInTime"])}</td>");
                html.Append($"<td>{FormatTime(row["CheckOutTime"])}</td>");
                html.Append("</tr>");
            }

            html.Append("</tbody></table></div>");

            return html.ToString();
        }

        protected string HistoryReset(string title) {
            if (title == "HISTORY")
            {
                return
                $@" ";

            }
            return "";
        }

        protected string HistoryHARDReset(string title) {
            return "";
        }


        protected string DownloadHistory(string title)
        {
            if (title == "HISTORY")
            {
                return $"<a href='DownloadHandler.ashx?file={HttpUtility.UrlEncode(title)}' title='Download History'>" +
                       $"<img src='/images/downloadICON.png' alt='Download' class='download-icon' /></a>";
            }

            return "";
        }




    }
}