<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pending.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Pending" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Logs</title>
</head>
    <style>
        /* 🌟 Center Content */
body {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0;
/*    background-color: #f8f9fa;*/
}

/* 🌟 Container */
.pending-container {
    position:absolute;
    top:50%;
    left:50%;
    transform:translate(-50%, -50%);
    width: 95%;
    padding: 20px;
    background-color: #ffffff;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    text-align: center;

}

/* 🌟 Table Containers */
.tables-container {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    margin-top: 20px;
}

/* 🌟 Each Table Box */
.table-box {
    width: 100%;
    padding: 15px;
    background: #ffffff;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    max-height: none; /* Adjust as needed */
    overflow: hidden;
    display: flex;
    flex-direction: column;
    min-width: 400px;   
}

/* 🌟 Scrollable Table */
.table-scroll {
    overflow-y: auto;
    flex-grow: 1;
    max-height: 300px; /* Adjust height to allow scrolling */
    position: relative;
    min-width: 400px;
}

/* 🌟 Table */
.table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    min-width: 400px;
}

    /* 🌟 Sticky Header */
    .table thead tr {
        position: sticky;
        top: 0;
        background-color: #f4f4f4;
        z-index: 10;
    }

    /* 🌟 Table Cells */
    .table th, .table td {
        padding: 10px;
        text-align: left;
        border: 1px solid #ddd;
    }

    .table th {
        background-color: #f4f4f4;
        text-transform: uppercase;
    }

/* 🌟 Responsive */
@media (max-width: 992px) {
    .tables-container {
        flex-direction: column;
        align-items: center;
    }

    .table-box {
        width: 99%;
        margin-bottom: 20px;
    }
}

/* 🌟 Button Styling */
.btn-out {
    background-color: red;
    color: white;
    border: none;
    padding: 5px 10px;
    cursor: pointer;
    font-size: 14px;
    border-radius: 5px;
}

    .btn-out:hover {
        background-color: darkred;
    }

    </style>
<body>
    <form id="form1" runat="server">
        <div class="pending-container">
            <h2>Pending Logs</h2>
            <div class="tables-container">

                <!-- University Vehicles (Left) -->
                <div class="table-box">
                    <h3>University Vehicles</h3>
                    <div class="table-scroll">
                        <asp:GridView ID="gvUniversityVehicles" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvPending_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="LogID" HeaderText="Log ID" />
                                <asp:BoundField DataField="PlateNumber" HeaderText="Plate Number" />
                                <asp:BoundField DataField="DriverName" HeaderText="Driver Name" />
                                <asp:BoundField DataField="SetOff" HeaderText="Set Off Time" />

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnArrive" runat="server" Text="ARRIVE" CssClass="btn-out"
                                            CommandName="Arrive" CommandArgument='<%# Eval("LogID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Visitors (Middle) -->
                <div class="table-box">
                    <h3>Visitors</h3>
                    <div class="table-scroll">
                        <asp:GridView ID="gvVisitors" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvPending_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="VisitorID" HeaderText="ID" />
                                <asp:BoundField DataField="FullName" HeaderText="Name" />
                                <asp:BoundField DataField="VisitDate" HeaderText="Visit Date" />
                                <asp:BoundField DataField="TimeIn" HeaderText="Time In" />

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnOut" runat="server" Text="OUT" CssClass="btn-out"
                                            CommandName="SetOut" CommandArgument='<%# Eval("VisitorID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Vehicles (Right) -->
                <div class="table-box">
                    <h3>Vehicles</h3>
                    <div class="table-scroll">
                        <asp:GridView ID="gvVehicles" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvPending_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="LogID" HeaderText="Log ID" />
                                <asp:BoundField DataField="PlateNumber" HeaderText="Plate Number" />
                                <asp:BoundField DataField="VehicleType" HeaderText="Vehicle Type" />
                                <asp:BoundField DataField="TimeIn" HeaderText="Time In" />

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnExit" runat="server" Text="EXIT" CssClass="btn-out"
                                            CommandName="ExitVehicle" CommandArgument='<%# Eval("LogID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
