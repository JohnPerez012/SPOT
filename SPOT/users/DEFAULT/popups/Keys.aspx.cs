using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.Services;
using SPOT.users.DEFAULT.popups.masterFunctions;
using System.Web;

namespace SPOT.users.DEFAULT.popups
{
    public partial class Keys : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKeys();
            }
        }

        protected void LoadKeys()
        {
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    SELECT ck.KeyID, ck.KeyName, ck.IsBorrowed, ck.isLost, 
                           kr.BorrowerName, kr.ContactNumber, kr.BorrowerID, kr.BorrowTime
                    FROM CampusKeys ck
                    LEFT JOIN KeyRequests kr ON ck.KeyID = kr.KeyID AND kr.IsBorrowed = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        rptKeys.DataSource = dt;
                        rptKeys.DataBind();
                    }
                }
            }
        }

        protected void CreateNewKey(object sender, EventArgs e)
        {
            string keyName = txtKeyName.Text.Trim();
            if (string.IsNullOrWhiteSpace(keyName))
            {
                Response.Write("<script>alert('Key name is required.');</script>");
                return;
            }

            if (!chkConfirm.Checked)
            {
                Response.Write("<script>alert('Please check the confirmation box.');</script>");
                return;
            }

            string serial = HttpContext.Current.Session["serial"]?.ToString();
            if (string.IsNullOrWhiteSpace(serial))
            {
                Response.Write("<script>alert('Session serial is missing.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string checkQuery = "SELECT COUNT(*) FROM CampusKeys WHERE KeyName = @KeyName";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@KeyName", keyName);
                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        Response.Write("<script>alert('Key name already exists.');</script>");
                        return;
                    }
                }

                string insertQuery = "INSERT INTO [CampusKeys] (KeyName, serial) VALUES (@keyname, @serial)";
                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                {
                    insertCmd.Parameters.AddWithValue("@keyname", keyName);
                    insertCmd.Parameters.AddWithValue("@serial", serial);
                    insertCmd.ExecuteNonQuery();
                }
            }

            LogHistory.Write("Key", $"'{keyName}' created", "0", serial);
            Response.Write("<script>alert('Campus key created successfully!'); window.location='Keys.aspx';</script>");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string keyName = hiddenSelectedKey.Value.Trim();
            string name = txtName.Text.Trim();
            string id = txtID.Text.Trim();
            string contact = txtContact.Text.Trim();
            string purpose = txtPurpose.Text.Trim();
            DateTime borrowTime = DateTime.Now;

            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(id) ||
                string.IsNullOrWhiteSpace(contact) || string.IsNullOrWhiteSpace(purpose))
            {
                Response.Write("<script>alert('Please fill in all fields.');</script>");
                return;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(contact, @"^\+?\d{10,15}$"))
            {
                Response.Write("<script>alert('Invalid contact number. Use 10-15 digits, optionally starting with +.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        int keyId = GetKeyIdByKeyName(keyName, conn, transaction);
                        if (keyId == 0)
                        {
                            Response.Write("<script>alert('Key not found.');</script>");
                            return;
                        }

                        string checkQuery = "SELECT IsBorrowed, isLost FROM Camps[uKeys WHERE KeyID = @KeyID";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn, transaction))
                        {
                            checkCmd.Parameters.AddWithValue("@KeyID", keyId);
                            using (SqlDataReader reader = checkCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    if (reader.GetBoolean(0))
                                    {
                                        Response.Write("<script>alert('Key is already borrowed.');</script>");
                                        return;
                                    }
                                    if (reader.GetBoolean(1))
                                    {
                                        Response.Write("<script>alert('Key is marked as lost.');</script>");
                                        return;
                                    }
                                }
                                reader.Close();
                            }
                        }

                        string insertQuery = @"
                            INSERT INTO KeyRequests (KeyID, IsBorrowed, BorrowerName, BorrowerID, Purpose, BorrowTime, ContactNumber)
                            VALUES (@KeyID, 1, @Name, @ID, @Purpose, @BorrowTime, @Contact)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn, transaction))
                        {
                            insertCmd.Parameters.AddWithValue("@KeyID", keyId);
                            insertCmd.Parameters.AddWithValue("@Name", name);
                            insertCmd.Parameters.AddWithValue("@ID", id);
                            insertCmd.Parameters.AddWithValue("@Purpose", purpose);
                            insertCmd.Parameters.AddWithValue("@BorrowTime", borrowTime);
                            insertCmd.Parameters.AddWithValue("@Contact", contact);
                            insertCmd.ExecuteNonQuery();
                        }

                        string updateQuery = "UPDATE CampusKeys SET IsBorrowed = 1 WHERE KeyID = @KeyID";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn, transaction))
                        {
                            updateCmd.Parameters.AddWithValue("@KeyID", keyId);
                            updateCmd.ExecuteNonQuery();
                        }

                        string userSerial = HttpContext.Current.Session["serial"]?.ToString() ?? "2500002";
                        LogHistory.Write("Key", $"'{keyName}' borrowed for: {purpose}", keyId.ToString(), userSerial);

                        transaction.Commit();
                        Response.Write("<script>alert('Key borrowed successfully!'); window.location='Keys.aspx';</script>");
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Response.Write($"<script>alert('Error: {ex.Message.Replace("'", "\\'")}');</script>");
                    }
                }
            }
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            string keyName = ReturnKey.Value.Trim();
            string returneeName = txtReturnee.Text.Trim();
            DateTime returnTime = DateTime.Now;

            if (string.IsNullOrWhiteSpace(returneeName))
            {
                Response.Write("<script>alert('Enter returnee name.');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        int keyId = GetKeyIdByKeyName(keyName, conn, transaction);
                        if (keyId == 0)
                        {
                            Response.Write("<script>alert('Key not found.');</script>");
                            return;
                        }

                        string updateRequestQuery = @"
                            UPDATE KeyRequests 
                            SET IsBorrowed = 0, ReturneeName = @Returnee, ReturnTime = @ReturnTime 
                            WHERE KeyID = @KeyID AND IsBorrowed = 1";
                        using (SqlCommand updateCmd = new SqlCommand(updateRequestQuery, conn, transaction))
                        {
                            updateCmd.Parameters.AddWithValue("@Returnee", returneeName);
                            updateCmd.Parameters.AddWithValue("@ReturnTime", returnTime);
                            updateCmd.Parameters.AddWithValue("@KeyID", keyId);
                            int rowsAffected = updateCmd.ExecuteNonQuery();
                            if (rowsAffected == 0)
                            {
                                Response.Write("<script>alert('No active borrow request found for this key.');</script>");
                                return;
                            }
                        }

                        string updateKeyQuery = "UPDATE CampusKeys SET IsBorrowed = 0 WHERE KeyID = @KeyID";
                        using (SqlCommand updateCmd = new SqlCommand(updateKeyQuery, conn, transaction))
                        {
                            updateCmd.Parameters.AddWithValue("@KeyID", keyId);
                            updateCmd.ExecuteNonQuery();
                        }

                        LogHistory.Write("Key", $"'{keyName}' returned", keyId.ToString(), returneeName);

                        transaction.Commit();
                        Response.Write("<script>alert('Key returned successfully!'); window.location='Keys.aspx';</script>");
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Response.Write($"<script>alert('Error: {ex.Message.Replace("'", "\\'")}');</script>");
                    }
                }
            }
        }

        private int GetKeyIdByKeyName(string keyName, SqlConnection conn, SqlTransaction transaction)
        {
            string query = "SELECT KeyID FROM CampusKeys WHERE KeyName = @KeyName";
            using (SqlCommand cmd = new SqlCommand(query, conn, transaction))
            {
                cmd.Parameters.AddWithValue("@KeyName", keyName);
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }
    }
}