<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Schedule" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>ASP.NET WebForms Schedule</title>
    <link rel="stylesheet" href="schedule.css">

</head>
<body>
    <form id="form1" runat="server">
        <div>   
            <h2>ASP.NET WebForms Schedule</h2>
           
           <asp:GridView ID="gvSchedule" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvSchedule_RowDataBound">
    <Columns>
        <asp:TemplateField HeaderText="Resource Name">
            <ItemTemplate>
                <%# Eval("ResourceName") %>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


        </div>
    </form>

    <script>
        function addEvent(resourceId, day) {
            var eventName = prompt("Enter Event Name:");
            if (!eventName) return;

            var cell = document.getElementById("cell-" + resourceId + "-" + day);
            if (cell) {
                var eventDiv = document.createElement("div");
                eventDiv.className = "event";
                eventDiv.innerText = eventName;
                cell.appendChild(eventDiv);
            }

            // Call server-side method via AJAX
            fetch("Schedule.aspx/SaveEvent", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ resourceId, day, eventName })
            })
                .then(response => response.json())
                .then(data => {
                    console.log("Event Saved:", data);
                })
                .catch(error => console.error("Error:", error));
        }







    </script>
</body>
</html>
