<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logs.aspx.cs" Inherits="SPOT.users.ADMIN.popups.Logs" %>

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

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .user-info-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            width: 300px;
            max-width: 90%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            position: relative;
        }

        .user-info-container h3 {
            margin: 0 0 15px;
            font-size: 1.2em;
        }

        .user-info-container p {
            margin: 5px 0;
        }

        .account-detail {
            width: 450px;
            height: 550px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .account-detail img {
            width: 230px;
            height: 220px;
            object-fit: cover;
            border-radius: 50%;
            margin-bottom: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .logged-by-link {
            color: #007bff;
            cursor: pointer;
            text-decoration: underline;
        }

        .logged-by-link:hover {
            color: #0056b3;
        }

        .close-account-popup {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 28px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .close-account-popup:hover {
            color: red;
        }

        .account-popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1002   ;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }

        th{
            position:sticky;
            top:-2px;
        }

        .popup-container.hidden {
            display: none;
        }

        .popup-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            position: relative;
            width: 400px;
            max-width: 90%;
        }

        .input-field {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn-red, .btn-green {
            padding: 10px 20px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-red {
            background-color: #dc3545;
            color: white;
        }

        .btn-green {
            background-color: #28a745;
            color: white;
        }

        .button-row {
            display: flex;
            justify-content: space-between;
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

            rows = rows.filter(row => row.cells.length === 7 && !row.querySelector("hr"));

            while (tbody.firstChild) tbody.removeChild(tbody.firstChild);

            if (!groupBy || groupBy === "") {
                rows.forEach(row => {
                    row.style.display = "";
                    tbody.appendChild(row);
                });
                return;
            }

            const groups = {};
            const now = new Date();

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
                        key = logDateTime.toLocaleDateString('en-US', options);
                    }
                } else {
                    key = row.cells[groupBy === "type" ? 3 : 4].textContent.trim();
                }

                if (!groups[key]) groups[key] = [];
                groups[key].push(row);
            });

            Object.keys(groups).sort().forEach(group => {
                const hr = document.createElement("tr");
                hr.innerHTML = `<td colspan="7"><hr><strong>${group}</strong></td>`;
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
            } else if (format === "docx") {
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
            }

            const tbody = table.querySelector("tbody");
            while (tbody.firstChild) {
                tbody.removeChild(tbody.firstChild);
            }

            const emptyRow = document.createElement("tr");
            emptyRow.innerHTML = `<td colspan="7" style="text-align:center;">Logs downloaded. Table is now empty.</td>`;
            tbody.appendChild(emptyRow);
        }

        function showDLForm() {
            document.getElementById("downloadPopup").classList.remove("hidden");
        }

        function closeForm() {
            document.getElementById('<%= txtDownloadBy.ClientID %>').value = '';
            document.getElementById('<%= txtReason.ClientID %>').value = '';
            document.getElementById('<%= chkResponsibility.ClientID %>').checked = false;
            document.getElementById("downloadPopup").classList.add("hidden");
        }

        function openPopup(popupId) {
            document.getElementById(popupId).style.display = 'flex';
        }

        function closePopup(popupId) {
            document.getElementById(popupId).style.display = 'none';
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
          <!-- Account Details Popup -->
  <div class="account-popup-overlay" id="accountPopup" style="display: none;">
      <div class="account-detail">
          <span class="close-account-popup" onclick="closePopup('accountPopup')">×</span>
          <asp:Image ID="imgProfile" runat="server" />
          <asp:Label ID="lblAlias" runat="server" /><br />
          <br />
          <asp:Label ID="lblFullName" runat="server" Font-Bold="true" Font-Size="Larger" /><br />
          <asp:Label ID="lblRole" runat="server" /><br />
          <asp:Label ID="lblAge" runat="server" /><br />
          <asp:Label ID="lblPhone" runat="server" /><br />
          <asp:Label ID="lblEmail" runat="server" /><br />
          <asp:Label ID="lblAccountCreated" runat="server" /><br />
      </div>
  </div>
        <div class="logs-popup">
            <asp:GridView ID="GridViewLogs" runat="server" AutoGenerateColumns="true" Visible="false" />

          

            <!-- Download Popup -->
            <div id="downloadPopup" class="popup-container hidden">
                <h2>Download Confirmation</h2>
                <label>Full Name</label>
                <asp:TextBox ID="txtDownloadBy" runat="server" CssClass="input-field" placeholder="What is your name?"></asp:TextBox>
                <label>Valid Reason</label>
                <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" CssClass="input-field" placeholder="Reason for downloading this information ... ?"></asp:TextBox>
                <asp:TextBox ID="txtDateTime" runat="server" ReadOnly="true" CssClass="input-field"></asp:TextBox>
                <asp:DropDownList ID="fileFormat" runat="server" CssClass="input-field">
                    <asp:ListItem Text=".DOCX (Word)" Value="docx" />
                    <asp:ListItem Text=".CSV (Excel)" Value="csv" />
                    <asp:ListItem Text=".Plain Text" Value="txt" />
                </asp:DropDownList>
                <label>
                    <asp:CheckBox ID="chkResponsibility" runat="server" />
                    I take full responsibility for downloading this file
                </label>
                <br />
                <div class="button-row">
                    <button type="button" class="btn-red" onclick="downloadNow()">Download Now</button>
                    <button type="button" class="btn-green" onclick="closeForm()">Cancel</button>
                </div>
            </div>

            <img src="/images/downloadICON.png" alt="Download Icon" class="download-icon" onclick="showDLForm()" />

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

            <!-- Logs Table -->
            <div class="logs-content">
                <asp:Repeater ID="rptLogs" runat="server" OnItemCommand="rptLogs_ItemCommand">
                    <HeaderTemplate>
                        <table>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Type</th>
                                <th>Action</th>
                                <th>Ref ID</th>
                                <th>Logged By</th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("HistoryLogID") %></td>
                            <td><%# Eval("LogDate") %></td>
                            <td><%# Eval("LogTime") %></td>
                            <td><%# Eval("LogType") %></td>
                            <td><%# Eval("Action") %></td>
                            <td><%# Eval("reference_id") %></td>
                            <td>
                                <asp:LinkButton ID="lnkLoggedBy" runat="server" CssClass="logged-by-link" CommandName="ShowAccountDetails" CommandArgument='<%# Eval("LoggedBy") %>'>
                                    <%# Eval("LoggedBy") %>
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoLogs" runat="server" Text="No logs found." Visible="false" />
            </div>
        </div>
    </form>
</body>
</html>