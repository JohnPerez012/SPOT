using System;
using System.IO;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

public class UploadHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string serial = context.Session["Serial"] as string;
        HttpPostedFile file = context.Request.Files["croppedImage"];

        if (string.IsNullOrEmpty(serial))
        {
            context.Response.Write("No session.");
            return;
        }

        if (file == null || file.ContentLength == 0)
        {
            context.Response.Write("No file.");
            return;
        }

        try
        {
            string path = context.Server.MapPath("~/images/");
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            string filePath = Path.Combine(path, $"profile_{serial}.png");
            file.SaveAs(filePath);

            byte[] imageData;
            using (MemoryStream ms = new MemoryStream())
            {
                file.InputStream.CopyTo(ms);
                imageData = ms.ToArray();
            }

            string connStr = ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "IF EXISTS (SELECT 1 FROM images WHERE serial = @serial) " +
                               "UPDATE images SET Img = @Img WHERE serial = @serial " +
                               "ELSE INSERT INTO images (serial, Img) VALUES (@serial, @Img)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@serial", serial);
                    cmd.Parameters.AddWithValue("@Img", imageData);
                    cmd.ExecuteNonQuery();
                }
            }

            context.Response.Write("Success");
        }
        catch (Exception ex)
        {
            context.Response.Write("Error: " + ex.Message);
        }
    }

    public bool IsReusable => false;
}
