<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SPOT.users.ADMIN.Dashboard" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
     <script>



         function updateTime() {
             const now = new Date();
             const options = {
                 //weekday: 'long',
                 year: 'numeric',
                 month: 'long',
                 //day: 'numeric',
                 hour: '2-digit',
                 minute: '2-digit',
                 second: '2-digit',
                 hour12: true
             };
             const dateTimeElement = document.getElementById("dateTime");
             if (dateTimeElement) {
                 dateTimeElement.innerText = now.toLocaleString('en-US', options);
             } else {
                 console.error('updateTime: dateTime element not found');
             }
         }

         function safeOpenPopup(url, urlEvaluation) {
             console.log('safeOpenPopup: URL:', url, 'Evaluation:', urlEvaluation);
             if (urlEvaluation === 1) {
                 openPopup(url);
             } else {
                 openSidebar(url);
             }
         }

         function openPopup(page) {
             console.log('openPopup: Opening page:', page);
             if (!page || page === "#") {
                 console.error("Invalid pop-up URL.");
                 return;
             }

             let popupFrame = document.getElementById("popupFrame");
             let popupContainer = document.getElementById("popupContainer");
             let overlay = document.getElementById("overlay");

             if (popupFrame && popupContainer && overlay) {
                 popupFrame.src = page;
                 popupContainer.classList.add("show");
                 overlay.classList.add("active");
             } else {
                 console.error("Pop-up elements not found!");
             }
         }

         function openSidebar(page) {
             console.log('openSidebar: Navigating to:', page);
             if (!page || page === "#") {
                 console.error("Invalid page URL.");
                 return;
             }
             window.location.href = page;
         }

         function closePopup() {
             console.log('closePopup: Closing popup');
             const popupContainer = document.getElementById("popupContainer");
             const overlay = document.getElementById("overlay");
             const popupFrame = document.getElementById("popupFrame");
             if (popupContainer && overlay && popupFrame) {
                 popupContainer.classList.remove("show");
                 overlay.classList.remove("active");
                 popupFrame.src = "";
             }
             //refreshDashboard();
         }


         window.onload = function () {
             console.log('window.onload: Initializing');
             updateTime();
             setInterval(updateTime, 999);

         };

         function handleClick(section) {
             console.log(`${section} clicked`);
             // Add your functionality here for each section
         }
     </script>


    <style>
/*        html { }*/
        body {
            overflow: hidden;
            margin: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            display: grid;
            grid-template-areas: 
                "header header header"
                "sidebar main events"
                "sidebar main events";
            grid-template-rows: 60px 1fr 1fr;
            grid-template-columns: 250px 1fr 300px;
            gap: 10px;
            position: relative;
        }
        .header { 
            grid-area: header; 
            background-color: cornflowerblue; 
            display: flex;
            justify-content: space-between; 
            align-items: center; 
            padding: 10px;
        }
    
        .right-section {
            display: flex; 
            align-items: center; 
            gap: 20px;
        }
        .user-profile{
            font-size:30px;
            cursor:pointer;
        }
                .date-time {
            font-size: 18px;
        }
        .sidebar { 
            grid-area: sidebar; 
            background: #e0e0e0; 
            padding: 20px;
/*        height:100vh;*/
            }


      
     .main-container {
    grid-area: main;
    display: flex;
    flex-wrap: wrap; /*    allows items to wrap onto the next line if needed */
    justify-content: center;
    align-items: flex-start;
    background: #f5f5f5;
    gap: 20px;  
    padding: 20px;
}

.content-container {
    width: 850px; /* or whatever fixed width you prefer */
    height: 175px; /* adjust based on content */
    display: grid;
    grid-template-rows: 1fr 1fr 1fr;
    background-color: white;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    border-radius: 8px;
    padding: 10px;
    font-size: 20px;
    font-weight: bold;
    transition: background 0.5s;
    cursor:pointer;
}

.content-container:hover {
    background: #007bff;
        box-shadow: 0 0 10px rgba(0,0,0,0.4);


}

        .officers, .check-logs, .campus-content { 
            background: #d0d0d0; 
            border: 2px solid black; 
            padding: 10px; 
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            height: 100%;
            box-sizing: border-box;
            cursor: pointer;
        }
        .officers:hover, .check-logs:hover, .campus-content:hover, .calendar:hover, .event-content:hover {
            background: #c0c0c0;
        }
        .officers span, .check-logs span, .campus-content span {
            margin-top: 5px;
        }
       .events {
    grid-area: events;
    background: #e0e0e0;
    padding: 20px;
    overflow-y: auto;
}

.events-wrapper {
    display: flex;
    flex-direction: column;
    gap: 12px;
    height: 100%;
}

.event-item {
    height:250px;
    background: #d0d0d0;
    border: 2px solid black;
    text-align: center;
    padding: 10px;
    flex: 0 0 auto;
    border-radius: 6px;
    transition: background 0.3s ease;
    cursor: pointer;
    font-weight: bold;
}

.event-item:hover {
    background-color: #c0c0c0;
}



        .logout-button {
            position: absolute;
            bottom: 15px;
            right: 15px;
            width: 100px;
            height: 40px;
            background: #ff4d4d;
            color: white;
            border: none;
            cursor: pointer;
            margin: 0;
            padding: 0;
        }



        

   /* Overlay for Blurring */
   .overlay {
       position: fixed;
       top: 0;
       left: 0;
       width: 100%;
       height: 100%;
       background: rgba(0, 0, 0, 0.5);
       display: none;
       z-index: 999;
   }

   .overlay.active {
       display: block;
   }

   /* Pop-up Container */
   .popup {
       position: fixed;
       width: 100vw;
       height: 100vh;
       background: rgba(255, 255, 255, 0.2);
       backdrop-filter: blur(3px);
       box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
       border-radius: 10px;
       display: none;
       z-index: 1000;
       overflow: hidden;
   }

   .popup.show {
       display: block;
   }

   /* Pop-up Frame */
   .popup-frame {
       width: 100%;
       height: 100%;
       display: flex;
       align-items: center;
       justify-content: center;
       overflow: auto;
   }

   /* Close Button */
   .close-btn {
       position: absolute;
       top: 15px;
       right: 15px;
       font-size: 40px;
       color: black;
       cursor: pointer;
       background: rgba(255, 255, 255, 0.7);
       border-radius: 50%;
       width: 50px;
       height: 50px;
       display: flex;
       align-items: center;
       justify-content: center;
       transition: 0.3s ease;
   }

   .close-btn:hover {
       background: red;
       color: white;
   }






                  .onDuty-officer-container {
                      align-self:center;
                 margin-left: 240px;
            height: 150px;
            width: 600px;
            position: absolute;
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            gap: 3px;
            border: 3px solid #007bff;
            border-radius: 10px;
            overflow-y: auto;
            padding: 10px;
            box-sizing: border-box;
            background: #f9f9f9;
                transition: background 0.3s, transform 0.2s;

    }

                  .onDuty-officer-container:hover {
/*    background: #007bff;*/
/*    color: white;*/
    box-shadow: 0px 4px 10px rgba(10, 5, 1, 0.2);
    transform: scale(1.5);
    border-radius: 15px;
}
 .onDuty-officer-box {
            display: flex;
            align-items: center;
            border: 2px solid black;
            padding: 5px;
            margin-bottom: 10px;
            border-radius: 20px;
            width: calc(80% - 6px);
            height: 45px;
            box-sizing: border-box;
        }
              

.onDuty-officer-profile-picture {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }
        .onDuty-officer-name {
            flex: 1;
            text-align: center;
            font-size: 16px;
        }

        .officer-count{
            margin-left:60px;
            margin-top:-50px;
            font-size:7em;
color:red;
        }

      
        .CSLViewingbox{
                      align-self:center;
     margin-left: 240px;
height: 150px;
width: 600px;
position: absolute;
display: flex;
flex-direction: row;
flex-wrap: wrap;
gap: 3px;
border: 3px solid #007bff;
border-radius: 10px;
overflow-y: auto;
padding: 10px;
box-sizing: border-box;
background: #f9f9f9;
    transition: background 0.3s, transform 0.2s;

        }

                          .CSLViewingbox:hover {
/*    background: #007bff;*/
/*    color: white;*/
    box-shadow: 0px 4px 10px rgba(10, 5, 1, 0.2);
    transform: scale(1.4);
    border-radius: 15px;
}

.CSLViewingbox th, .CSLViewingbox td {
    font-size:16px;
    border: 1px solid #ccc;
/*    padding: 5px;*/
    text-align: center;
}

.CSLViewingbox th {
        position: sticky;
top:-10%;
/*left:50px;*/
        background-color:cornflowerblue;

}



  /* Sidebar */
  .sidebar {
/*        background-color:cornflowerblue;*/
      gap:10px;
/*      color: yellow;*/
      display: flex;
      flex-direction: column;
/*      position: fixed;*/
/*      top: 80px;
      left: 0px;
      width: 200px;
      height: 100%;
      padding: 10px;*/
  }



  .sidebar a {
      color: black;
      display: flex;
      background-color: #c0c0c0;
      justify-content: flex-end;
      padding: 10px;
      margin: 8px;
      border-radius: 20px;
      box-shadow: 0px 4px 10px rgba(2, 2, 2, 0.1);
      font-size: 18px;
      text-decoration: none;
      font-weight: bold;
      transform: translateX(-25%);
      transition: background 0.3s, transform 0.2s;
  }

  .sidebar a:hover {
      transition: 0.2s;
      background: rgb(0, 208, 255);
      color: white;
      transform: translate(-10px);
  }
   
           



    .download-button-container {
    position: absolute;
    bottom: 10px;
    left: 10px;
}

    .content-container {
    position: relative;
}


    .download-icon {
    text-decoration: none;
    width:7%;
    height:7%;

/*    font-size: 1.5em;*/
/*    color: #007bff;*/
    margin-left: 10px;
}

.download-icon:hover {
    color: #0056b3;
}


    </style>
</head>
<body>
        <div id="overlay" class="overlay" onclick="closePopup()"></div>
    <div id="popupContainer" class="popup">
        <iframe id="popupFrame" class="popup-frame"></iframe>
        <span class="close-btn" onclick="closePopup()">✖</span>
    </div>

    <div class="header">
     <div class="logo">
    <a href="/users/ADMIN/Dashboard.aspx">
        <img class="dashboardlogo" src="/images/logo.png" alt="SPOT logo Img" width="55" height="55">
    </a>
</div>
        <div class="right-section">
            <span class="date-time" id="dateTime"></span>
            <div class="user-profile" onclick="safeOpenPopup('/users/Popup_master/PROFILE.aspx', 1)">👤</div>

        </div>
    </div>
    <div class="sidebar">
     <asp:Repeater ID="SidebarMenu" runat="server">
         <ItemTemplate>
             <a href="javascript:void(0);" onclick="safeOpenPopup('<%# Eval("Url") as string ?? "#" %>', 0)">
                 <i class='<%# Eval("Icon") %>'></i> <%# Eval("Title") %>
             </a>
         </ItemTemplate>
     </asp:Repeater>
    </div>

        <div class="main-container">
        <asp:Repeater ID="DashboardBoxes" runat="server">
            <ItemTemplate> 
                <div class="content-container" onclick="safeOpenPopup('<%# Eval("Url") as string ?? "#" %>', 1)">
                    <%# Eval("Title").ToString().Contains("|") 
                        ? Eval("Title").ToString().Split('|')[0] 
                        : Eval("Title") %>  
                    <asp:Literal ID="onDutyOfficersCount" runat="server" EnableViewState="false" Text='<%# CountOndutyOfficers(Eval("Title").ToString()) %>' />
                    <asp:Literal ID="officersOnDuty" runat="server" EnableViewState="false" Text='<%# GetOnDutyOfficers(Eval("Title").ToString()) %>' />
                    <asp:Literal ID="forHistory" runat="server" EnableViewState="false" Text='<%# showHistoryViewState(Eval("Title").ToString()) %>' />
                    <asp:Literal ID="ClickableReset" runat="server" EnableViewState="false" Text='<%# HistoryReset(Eval("Title").ToString()) %>' />
                    <asp:Literal ID="ClickableHARDReset" runat="server" EnableViewState="false" Text='<%# HistoryHARDReset(Eval("Title").ToString()) %>' />

                 


                    <asp:Literal ID="ViewState" runat="server" EnableViewState="false" Text='<%# SysLogs(Eval("Title").ToString()) %>' />


                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

<div class="events">
    <div class="events-wrapper">
        <asp:Repeater ID="DashboardBoxes_Side" runat="server">
            <ItemTemplate> 
                <div class="event-item" onclick="safeOpenPopup('<%# Eval("Url") as string ?? "#" %>', 1)">
                    <%# Eval("Title").ToString().Contains("|") 
                        ? Eval("Title").ToString().Split('|')[0] 
                        : Eval("Title") %>  
                    <asp:Literal ID="onDutyOfficers" runat="server" EnableViewState="false" Text='<%# GetCalendarDateMarkup(Eval("Title").ToString()) %>' />
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
    <form id="form1" runat="server">   

                    <asp:Button ID="Button1" runat="server" Text="Logout" CssClass="logout-button" OnClick="btnLogout_Click" />
        </form>
</body>
</html>