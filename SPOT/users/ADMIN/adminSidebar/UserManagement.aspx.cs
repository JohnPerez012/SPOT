using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Globalization;
using DocumentFormat.OpenXml.Wordprocessing;
using System.IO;

namespace SPOT.users.ADMIN.adminSidebar {
    public partial class UserManagement : System.Web.UI.Page { 
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) { 
                ViewState["TotalUsers"] = DataSummary("TotalUsers"); 
                ViewState["TotalOfficers"] = DataSummary("TotalOfficers"); 
                ViewState["TotalAdmins"] = DataSummary("TotalAdmins"); 
                ViewState["AccountsRegistered"] = DataSummary("AccountsRegistered");
                ViewState["AccountsRemoved"] = DataSummary("AccountsRemoved"); BindSidebarMenu(); 
                LoadAccounts(); 
                // Set admin name
                                lblAdminName.Text = Session["AdminLastName"]?.ToString() ?? "Administrator"; 
            }
        }   
        
        protected string GetNextSerialID()
                {
                    string nextSerial = "724999"; // Default value if the table is empty
                    string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT IDENT_CURRENT('accounts') + IDENT_INCR('accounts')";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            conn.Open();
                            object result = cmd.ExecuteScalar();
                            if (result != null && result != DBNull.Value)
                            {
                                nextSerial = result.ToString();
                            }
                        }
                    }
                    return nextSerial;
                }

                [WebMethod]
                public static object GetRecord(string serial)
                {
                    if (string.IsNullOrEmpty(serial) || !int.TryParse(serial, out int serialInt))
                    {
                        return null; // Invalid serial
                    }

                    string connectionString = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                    try
                    {
                        using (SqlConnection conn = new SqlConnection(connectionString))
                        {
                            conn.Open();
                            string query = @"SELECT serial, fname, lname, mname, dob, address, phonenumber, email, alias, role, pin, fullname 
                                FROM Accounts WHERE serial = @serial";
                            SqlCommand cmd = new SqlCommand(query, conn);
                            cmd.Parameters.AddWithValue("@serial", serialInt);
                            SqlDataReader reader = cmd.ExecuteReader();

                            if (reader.Read())
                            {
                                // Format dob as YYYY-MM-DD for consistency
                                string dob = reader["dob"] != DBNull.Value ? reader["dob"].ToString().Trim() : "";
                                if (!string.IsNullOrEmpty(dob))
                                {
                                    if (DateTime.TryParse(dob, out DateTime dobDate))
                                    {
                                        dob = dobDate.ToString("yyyy-MM-dd");
                                    }
                                    else
                                    {
                                        dob = "";
                                    }
                                }

                                var record = new
                                {
                                    serial = reader["serial"].ToString(),
                                    fname = reader["fname"] != DBNull.Value ? reader["fname"].ToString() : "",
                                    lname = reader["lname"] != DBNull.Value ? reader["lname"].ToString() : "",
                                    mname = reader["mname"] != DBNull.Value ? reader["mname"].ToString() : "",
                                    dob = dob,
                                    address = reader["address"] != DBNull.Value ? reader["address"].ToString() : "",
                                    phonenumber = reader["phonenumber"] != DBNull.Value ? reader["phonenumber"].ToString() : "",
                                    email = reader["email"] != DBNull.Value ? reader["email"].ToString() : "",
                                    alias = reader["alias"] != DBNull.Value ? reader["alias"].ToString() : "",
                                    role = reader["role"] != DBNull.Value ? reader["role"].ToString() : "",
                                    pin = reader["pin"] != DBNull.Value ? reader["pin"].ToString() : "",
                                    fullname = reader["fullname"] != DBNull.Value ? reader["fullname"].ToString() : ""
                                };
                                reader.Close();
                                return record;
                            }
                            reader.Close();
                            return null; // Record not found
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Error fetching record: " + ex.Message);
                    }
                }

    protected void btnLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/log_in/logout.aspx");
        }

        private int DataSummary(string i)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            int count = 0;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "";
                    SqlCommand command;

                    if (i == "TotalUsers")
                    {
                        query = "SELECT COUNT(*) FROM Accounts";
                        command = new SqlCommand(query, connection);
                    }
                    else if (i == "TotalOfficers")
                    {
                        query = "SELECT COUNT(*) FROM Accounts WHERE Role = @Role";
                        command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@Role", "User");
                    }
                    else if (i == "TotalAdmins")
                    {
                        query = "SELECT COUNT(*) FROM Accounts WHERE Role = @Role";
                        command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@Role", "Admin");
                    }
                    else if (i == "AccountsRegistered")
                    {
                        query = "  SELECT COUNT(*) FROM Accounts WHERE  MONTH(acccreateat) = @Month AND YEAR(acccreateat) = @Year";
                        command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@Status", "Active");
                        command.Parameters.AddWithValue("@Month", DateTime.Now.Month);
                        command.Parameters.AddWithValue("@Year", DateTime.Now.Year);
                    }
                    else if (i == "AccountsRemoved")
                    {
                        query = "SELECT COUNT(*) FROM removedAccounts WHERE MONTH(dateRemoved) = @Month AND YEAR(dateRemoved) = @Year";
                        command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@Status", "Removed");
                        command.Parameters.AddWithValue("@Month", DateTime.Now.Month);
                        command.Parameters.AddWithValue("@Year", DateTime.Now.Year);
                    }
                    else
                    {
                        return 0; // Invalid input
                    }

                    count = (int)command.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                return 0;
            }

            return count;
        }

        private void BindSidebarMenu()
        {
            var menuItems = new List<object>
        {
            new { Title = "Dashboard", Icon = "icon-dashboard", Url = "/users/ADMIN/Dashboard.aspx" },
            new { Title = "User Management", Icon = "icon-users", Url = "UserManagement.aspx" },
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

        private void LoadAccounts()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT serial, fname, lname, mname, dob, address, phonenumber, email FROM Accounts ORDER BY serial";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    LogData = dt;
                }
                catch (Exception ex)
                {
                    Response.Write("Error loading logs: " + ex.Message + "<br/>");
                }
            }
        }

        protected void UpdateRecord(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

            try
            {
                string serialStr = Request.Form["serial"];
                if (string.IsNullOrEmpty(serialStr) || !int.TryParse(serialStr, out int serial))
                {
                    Response.Write("Error: Invalid or missing serial number.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Fetch the current record
                    string selectQuery = "SELECT fname, lname, mname, dob, address, phonenumber, email FROM Accounts WHERE serial = @serial";
                    SqlCommand selectCmd = new SqlCommand(selectQuery, conn);
                    selectCmd.Parameters.AddWithValue("@serial", serial);
                    SqlDataReader reader = selectCmd.ExecuteReader();

                    if (!reader.Read())
                    {
                        reader.Close();
                        Response.Write("No record found with the specified serial.");
                        return;
                    }

                    // Get current values from the database
                    string currentFname = reader["fname"] != DBNull.Value ? reader["fname"].ToString() : null;
                    string currentLname = reader["lname"] != DBNull.Value ? reader["lname"].ToString() : null;
                    string currentMname = reader["mname"] != DBNull.Value ? reader["mname"].ToString() : null;
                    string currentDob = reader["dob"] != DBNull.Value ? reader["dob"].ToString().Trim() : null;
                    string currentAddress = reader["address"] != DBNull.Value ? reader["address"].ToString() : null;
                    string currentPhonenumber = reader["phonenumber"] != DBNull.Value ? reader["phonenumber"].ToString() : null;
                    string currentEmail = reader["email"] != DBNull.Value ? reader["email"].ToString() : null;

                    reader.Close();

                    // Use form values if provided, otherwise use current database values
                    string fname = !string.IsNullOrEmpty(Request.Form["fname"]) ? Request.Form["fname"] : currentFname;
                    string lname = !string.IsNullOrEmpty(Request.Form["lname"]) ? Request.Form["lname"] : currentLname;
                    string mname = !string.IsNullOrEmpty(Request.Form["mname"]) ? Request.Form["mname"] : currentMname;
                    string dob = !string.IsNullOrEmpty(Request.Form["dob"]) ? Request.Form["dob"] : currentDob;
                    string address = !string.IsNullOrEmpty(Request.Form["address"]) ? Request.Form["address"] : currentAddress;
                    string phonenumber = !string.IsNullOrEmpty(Request.Form["phonenumber"]) ? Request.Form["phonenumber"] : currentPhonenumber;
                    string email = !string.IsNullOrEmpty(Request.Form["email"]) ? Request.Form["email"] : currentEmail;

                    // Update the record
                    string updateQuery = @"UPDATE Accounts 
                                      SET fname = @fname, lname = @lname, mname = @mname, 
                                          dob = @dob, address = @address, phonenumber = @phonenumber, 
                                          email = @email 
                                      WHERE serial = @serial";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@serial", serial);
                    updateCmd.Parameters.AddWithValue("@fname", (object)fname ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@lname", (object)lname ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@mname", (object)mname ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@dob", (object)dob ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@address", (object)address ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@phonenumber", (object)phonenumber ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@email", (object)email ?? DBNull.Value);

                    int rowsAffected = updateCmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        // Refresh the table
                        LoadAccounts();
                    }
                    else
                    {
                        Response.Write("No record updated.");
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error updating record:elia " + ex.Message + "<br/>");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Form is valid, save to DB or proceed
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                int serial = int.Parse(GetNextSerialID());
                string pin = txtPin.Text.Trim();
                string fname = txtFirstName.Text.Trim();
                string lname = txtLastName.Text.Trim();
                string mname = txtMiddleName.Text.Trim();
                string fullname = $"{fname} {(string.IsNullOrEmpty(mname) ? "" : mname + " ")}{lname}".Trim();
                string dobInput = txtDOB.Text.Trim();
                string address = txtAddress.Text.Trim();
                string phoneNumber = txtPhoneNumber.Text.Trim();
                string email = txtEmail.Text.Trim();
                string alias = txtAlias.Text.Trim();

                // Force parse Date of Birth as yyyy-MM-dd
                DateTime? dob = null;
                if (!string.IsNullOrEmpty(dobInput))
                {
                    dob = DateTime.ParseExact(dobInput, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                }

                string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO accounts (pin, fname, lname, mname, fullname, dob, address, phonenumber, email, acccreateat, alias) 
                                 VALUES (@Pin, @FName, @LName, @MName, @FullName, @DOB, @Address, @PhoneNumber, @Email, @AccCreateAt, @Alias)";
                    string addLockingAccount = "insert into accountlocked values (@Serial, @FullName, 0)";
                    string addintoDutySheet = "insert into[Officers_ON_DUTY] values(@Serial, @LName, @FName, @MName, 'User', 0, Null, Null)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlCommand cmd1 = new SqlCommand(addLockingAccount, conn);
                        SqlCommand cmd2 = new SqlCommand(addintoDutySheet, conn);

                        cmd1.Parameters.Add("@Serial", SqlDbType.NVarChar).Value = serial;
                        cmd2.Parameters.Add("@Serial", SqlDbType.NVarChar).Value = serial;
                        cmd.Parameters.Add("@Pin", SqlDbType.NVarChar).Value = pin;
                        cmd.Parameters.Add("@FName", SqlDbType.NVarChar).Value = fname;
                        cmd2.Parameters.Add("@FName", SqlDbType.NVarChar).Value = fname;
                        cmd.Parameters.Add("@LName", SqlDbType.NVarChar).Value = lname;
                        cmd2.Parameters.Add("@LName", SqlDbType.NVarChar).Value = lname;
                        cmd.Parameters.Add("@MName", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(mname) ? (object)DBNull.Value : mname;
                        cmd2.Parameters.Add("@MName", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(mname) ? (object)DBNull.Value : mname;
                        cmd.Parameters.Add("@FullName", SqlDbType.NVarChar).Value = fullname;
                        cmd1.Parameters.Add("@FullName", SqlDbType.NVarChar).Value = fullname;
                        cmd.Parameters.Add("@DOB", SqlDbType.Date).Value = dob.HasValue ? (object)dob.Value : DBNull.Value;
                        cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(address) ? (object)DBNull.Value : address;
                        cmd.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(phoneNumber) ? (object)DBNull.Value : phoneNumber;
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(email) ? (object)DBNull.Value : email;
                        cmd.Parameters.Add("@AccCreateAt", SqlDbType.DateTime).Value = DateTime.Now;
                        cmd.Parameters.Add("@Alias", SqlDbType.NVarChar).Value = alias;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        cmd1.ExecuteNonQuery();
                        cmd2.ExecuteNonQuery();


                    }
                }


               
                Response.Write("<script>alert('Registration Successful!'); window.location='UserManagement.aspx';</script>");
            }
            catch (FormatException)
            {
                Response.Write("<script>alert('Invalid Date of Birth format. Use YYYY-MM-DD.');</script>");
            }
            catch (SqlException ex)
            {
                Response.Write("<script>alert('Registration failed: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
            catch (Exception)
            {
                Response.Write("<script>alert('An unexpected error occurred. Please try again later.');</script>");
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string serial = hdnSerial.Value; // Get serial from hidden field
                System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Serial = {serial}");
                if (string.IsNullOrEmpty(serial) || !int.TryParse(serial, out int serialInt))
                {
                    System.Diagnostics.Debug.WriteLine("btnConfirmDelete_Click: Invalid serial number.");
                    Response.Write("<script>alert('Invalid serial number.');</script>");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();
                    try
                    {
                        // Fetch account details
                        string selectQuery = @"SELECT serial, pin, fname, lname, mname, fullname, dob, address, phonenumber, email, acccreateat, role, alias 
                                          FROM accounts WHERE serial = @Serial";
                        using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn, transaction))
                        {
                            selectCmd.Parameters.AddWithValue("@Serial", serialInt);
                            SqlDataReader reader = selectCmd.ExecuteReader();
                            if (reader.Read())
                            {
                                // Handle DOB parsing
                                object dobValue = reader["dob"] != DBNull.Value ? reader["dob"] : DBNull.Value;
                                if (dobValue != DBNull.Value)
                                {
                                    string dobStr = dobValue.ToString().Trim();
                                    if (!string.IsNullOrEmpty(dobStr) && DateTime.TryParse(dobStr, out DateTime dobDate))
                                    {
                                        dobValue = dobDate;
                                    }
                                    else
                                    {
                                        System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Invalid DOB format: {dobStr}");
                                        dobValue = DBNull.Value;
                                    }
                                }

                                // Insert into removedAccounts
                                string insertQuery = @"INSERT INTO removedAccounts (Serial, pin, fname, lname, mname, fullname, dob, address, phonenumber, email, acccreateat, role, alias, dateRemoved)
                                                  VALUES (@Serial, @Pin, @Fname, @Lname, @Mname, @Fullname, @Dob, @Address, @Phonenumber, @Email, @Acccreateat, @Role, @Alias, @DateRemoved)";
                                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn, transaction))
                                {
                                    insertCmd.Parameters.AddWithValue("@Serial", reader["serial"]);
                                    insertCmd.Parameters.AddWithValue("@Pin", reader["pin"] != DBNull.Value ? reader["pin"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Fname", reader["fname"] != DBNull.Value ? reader["fname"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Lname", reader["lname"] != DBNull.Value ? reader["lname"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Mname", reader["mname"] != DBNull.Value ? reader["mname"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Fullname", reader["fullname"] != DBNull.Value ? reader["fullname"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Dob", dobValue);
                                    insertCmd.Parameters.AddWithValue("@Address", reader["address"] != DBNull.Value ? reader["address"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Phonenumber", reader["phonenumber"] != DBNull.Value ? reader["phonenumber"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Email", reader["email"] != DBNull.Value ? reader["email"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Acccreateat", reader["acccreateat"] != DBNull.Value ? reader["acccreateat"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Role", reader["role"] != DBNull.Value ? reader["role"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@Alias", reader["alias"] != DBNull.Value ? reader["alias"] : DBNull.Value);
                                    insertCmd.Parameters.AddWithValue("@DateRemoved", DateTime.Now);
                                    reader.Close();
                                    int rowsInserted = insertCmd.ExecuteNonQuery();
                                    System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Rows inserted into removedAccounts: {rowsInserted}");
                                }

                                // Delete from accounts
                                string deleteQuery = "DELETE FROM accounts WHERE serial = @Serial";
                                using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn, transaction))
                                {
                                    deleteCmd.Parameters.AddWithValue("@Serial", serialInt);
                                    int rowsDeleted = deleteCmd.ExecuteNonQuery();
                                    System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Rows deleted from accounts: {rowsDeleted}");
                                }

                                string delete_account_locking = " DELETE FROM accountlocked WHERE serial = @Serial";
                                using (SqlCommand deleteCmd = new SqlCommand(delete_account_locking, conn, transaction))
                                {
                                    deleteCmd.Parameters.AddWithValue("@Serial", serialInt);
                                    int rowsDeleted = deleteCmd.ExecuteNonQuery();
                                    System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Rows deleted from accounts: {rowsDeleted}");
                                }

                                string delete_account_Dutytable = "  delete [Officers_ON_DUTY] where officersSerial = @Serial";
                                using (SqlCommand deleteCmd = new SqlCommand(delete_account_Dutytable, conn, transaction))
                                {
                                    deleteCmd.Parameters.AddWithValue("@Serial", serialInt);
                                    int rowsDeleted = deleteCmd.ExecuteNonQuery();
                                    System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Rows deleted from accounts: {rowsDeleted}");
                                }

                                string delete_account_DatabaseIMG = "delete images where serial = @Serial";
                                using (SqlCommand deleteCmd = new SqlCommand(delete_account_DatabaseIMG, conn, transaction))
                                {
                                    deleteCmd.Parameters.AddWithValue("@Serial", serialInt);
                                    int rowsDeleted = deleteCmd.ExecuteNonQuery();
                                    System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Rows deleted from accounts: {rowsDeleted}");
                                }

                                // Delete image from file system
                                string imagePath = Server.MapPath($"~/images/profile_{serial}.png");
                                if (File.Exists(imagePath))
                                {
                                    File.Delete(imagePath);
                                }



                                transaction.Commit();
                            }
                            else
                            {
                                reader.Close();
                                System.Diagnostics.Debug.WriteLine("btnConfirmDelete_Click: Account not found.");
                                Response.Write("<script>alert('Account not found.');</script>");
                                return;
                            }
                        }

                        // Refresh the table
                        LoadAccounts();
                        System.Diagnostics.Debug.WriteLine("btnConfirmDelete_Click: Table refreshed, redirecting.");
                        Response.Write("<script>alert('Account successfully removed.'); window.location='UserManagement.aspx';</script>");
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Error: {ex.Message}, StackTrace: {ex.StackTrace}");
                        Response.Write("<script>alert('Failed to delete account: " + ex.Message.Replace("'", "\\'") + "');</script>");
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnConfirmDelete_Click: Unexpected Error: {ex.Message}, StackTrace: {ex.StackTrace}");
                Response.Write("<script>alert('Unexpected error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }

        public DataTable LogData { get; set; }
    } }