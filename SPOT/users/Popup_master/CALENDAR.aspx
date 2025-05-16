<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="CALENDAR.aspx.cs" Inherits="SPOT.users.Popup_master.CALENDAR" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Offline Calendar with Selection Dropdown and Modal Popup</title>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }
        #calendarWrapper {
            width: 95vw;
            margin: auto;
            height: 95vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            box-sizing: border-box;
            background: white;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        #calendar {
            width: 100%;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
        }
        .modal-header { font-size: 18px; margin-bottom: 15px; }
        .modal-body { margin-bottom: 20px; }
        .modal-footer { text-align: right; }
        .modal-footer button {
            padding: 8px 16px;
            margin: 0 10px;
            cursor: pointer;
        }
        .modal-footer button.cancel { background-color: #ccc; }
        .modal-footer button.ok { background-color: #4CAF50; color: white; }
        .main-container { display: flex; height: 100vh; width: 100vw; }
        #calendar { width: 70%; padding: 20px; }
        .event-panel {
            width: 30%;
            background-color: #f4f4f4;
            padding: 20px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .event-card-container {
            width: 95%;
            min-height: 150px;
            background-color: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
            box-sizing: border-box;
            flex-grow: 1;
        }
        .event-card-container h3 { margin-top: 0; }
        .color-legend { margin-top: 20px; width: 95%; }
        .legend-item { display: flex; align-items: center; margin-bottom: 5px; }
        .legend-color { width: 20px; height: 20px; margin-right: 10px; border-radius: 3px; }
        .red { background-color: red; }
        .green { background-color: green; }
        .blue { background-color: blue; }
        .black { background-color: black; }
        @media (max-width: 768px) {
            .main-container { flex-direction: column; overflow: auto; }
            #calendar, .event-panel { width: 100%; }
        }
        .color-option-container {
            display: flex;
            justify-content: space-between;
            gap: 7px;
            width: 100%;
            margin-top: 15px;
        }
        .color-option {
            flex-grow: 1;
            height: 30px;
            cursor: pointer;
        }
        .fc-day-today {
            background-color: #fff !important; /* Preserve FullCalendar default with custom border */
            font-weight: bold !important;
            border: 2px solid black;
        }
        .fc-event-main-frame .fc-event-title-container {
            border-radius: 4px;
            padding: 2px 6px;
        }
        .fc-event-main-frame .fc-event-title {
            color: white !important;
            font-weight: bold;
        }
        .fc-daygrid-day-number {
            font-size: 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="main-container">    
        <div id="calendar"></div>

        <!-- Event Add Modal -->
        <div id="eventModal" class="modal">
            <div class="modal-content">
                <div class="modal-header"><h3>Enter Event Title</h3></div>
                <div class="modal-body">
                    <label for="eventTitle">Event Title:</label>
                    <input type="text" id="eventTitle" style="width:100%; padding:8px;" required>
                        <div id="selectedDatesText" style="margin-top:10px; font-size:14px; color:#444;"></div>
                    <label style="margin-top:10px;"><input type="checkbox" id="isPublish" checked> Publish to all</label>
                </div>
                <i>SELECT COLOR:</i>
                <div class="color-option-container">
                    <div class="color-option red" data-color="red"></div>
                    <div class="color-option green" data-color="green"></div>
                    <div class="color-option blue" data-color="blue"></div>
                    <div class="color-option black" data-color="black"></div>
                </div>
                <div id="selectedColorText" class="selected-color-text">
                    <span id="colorEmoji" class="emoji">❌</span>No color selected
                </div>
                <div class="modal-footer">
                    <button type="button" class="cancel" id="cancelButton">Cancel</button>
                    <button type="button" class="ok" id="okButton">OK</button>
                </div>
            </div>
        </div>

        <!-- Event Edit Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <div class="modal-header"><h3>Edit or Delete Event</h3></div>
                <div class="modal-body">
                    <label for="editTitle">Edit Title:</label>
                    <input type="text" id="editTitle" style="width:100%; padding:8px;" required>
                    <label for="editIsPublish" style="margin-top:10px;"><input type="checkbox" id="editIsPublish"> Publish to all</label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="delete" id="deleteButton">Delete</button>
                    <button type="button" class="ok" id="saveButton">Save</button>
                </div>
            </div>
        </div>

        <div class="event-panel">
            <div>
                <div class="event-card-container">
                    <h3>Today's Events</h3>
                    <div id="todayEvents"><p>No events today.</p></div>
                </div>
                <div class="event-card-container">
                    <h3>Tomorrow's Events</h3>
                    <div id="tomorrowEvents"><p>No events tomorrow.</p></div>
                </div>
                <div class="event-card-container">
                    <h3>Yesterday's Events</h3>
                    <div id="yesterdayEvents"><p>No events yesterday.</p></div>
                </div>
            </div>
            <div class="color-legend">
                <div class="legend-item"><div class="legend-color red"></div> Birthday</div>
                <div class="legend-item"><div class="legend-color green"></div> No Class Day</div>
                <div class="legend-item"><div class="legend-color blue"></div> Holiday</div>
                <div class="legend-item"><div class="legend-color black"></div> School Event</div>
            </div>
        </div>
    </div>
</form>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


    <script>
        let calendar;
        let localEvents = [];
        let selectedEvent = null;
        let selectedColor = 'cornflowerblue';

        function loadEvents() {
            console.log("Loading events...");
            return $.ajax({
                type: "POST",
                url: "CALENDAR.aspx/LoadEvents",
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            }).then(response => {
                console.log("LoadEvents response:", response.d);
                return response.d || [];
            }).catch(error => {
                console.error("LoadEvents error:", error);
                alert("Failed to load events. Check console for details.");
                return [];
            });
        }

        function saveEvents(events) {
            console.log("Saving events:", events);
            return $.ajax({
                type: "POST",
                url: "CALENDAR.aspx/SaveEvents",
                data: JSON.stringify({ events: events }),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            }).then(response => {
                console.log("SaveEvents response:", response);
                return response;
            }).catch(error => {
                console.error("SaveEvents error:", error);
                alert("Failed to save events. Check console for details.");
                throw error;
            });
        }

        function updateEventPanels() {
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            const tomorrow = new Date(today);
            tomorrow.setDate(today.getDate() + 1);

            const yesterday = new Date(today);
            yesterday.setDate(today.getDate() - 1);

            const formatDate = (date) => {
                const yyyy = date.getFullYear();
                const mm = String(date.getMonth() + 1).padStart(2, '0');
                const dd = String(date.getDate()).padStart(2, '0');
                return `${yyyy}-${mm}-${dd}`;
            };

            const todayStr = formatDate(today);
            const tomorrowStr = formatDate(tomorrow);
            const yesterdayStr = formatDate(yesterday);

            const todayContainer = document.getElementById("todayEvents");
            const tomorrowContainer = document.getElementById("tomorrowEvents");
            const yesterdayContainer = document.getElementById("yesterdayEvents");

            todayContainer.innerHTML = "";
            tomorrowContainer.innerHTML = "";
            yesterdayContainer.innerHTML = "";

            let todayEvents = [], tomorrowEvents = [], yesterdayEvents = [];

            localEvents.forEach(event => {
                const start = new Date(event.start);
                const end = event.end ? new Date(event.end) : new Date(event.start);
                if (event.end) end.setDate(end.getDate() - 1);

                for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
                    const dStr = formatDate(d);
                    if (dStr === todayStr) todayEvents.push(`${event.title} (by ${event.addedBy})`);
                    else if (dStr === tomorrowStr) tomorrowEvents.push(`${event.title} (by ${event.addedBy})`);
                    else if (dStr === yesterdayStr) yesterdayEvents.push(`${event.title} (by ${event.addedBy})`);
                }
            });

            todayContainer.innerHTML = todayEvents.length ? [...new Set(todayEvents)].join("<br>") : "No events today.";
            tomorrowContainer.innerHTML = tomorrowEvents.length ? [...new Set(tomorrowEvents)].join("<br>") : "No events tomorrow.";
            yesterdayContainer.innerHTML = yesterdayEvents.length ? [...new Set(yesterdayEvents)].join("<br>") : "No events yesterday.";
        }

        function showModal(start, end) {
            const modal = document.getElementById("eventModal");
            const input = document.getElementById("eventTitle");
            const addedByInput = document.getElementById("addedBy");
            const isPublishCheckbox = document.getElementById("isPublish");
            const text = document.getElementById("selectedDatesText");
            text.textContent = `Selected: ${getSelectionLabel(start, end)}`;
            modal.style.display = "block";
            input.value = "";
            isPublishCheckbox.checked = true;
        }

        function generateGuid() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        function getSelectionLabel(startStr, endStr) {
            const start = new Date(startStr);
            const end = new Date(endStr);
            const month = start.toLocaleString('default', { month: 'long' });
            const year = start.getFullYear();

            if (isWholeMonth(start, end)) return `Entire month of ${month} ${year}`;
            const weeks = getCalendarWeeksInMonth(year, start.getMonth());
            const selectedWeeks = weeks.map((week, i) => (
                datesMatch(start, week[0]) && datesMatch(end, week[6]) ? i + 1 : null
            )).filter(i => i !== null);

            if (selectedWeeks.length)
                return selectedWeeks.length === 1 ? `${ordinal(selectedWeeks[0])} week of ${month} ${year}` :
                    `${ordinal(selectedWeeks[0])} to ${ordinal(selectedWeeks.at(-1))} week of ${month} ${year}`;

            const days = [];
            let current = new Date(start); // Fixed typo here
            while (current <= end) {
                days.push(current.getDate());
                current.setDate(current.getDate() + 1);
            }
            return `This ${month} ${days.join(', ')} ${year}`;
        }

        function getCalendarWeeksInMonth(year, month) {
            const weeks = [];
            let date = new Date(year, month, 1);
            while (date.getDay() !== 0) date.setDate(date.getDate() - 1);
            do {
                const week = [];
                for (let i = 0; i < 7; i++) {
                    week.push(new Date(date));
                    date.setDate(date.getDate() + 1);
                }
                weeks.push(week);
            } while (date.getMonth() === month || (date.getMonth() === month + 1 && date.getDay() !== 0));
            return weeks;
        }

        function isWholeMonth(start, end) {
            const lastDay = new Date(start.getFullYear(), start.getMonth() + 1, 0).getDate();
            return start.getDate() === 1 && (end.getDate() === lastDay || end.getDate() === 1);
        }

        function datesMatch(d1, d2) {
            return d1.getFullYear() === d2.getFullYear() &&
                d1.getMonth() === d2.getMonth() &&
                d1.getDate() === d2.getDate();
        }

        function ordinal(n) {
            const s = ["th", "st", "nd", "rd"];
            const v = n % 100;
            return n + (s[(v - 20) % 10] || s[v] || s[0]);
        }

        function getSessionFullName() {
            const fullName = sessionStorage.getItem('userFullName') ||
                        "<%= Session["FullName"] != null ? Session["FullName"].ToString() : "Unknown User" %>";
            return fullName !== "Unknown User" ? fullName : "Unknown User";
        }
        //prompt("Please enter your full name (this will be saved for this session):") ||

        document.addEventListener('DOMContentLoaded', function () {
            const calendarEl = document.getElementById('calendar');
            const modal = document.getElementById("eventModal");
            const editModal = document.getElementById("editModal");
            const input = document.getElementById("eventTitle");
            const addedByInput = document.getElementById("addedBy");
            const isPublishCheckbox = document.getElementById("isPublish");

            // Define modal button handlers once on page load
            document.getElementById("okButton").onclick = () => {
                console.log("OK button clicked");
                const title = input.value.trim();
                const addedBy = getSessionFullName();
                if (!title || !addedBy) {
                    alert("Please enter both a title and your full name.");
                    return;
                }
                const now = new Date();
                const newEvent = {
                    id: generateGuid(),
                    title,
                    start: modal.dataset.start,
                    end: modal.dataset.end !== modal.dataset.start ? modal.dataset.end : null,
                    backgroundColor: selectedColor,
                    borderColor: selectedColor,
                    textColor: 'white',
                    addedBy,
                    addedTime: now.toTimeString().split(' ')[0],
                    addedDate: now.toISOString().split('T')[0],
                    IsPublish: isPublishCheckbox.checked ? 1 : 0
                };

                calendar.addEvent(newEvent);
                localEvents.push(newEvent);
                saveEvents(localEvents).then(() => {
                    updateEventPanels();
                    modal.style.display = "none";
                }).catch(error => {
                    console.error("Error saving event:", error);
                    alert("Failed to save event. Data may be inconsistent. Check console.");
                    localEvents.pop();
                    calendar.getEventById(newEvent.id)?.remove();
                    modal.style.display = "none";
                });
            };

            document.getElementById("cancelButton").onclick = () => {
                console.log("Cancel button clicked");
                modal.style.display = "none";
            };

            // Define color options handler once on page load
            const colorOptions = document.querySelectorAll(".color-option");
            colorOptions.forEach(option => {
                option.onclick = () => {
                    selectedColor = option.dataset.color;
                    const colorName = option.dataset.color;
                    const emojiMap = {
                        red: "Happy burtdi🎉",
                        green: "Ey Noklass📚",
                        blue: "Wowers halidi🌴",
                        black: "Skol eBent🏫"
                    };
                    document.getElementById("selectedColorText").textContent = `${emojiMap[colorName] || 'No color selected'}`;
                    document.getElementById("colorEmoji").textContent = emojiMap[colorName] || '❌';
                };
            });

            loadEvents().then(events => {
                localEvents = events;
                updateEventPanels();

                calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    editable: true,
                    selectable: true,
                    events: localEvents,
                    dateClick: info => {
                        modal.dataset.start = info.dateStr;
                        modal.dataset.end = info.dateStr;
                        showModal(info.dateStr, info.dateStr);
                    },
                    select: info => {
                        modal.dataset.start = info.startStr;
                        modal.dataset.end = info.endStr;
                        showModal(info.startStr, info.endStr);
                    },
                    eventClick: function (info) {
                        selectedEvent = info.event;
                        if (selectedEvent.extendedProps.addedBy !== getSessionFullName()) {
                            alert("You can only edit or delete events created by yourself.");
                            return;
                        }
                        document.getElementById("editTitle").value = selectedEvent.title;
                        document.getElementById("editIsPublish").checked = selectedEvent.extendedProps.IsPublish === 1;
                        editModal.style.display = "block";
                    },
                    eventDidMount: function (info) {
                        const titleContainer = info.el.querySelector('.fc-event-title-container');
                        if (titleContainer) {
                            titleContainer.style.backgroundColor = info.event.backgroundColor;
                            titleContainer.style.borderRadius = '4px';
                            titleContainer.style.padding = '2px 6px';
                            titleContainer.style.color = info.event.textColor || 'white';
                        }
                    },
                    eventChange: function (info) {
                        if (info.event.extendedProps.addedBy !== getSessionFullName()) {
                            info.revert();
                            alert("You can only edit events created by yourself.");
                            return;
                        }
                        localEvents = calendar.getEvents().map(e => ({
                            id: e.id,
                            title: e.title,
                            start: e.startStr,
                            end: e.endStr || null,
                            backgroundColor: e.backgroundColor,
                            borderColor: e.borderColor,
                            textColor: e.textColor,
                            addedBy: e.extendedProps.addedBy || '',
                            addedTime: e.extendedProps.addedTime || '',
                            addedDate: e.extendedProps.addedDate || '',
                            IsPublish: e.extendedProps.IsPublish || 0
                        }));
                        saveEvents(localEvents).then(() => {
                            updateEventPanels();
                        }).catch(error => {
                            console.error("Error saving events:", error);
                            alert("Failed to save event changes. Reverting...");
                            loadEvents().then(events => {
                                localEvents = events;
                                calendar.removeAllEvents();
                                calendar.addEventSource(localEvents);
                                updateEventPanels();
                            });
                        });
                    },
                    dayCellDidMount: function (info) {
                        const today = new Date();
                        const cellDate = info.date;
                        if (
                            cellDate.getFullYear() === today.getFullYear() &&
                            cellDate.getMonth() === today.getMonth() &&
                            cellDate.getDate() === today.getDate()
                        ) {
                            const contentEl = info.el.querySelector('.fc-daygrid-day-number');
                            if (contentEl && !contentEl.innerText.includes("TODAY")) {
                                contentEl.innerHTML = `<span style=" margin-right:30px; font-size: 15px; color: red;">TODAY</span>${contentEl.innerHTML}`;
                            }
                        }
                    }
                });

                calendar.render();
                updateEventPanels();
            }).catch(error => {
                console.error("Error loading events:", error);
                alert("Failed to load events. Starting with empty calendar.");
                calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    editable: true,
                    selectable: true,
                    events: [],
                    dateClick: info => {
                        modal.dataset.start = info.dateStr;
                        modal.dataset.end = info.dateStr;
                        showModal(info.dateStr, info.dateStr);
                    },
                    select: info => {
                        modal.dataset.start = info.startStr;
                        modal.dataset.end = info.endStr;
                        showModal(info.startStr, info.endStr);
                    },
                    eventClick: function (info) {
                        selectedEvent = info.event;
                        if (selectedEvent.extendedProps.addedBy !== getSessionFullName()) {
                            alert("You can only edit or delete events created by yourself.");
                            return;
                        }
                        document.getElementById("editTitle").value = selectedEvent.title;
                        document.getElementById("editIsPublish").checked = selectedEvent.extendedProps.IsPublish === 1;
                        editModal.style.display = "block";
                    },
                    eventDidMount: function (info) {
                        const titleContainer = info.el.querySelector('.fc-event-title-container');
                        if (titleContainer) {
                            titleContainer.style.backgroundColor = info.event.backgroundColor;
                            titleContainer.style.borderRadius = '4px';
                            titleContainer.style.padding = '2px 6px';
                            titleContainer.style.color = info.event.textColor || 'white';
                        }
                    },
                    eventChange: function (info) {
                        if (info.event.extendedProps.addedBy !== getSessionFullName()) {
                            info.revert();
                            alert("You can only edit events created by yourself.");
                            return;
                        }
                        localEvents = calendar.getEvents().map(e => ({
                            id: e.id,
                            title: e.title,
                            start: e.startStr,
                            end: e.endStr || null,
                            backgroundColor: e.backgroundColor,
                            borderColor: e.borderColor,
                            textColor: e.textColor,
                            addedBy: e.extendedProps.addedBy || '',
                            addedTime: e.extendedProps.addedTime || '',
                            addedDate: e.extendedProps.addedDate || '',
                            IsPublish: e.extendedProps.IsPublish || 0
                        }));
                        saveEvents(localEvents).then(() => {
                            updateEventPanels();
                        }).catch(error => {
                            console.error("Error saving events:", error);
                            alert("Failed to save event changes. Reverting...");
                            loadEvents().then(events => {
                                localEvents = events;
                                calendar.removeAllEvents();
                                calendar.addEventSource(localEvents);
                                updateEventPanels();
                            });
                        });
                    },
                    dayCellDidMount: function (info) {
                        const today = new Date();
                        const cellDate = info.date;
                        if (
                            cellDate.getFullYear() === today.getFullYear() &&
                            cellDate.getMonth() === today.getMonth() &&
                            cellDate.getDate() === today.getDate()
                        ) {
                            const contentEl = info.el.querySelector('.fc-daygrid-day-number');
                            if (contentEl && !contentEl.innerText.includes("TODAY")) {
                                contentEl.innerHTML = `<div style="text-align: center; width: 100%;"><span style="font-size: 15px; color: red;">TODAY</span><br>${contentEl.innerHTML}</div>`;
                            }
                        }
                    }
                });
                calendar.render();
            });

            document.getElementById("deleteButton").onclick = function () {
                console.log("Delete button clicked");
                if (selectedEvent) {
                    if (selectedEvent.extendedProps.addedBy !== getSessionFullName()  ) {
                        alert("You can only delete events created by yourself.");
                        editModal.style.display = "none";
                        return;
                    }
                    selectedEvent.remove();
                    localEvents = calendar.getEvents().map(e => ({
                        id: e.id,
                        title: e.title,
                        start: e.startStr,
                        end: e.endStr || null,
                        backgroundColor: e.backgroundColor,
                        borderColor: e.borderColor,
                        textColor: e.textColor,
                        addedBy: e.extendedProps.addedBy || '',
                        addedTime: e.extendedProps.addedTime || '',
                        addedDate: e.extendedProps.addedDate || '',
                        IsPublish: e.extendedProps.IsPublish || 0
                    }));
                    saveEvents(localEvents).then(() => {
                        updateEventPanels();
                        editModal.style.display = "none";
                    }).catch(error => {
                        console.error("Error saving events:", error);
                        alert("Failed to delete event. Reverting...");
                        loadEvents().then(events => {
                            localEvents = events;
                            calendar.removeAllEvents();
                            calendar.addEventSource(localEvents);
                            updateEventPanels();
                            editModal.style.display = "none";
                        });
                    });
                } else {
                    console.warn("No selected event to delete");
                    editModal.style.display = "none";
                }
            };

            document.getElementById("saveButton").onclick = function () {
                console.log("Save button clicked");
                if (selectedEvent) {
                    if (selectedEvent.extendedProps.addedBy !== getSessionFullName()) {
                        alert("You can only edit events created by yourself.");
                        editModal.style.display = "none";
                        return;
                    }
                    const newTitle = document.getElementById("editTitle").value.trim();
                    if (!newTitle) {
                        alert("Please enter a title.");
                        return;
                    }
                    selectedEvent.setProp("title", newTitle);
                    selectedEvent.setExtendedProp("IsPublish", document.getElementById("editIsPublish").checked ? 1 : 0);
                    localEvents = calendar.getEvents().map(e => ({
                        id: e.id,
                        title: e.title,
                        start: e.startStr,
                        end: e.endStr || null,
                        backgroundColor: e.backgroundColor,
                        borderColor: e.borderColor,
                        textColor: e.textColor,
                        addedBy: e.extendedProps.addedBy || '',
                        addedTime: e.extendedProps.addedTime || '',
                        addedDate: e.extendedProps.addedDate || '',
                        IsPublish: e.extendedProps.IsPublish || 0
                    }));
                    saveEvents(localEvents).then(() => {
                        updateEventPanels();
                        editModal.style.display = "none";
                    }).catch(error => {
                        console.error("Error saving events:", error);
                        alert("Failed to save event. Reverting...");
                        loadEvents().then(events => {
                            localEvents = events;
                            calendar.removeAllEvents();
                            calendar.addEventSource(localEvents);
                            updateEventPanels();
                            editModal.style.display = "none";
                        });
                    });
                } else {
                    console.warn("No selected event to save");
                    editModal.style.display = "none";
                }
            };
        });
    </script>
</body>
</html>