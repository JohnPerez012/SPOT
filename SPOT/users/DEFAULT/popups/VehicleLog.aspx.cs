using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Web.Services;
using SPOT.users.DEFAULT.popups.masterFunctions;

namespace SPOT.users.DEFAULT
{
    public partial class VehicleLog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtsetoutDateTime.Text = txtDateTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            }
        }

       protected void btnSetOut_Click(object sender, EventArgs e)
        {
            string plateNumber = txtSetOutPlateNumber.Text.Trim();
            string driverName = txtSetOutDriverName.Text.Trim();
            string personCount = txtSetOutPersonCount.Text.Trim();
            string purpose = txtSetOutPurpose.Text.Trim();

            // Validate required fields
            if (string.IsNullOrWhiteSpace(plateNumber) || string.IsNullOrWhiteSpace(driverName) || 
                string.IsNullOrWhiteSpace(personCount) || string.IsNullOrWhiteSpace(purpose))
            {
                Response.Write("<script>alert('⚠ Please fill in all required fields.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                      INSERT INTO UniversityVehiclesLogs (PlateNumber, DriverName, PersonCount, Purpose) 
                            VALUES (@PlateNumber, @DriverName , @PersonCount , @Purpose)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                    cmd.Parameters.AddWithValue("@DriverName", driverName);
                    cmd.Parameters.AddWithValue("@PersonCount", personCount);
                    cmd.Parameters.AddWithValue("@Purpose", purpose);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        Response.Write("<script>alert('✅ Vehicle Entry Logged Successfully!');</script>");
                    }
                    catch (SqlException ex)
                    {
                        Response.Write($"<script>alert('⚠ Error logging entry: {ex.Message.Replace("'", "\\'")}');</script>");
                        return;
                    }
                }

                // Use global primary key method to get the inserted record's ID
                int referenceId = DbHelper.GetPrimaryKeyValue("VehicleLog", "PlateNumber", plateNumber);

                // Log the action
                string userSerial = Session["serial"]?.ToString() ?? "2500002";
                LogHistory.Write("Vehicle", $"'{plateNumber}' Entered", referenceId.ToString(), userSerial);
            }

        }

        [WebMethod]
        public static string CheckVehicle(string plateNumber)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            var result = new
            {
                exists = false,
                vehicleID = 0,
                plateNumber = "",
                vehicleType = "",
                vehicleColor = "",
                ownerName = "",
                contactNumber = ""
            };

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    SELECT VehicleID, PlateNumber, VehicleType, VehicleColor, OwnerName, ContactNumber 
                    FROM Vehicles 
                    WHERE PlateNumber = @PlateNumber";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            result = new
                            {
                                exists = true,
                                vehicleID = Convert.ToInt32(reader["VehicleID"]),
                                plateNumber = reader["PlateNumber"].ToString(),
                                vehicleType = reader["VehicleType"].ToString(),
                                vehicleColor = reader["VehicleColor"].ToString(),
                                ownerName = reader["OwnerName"].ToString(),
                                contactNumber = reader["ContactNumber"] != DBNull.Value ? reader["ContactNumber"].ToString() : ""
                            };
                        }
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(result);
        }


        [WebMethod]
        public static string CheckUniVehicle(string plateNumber)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            var result = new
            {
                exists = false,
                vehicleID = 0,
                plateNumber = "",
                vehicleType = "",
                vehicleColor = ""
            };

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    SELECT VehicleID, PlateNumber, VehicleType, VehicleColor
                    FROM UniversityVehicles 
                    WHERE PlateNumber = @PlateNumber";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            result = new
                            {
                                exists = true,
                                vehicleID = Convert.ToInt32(reader["VehicleID"]),
                                plateNumber = reader["PlateNumber"].ToString(),
                                vehicleType = reader["VehicleType"].ToString(),
                                vehicleColor = reader["VehicleColor"].ToString()
                            };
                        }
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(result);
        }

        protected void btnLogEntry_Click(object sender, EventArgs e)
        {
            string plateNumber = txtPlateNumber.Text.Trim();
            string vehicleType = ddlVehicleType.SelectedValue;
            string vehicleColor = txtVehicleColor.Text.Trim();
            string driverName = txtDriverName.Text.Trim();
            string driverType = ddlDriverType.SelectedValue;
            string purpose = txtPurpose.Text.Trim();
            string contactNumber = txtContactNumber.Text.Trim();

            // Validate required fields
            if (string.IsNullOrWhiteSpace(plateNumber) || string.IsNullOrWhiteSpace(vehicleType) ||
                string.IsNullOrWhiteSpace(vehicleColor) || string.IsNullOrWhiteSpace(driverName) ||
                string.IsNullOrWhiteSpace(driverType) || string.IsNullOrWhiteSpace(purpose))
            {
                Response.Write("<script>alert('⚠ Please fill in all required fields.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    INSERT INTO VehicleLog (PlateNumber, VehicleType, VehicleColor, DriverName, DriverType, Purpose, ContactNumber) 
                    VALUES (@PlateNumber, @VehicleType, @VehicleColor, @DriverName, @DriverType, @Purpose, @ContactNumber)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                    cmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                    cmd.Parameters.AddWithValue("@VehicleColor", vehicleColor);
                    cmd.Parameters.AddWithValue("@DriverName", driverName);
                    cmd.Parameters.AddWithValue("@DriverType", driverType);
                    cmd.Parameters.AddWithValue("@Purpose", purpose);
                    cmd.Parameters.AddWithValue("@ContactNumber", string.IsNullOrEmpty(contactNumber) ? DBNull.Value : (object)contactNumber);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        Response.Write("<script>alert('✅ Vehicle Entry Logged Successfully!');</script>");
                    }
                    catch (SqlException ex)
                    {
                        Response.Write($"<script>alert('⚠ Error logging entry: {ex.Message.Replace("'", "\\'")}');</script>");
                        return;
                    }
                }

                // Use global primary key method to get the inserted record's ID
                int referenceId = DbHelper.GetPrimaryKeyValue("VehicleLog", "PlateNumber", plateNumber);

                // Log the action
                string userSerial = Session["serial"]?.ToString() ?? "2500002";
                LogHistory.Write("Vehicle", $"'{plateNumber}' Entered", referenceId.ToString(), userSerial);
            }   
        }
    }
}