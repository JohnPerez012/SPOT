<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Fullcalendar_Scheduler.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Fullcalendar_Scheduler" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
      <title></title>
</head>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar-scheduler/index.global.min.js'></script>
    <script>

        document.addEventListener('DOMContentLoaded', function () {
            const calendarEl = document.getElementById('calendar')
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'resourceTimelineMonth'
            })
            calendar.render()
        })

    </script>
  <body>
    <form id="form1" runat="server">

    <div id='calendar'></div>
    </form>

  </body>
</html>