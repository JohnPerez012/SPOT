<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GuardScheduler.aspx.cs" Inherits="SPOT.users.ADMIN.popups.GuardScheduler" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <style>

        .popup-card {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 400px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
    padding: 20px;
    z-index: 9999;
    font-family: 'Segoe UI', sans-serif;
}

.popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.popup-header h2 {
    font-size: 20px;
    margin: 0;
}

.close-btn {
    background: none;
    border: none;
    font-size: 22px;
    cursor: pointer;
}

.popup-body {
    margin-top: 10px;
}

.selected-dates {
    font-size: 14px;
    margin-bottom: 12px;
    color: #333;
    padding: 8px;
    background: #f4f4f4;
    border-radius: 6px;
}

.form-group {
    margin-bottom: 12px;
}

.input {
    width: 100%;
    padding: 6px 8px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

.button-group {
    display: flex;
    justify-content: space-between;
    margin-top: 16px;
}

.assign-btn, .back-btn {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
}

.assign-btn {
    background-color: #2e8b57;
    color: white;
}

.back-btn {
    background-color: #ccc;
}


    </style>
</head>
<body>
    <form id="form1" runat="server">
<!-- Hidden field to store selected dates -->
<asp:HiddenField ID="hfSelectedDates" runat="server" />

<!-- Assign Shift Button -->
<button type="button" id="btnAssignShift" onclick="openShiftPopup()">ASSIGN SHIFT</button>

<!-- Shift Popup -->
<div id="shiftPopupCard" class="popup-card" style="display:none;">
    <div class="popup-header">
        <h2>Assign Shift</h2>
        <button type="button" class="close-btn" onclick="closeShiftPopup()">×</button>
    </div>
    <hr />
<asp:GridView ID="gvSchedule" runat="server" AutoGenerateColumns="false" CssClass="input" HeaderStyle-BackColor="#eee">
    <Columns>
        <asp:BoundField DataField="Guard" HeaderText="Guard" />
        <asp:BoundField DataField="Post" HeaderText="Post" />
        <asp:BoundField DataField="Shift" HeaderText="Shift" />
        <asp:BoundField DataField="Dates" HeaderText="Dates" />
        <asp:TemplateField HeaderText="Color">
            <ItemTemplate>
                <div style='width: 20px; height: 20px; border-radius: 4px; background:<%# Eval("Color") %>'></div>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

    <div class="popup-body">
        <!-- Selected dates display -->
        <div class="selected-dates" id="selectedDatesDisplay">
            No dates selected.
        </div>

        <!-- Guard selection -->
        <div class="form-group">
            <label for="ddlGuard">Guard:</label>
            <asp:DropDownList ID="ddlGuard" runat="server" CssClass="input" />
        </div>

        <!-- Post selection -->
        <div class="form-group">
            <label for="ddlPost">Post:</label>
            <asp:DropDownList ID="ddlPost" runat="server" CssClass="input">
                <asp:ListItem Text="Post A" Value="Post A" />
                <asp:ListItem Text="Post B" Value="Post B" />
            </asp:DropDownList>
        </div>

        <!-- Shift type -->
        <div class="form-group">
            <label for="ddlShift">Shift:</label>
            <asp:DropDownList ID="ddlShift" runat="server" CssClass="input">
                <asp:ListItem Text="Day (7:00 AM - 6:00 PM)" Value="Day" />
                <asp:ListItem Text="Night (6:00 PM - 7:00 AM)" Value="Night" />
            </asp:DropDownList>
        </div>

        <!-- Color Tag -->
        <div class="form-group">
            <label for="txtColor">Color Tag:</label>
            <input type="color" id="txtColor" class="input" value="#29a329" />
        </div>

        <!-- Buttons -->
        <div class="button-group">
            <asp:Button ID="btnAssign" runat="server" CssClass="assign-btn" Text="ASSIGN" OnClick="btnAssign_Click" />
            <button type="button" class="back-btn" onclick="closeShiftPopup()">BACK</button>
        </div>
    </div>
</div>

    </form>


    <script>
    function openShiftPopup() {
        document.getElementById("shiftPopupCard").style.display = "block";

        // Get selected dates from hidden field (JSON array)
        let selectedDates = JSON.parse(document.getElementById('<%= hfSelectedDates.ClientID %>').value || "[]");

        let display = selectedDates.length > 0
            ? selectedDates.join(', ')
            : "No dates selected.";

        document.getElementById("selectedDatesDisplay").innerText = display;
    }

    function closeShiftPopup() {
        document.getElementById("shiftPopupCard").style.display = "none";
    }
    </script>




</body>
</html>
