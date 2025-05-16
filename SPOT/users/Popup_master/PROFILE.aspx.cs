using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SPOT.users.Popup_master
{
    public partial class PROFILE : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProfileData();
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUploadProfile.HasFile)
            {
                string serial = Session["Serial"] as string;
                if (string.IsNullOrEmpty(serial))
                {
                    Response.Write("<script>alert('Error: No serial found. Please log in again.');</script>");
                    return;
                }

                string fileExt = Path.GetExtension(fileUploadProfile.FileName).ToLower();
                if (fileExt != ".jpg" && fileExt != ".png")
                {
                    Response.Write("<script>alert('Only JPG and PNG files are allowed.');</script>");
                    return;
                }

                if (fileUploadProfile.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    Response.Write("<script>alert('File size exceeds 5MB limit.');</script>");
                    return;
                }

                string folderPath = Server.MapPath("~/images/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string oldImagePath = Path.Combine(folderPath, $"profile_{serial}.png");
                if (File.Exists(oldImagePath))
                {
                    File.Delete(oldImagePath);
                }

                string fileName = $"profile_{serial}.png";
                string savePath = Path.Combine(folderPath, fileName);
                fileUploadProfile.SaveAs(savePath);

                byte[] imageData;
                using (BinaryReader br = new BinaryReader(fileUploadProfile.PostedFile.InputStream))
                {
                    imageData = br.ReadBytes(fileUploadProfile.PostedFile.ContentLength);
                }

                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM dbo.images WHERE serial = @Serial";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Serial", serial);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            string updateQuery = "UPDATE dbo.images SET Img = @Img WHERE serial = @Serial";
                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@Serial", serial);
                                updateCmd.Parameters.AddWithValue("@Img", imageData);
                                int rowsAffected = updateCmd.ExecuteNonQuery();

                                if (rowsAffected == 0)
                                {
                                    string insertQuery = "INSERT INTO dbo.images (serial, Img) VALUES (@Serial, @Img)";
                                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                                    {
                                        insertCmd.Parameters.AddWithValue("@Serial", serial);
                                        insertCmd.Parameters.AddWithValue("@Img", imageData);
                                        insertCmd.ExecuteNonQuery();
                                    }
                                }
                            }
                        }
                        else
                        {
                            string insertQuery = "INSERT INTO dbo.images (serial, Img) VALUES (@Serial, @Img)";
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@Serial", serial);
                                insertCmd.Parameters.AddWithValue("@Img", imageData);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                LoadProfileImage();
                Image1.ImageUrl = $"~/images/{fileName}?t=" + DateTime.Now.Ticks;
                btnRemove.Visible = true; // Explicitly set Remove button visible
            }
        }

        protected void LoadProfileData()
        {
            lblLastName.Text = (Session["LastName"] as string ?? "N/A").ToUpper();
            lblMiddleInitial.Text = (Session["MiddleInitial"] as string ?? " ").ToUpper();
            lblFirstName.Text = (Session["FirstName"] as string ?? "N/A").ToUpper();
            lblAddress.Text = Session["Address"] as string ?? "N/A";
            lblPhoneHidden.Text = MaskPhoneNumber(Session["PhoneNumber"] as string ?? "N/A");
            lblEmail.Text = MaskEmail(Session["Email"] as string ?? "N/A");

            if (Session["AccCreated"] != null && DateTime.TryParse(Session["AccCreated"].ToString(), out DateTime accCreatedDate))
            {
                lblAccCreatedAgo.Text = GetTimeAgo(accCreatedDate);
            }
            else
            {
                lblAccCreatedAgo.Text = "N/A";
            }

            LoadProfileImage();
        }

        private void LoadProfileImage()
        {
            string serial = Session["Serial"] as string;
            if (string.IsNullOrEmpty(serial))
            {
                Image1.ImageUrl = "~/images/default-profile.png";
                btnRemove.Visible = false;
                // Debug: Log session issue
                System.Diagnostics.Debug.WriteLine("LoadProfileImage: Serial is null or empty");
                return;
            }

            bool hasImage = false;
            string fileName = $"profile_{serial}.png";
            string imagePath = Server.MapPath($"~/images/{fileName}");

            // Check database for image
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Img FROM dbo.images WHERE serial = @Serial";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Serial", serial);
                        object imgData = cmd.ExecuteScalar();

                        if (imgData != null && imgData != DBNull.Value)
                        {
                            byte[] imageBytes = (byte[])imgData;
                            string base64String = Convert.ToBase64String(imageBytes);
                            Image1.ImageUrl = "data:image/png;base64," + base64String;
                            hasImage = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Debug: Log database error
                    System.Diagnostics.Debug.WriteLine($"LoadProfileImage: Database error - {ex.Message}");
                }
            }

            // Fallback: Check file system
            if (!hasImage && File.Exists(imagePath))
            {
                Image1.ImageUrl = $"~/images/{fileName}?t=" + DateTime.Now.Ticks;
                hasImage = true;
            }

            // Set default image if no image found
            if (!hasImage)
            {
                Image1.ImageUrl = "~/images/default-profile.png";
            }

            // Set Remove button visibility
            btnRemove.Visible = hasImage;
            // Debug: Log button visibility state
            System.Diagnostics.Debug.WriteLine($"LoadProfileImage: btnRemove.Visible = {btnRemove.Visible}, hasImage = {hasImage}");
        }

        private string GetTimeAgo(DateTime dateTime)
        {
            TimeSpan timeDiff = DateTime.Now - dateTime;

            if (timeDiff.TotalSeconds < 60)
                return $"{(int)timeDiff.TotalSeconds} seconds ago";
            if (timeDiff.TotalMinutes < 60)
                return $"{(int)timeDiff.TotalMinutes} minutes ago";
            if (timeDiff.TotalHours < 24)
                return $"{(int)timeDiff.TotalHours} hours ago";
            if (timeDiff.TotalDays < 30)
                return $"{(int)timeDiff.TotalDays} days ago";
            if (timeDiff.TotalDays < 365)
                return $"{(int)(timeDiff.TotalDays / 30)} months ago";

            return $"{(int)(timeDiff.TotalDays / 365)} years ago";
        }

        private string MaskPhoneNumber(string phone)
        {
            if (phone.Length >= 4)
                return "****" + phone.Substring(phone.Length - 4);
            return "****";
        }

        private string MaskEmail(string email)
        {
            if (!email.Contains("@")) return "***@***.com";
            string[] parts = email.Split('@');
            string domain = parts[1];
            return $"{parts[0].Substring(0, 2)}***@{domain}";
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            string serial = Session["Serial"] as string;
            if (string.IsNullOrEmpty(serial))
            {
                Response.Write("<script>alert('Error: No serial found. Please log in again.');</script>");
                return;
            }

            // Delete image from file system
            string imagePath = Server.MapPath($"~/images/profile_{serial}.png");
            if (File.Exists(imagePath))
            {
                File.Delete(imagePath);
            }

            // Delete image from database
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string deleteQuery = "DELETE FROM dbo.images WHERE serial = @Serial";
                using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Serial", serial);
                    cmd.ExecuteNonQuery();
                }
            }

            // Reset UI
            Image1.ImageUrl = "~/images/default-profile.png";
            btnRemove.Visible = false;
        }
    }
}