
<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-5">
            <h2>Error</h2>
            <div class="alert alert-danger">
                <asp:Label ID="lblErrorMessage" runat="server" Text="An error occurred."></asp:Label>
            </div>
            <a href="InventoryManagement.aspx" class="btn btn-primary">Return to Inventory Management</a>
        </div>
    </form>
    <script>
        // Display the error message from the query string
        document.addEventListener('DOMContentLoaded', function () {
            var urlParams = new URLSearchParams(window.location.search);
            var message = urlParams.get('message');
            if (message) {
                document.getElementById('<%= lblErrorMessage.ClientID %>').innerText = message;
            }
        });
    </script>
</body>
</html>