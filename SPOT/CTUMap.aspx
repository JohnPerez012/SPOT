<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CTUMap.aspx.cs" Inherits="CTUMap.CTUMap" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CTU Daanbantayan Map</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        /* Map iframe taking full screen */
        #map {
            width: 100%;
            height: 100vh; /* Full viewport height */
            border: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Embed Google Maps -->
        <iframe id="map" src="https://www.google.com/maps/d/embed?mid=12UsjR9XJvuP88fXA2hjNvzzI0sNkxHI&ehbc=2E312F"allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </form>
</body>
</html>


