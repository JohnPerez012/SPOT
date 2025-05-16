<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SPOT.users.DEFAULT.Dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <script>








        function openPopup(page) {
            if (!page || page === "#") return;
            document.getElementById("popupFrame").src = page;
            document.getElementById("popupContainer").classList.add("show");
            document.getElementById("overlay").classList.add("active");
        }

        function closePopup() {
            document.getElementById("popupContainer").classList.remove("show");
            document.getElementById("overlay").classList.remove("active");
            document.getElementById("popupFrame").src = "";

            fetch("Dashboard.aspx/UpdateCircles", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({})
            })
                .then(res => res.json())
                .then(data => {
                    const result = data.d;
                    const values = [result.university, result.visitors, result.vehicles];
                    const circles = document.querySelectorAll(".pending-circles-container .circle");

                    circles.forEach((circle, index) => {
                        const count = parseInt(values[index], 10);
                        circle.innerText = count;
                        circle.classList.toggle("green", count === 0);
                    });
                })
                .catch(err => console.error("Error updating circles:", err));
        }

        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("hidden");
        }

        function updateTime() {
            const now = new Date();
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
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







        // Function to close the Pin Unlock form
        function closePinUnlockForm() {
            const form = document.querySelector('.pin-unlock-form');
            form.style.display = 'none'; // Hides the form when "Cancel" is clicked
        }


        // Function to unlock the system (to be triggered on the "Unlock" button click)
        function unlockSystem() {
            // Assuming you have some logic to "unlock" the system here
            // You can set a session variable, change the UI, or trigger a backend request
            alert('System unlocked!'); // Placeholder alert for testing

            // For example, you could set a hidden field or change the UI to indicate unlocked state
            document.getElementById('lockStatus').innerText = 'Unlocked';

            // Close the pin unlock form after successful unlock (if needed)
            closePinUnlockForm(); // Hide the form after unlocking
        }

        function openSidebar(page) {
            console.log('openSidebar: Navigating to:', page);
            if (!page || page === "#") {
                console.error("Invalid page URL.");
                return;
            }
            window.location.href = page;
        }


        function safeOpenPopup(url, urlEvaluation) {
            console.log('safeOpenPopup: URL:', url, 'Evaluation:', urlEvaluation);
            if (urlEvaluation === 1) {
                openPopup(url);
            } else {
                openSidebar(url);
            }
        }
        window.onload = function () {
            console.log('window.onload: Initializing');
            updateTime();
            setInterval(updateTime, 1000);
        };


    </script>
</head>
<body>
<form id="form1" runat="server" style="width:100%; height:100%;">
            <div class="lockBlurProtection" id="lockBlurProtectionCard" runat="server"></div>
        <asp:HiddenField ID="hdnIsLocked" runat="server" Value="false" />

        <!-- Overlay -->
        <div id="overlay" class="overlay" onclick="closePopup()"></div>

    <div class="card" id="lockCard" runat="server">
            <h2>Account Locked</h2>
            <asp:TextBox ID="txtPin" runat="server" TextMode="Password" placeholder="Enter PIN" CssClass="input" />
            <br />
            <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false" />
            <div>
                <asp:Button ID="btnUnlock" runat="server" Text="UNLOCK ACCOUNT" CssClass="unlock-btn" OnClick="btnUnlock_Click" />
                <asp:Button ID="btnSysUnlock" runat="server" Text="UNLOCK sys" CssClass="unlock-btn" OnClick="btnSystemUnlock_Click" />
                <asp:Button ID="btnLogout" runat="server" Text="LOGOUT" CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div> 



        <!-- Header -->
        <div class="header">
            <div class="menu-icon" onclick="toggleSidebar()">☰</div>
            <asp:Label ID="Label1" CssClass="hello-text" runat="server" Text="MODERN SECURITY PERSONNEL OPERATION AND TASK"></asp:Label>
            <span class="date-time" id="dateTime"></span>
            <div class="dropdown">
                <div class="dropdown-icon">⧋</div>
                <div class="dropdown-content">
                    <asp:Button ID="Button1" runat="server" Text="Logout" CssClass="logout-btn" OnClick="btnLogout_Click" />
                    <asp:Button ID="Button0" runat="server" Text="Lock Account" CssClass="lock-btn" OnClick="btnAccountLOCK_Click" />
                </div>
            </div>
            <div class="notification-icon" onclick="showNotification()">
                <i class="fa fa-bell"></i>
                <span class="notification-count">3</span>
            </div>
            <div class="profile" onclick="safeOpenPopup('/users/Popup_master/PROFILE.aspx', 1)">👤</div>
        </div>

         <div id="sidebar" class="sidebar hidden">
            <asp:Repeater ID="SidebarMenu" runat="server">
                <ItemTemplate>
                    <a href="javascript:void(0);" onclick="safeOpenPopup('<%# Eval("Url") as string ?? "#" %>', 0)">
                        <i class='<%# Eval("Icon") %>'></i> <%# Eval("Title") %>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>



        <!-- Pop-up Container -->
        <div id="popupContainer" class="popup">
            <iframe id="popupFrame" class="popup-frame"></iframe>
            <span class="close-btn" onclick="closePopup()">✖</span> 
        </div>

        <!-- Dashboard -->
        <div class="dashboard-container">
            <asp:Repeater ID="DashboardBoxes" runat="server">
                <ItemTemplate>
                    <div class="box" onclick="safeOpenPopup('<%# Eval("Url") as string ?? "#" %>', 1)">
                        <%# Eval("Title").ToString().Contains("|") 
                            ? Eval("Title").ToString().Split('|')[0] 
                            : Eval("Title") 
                        %>
                        <asp:Literal ID="litDateToday" runat="server" EnableViewState="false" Text='<%# GetCalendarDateMarkup(Eval("Title").ToString()) %>' />
                       <asp:Literal ID="litPendingCircles" runat="server" EnableViewState="false" Text='<%# GetPendingCircles(Eval("Title").ToString()) %>' />
                               </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>