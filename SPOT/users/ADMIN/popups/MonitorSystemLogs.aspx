<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MonitorSystemLogs.aspx.cs" Inherits="SPOT.users.ADMIN.popups.MonitorSystemLogs" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monitor System Logs</title>
    <style>
 .account-popup-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 9999;
    justify-content: center;
    align-items: center;
}

.popup-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
}


.popup-form {
    background: white;
    width: 75%;
    height: 75%;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

.popup-form .scrollable-content {
    overflow-y: auto;
    flex-grow: 1;
    padding-right: 5px;
    margin-top: 10px;
}

.popup-form .scrollable-content::-webkit-scrollbar {
    width: 8px;
}
.popup-form .scrollable-content::-webkit-scrollbar-thumb {
    background-color: rgba(0,0,0,0.2);
    border-radius: 4px;
}



.account-detail {
    width:450px;
    height: 550px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center; /* centers content vertically */
    background: white;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    position: relative;
}


  
.account-detail img {
    width:230px;
    height: 220px;
    object-fit: cover;
    border-radius: 50%;
    margin-bottom: 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);

}


.log-table {
    width: 100%;
    border-collapse: collapse;
}

.log-table th, .log-table td {

    border: 1px solid #ccc;
    padding: 10px;
    text-align: center;
}

.log-table th {
        position: sticky;
    top: 0;

        background: rgb(128, 128, 128);

}


.serial-link {
    color: #007bff;
   cursor: pointer;
   text-decoration: underline;
}

.serial-link:hover {
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



    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <!-- Main Logs Popup -->
        <div class="popup-overlay" id="logsPopup" style="display: flex;">
<div class="popup-form">
    <div class="scrollable-content">
        <asp:Repeater ID="rptLogs" runat="server">
            <HeaderTemplate>
                <table class="log-table">
                    <thead>
                        <tr>
                            <th>Account Log ID</th>
                            <th>Serial</th>
                            <th>LogDate</th>
                            <th>Check In Time</th>
                            <th>Check Out Time</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>

            <ItemTemplate>
                <tr>
                    <td><%# Eval("AccLogID") %></td>
                    <td>
                        <span class="serial-link" onclick="__doPostBack('ShowAccountDetails', '<%# Eval("Serial") %>')">
                            <%# Eval("Serial") %>
                        </span>
                    </td>
                    <td><%# FormatDate(Eval("LogDate")) %></td>
                    <td><%# FormatTime(Eval("CheckInTime")) %></td> 
                    <td><%# FormatTime(Eval("CheckOutTime")) %></td>
                </tr>
            </ItemTemplate>

            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</div>

        </div>

        <!-- Account Details Popup -->
        <div class="account-popup-overlay" id="accountPopup" style="display: none;">
            <div class="account-detail">
                <span class="close-account-popup" onclick="closePopup('accountPopup')">&times;</span>

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

        <script>
                function openPopup(id) {
                    document.getElementById(id).style.display = 'flex';
    }

                function closePopup(id) {
                    document.getElementById(id).style.display = 'none';
    }

        </script>
    </form>
</body>
</html>
