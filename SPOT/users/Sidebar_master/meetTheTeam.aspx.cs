using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace SPOT.users.Sidebar_master
{
    public partial class meetTheTeam : Page
    {

      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTeamData();
                BindSidebarMenu();

            }
        }

        private void LoadTeamData()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["accounts"].ConnectionString;
            List<TeamMember> members = new List<TeamMember>();
            Dictionary<int, ProfileData> profileData = LoadProfileData();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                  SELECT a.serial, a.fname, a.lname, a.mname, i.Img
                FROM accounts a
                LEFT JOIN images i ON a.serial = i.serial
                WHERE a.serial BETWEEN 725002 AND 725011";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            TeamMember member = new TeamMember
                            {
                                Serial = reader.GetInt32(0),
                                FirstName = reader.IsDBNull(1) ? "N /A" : (reader.GetString(1)).ToUpper(),
                                LastName = reader.IsDBNull(2) ? "N/A" : (reader.GetString(2)).ToUpper(),
                                MiddleInitial = reader.IsDBNull(3) ? "" : (reader.GetString(3)).ToUpper(),
                                ImageData = reader.IsDBNull(4) ? null : (byte[])reader[4]
                            };
                            ProfileData data = profileData.ContainsKey(member.Serial) ? profileData[member.Serial] : new ProfileData();
                            member.Position = string.IsNullOrEmpty(data.Position) ? "N/A" : data.Position;
                            member.Bio = string.IsNullOrEmpty(data.Bio) ? "N/A" : data.Bio;
                            members.Add(member);
                        }
                    }
                }
            }

            // Ensure exactly 10 members (pad with placeholders if needed)
            while (members.Count < 10)
            {
                members.Add(new TeamMember
                {
                    Serial = -1,
                    FirstName = "N/A",
                    LastName = "N/A",
                    MiddleInitial = "",
                    Position = "N/A",
                    Bio = "N/A",
                    ImageData = null
                });
            }

            // Define frame order as per your layout
            int[] frameOrder = { 1, 3, 5, 2, 4, 6, 8, 0, 7, 9 };
            for (int i = 0; i < 10; i++)
            {
                int memberIndex = frameOrder[i];
                TeamMember member = members[memberIndex];
                Panel frame = new Panel { CssClass = "team-frame" };

                // Logo
                Panel logo = new Panel { CssClass = "logo" };
                Image logoImg = new Image { ImageUrl = "~/images/logo.png", AlternateText = "Company Logo" };
                logo.Controls.Add(logoImg);

                // Profile Picture
                Panel picture = new Panel { CssClass = "profile-picture" };
                Image profileImg = new Image { AlternateText = "Team Member" };
                if (member.ImageData != null)
                {
                    string base64String = Convert.ToBase64String(member.ImageData);
                    profileImg.ImageUrl = "data:image/png;base64," + base64String;
                }
                else
                {
                    profileImg.ImageUrl = "~/images/default-profile.png";
                }
                picture.Controls.Add(profileImg);

                // Info Section
                Panel info = new Panel { CssClass = "info-section" };
                Literal position = new Literal
                {
                    Text = $"<div id='position-{member.Serial}' class='position' onclick='editField({member.Serial}, \"position\")'>{HttpUtility.HtmlEncode(member.Position)}</div>"
                };
                Literal name = new Literal
                {
                    Text = $"<div class='name'>{HttpUtility.HtmlEncode(member.LastName)}, {HttpUtility.HtmlEncode(member.FirstName)} {HttpUtility.HtmlEncode(member.MiddleInitial)}</div>"
                };
                Literal bio = new Literal
                {
                    Text = $"<div id='bio-{member.Serial}' class='bio' onclick='editField({member.Serial}, \"bio\")'>{HttpUtility.HtmlEncode(member.Bio)}</div>"
                };
                info.Controls.Add(position);
                info.Controls.Add(name);
                info.Controls.Add(bio);

                frame.Controls.Add(logo);
                frame.Controls.Add(picture);
                frame.Controls.Add(info);
                TeamGrid.Controls.Add(frame);
            }
        }

        private Dictionary<int, ProfileData> LoadProfileData()
        {
            string jsonPath = Server.MapPath("~/App_Data/PROFILES.json");
            if (File.Exists(jsonPath))
            {
                string json = File.ReadAllText(jsonPath);
                return JsonConvert.DeserializeObject<Dictionary<int, ProfileData>>(json) ?? new Dictionary<int, ProfileData>();
            }
            return new Dictionary<int, ProfileData>();
        }

        [WebMethod]
        public static string SaveProfileData(int serial, string field, string value)
        {
            try
            {
                string jsonPath = HttpContext.Current.Server.MapPath("~/App_Data/PROFILES.json");
                Dictionary<int, ProfileData> profileData = new Dictionary<int, ProfileData>();

                if (File.Exists(jsonPath))
                {
                    string json = File.ReadAllText(jsonPath);
                    profileData = JsonConvert.DeserializeObject<Dictionary<int, ProfileData>>(json) ?? new Dictionary<int, ProfileData>();
                }

                if (!profileData.ContainsKey(serial))
                {
                    profileData[serial] = new ProfileData();
                }

                if (field == "position")
                {
                    profileData[serial].Position = value;
                }
                else if (field == "bio")
                {
                    profileData[serial].Bio = value;
                }

                File.WriteAllText(jsonPath, JsonConvert.SerializeObject(profileData, Formatting.Indented));
                return JsonConvert.SerializeObject(new { success = true });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        private class TeamMember
        {
            public int Serial { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string MiddleInitial { get; set; }
            public string Position { get; set; }
            public string Bio { get; set; }
            public byte[] ImageData { get; set; }
        }

        private class ProfileData
        {
            public string Position { get; set; }
            public string Bio { get; set; }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Logout button clicked.");
            Session.Abandon();
            Response.Redirect("~/log_in/logout.aspx");
        }

        private void BindSidebarMenu()
        {
            var menuItems = new List<object>();

            // Safely get Serial from Session as a string
            string serial = Session["Serial"]?.ToString();
            if (string.IsNullOrEmpty(serial))
            {
                System.Diagnostics.Debug.WriteLine("Session['Serial'] is null or empty. Using default value.");
                serial = "DEFAULT"; // Fallback to "DEFAULT" if null or empty
            }

            // Define base paths
            string popupPath = "popups/";

            // Set menu items with dynamic URLs based on serial string
            if (serial == "725001")
            {
                menuItems = new List<object>
        {       
            new { Title = "Dashboard", Icon = "icon-dashboard", Url = Page.ResolveUrl($"~/users/ADMIN/Dashboard.aspx") },
            new { Title = "History", Icon = "icon-history", Url = Page.ResolveUrl($"~{popupPath}HistoryPopup.aspx") },
            new { Title = "Users", Icon = "icon-users", Url = Page.ResolveUrl($"~{popupPath}UsersPopup.aspx") },
            new { Title = "Officers", Icon = "icon-ood", Url = Page.ResolveUrl($"~{popupPath}OfficersPopup.aspx") },
            new { Title = "Meet DeVs", Icon = "icon-logout", Url = Page.ResolveUrl("~/meetTheTeam.aspx") },
            new { Title = "Program Info", Icon = "icon-info", Url = Page.ResolveUrl($"~{popupPath}ProgramInfoPopup.aspx") }
        };
            }
            else
            {
                menuItems = new List<object>
        {
            new { Title = "Dashboard", Icon = "icon-dashboard", Url = Page.ResolveUrl($"~/users/DEFAULT/Dashboard.aspx") },
            new { Title = "History", Icon = "icon-history", Url = Page.ResolveUrl($"~{popupPath}HistoryPopup.aspx") },
            new { Title = "Users", Icon = "icon-users", Url = Page.ResolveUrl($"~{popupPath}UsersPopup.aspx") },
            new { Title = "Officers", Icon = "icon-ood", Url = Page.ResolveUrl($"~{popupPath}OfficersPopup.aspx") },
            new { Title = "Meet DeVs", Icon = "icon-logout", Url = Page.ResolveUrl("~/meetTheTeam.aspx") },
            new { Title = "Program Info", Icon = "icon-info", Url = Page.ResolveUrl($"~{popupPath}ProgramInfoPopup.aspx") }
        };
            }

            SidebarMenu.DataSource = menuItems;
            SidebarMenu.DataBind();
            System.Diagnostics.Debug.WriteLine($"SidebarMenu bound successfully with {menuItems.Count} items.");
        }


    }
}