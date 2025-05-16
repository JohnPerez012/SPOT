using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Services;
using System.Web;
using System.Web.UI;

namespace SPOT.users.Popup_master
{
    public partial class CALENDAR : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No need to call LoadEvents here since client-side handles it
        }

        [WebMethod]
        public static void SaveEvents(List<Event> events)
        {
            try
            {
                string directoryPath = HttpContext.Current.Server.MapPath("~/App_Data/calendarEvtns");
                string filePath = Path.Combine(directoryPath, "events.txt");

                // Ensure the directory exists
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }

                // Ensure log directory and file exist
                string logPath = HttpContext.Current.Server.MapPath("~/App_Data/logs");
                if (!Directory.Exists(logPath))
                {
                    Directory.CreateDirectory(logPath);
                }
                string logFile = Path.Combine(logPath, "error.log");
                if (!File.Exists(logFile))
                {
                    File.WriteAllText(logFile, "");
                }

                // Write events to text file in | delimited format
                using (StreamWriter writer = new StreamWriter(filePath, false))
                {
                    foreach (var evt in events)
                    {
                        string line = $"{evt.id}|{evt.title}|{evt.start}|{evt.end ?? ""}|{evt.backgroundColor}|{evt.borderColor}|{evt.textColor}|{evt.addedBy}|{evt.addedTime}|{evt.addedDate}|{evt.IsPublish}";
                        writer.WriteLine(line);
                    }
                }
            }
            catch (Exception ex)
            {
                string logFile = HttpContext.Current.Server.MapPath("~/App_Data/logs/error.log");
                File.AppendAllText(logFile, $"{DateTime.Now}: SaveEvents error: {ex.Message}\n{ex.StackTrace}\n");
                throw; // Rethrow to inform client of failure
            }
        }

        [WebMethod]
        public static List<Event> LoadEvents()
        {
            try
            {
                string directoryPath = HttpContext.Current.Server.MapPath("~/App_Data/calendarEvtns");
                string filePath = Path.Combine(directoryPath, "events.txt");

                // Ensure the directory exists
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }

                // Create an empty events file if it doesn't exist
                if (!File.Exists(filePath))
                {
                    File.WriteAllText(filePath, "");
                }

                List<Event> events = new List<Event>();
                if (File.Exists(filePath))
                {
                    string[] lines = File.ReadAllLines(filePath);
                    foreach (string line in lines)
                    {
                        if (!string.IsNullOrWhiteSpace(line))
                        {
                            string[] parts = line.Split('|');
                            if (parts.Length == 11) // Ensure correct number of fields
                            {
                                events.Add(new Event
                                {
                                    id = parts[0],
                                    title = parts[1],
                                    start = parts[2],
                                    end = string.IsNullOrEmpty(parts[3]) ? null : parts[3],
                                    backgroundColor = parts[4],
                                    borderColor = parts[5],
                                    textColor = parts[6],
                                    addedBy = parts[7],
                                    addedTime = parts[8],
                                    addedDate = parts[9],
                                    IsPublish = int.Parse(parts[10])
                                });
                            }
                            else
                            {
                                // Log invalid line
                                string logFile = HttpContext.Current.Server.MapPath("~/App_Data/logs/error.log");
                                File.AppendAllText(logFile, $"{DateTime.Now}: Invalid event line: {line}\n");
                            }
                        }
                    }
                }
                return events;
            }
            catch (Exception ex)
            {
                string logFile = HttpContext.Current.Server.MapPath("~/App_Data/logs/error.log");
                File.AppendAllText(logFile, $"{DateTime.Now}: LoadEvents error: {ex.Message}\n{ex.StackTrace}\n");
                throw; // Rethrow to inform client of failure
            }
        }

        public class Event
        {
            public string id { get; set; } = Guid.NewGuid().ToString();
            public string title { get; set; }
            public string start { get; set; }
            public string end { get; set; }
            public string backgroundColor { get; set; }
            public string borderColor { get; set; }
            public string textColor { get; set; }
            public string addedBy { get; set; }
            public string addedTime { get; set; }
            public string addedDate { get; set; }
            public int IsPublish { get; set; } = 1; // Default to true (visible to all)
        }
    }
}