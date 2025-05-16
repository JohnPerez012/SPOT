<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logs.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Logs" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="logs.css" />

    <style>
        .custom-dropdown {
            position: relative;
            display: inline-block;
            font-family: 'Poppins', sans-serif;
            margin-right: 20px;
        }

        .custom-dropdown .dropdown-toggle {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: white;
            cursor: pointer;
        }

        .custom-dropdown .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background-color: white;
            border: 1px solid #ccc;
            margin-top: -1px;
            z-index: 100;
            min-width: 100px;
            border-radius: 5px;
            padding: 10px;
            opacity: 0;
            transform: translateY(-10px);
            transition: opacity 0.2s ease, transform 0.2s ease;
            pointer-events: none;
        }

        .custom-dropdown:hover .dropdown-menu {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        .custom-dropdown .dropdown-group {
            margin-bottom: 10px;
        }

        .custom-dropdown label {
            display: block;
            margin-bottom: 5px;
            cursor: pointer;
        }

        .custom-dropdown input[type="radio"] {
            margin-right: 7px;
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            document.querySelectorAll(".custom-dropdown").forEach(dropdown => {
                dropdown.addEventListener("mouseleave", () => {
                    dropdown.classList.remove("show");
                });
            });
        });

        function toggleDropdown(id) {
            const dropdown = document.getElementById(id);
            const allDropdowns = document.querySelectorAll(".custom-dropdown");
            allDropdowns.forEach(dd => {
                if (dd !== dropdown) dd.classList.remove("show");
            });
            dropdown.classList.toggle("show");
        }

        function handleSortSelection() {
            sortLogs();
        }

        function handleGroupSelection() {
            groupLogs();
        }

        function sortLogs() {
            const sortBy = document.querySelector('input[name="sortBy"]:checked')?.value;
            const order = document.querySelector('input[name="sortOrder"]:checked')?.value;
            const tbody = document.querySelector(".logs-content table tbody");
            const rows = Array.from(tbody.querySelectorAll("tr"));

            if (!sortBy) return;

            let columnIndex = 0;
            let direction = order === "asc" ? 1 : -1;

            switch (sortBy) {
                case "id": columnIndex = 0; break;
                case "date": columnIndex = 1; break;
                case "time": columnIndex = 2; break;
                case "type": columnIndex = 3; break;
                case "action": columnIndex = 4; break;
                case "refid": columnIndex = 5; break;
            }

            rows.sort((a, b) => {
                const aText = a.cells[columnIndex].textContent.trim().toLowerCase();
                const bText = b.cells[columnIndex].textContent.trim().toLowerCase();
                return aText.localeCompare(bText, undefined, { numeric: true }) * direction;
            });

            while (tbody.firstChild) tbody.removeChild(tbody.firstChild);
            rows.forEach(row => tbody.appendChild(row));
        }

        function filterLogs() {
            const input = document.getElementById("logSearchInput");
            const filter = input.value.toLowerCase();
            const tbody = document.querySelector(".logs-content table tbody");
            const rows = Array.from(tbody.querySelectorAll("tr"));

            const matchingRows = [];
            const nonMatchingRows = [];

            rows.forEach(row => {
                const cells = row.querySelectorAll("td");
                let rowMatch = false;

                cells.forEach(cell => {
                    const text = cell.textContent;
                    const lowerText = text.toLowerCase();

                    if (filter && lowerText.includes(filter)) {
                        rowMatch = true;
                        const regex = new RegExp(`(${filter})`, 'gi');
                        cell.innerHTML = text.replace(regex, '<mark>$1</mark>');
                    } else {
                        cell.innerHTML = text;
                    }
                });

                if (rowMatch) matchingRows.push(row);
                else if (filter !== "") nonMatchingRows.push(row);
                else matchingRows.push(row);
            });

            while (tbody.firstChild) tbody.removeChild(tbody.firstChild);
            matchingRows.forEach(row => {
                row.style.display = "";
                tbody.appendChild(row);
            });
            nonMatchingRows.forEach(row => {
                row.style.display = "none";
                tbody.appendChild(row);
            });
        }

        function groupLogs() {
            sortLogs();

            const groupBy = document.querySelector('input[name="groupBy"]:checked')?.value;
            const tbody = document.querySelector(".logs-content table tbody");
            let rows = Array.from(tbody.querySelectorAll("tr"));

            // Filter out any rows that are not actual log entries (e.g., group headers)
            rows = rows.filter(row => row.cells.length === 6 && !row.querySelector("hr"));

            while (tbody.firstChild) tbody.removeChild(tbody.firstChild);

            if (!groupBy || groupBy === "") {
                rows.forEach(row => {
                    row.style.display = "";
                    tbody.appendChild(row);
                });
                return;
            }

            const groups = {};
            const now = new Date("2025-04-07T00:00:00");

            rows.forEach(row => {
                let key;
                if (groupBy === "date") {
                    const date = row.cells[1].textContent;
                    const time = row.cells[2].textContent;
                    const [month, day, year] = date.split("-");
                    const logDateTime = new Date(`${year}-${month}-${day}T${time}`);
                    const diffMs = now - logDateTime;
                    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

                    if (diffDays === 0) {
                        key = "Today";
                    } else if (diffDays <= 3) {
                        key = "Previous 3 Days";
                    } else if (diffDays <= 7) {
                        key = "Previous 7 Days";
                    } else if (diffDays <= 30) {
                        key = "Previous 30 Days";
                    } else {
                        const options = { year: 'numeric', month: 'long' };
                        key = logDateTime.toLocaleDateString('en-US', options); // e.g., "March 2025"
                    }
                } else {
                    key = row.cells[groupBy === "type" ? 3 : 4].textContent.trim();
                }

                if (!groups[key]) groups[key] = [];
                groups[key].push(row);
            });

            Object.keys(groups).sort().forEach(group => {
                const hr = document.createElement("tr");
                hr.innerHTML = `<td colspan="6"><hr><strong>${group}</strong></td>`;
                tbody.appendChild(hr);
                groups[group].forEach(row => {
                    row.style.display = "";
                    tbody.appendChild(row);
                });
            });
        }









        function downloadNow() {
            const format = document.getElementById("fileFormat").value;
            const table = document.querySelector(".logs-content table");
            const rows = Array.from(table.querySelectorAll("tr"));

            let content = "";

            if (format === "csv" || format === "txt") {
                // Generate CSV or plain text
                rows.forEach(row => {
                    const cells = Array.from(row.querySelectorAll("th, td")).map(cell =>
                        `"${cell.textContent.trim().replace(/"/g, '""')}"`
                    );
                    content += cells.join(",") + "\n";
                });

                const blob = new Blob([content], { type: "text/plain;charset=utf-8;" });
                const link = document.createElement("a");
                link.href = URL.createObjectURL(blob);
                link.download = format === "csv" ? "logs.csv" : "logs.txt";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }

            else if (format === "docx") {
                // Basic table format for Word-compatible docx
                let docContent = `
            <html xmlns:o='urn:schemas-microsoft-com:office:office' 
                  xmlns:w='urn:schemas-microsoft-com:office:word' 
                  xmlns='http://www.w3.org/TR/REC-html40'>
            <head><meta charset='utf-8'><title>Logs</title></head><body><table border='1'>`;



                rows.forEach(row => {
                    docContent += "<tr>";
                    row.querySelectorAll("th, td").forEach(cell => {
                        const tag = cell.tagName.toLowerCase();
                        docContent += `<${tag}>${cell.textContent.trim()}</${tag}>`;
                    });
                    docContent += "</tr>";
                });

                docContent += "</table></body></html>";

                const blob = new Blob(['\ufeff' + docContent], {
                    type: "application/msword"
                });

                const link = document.createElement("a");
                link.href = URL.createObjectURL(blob);
                link.download = "logs.doc";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                GenerateProtectedDoc(link);


            }

            // Clear the table visually
            const tbody = table.querySelector("tbody");
            while (tbody.firstChild) {
                tbody.removeChild(tbody.firstChild);
            }

            const emptyRow = document.createElement("tr");
            emptyRow.innerHTML = `<td colspan="6" style="text-align:center;">Logs downloaded. Table is now empty.</td>`;
            tbody.appendChild(emptyRow);

        }




        function showDLForm() {
            document.getElementById("downloadPopup").classList.remove("hidden");

        }



        document.querySelector(".btn-green").addEventListener("click", function () {
            clearForm();
        });


    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="logs-popup">
            <asp:GridView ID="GridViewLogs" runat="server" AutoGenerateColumns="true" />


            <div class="logs-header">
                <h2>H I S T O R Y</h2>
                <div class="search-bar-wrapper">
                    <input type="text" id="logSearchInput" placeholder="Search" onkeyup="filterLogs()" />
                </div>
            </div>

            <div class="log-options">
                <!-- Sort Dropdown -->
                <div class="custom-dropdown" id="sortDropdown">
                    <div class="dropdown-toggle" onclick="toggleDropdown('sortDropdown')">Sort Options</div>
                    <div class="dropdown-menu">
                        <div class="dropdown-group">
                            <strong>Sort By:</strong>
                            <label><input type="radio" name="sortBy" value="id" checked="checked" onchange="handleSortSelection()"> ID</label>
                            <label><input type="radio" name="sortBy" value="date" onchange="handleSortSelection()"> Date</label>
                            <label><input type="radio" name="sortBy" value="time" onchange="handleSortSelection()"> Time</label>
                            <label><input type="radio" name="sortBy" value="type" onchange="handleSortSelection()"> Type</label>
                            <label><input type="radio" name="sortBy" value="action" onchange="handleSortSelection()"> Action</label>
                            <label><input type="radio" name="sortBy" value="refid" onchange="handleSortSelection()"> Ref ID</label>
                        </div>
                        <div class="dropdown-group">
                            <strong>Order:</strong>
                            <label><input type="radio" name="sortOrder" value="asc" checked="checked" onchange="handleSortSelection()"> ASC</label>
                            <label><input type="radio" name="sortOrder" value="desc" onchange="handleSortSelection()"> DESC</label>
                        </div>
                    </div>
                </div>

                <!-- Group Dropdown -->
                <div class="custom-dropdown" id="groupDropdown">
                    <div class="dropdown-toggle" onclick="toggleDropdown('groupDropdown')">Group Options</div>
                    <div class="dropdown-menu">
                        <div class="dropdown-group">
                            <strong>Group By:</strong>
                            <label><input type="radio" name="groupBy" value="" checked="checked" onchange="handleGroupSelection()"> None</label>
                            <label><input type="radio" name="groupBy" value="type" onchange="handleGroupSelection()"> Type</label>
                            <label><input type="radio" name="groupBy" value="date" onchange="handleGroupSelection()"> Date</label>
                        </div>
                    </div>
                </div>
            </div>
            <hr />

            <div class="logs-content">
                <table border="1" cellpadding="10" cellspacing="0" width="50%">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Type</th>
                            <th>Action</th>
                            <th>Ref ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (LogData != null && LogData.Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow row in LogData.Rows)
                                {
                        %>
                            <tr>
                                <td><%= row["HistoryLogID"] %></td>
                                <td><%= ((DateTime)row["LogDate"]).ToString("MM-dd-yyyy") %></td>
                                <td><%= row["LogTime"] %></td>
                                <td><%= row["LogType"] %></td>
                                <td><%= row["Action"] %></td>
                                <td><%= row["reference_id"] != DBNull.Value ? row["reference_id"] : "" %></td>
                            </tr>
                        <% 
                                }
                            }
                            else
                            {
                        %>
                            <tr><td colspan="6">No logs found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

