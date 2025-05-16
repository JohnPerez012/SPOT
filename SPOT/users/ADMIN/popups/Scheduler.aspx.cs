using System;
using System.Web.UI;

namespace SPOT.users.ADMIN.popups
{
    public partial class Scheduler : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initial data loading or setup
                LoadSchedulerData();
            }
        }

        // Method to load the scheduler data
        private void LoadSchedulerData()
        {
            // Logic to fetch data from the database or other sources
            // Example:
            var shifts = GetShiftsFromDatabase();
            var guards = GetGuardsFromDatabase();

            // Optionally, store this data in session or pass to frontend for initialization
            Session["Shifts"] = shifts;
            Session["Guards"] = guards;
        }

        // Method to get shift data from the database
        private object GetShiftsFromDatabase()
        {
            // Replace this with actual database fetching logic
            return new[]
            {
                new { Id = 1, Start = "2025-04-03T08:00:00", End = "2025-04-03T18:00:00", Resource = "A", Text = "Day Shift" },
                new { Id = 2, Start = "2025-04-03T18:00:00", End = "2025-04-04T07:00:00", Resource = "A", Text = "Night Shift" }
            };
        }

        // Method to get guard data from the database
        private object GetGuardsFromDatabase()
        {
            // Replace this with actual database fetching logic
            return new[]
            {
                new { GuardName = "Guard 1", GuardId = "A" },
                new { GuardName = "Guard 2", GuardId = "B" },
                new { GuardName = "Guard 3", GuardId = "C" },
                new { GuardName = "Guard 4", GuardId = "D" }
            };
        }

        // A sample method to retrieve guard assignment dynamically
        protected string GetGuard(string day, string shift)
        {
            // This should fetch guard assignments based on the day and shift
            // Example logic - fetching from the session or database
            var guards = (object[])Session["Guards"];
            return shift == "Day" ? "Guard 1" : "Guard 2"; // Example assignment logic
        }
    }
}
