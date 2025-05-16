

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web;
using System.Web.UI;
using Spire.Doc;
using Spire.Doc.Documents;

namespace SPOT.users.DEFAULT.popups
{
    public partial class Logs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = "Logs";

            if (!IsPostBack)
            {
                LoadLogs();
            }
        }


        [WebMethod]
        public static void GenerateProtectedDoc(string savePath)
        {
            Document doc = new Document();
            Section section = doc.AddSection();
            Paragraph para = section.AddParagraph();
            para.AppendText("This is a protected log file.");

            DataTable logData = (DataTable)HttpContext.Current.Session["LogData"];
            foreach (DataRow row in logData.Rows)
            {
                string logLine = $"{row["LogDate"]} {row["LogTime"]} - {row["LogType"]} - {row["Action"]} (Ref: {row["reference_id"]})";
                section.AddParagraph().AppendText(logLine);
            }

            doc.Protect(ProtectionType.AllowOnlyReading, "SPOTMODE!@#");

            doc.SaveToFile(savePath, FileFormat.Docx);
        }




        private void LoadLogs()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT HistoryLogID, LogDate, LogTime, LogType, Action, reference_id FROM HistoryLogs ORDER BY LogDate desc, LogTime desc";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    Response.Write("Rows retrieved: " + dt.Rows.Count + "<br/>");
                    LogData = dt;
                }
                catch (Exception ex)
                {
                    Response.Write("Error loading logs: " + ex.Message + "<br/>");
                }
            }
        }

        public DataTable LogData { get; set; }
    }
}



