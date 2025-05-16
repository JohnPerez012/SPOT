using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SPOT.users.DEFAULT.popups
{
    public partial class Schedule : Page
    {
        protected int CurrentYear;
        protected int CurrentMonth;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (gvSchedule == null)
                {
                    Response.Write("<script>console.error('GridView is null. Check its ID and make sure it is declared in the ASPX page.');</script>");
                    return;
                }

                CurrentYear = Request.QueryString["year"] != null ? Convert.ToInt32(Request.QueryString["year"]) : DateTime.Now.Year;
                CurrentMonth = Request.QueryString["month"] != null ? Convert.ToInt32(Request.QueryString["month"]) : DateTime.Now.Month;

                GenerateSchedule(CurrentYear, CurrentMonth);
            }
        }

        protected void gvSchedule_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Resource resource = (Resource)e.Row.DataItem;

                for (int i = 1; i <= DateTime.DaysInMonth(CurrentYear, CurrentMonth); i++) // Adjust for month days
                {
                    TableCell cell = e.Row.Cells[i];
                    cell.Controls.Clear();

                    // Fetch events from DB
                    string eventsHtml = GetEventsHtml(resource.ResourceId, i);

                    LiteralControl divControl = new LiteralControl($"<div id='cell-{resource.ResourceId}-{i}' class='schedule-box' onclick=\"addEvent('{resource.ResourceId}', '{i}')\">{eventsHtml}</div>");
                    cell.Controls.Add(divControl);
                }
            }
        }

        // Method to fetch saved events from the database
        private string GetEventsHtml(int resourceId, int day)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LogsDB"].ConnectionString;
            int eventCount = 0;
            string lastEventName = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT EventName FROM ScheduleEvents WHERE ResourceId = @resourceId AND EventDay = @day", conn))
                {
                    cmd.Parameters.AddWithValue("@resourceId", resourceId);
                    cmd.Parameters.AddWithValue("@day", day);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            eventCount++;
                            lastEventName = reader["EventName"].ToString();
                        }
                    }
                }
            }

            if (eventCount == 0) return "";
            if (eventCount == 1) return $"<div class='event'>{lastEventName}</div>";
            return $"<div class='event'>{lastEventName} (+{eventCount - 1})</div>"; // Show count if more than one event
        }




        public class Resource
        {
            public int ResourceId { get; set; }
            public string ResourceName { get; set; }
        }


        private void GenerateSchedule(int year, int month)
        {
            gvSchedule.AutoGenerateColumns = false;
            gvSchedule.Columns.Clear();

            // Add Resource Name Column
            gvSchedule.Columns.Add(new BoundField
            {
                HeaderText = "Resource Name",
                DataField = "ResourceName"
            });

            // Determine number of days in the month
            int daysInMonth = DateTime.DaysInMonth(year, month);

            for (int i = 1; i <= daysInMonth; i++)
            {
                TemplateField field = new TemplateField
                {
                    HeaderText = i.ToString()
                };
                field.ItemTemplate = new ScheduleCellTemplate(year, month, i);
                gvSchedule.Columns.Add(field);
            }

            LoadResources();
        }

        private void LoadResources()
        {
            List<Resource> resources = new List<Resource>
            {
                new Resource { ResourceId = 1, ResourceName = "Resource A" },
                new Resource { ResourceId = 2, ResourceName = "Resource B" },
                new Resource { ResourceId = 3, ResourceName = "Resource C" }
            };

            gvSchedule.DataSource = resources;
            gvSchedule.DataBind();
        }

        public class ScheduleCellTemplate : ITemplate
        {
            private readonly int _year, _month, _day;

            public ScheduleCellTemplate(int year, int month, int day)
            {
                _year = year;
                _month = month;
                _day = day;
            }

            public void InstantiateIn(Control container)
            {
                string date = new DateTime(_year, _month, _day).ToString("yyyy-MM-dd");
                string link = $"<a href='EventDetails.aspx?date={date}'> {_day} </a>";
                LiteralControl lc = new LiteralControl($"<div class='schedule-box'>{link}</div>");
                container.Controls.Add(lc);
            }
        }
    }
}
