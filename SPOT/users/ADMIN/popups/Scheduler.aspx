    <%@ Page Language="C#" AutoEventWireup="true" CodeFile="Scheduler.aspx.cs" Inherits="SPOT.users.ADMIN.popups.Scheduler" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>DayPilot Scheduler</title>
        <script src="/Scripts/DayPilot/daypilot-all.min.js"></script>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            #dp {
        width: 100%;
        height: 500px; /* <- Add this */
    }
    .scheduler-container {
      width: 100%;
      padding: 20px;
      font-family: Arial, sans-serif;
    }

    .scheduler-header {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-bottom: 10px;
      gap: 10px;
    }

    .scheduler-header button {
      padding: 5px 10px;
      cursor: pointer;
    }

    .scheduler-grid table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }

    .scheduler-grid th, .scheduler-grid td {
      border: 1px solid #ccc;
      text-align: center;
      height: 80px;
      position: relative;
    }

    .time-slot {
      width: 150px;
      background-color: #f3f4f6;
      font-weight: bold;
    }

    .drop-zone {
      background-color: #fff;
    }

    .scheduler-legend {
      margin-top: 20px;
    }

    .legend-item {
      display: inline-block;
      padding: 5px 10px;
      margin-right: 10px;
      color: #fff;
      border-radius: 5px;
    }
    </style>
    </head>
    <body>
        <form id="form1" runat="server">
    <div class="scheduler-container">
      <div class="scheduler-header">
        <button onclick="prevMonth()">◀</button>
        <span id="month-label">April 2025</span>
        <button onclick="nextMonth()">▶</button>
      </div>

      <div class="scheduler-grid">
        <table>
          <thead>
            <tr>
              <th>Week</th>
              <th colspan="2">Monday</th>
              <th colspan="2">Tuesday</th>
              <th colspan="2">Wednesday</th>
              <th colspan="2">Thursday</th>
              <th colspan="2">Friday</th>
              <th colspan="2">Saturday</th>
              <th colspan="2">Sunday</th>
            </tr>
            <tr>
              <th></th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
              <th>Day</th>
              <th>Night</th>
            </tr>
          </thead>
          <tbody>
            <% 
              // Calculate the start of the month and the start of each week
              DateTime firstDayOfMonth = new DateTime(2025, 4, 1);
              DateTime startOfWeek = firstDayOfMonth.AddDays(-(int)firstDayOfMonth.DayOfWeek); // Adjust to the previous Sunday
          
              for (int week = 1; week <= 5; week++) { 
            %>
            <tr>
              <td class="week-label">Week <%= week %></td>
              <% 
                string[] days = { "mon", "tue", "wed", "thu", "fri", "sat", "sun" }; 
                for (int dayIndex = 0; dayIndex < days.Length; dayIndex++) {
                  DateTime dayOfWeek = startOfWeek.AddDays(dayIndex + ((week - 1) * 7)); // Calculate the actual date for each day
                  string dayId = days[dayIndex] + "_day_week" + week;
                  string nightId = days[dayIndex] + "_night_week" + week;
              %>
                <td id="<%= dayId %>" class="drop-zone">
                </td>
                <td id="<%= nightId %>" class="drop-zone">
                  <span class="day-date"><%= dayOfWeek.Day %></span>
                </td>
              <% } %>
            </tr>
            <% 
                startOfWeek = startOfWeek.AddDays(7); // Move to the next week
              } 
            %>
          </tbody>
        </table>
      </div>

      <div class="scheduler-legend">
        <strong>Legend:</strong>
        <span class="legend-item" style="background-color: #22c55e;">Guard A</span>
        <span class="legend-item" style="background-color: #f59e0b;">Guard B</span>
      </div>
    </div>

    <style>
      .drop-zone {
        position: relative;
        padding: 10px;
        border: 1px solid #ddd;
        height: 60px;
        text-align: center;
      }

      .day-date {
        position: absolute;
        top: 5px;
        right: 5px;
        font-size: 18px;
        font-weight: bold;
        color: #333;
      }
    </style>


        </form>

        <script>
            const dp = new DayPilot.Scheduler("dp", {
                startDate: "2025-04-01",
                days: 365,
                scale: "Day",
                timeHeaders: [
                    { groupBy: "Month", format: "MMMM yyyy" },
                    { groupBy: "Day", format: "d" }
                ],
                treeEnabled: true,
                treePreventParentUsage: true,
                heightSpec: "Max",
                height: 400,
                eventMovingStartEndEnabled: true,
                eventResizingStartEndEnabled: true,
                timeRangeSelectingStartEndEnabled: true,
                contextMenu: new DayPilot.Menu({
                    items: [
                        {
                            text: "Counter",
                            counter: 0,
                            onClick: (args) => {
                                args.preventDefault();
                                dp.contextMenu.items[0].text = "Counter: " + (++args.item.counter);
                                dp.contextMenu.update();
                            }
                        },
                        {
                            text: "Edit",
                            onClick: (args) => {
                                dp.events.edit(args.source);
                            }
                        },
                        {
                            text: "Delete",
                            onClick: (args) => {
                                dp.events.remove(args.source);
                            }
                        },
                        { text: "-" },
                        {
                            text: "Select",
                            onClick: (args) => {
                                dp.multiselect.add(args.source);
                            }
                        },
                    ]
                }),
                bubble: new DayPilot.Bubble({
                    onLoad: (args) => {
                        const e = args.source;
                        const text = DayPilot.Util.escapeHtml(e.text());
                        const start = e.start().toString("M/d/yyyy h:mm tt");
                        const end = e.end().toString("M/d/yyyy h:mm tt");
                        args.html = `<div><b>${text}</b></div><div>Start: ${start}</div><div>End: ${end}</div>`;
                    }
                }),
                onEventMoved: (args) => {
                    const text = args.e.text();
                    dp.message(`The event has been moved (${text})`);
                },
                onEventMoving: (args) => {
                    if (args.e.resource() === "A" && args.resource === "B") {
                        args.left.enabled = false;
                        args.right.html = "You can't move an event from Room 1 to Room 2";
                        args.allowed = false;
                    }
                    else if (args.resource === "B") {
                        while (args.start.getDayOfWeek() === 0 || args.start.getDayOfWeek() === 6) {
                            args.start = args.start.addDays(1);
                        }
                        args.end = args.start.addDays(1);
                        args.left.enabled = false;
                        args.right.html = "Events in Room 2 must start on a workday and are limited to 1 day.";
                    }
                },
                onEventResized: (args) => {
                    dp.message("Resized: " + args.e.text());
                },
                onTimeRangeSelected: async (args) => {
                    const modal = await DayPilot.Modal.prompt("New event name:", "New Event");
                    dp.clearSelection();
                    if (modal.canceled) return;
                    const name = modal.result;
                    dp.events.add({
                        start: args.start,
                        end: args.end,
                        id: DayPilot.guid(),
                        resource: args.resource,
                        text: name
                    });
                    dp.message("Created");
                },
                onEventMove: (args) => {
                    if (args.ctrl) {
                        dp.events.add({
                            start: args.newStart,
                            end: args.newEnd,
                            text: "Copy of " + args.e.text(),
                            resource: args.newResource,
                            id: DayPilot.guid()
                        });
                        args.preventDefault();
                    }
                },
                onEventClick: (args) => {
                    DayPilot.Modal.alert(args.e.data.text);
                },
                separators: [
                    { location: new DayPilot.Date("2024-09-01"), color: "red", toolTip: "Test" },
                ],
            });

            dp.init();
            dp.scrollTo("2025-04-01");

            const app = {
                barColor(i) {
                    const colors = ["#3c78d8", "#6aa84f", "#f1c232", "#cc0000"];
                    return colors[i % 4];
                },
                barBackColor(i) {
                    const colors = ["#a4c2f4", "#b6d7a8", "#ffe599", "#ea9999"];
                    return colors[i % 4];
                },
                loadData() {
                    const resources = [
                        {
                            name: "Locations", id: "G1", expanded: true, children: [
                                { name: "Room 1", id: "A" },
                                { name: "Room 2", id: "B" },
                                { name: "Room 3", id: "C" },
                                { name: "Room 4", id: "D" }
                            ]
                        },
                        {
                            name: "People", id: "G2", expanded: true, children: [
                                { name: "Person 1", id: "E" },
                                { name: "Person 2", id: "F" },
                                { name: "Person 3", id: "G" },
                                { name: "Person 4", id: "H" }
                            ]
                        },
                        {
                            name: "Tools", id: "G3", expanded: true, children: [
                                { name: "Tool 1", id: "I" },
                                { name: "Tool 2", id: "J" },
                                { name: "Tool 3", id: "K" },
                                { name: "Tool 4", id: "L" }
                            ]
                        },
                        {
                            name: "Other Resources", id: "G4", expanded: true, children: [
                                { name: "Resource 1", id: "R1" },
                                { name: "Resource 2", id: "R2" },
                                { name: "Resource 3", id: "R3" },
                                { name: "Resource 4", id: "R4" }
                            ]
                        }
                    ];

                    const events = [];
                    for (let i = 0; i < 12; i++) {
                        const duration = Math.floor(Math.random() * 6) + 1;
                        const durationDays = Math.floor(Math.random() * 6) + 1;
                        const start = Math.floor(Math.random() * 6) + 2;

                        const e = {
                            start: new DayPilot.Date("2025-04-05T12:00:00").addDays(start),
                            end: new DayPilot.Date("2025-04-05T12:00:00").addDays(start + durationDays).addHours(duration),
                            id: i + 1,
                            resource: String.fromCharCode(65 + i),
                            text: "Event " + (i + 1),
                            bubbleHtml: "Event " + (i + 1),
                            barColor: app.barColor(i),
                            barBackColor: app.barBackColor(i)
                        };

                        events.push(e);
                    }

                    dp.update({ resources, events });
                    dp.resources = resources;

                    dp.events.list = [
                        {
                            id: "1",
                            resource: "A", // Room 1
                            start: "2025-04-01T07:00:00",
                            end: "2025-04-01T19:00:00",
                            text: "Guard A (Day)",
                            backColor: "#22c55e"
                        },
                        {
                            id: "2",
                            resource: "A",
                            start: "2025-04-01T19:00:00",
                            end: "2025-04-02T07:00:00",
                            text: "Guard B (Night)",
                            backColor: "#f59e0b"
                        }
                    ];

                    dp.update();

                }
            };
            document.querySelectorAll(".drop-zone").forEach(zone => {
                zone.addEventListener("click", () => {
                    const guardName = prompt("Assign guard:");
                    if (guardName) {
                        zone.innerHTML += `<div>${guardName}</div>`;
                        zone.style.backgroundColor = guardName === "Guard A" ? "#22c55e" : "#f59e0b";
                    }
                });
            });


            let currentMonth = new Date(2025, 3); // April 2025 (0-indexed)

            function renderMonthLabel() {
                document.getElementById("month-label").innerText =
                    currentMonth.toLocaleString('default', { month: 'long', year: 'numeric' });
            }

            function prevMonth() {
                currentMonth.setMonth(currentMonth.getMonth() - 1);
                renderMonthLabel();
                // Optionally reload table grid and DayPilot data
            }

            function nextMonth() {
                currentMonth.setMonth(currentMonth.getMonth() + 1);
                renderMonthLabel();
            }
            renderMonthLabel();

            app.loadData();
        </script>
    </body>
    </html>





