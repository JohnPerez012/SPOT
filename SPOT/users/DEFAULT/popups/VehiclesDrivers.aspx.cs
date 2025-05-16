using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace SPOT.users.DEFAULT.popups
{
    public partial class VehiclesDrivers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                System.Diagnostics.Debug.WriteLine("Page_Load: Initial load");
                txtOwnerName.Attributes.Add("onchange", "this.form.submit();");
                btnRegisterDriver.Attributes.Add("onclick", "console.log('Register Driver button clicked from ASP.NET');");
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("Page_Load: Postback occurred");
            }
        }

        private static readonly Dictionary<string, string> HexToColorName = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { "#F0F8FF", "AliceBlue" }, { "#FAEBD7", "AntiqueWhite" }, { "#00FFFF", "Aqua" }, { "#7FFFD4", "Aquamarine" },
            { "#F0FFFF", "Azure" }, { "#F5F5DC", "Beige" }, { "#FFE4C4", "Bisque" }, { "#000000", "Black" },
            { "#FFEBCD", "BlanchedAlmond" }, { "#0000FF", "Blue" }, { "#8A2BE2", "BlueViolet" }, { "#A52A2A", "Brown" },
            { "#DEB887", "BurlyWood" }, { "#5F9EA0", "CadetBlue" }, { "#7FFF00", "Chartreuse" }, { "#D2691E", "Chocolate" },
            { "#FF7F50", "Coral" }, { "#6495ED", "CornflowerBlue" }, { "#FFF8DC", "Cornsilk" }, { "#DC143C", "Crimson" },
            { "#00008B", "DarkBlue" }, { "#008B8B", "DarkCyan" }, { "#B8860B", "DarkGoldenRod" }, { "#A9A9A9", "DarkGray" },
            { "#006400", "DarkGreen" }, { "#BDB76B", "DarkKhaki" }, { "#8B008B", "DarkMagenta" }, { "#556B2F", "DarkOliveGreen" },
            { "#FF8C00", "DarkOrange" }, { "#9932CC", "DarkOrchid" }, { "#8B0000", "DarkRed" }, { "#E9967A", "DarkSalmon" },
            { "#8FBC8F", "DarkSeaGreen" }, { "#483D8B", "DarkSlateBlue" }, { "#2F4F4F", "DarkSlateGray" }, { "#00CED1", "DarkTurquoise" },
            { "#9400D3", "DarkViolet" }, { "#FF1493", "DeepPink" }, { "#00BFFF", "DeepSkyBlue" }, { "#696969", "DimGray" },
            { "#1E90FF", "DodgerBlue" }, { "#B22222", "FireBrick" }, { "#FFFAF0", "FloralWhite" }, { "#228B22", "ForestGreen" },
            { "#FF00FF", "Fuchsia" }, { "#DCDCDC", "Gainsboro" }, { "#F8F8FF", "GhostWhite" }, { "#FFD700", "Gold" },
            { "#DAA520", "GoldenRod" }, { "#808080", "Gray" }, { "#008000", "Green" }, { "#ADFF2F", "GreenYellow" },
            { "#F0FFF0", "HoneyDew" }, { "#FF69B4", "HotPink" }, { "#CD5C5C", "IndianRed" }, { "#4B0082", "Indigo" },
            { "#FFFFF0", "Ivory" }, { "#F0E68C", "Khaki" }, { "#E6E6FA", "Lavender" }, { "#FFF0F5", "LavenderBlush" },
            { "#7CFC00", "LawnGreen" }, { "#FFFACD", "LemonChiffon" }, { "#ADD8E6", "LightBlue" }, { "#F08080", "LightCoral" },
            { "#E0FFFF", "LightCyan" }, { "#FAFAD2", "LightGoldenRodYellow" }, { "#D3D3D3", "LightGray" }, { "#90EE90", "LightGreen" },
            { "#FFB6C1", "LightPink" }, { "#FFA07A", "LightSalmon" }, { "#20B2AA", "LightSeaGreen" }, { "#87CEFA", "LightSkyBlue" },
            { "#778899", "LightSlateGray" }, { "#B0C4DE", "LightSteelBlue" }, { "#FFFFE0", "LightYellow" }, { "#00FF00", "Lime" },
            { "#32CD32", "LimeGreen" }, { "#FAF0E6", "Linen" }, { "#800000", "Maroon" }, { "#66CDAA", "MediumAquaMarine" },
            { "#0000CD", "MediumBlue" }, { "#BA55D3", "MediumOrchid" }, { "#9370DB", "MediumPurple" }, { "#3CB371", "MediumSeaGreen" },
            { "#7B68EE", "MediumSlateBlue" }, { "#00FA9A", "MediumSpringGreen" }, { "#48D1CC", "MediumTurquoise" }, { "#C71585", "MediumVioletRed" },
            { "#191970", "MidnightBlue" }, { "#F5FFFA", "MintCream" }, { "#FFE4E1", "MistyRose" }, { "#FFE4B5", "Moccasin" },
            { "#FFDEAD", "NavajoWhite" }, { "#000080", "Navy" }, { "#FDF5E6", "OldLace" }, { "#808000", "Olive" },
            { "#6B8E23", "OliveDrab" }, { "#FFA500", "Orange" }, { "#FF4500", "OrangeRed" }, { "#DA70D6", "Orchid" },
            { "#EEE8AA", "PaleGoldenRod" }, { "#98FB98", "PaleGreen" }, { "#AFEEEE", "PaleTurquoise" }, { "#DB7093", "PaleVioletRed" },
            { "#FFEFD5", "PapayaWhip" }, { "#FFDAB9", "PeachPuff" }, { "#CD853F", "Peru" }, { "#FFC0CB", "Pink" },
            { "#DDA0DD", "Plum" }, { "#B0E0E6", "PowderBlue" }, { "#800080", "Purple" }, { "#663399", "RebeccaPurple" },
            { "#FF0000", "Red" }, { "#BC8F8F", "RosyBrown" }, { "#4169E1", "RoyalBlue" }, { "#8B4513", "SaddleBrown" },
            { "#FA8072", "Salmon" }, { "#F4A460", "SandyBrown" }, { "#2E8B57", "SeaGreen" }, { "#FFF5EE", "Seashell" },
            { "#A0522D", "Sienna" }, { "#C0C0C0", "Silver" }, { "#87CEEB", "SkyBlue" }, { "#6A5ACD", "SlateBlue" },
            { "#708090", "SlateGray" }, { "#FFFAFA", "Snow" }, { "#00FF7F", "SpringGreen" }, { "#4682B4", "SteelBlue" },
            { "#D2B48C", "Tan" }, { "#008080", "Teal" }, { "#D8BFD8", "Thistle" }, { "#FF6347", "Tomato" },
            { "#40E0D0", "Turquoise" }, { "#EE82EE", "Violet" }, { "#F5DEB3", "Wheat" }, { "#FFFFFF", "White" },
            { "#F5F5F5", "WhiteSmoke" }, { "#FFFF00", "Yellow" }, { "#9ACD32", "YellowGreen" }
        };

        private bool IsDriverRegistered(string ownerName)
        {
            if (string.IsNullOrWhiteSpace(ownerName))
                return false;

            try
            {
                System.Diagnostics.Debug.WriteLine($"IsDriverRegistered: Checking for {ownerName}");
                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT COUNT(1) FROM Drivers WHERE UPPER(FullName) = UPPER(@FullName)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", ownerName);
                        int count = (int)cmd.ExecuteScalar();
                        System.Diagnostics.Debug.WriteLine($"IsDriverRegistered: Found {count} drivers with name {ownerName}");
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in IsDriverRegistered: {ex.Message}");
                Response.Write($"<script>alert('⚠ Error checking driver: {ex.Message.Replace("'", "\\'")}');</script>");
                return false;
            }
        }

        [WebMethod]
        public static object GetDriverDetails(string fullName, string contactNumber)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"GetDriverDetails: Checking FullName={fullName}, ContactNumber={contactNumber}");
                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT DriverID, FullName, ContactNumber, DriverType FROM Drivers WHERE UPPER(FullName) = UPPER(@FullName) OR UPPER(ContactNumber) = UPPER(@ContactNumber)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", string.IsNullOrEmpty(fullName) ? (object)DBNull.Value : fullName);
                        cmd.Parameters.AddWithValue("@ContactNumber", string.IsNullOrEmpty(contactNumber) ? (object)DBNull.Value : contactNumber);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return new
                                {
                                    DriverID = reader["DriverID"].ToString(),
                                    FullName = reader["FullName"].ToString(),
                                    ContactNumber = reader["ContactNumber"].ToString(),
                                    DriverType = reader["DriverType"].ToString()
                                };
                            }
                        }
                    }
                }
                System.Diagnostics.Debug.WriteLine("GetDriverDetails: No driver found");
                return null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetDriverDetails: {ex.Message}");
                return null;
            }
        }

        [WebMethod]
        public static object UpdateDriver(int driverId, string fullName, string contactNumber, string driverType)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"UpdateDriver: Updating DriverID={driverId}, FullName={fullName}, ContactNumber={contactNumber}, DriverType={driverType}");
                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Check for duplicate contact number (excluding current driver)
                    string checkQuery = "SELECT COUNT(1) FROM Drivers WHERE UPPER(ContactNumber) = UPPER(@ContactNumber) AND DriverID != @DriverID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@ContactNumber", contactNumber);
                        checkCmd.Parameters.AddWithValue("@DriverID", driverId);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine($"UpdateDriver: Contact number {contactNumber} already registered");
                            return new { success = false, error = "This contact number is already registered to another driver." };
                        }
                    }

                    // Update driver
                    string updateQuery = "UPDATE Drivers SET FullName = @FullName, ContactNumber = @ContactNumber, DriverType = @DriverType WHERE DriverID = @DriverID";
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@DriverID", driverId);
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@ContactNumber", contactNumber);
                        cmd.Parameters.AddWithValue("@DriverType", driverType);
                        cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("UpdateDriver: Driver updated successfully");
                        return new { success = true };
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in UpdateDriver: {ex.Message}");
                return new { success = false, error = ex.Message };
            }
        }

        protected void txtOwnerName_TextChanged(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("txtOwnerName_TextChanged: Started");
                string ownerName = txtOwnerName.Text.Trim();
                System.Diagnostics.Debug.WriteLine($"txtOwnerName_TextChanged: OwnerName={ownerName}");
                if (string.IsNullOrWhiteSpace(ownerName))
                {
                    txtOwnerName.CssClass = "input-fields";
                    btnRegisterVehicle.Enabled = false;
                    ViewState["IsDriverRegistered"] = false;
                    ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", "updateVehicleValidation(false);", true);
                    return;
                }

                bool isRegistered = IsDriverRegistered(ownerName);
                txtOwnerName.CssClass = "input-fields " + (isRegistered ? "valid-driver" : "invalid-driver");
                btnRegisterVehicle.Enabled = isRegistered;
                ViewState["IsDriverRegistered"] = isRegistered;
                ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", $"updateVehicleValidation({(isRegistered ? "true" : "false")});", true);
                System.Diagnostics.Debug.WriteLine($"txtOwnerName_TextChanged: isRegistered={isRegistered}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in txtOwnerName_TextChanged: {ex.Message}");
                Response.Write($"<script>alert('⚠ Error validating owner name: {ex.Message.Replace("'", "\\'")}');</script>");
            }
        }

        protected void btnRegisterVehicle_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("btnRegisterVehicle_Click: Started");
                string plateNumber = txtPlateNumber.Text.Trim();
                string vehicleType = ddlVehicleType.SelectedValue;
                string vehicleColor = txtVehicleColor.Text.Trim();
                string ownerName = txtOwnerName.Text.Trim();
                string contactNumber = txtVehicleContact.Text.Trim();

                System.Diagnostics.Debug.WriteLine($"btnRegisterVehicle_Click: PlateNumber={plateNumber}, VehicleType={vehicleType}, VehicleColor={vehicleColor}, OwnerName={ownerName}, ContactNumber={contactNumber}");

                if (string.IsNullOrWhiteSpace(plateNumber) || string.IsNullOrWhiteSpace(ownerName) || string.IsNullOrWhiteSpace(vehicleType) || string.IsNullOrWhiteSpace(vehicleColor))
                {
                    if (string.IsNullOrWhiteSpace(ownerName))
                    {
                        txtOwnerName.CssClass = "input-fields invalid-driver";
                    }
                    ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", $"updateVehicleValidation({(IsDriverRegistered(ownerName) ? "true" : "false")});", true);
                    Response.Write("<script>alert('⚠ Error: Missing required fields.');</script>");
                    return;
                }

                if (!IsDriverRegistered(ownerName))
                {
                    txtOwnerName.CssClass = "input-fields invalid-driver";
                    ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", "updateVehicleValidation(false);", true);
                    Response.Write("<script>alert('⚠ Error: Owner must be a registered driver. Please register the driver first.');</script>");
                    return;
                }

                if (!string.IsNullOrWhiteSpace(vehicleColor) && vehicleColor.StartsWith("#") && HexToColorName.ContainsKey(vehicleColor.ToUpper()))
                {
                    vehicleColor = HexToColorName[vehicleColor.ToUpper()];
                    System.Diagnostics.Debug.WriteLine($"btnRegisterVehicle_Click: Converted color to {vehicleColor}");
                }

                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO Vehicles (PlateNumber, VehicleType, VehicleColor, OwnerName, ContactNumber) 
                        VALUES (@PlateNumber, @VehicleType, @VehicleColor, @OwnerName, @ContactNumber)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                        cmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                        cmd.Parameters.AddWithValue("@VehicleColor", vehicleColor);
                        cmd.Parameters.AddWithValue("@OwnerName", ownerName);
                        cmd.Parameters.AddWithValue("@ContactNumber", contactNumber);

                        cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("btnRegisterVehicle_Click: Vehicle inserted successfully");
                        Response.Write("<script>alert('✅ Vehicle Registered Successfully!'); window.location='VehiclesDrivers.aspx';</script>");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnRegisterVehicle_Click: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", $"updateVehicleValidation({(IsDriverRegistered(txtOwnerName.Text.Trim()) ? "true" : "false")});", true);
                Response.Write($"<script>alert('⚠ Error registering vehicle: {ex.Message.Replace("'", "\\'")}');</script>");
            }
        }

        protected void btnUVRegisterVehicle_Click(object sender, EventArgs e)
        {
            try
            {
                string plateNumber = txtPlateNumberUVR.Text.Trim();
                string vehicleType = ddlVehicleTypeUVR.SelectedValue;
                string vehicleColor = txtVehicleColorUVR.Text.Trim();


                if (string.IsNullOrWhiteSpace(plateNumber)|| string.IsNullOrWhiteSpace(vehicleType) || string.IsNullOrWhiteSpace(vehicleColor))
                {
 
                    Response.Write("<script>alert('⚠ Error: Missing required fields.');</script>");
                    return;
                }


                if (!string.IsNullOrWhiteSpace(vehicleColor) && vehicleColor.StartsWith("#") && HexToColorName.ContainsKey(vehicleColor.ToUpper()))
                {
                    vehicleColor = HexToColorName[vehicleColor.ToUpper()];
                    System.Diagnostics.Debug.WriteLine($"btnRegisterVehicle_Click: Converted color to {vehicleColor}");
                }

                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"	     
           INSERT INTO UniversityVehicles (PlateNumber, VehicleType, VehicleColor) 
									VALUES (@PlateNumber, @VehicleType, @VehicleColor)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PlateNumber", plateNumber);
                        cmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                        cmd.Parameters.AddWithValue("@VehicleColor", vehicleColor);

                        cmd.ExecuteNonQuery();
                        Response.Write("<script>alert('✅ Vehicle Registered Successfully!'); window.location='VehiclesDrivers.aspx';</script>");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnRegisterVehicle_Click: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "updateVehicleValidation", $"updateVehicleValidation({(IsDriverRegistered(txtOwnerName.Text.Trim()) ? "true" : "false")});", true);
                Response.Write($"<script>alert('⚠ Error registering vehicle: {ex.Message.Replace("'", "\\'")}');</script>");
            }
        }

        protected void btnRegisterDriver_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("btnRegisterDriver_Click: Started");
                string fullName = txtDriverName.Text.Trim();
                string contactNumber = txtDriverContact.Text.Trim();
                string driverType = ddlRole.SelectedValue.Trim();

                System.Diagnostics.Debug.WriteLine($"btnRegisterDriver_Click: FullName={fullName}, ContactNumber={contactNumber}, DriverType={driverType}");

                if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(contactNumber) || string.IsNullOrWhiteSpace(driverType))
                {
                    System.Diagnostics.Debug.WriteLine("btnRegisterDriver_Click: Missing required fields");
                    if (string.IsNullOrWhiteSpace(fullName))
                    {
                        txtDriverName.CssClass = "input-fields invalid-driver";
                    }
                    if (string.IsNullOrWhiteSpace(contactNumber))
                    {
                        txtDriverContact.CssClass = "input-fields invalid-driver";
                    }
                    ClientScript.RegisterStartupScript(this.GetType(), "updateDriverValidation", "updateDriverValidation();", true);
                    Response.Write("<script>alert('⚠ Error: Missing required fields.');</script>");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Check for duplicate full name or contact number
                    string checkQuery = "SELECT COUNT(1) FROM Drivers WHERE UPPER(FullName) = UPPER(@FullName) OR UPPER(ContactNumber) = UPPER(@ContactNumber)";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@FullName", fullName);
                        checkCmd.Parameters.AddWithValue("@ContactNumber", contactNumber);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine($"btnRegisterDriver_Click: Duplicate found for FullName={fullName} or ContactNumber={contactNumber}");
                            txtDriverName.CssClass = "input-fields invalid-driver";
                            txtDriverContact.CssClass = "input-fields invalid-driver";
                            ClientScript.RegisterStartupScript(this.GetType(), "updateDriverValidation", "updateDriverValidation();", true);
                            Response.Write("<script>alert('⚠ Error: Full name or contact number is already registered.');</script>");
                            return;
                        }
                    }

                    // Insert new driver
                    string insertQuery = "INSERT INTO Drivers (FullName, ContactNumber, DriverType) VALUES (@FullName, @ContactNumber, @DriverType)";
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@ContactNumber", contactNumber);
                        cmd.Parameters.AddWithValue("@DriverType", driverType);

                        cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("btnRegisterDriver_Click: Driver inserted successfully");
                        Response.Write("<script>alert('✅ Driver Registered Successfully!'); window.location='VehiclesDrivers.aspx';</script>");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnRegisterDriver_Click: {ex.Message}");
                txtDriverName.CssClass = "input-fields invalid-driver";
                txtDriverContact.CssClass = "input-fields invalid-driver";
                ClientScript.RegisterStartupScript(this.GetType(), "updateDriverValidation", "updateDriverValidation();", true);
                Response.Write($"<script>alert('⚠ Error registering driver: {ex.Message.Replace("'", "\\'")}');</script>");
            }
        }
    
    
    
    }
}