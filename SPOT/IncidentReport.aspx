<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IncidentReport.aspx.cs" Inherits="IncidentReport.IncidentReport" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Incident Report</title>
    <link rel="stylesheet" href="IncedentReport.css" /> 
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">

    <script type="text/javascript">
        function LrprtCont_clcik() {
            document.getElementById("list-report-container").classList.remove("hidden");
        }

        function hideIncidentReportList() {
            document.getElementById("list-report-container").classList.add("hidden");
        }
    </script>


</head>
<body>
    <form id="form1" runat="server">

        <!-- ==================== INCIDENT REPORT FORM ==================== -->
        <div class="report-container">
            <div class="h2_place">
                <h2>INCIDENT REPORT</h2>
            </div>

                <asp:Label runat="server" ID="lblMessage" ForeColor="Green" /> 

                <label>Incident Type:</label>
                <asp:TextBox ID="txtIncidentType" runat="server" CssClass="input-field" placeholder="Incident Type:"/>

                <label>Location:</label>
                <asp:TextBox ID="txtLocation" runat="server" CssClass="input-field" />

                <label>Date & Time:</label>
                <asp:TextBox ID="txtDateTime" runat="server" CssClass="input-field" TextMode="DateTimeLocal" />

                <label>Description:</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="input-field" TextMode="MultiLine" Rows="4" />

                <label>Reported By:</label>
                <asp:TextBox ID="txtReportedBy" runat="server" CssClass="input-field" />

                <label>Witnesses (optional):</label>
                <asp:TextBox ID="txtWitnesses" runat="server" CssClass="input-field" />

                <label>Status:</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="input-field">
                <asp:ListItem>Open</asp:ListItem>
                <asp:ListItem>Under Investigation</asp:ListItem>
                <asp:ListItem>Resolved</asp:ListItem>
            </asp:DropDownList>

            <label>Follow-Up Actions:</label>
            <asp:TextBox ID="txtFollowUp" runat="server" CssClass="input-field" />

            <div class="submit_btn">
                <asp:Button class="btnSubmit" runat="server" Text="Submit Report" CssClass="submit-button" OnClick="btnSubmit_Click" />
            </div>
        
        </div>
            <img src="https://cdn-icons-png.flaticon.com/512/8633/8633179.png" alt="LRI icon" class="LRI_icon" onclick="LrprtCont_clcik(); return false;" />
        


        <!-- ==================== LIST OF INCIDENT REPORTS ==================== -->
        <div id="list-report-container" class="List_report-container hidden">
            <div class="h2_place">
                <h2>List of Incident Reports</h2>
            </div>
            <asp:GridView ID="GridViewReports" runat="server" AutoGenerateColumns="true" CssClass="report-table" />

            <div class="submit_btn">
                <button type="button" class="btn-green" onclick="hideIncidentReportList()">Back</button>
            </div>
        </div>

    </form>
</body>
</html>


