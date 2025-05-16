using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SPOT.users.ADMIN.popups
{
    public partial class RegisterPopup : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblAccCreatedAt.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtSerial.Text = GetNextSerialID();
            }
            Page.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None; // ✅ Disable Unobtrusive Mode
        }


        private string GetNextSerialID()
        {
            string nextSerial = "724999"; // Default value if the table is empty
            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT IDENT_CURRENT('accounts') + IDENT_INCR('accounts')"; // ✅ Correct Query

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


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string serial = txtSerial.Text.Trim();
            string pin = txtPin.Text.Trim();
            string fname = txtFirstName.Text.Trim();
            string lname = txtLastName.Text.Trim();
            string mname = txtMiddleName.Text.Trim(); // Can be empty (nullable)
            string fullname = $"{fname} {mname} {lname}".Trim(); // Auto-generate fullname
            string dob = txtDOB.Text.Trim();
            string address = txtAddress.Text.Trim();
            string phoneNumber = txtPhoneNumber.Text.Trim();
            string email = txtEmail.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO accounts (pin, fname, lname, mname, fullname, dob, address, phonenumber, email, acccreateat) " +
                               "VALUES (@Pin, @FName, @LName, @MName, @FullName, @DOB, @Address, @PhoneNumber, @Email, @AccCreateAt)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Pin", pin);
                    cmd.Parameters.AddWithValue("@FName", fname);
                    cmd.Parameters.AddWithValue("@LName", lname);
                    cmd.Parameters.AddWithValue("@MName", string.IsNullOrEmpty(mname) ? (object)DBNull.Value : mname);
                    cmd.Parameters.AddWithValue("@FullName", fullname);
                    cmd.Parameters.AddWithValue("@DOB", string.IsNullOrEmpty(dob) ? (object)DBNull.Value : dob);
                    cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(address) ? (object)DBNull.Value : address);
                    cmd.Parameters.AddWithValue("@PhoneNumber", string.IsNullOrEmpty(phoneNumber) ? (object)DBNull.Value : phoneNumber);
                    cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                    cmd.Parameters.AddWithValue("@AccCreateAt", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Write("<script>alert('Registration Successful!');</script>");
        }


        private string GenerateSerial()
        {
            string serial = "U" + new Random().Next(100000, 999999).ToString();
            return serial;
        }
    }
}
