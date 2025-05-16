using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SPOT.users.ADMIN.popups
{
	public partial class GuardScheduler : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGuards();
            }
        }

        private void LoadGuards()
        {
            // Sample binding from DB
            ddlGuard.DataSource = GetGuards(); // Replace with your actual DB call
            ddlGuard.DataTextField = "FullName";
            ddlGuard.DataValueField = "GuardID";
            ddlGuard.DataBind();
        }

        private DataTable GetGuards()
        {
            // You can replace this with real DB logic
            DataTable dt = new DataTable();
            dt.Columns.Add("GuardID");
            dt.Columns.Add("FullName");
            dt.Rows.Add("1", "Guard Alpha");
            dt.Rows.Add("2", "Guard Bravo");
            return dt;
        }


        protected void btnAssign_Click(object sender, EventArgs e)
        {
            // You can retrieve values like this
            string guardId = ddlGuard.SelectedValue;
            string guardName = ddlGuard.SelectedItem.Text;
            string post = ddlPost.SelectedValue;
            string shift = ddlShift.SelectedValue;
            string color = Request.Form["txtColor"]; // since it's a regular HTML input

            string selectedDatesJson = hfSelectedDates.Value;
            List<string> selectedDates = new List<string>();
            if (!string.IsNullOrEmpty(selectedDatesJson))
            {
                selectedDates = Newtonsoft.Json.JsonConvert.DeserializeObject<List<string>>(selectedDatesJson);
            }

            // TODO: Save the shift assignment to database or JSON file
            // Example logging
            System.Diagnostics.Debug.WriteLine($"Assigned {guardName} to {shift} shift at {post} on {string.Join(", ", selectedDates)} with color {color}");
        }



    }
}