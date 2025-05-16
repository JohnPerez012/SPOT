using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SPOT.users.DEFAULT.popups.masterFunctions;

namespace SPOT.users.DEFAULT.popups
{
    public partial class Pending : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPendingVisitors();
                LoadPendingVehicles();
                LoadPendingUniversityVehicles();
            }
        }

        private void LoadPendingVisitors()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT VisitorID, FullName, VisitDate, TimeIn FROM VisitorLogs WHERE TimeOut IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvVisitors.DataSource = dt;
                    gvVisitors.DataBind();
                }
            }
        }

        private void LoadPendingVehicles()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT LogID, PlateNumber, VehicleType, TimeIn FROM VehicleLog WHERE TimeOut IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvVehicles.DataSource = dt;
                    gvVehicles.DataBind();
                }
            }
        }

        private void LoadPendingUniversityVehicles()
        {
            string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT LogID, PlateNumber, DriverName, SetOff FROM UniversityVehiclesLogs WHERE Arrive IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvUniversityVehicles.DataSource = dt;
                    gvUniversityVehicles.DataBind();
                }
            }
        }

        protected void gvPending_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SetOut")
            {
                try
                {
                    int visitorId = Convert.ToInt32(e.CommandArgument);
                    string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        conn.Open();
                        string query = "UPDATE VisitorLogs SET TimeOut = GETDATE() WHERE VisitorID = @VisitorID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@VisitorID", visitorId);
                            cmd.ExecuteNonQuery();
                        }

                        string fullName = "";
                        string selectQuery = "SELECT FullName FROM VisitorLogs WHERE VisitorID = @VisitorID";
                        using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                        {
                            selectCmd.Parameters.AddWithValue("@VisitorID", visitorId);
                            object result = selectCmd.ExecuteScalar();
                            fullName = (result == DBNull.Value || string.IsNullOrWhiteSpace(result?.ToString()))
                                ? "Unknown Visitor"
                                : result.ToString();
                        }

                        string userSerial = Session["serial"]?.ToString() ?? "2500002";
                        LogHistory.Write("Visitor", $"'{fullName}' exited", visitorId.ToString(), userSerial);
                    }

                    // Refresh the GridView to remove updated rows
                    LoadPendingVisitors();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
            else if (e.CommandName == "ExitVehicle")
            {
                try
                {
                    int logId = Convert.ToInt32(e.CommandArgument);
                    string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        conn.Open();
                        string query = "UPDATE VehicleLog SET TimeOut = GETDATE() WHERE LogID = @LogID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@LogID", logId);
                            cmd.ExecuteNonQuery();
                        }

                        string plateNumber = "";
                        string selectQuery = "SELECT PlateNumber FROM VehicleLog WHERE LogID = @LogID";
                        using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                        {
                            selectCmd.Parameters.AddWithValue("@LogID", logId);
                            object result = selectCmd.ExecuteScalar();
                            plateNumber = (result == DBNull.Value || string.IsNullOrWhiteSpace(result?.ToString()))
                                ? "NO Plate Number Detected"
                                : result.ToString();
                        }

                        string userSerial = Session["serial"]?.ToString() ?? "2500002";
                        LogHistory.Write("Vehicle", $"'{plateNumber}' exited", logId.ToString(), userSerial);
                    }

                    // Refresh the GridView to remove updated rows
                    LoadPendingVehicles();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
            else if (e.CommandName == "Arrive")
            {
                try
                {
                    int logId = Convert.ToInt32(e.CommandArgument);
                    string connString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        conn.Open();
                        string query = "UPDATE UniversityVehiclesLogs SET Arrive = GETDATE() WHERE LogID = @LogID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@LogID", logId);
                            cmd.ExecuteNonQuery();
                        }

                        string plateNumber = "";
                        string driverName = "";
                        string selectQuery = "SELECT PlateNumber, DriverName FROM UniversityVehiclesLogs WHERE LogID = @LogID";
                        using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                        {
                            selectCmd.Parameters.AddWithValue("@LogID", logId);
                            using (SqlDataReader reader = selectCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    plateNumber = (reader["PlateNumber"] == DBNull.Value || string.IsNullOrWhiteSpace(reader["PlateNumber"]?.ToString()))
                                        ? "NO Plate Number Detected"
                                        : reader["PlateNumber"].ToString();
                                    driverName = (reader["DriverName"] == DBNull.Value || string.IsNullOrWhiteSpace(reader["DriverName"]?.ToString()))
                                        ? "Unknown Driver"
                                        : reader["DriverName"].ToString();
                                }
                                else
                                {
                                    plateNumber = "NO Plate Number Detected";
                                    driverName = "Unknown Driver";
                                }
                            }
                        }

                        string userSerial = Session["serial"]?.ToString() ?? "2500002";
                        LogHistory.Write("UniversityVehicle", $"'{plateNumber}' driven by {driverName} arrived", logId.ToString(), userSerial);
                    }

                    // Refresh the GridView to remove updated rows
                    LoadPendingUniversityVehicles();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
            }
        }
    }
}