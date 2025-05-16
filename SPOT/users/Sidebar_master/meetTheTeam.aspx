<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="meetTheTeam.aspx.cs" Inherits="SPOT.users.Sidebar_master.meetTheTeam" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meet The Team</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
        }

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #007bff;
            color: white;
            padding: 15px 20px;
            width: 100%;
            position: fixed; /* Changed to fixed to prevent any movement */
            top: 0;
            left: 0; /* Ensures no left-right movement */
            z-index: 1000;
        }

        /* Menu Icon */
        .menu-icon {
            font-size: 24px;
            cursor: pointer;
        }

        /* Center "Hello" */
        .hello-text {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            font-size: 20px;
            font-weight: bold;
        }

        /* Date-Time */
        .date-time {
            position: absolute;
            right: 150px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
        }

        /* Profile Icon */
        .profile {
            position: absolute;
            right: 50px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 24px;
            cursor: pointer;
        }

        /* Notification Icon */
        .notification-icon {
            position: absolute;
            right: 100px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }

        .notification-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background: red;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
        }

        /* Logout Button */
        .logout-btn {
            position: absolute;
            right: 80px;
            top: 50%;
            transform: translateY(-50%);
            background: red;
            color: white;
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: darkred;
        }

 
.sidebar {
    color: yellow;
    display: flex;
    flex-direction: column;
    position: fixed;
    top: 80px;
    left: 0px;
    width: 200px;
    height: 100%;
    padding: 10px;
}

    .sidebar.hidden {
        display: none;
    }



    .sidebar a {
        color: black;
        display: flex;
        justify-content: flex-end;
        padding: 10px;
        margin: 8px;
        border-radius: 20px;
        box-shadow: 0px 4px 10px rgba(2, 2, 2, 0.1);
        font-size: 18px;
        text-decoration: none;
        font-weight: bold;
        transform: translateX(-35%);
        transition: background 0.3s, transform 0.2s;
    }

        .sidebar a:hover {
            transition: 0.2s;
            background: rgb(0, 208, 255);
            color: white;
            transform: translate(-50px);
        }

        /* Overlay */
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

        /* Popup Container */
        .popup {
            position: fixed;
                top: 0;
    left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(3px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            display: none;
            z-index: 1000;
            overflow: hidden;
        }

        .popup.show {
            display: block;
        }

        /* Popup Frame */
        .popup-frame {
            width: 100%;
            height: 100%;
            border: none;
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
            transition: background 0.3s ease;
        }

        .close-btn:hover {
            background: red;
            color: white;
        }

        /* PIN Overlay */
        .pin-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .pin-popup {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            width: 300px;
        }

        .pin-popup button {
            margin: 10px;
            padding: 8px 16px;
            cursor: pointer;
        }

        .pin-popup input {
            margin: 10px 0;
            padding: 8px;
            width: 80%;
        }

        /* Inactivity Notification */
        .inactive-notification {
            display: none;
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #ff4f4f;
            color: white;
            padding: 15px 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            font-size: 16px;
            z-index: 9999;
            animation: fadeIn 0.5s ease-in-out;
        }

        .inactive-notification.show {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .inactive-notification button {
            background-color: white;
            color: #ff4f4f;
            border: none;
            font-weight: bold;
            font-size: 18px;
            padding: 4px 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateX(-50%) translateY(10px); }
            to { opacity: 1; transform: translateX(-50%) translateY(0); }
        }

        body.locked .main-container,
        body.locked .profile,
        body.locked .notification-icon {
            pointer-events: none;
            opacity: 0.4;
        }

        body:not(.locked) .main-container,
        body:not(.locked) .profile,
        body:not(.locked) .notification-icon {
            pointer-events: auto;
            opacity: 1;
        }

        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 80px auto 50px; /* Adjusted to prevent overlap with fixed header */
            padding: 20px;
            text-align: center;
            font-family: 'Arial', sans-serif;
        }

        /* Grid Layout */
        .team-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            justify-items: center;
        }

        /* Individual Frame */
        .team-frame {
            position: relative;
            width: 300px;
            border: 2px solid #007bff;
            border-radius: 10px;
            overflow: hidden;
            background: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding-bottom: 20px;
        }

        /* Floating Logo */
        .logo {
            position: absolute;
            top: 0;
            left: -5px;
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background: white;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .logo img {
            width: 100%;
            height: 100%;
        }

        /* Profile Picture */
        .profile-picture {
            width: 150px;
            height: 150px;
            margin: 20px auto;
            border-radius: 50%;
            overflow: hidden;
            border: 4px solid #007bff;
        }

        .profile-picture img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Info Section */
        .info-section {
            padding: 0 20px;
            text-align: center;
        }

        .position {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 10px;
            cursor: pointer;
        }

        .name {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .bio {
            font-size: 14px;
            color: #555;
            margin-bottom: 20px;
            cursor: pointer;
        }

        /* Editable Input */
        .edit-input {
            width: 100%;
            padding: 5px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        /* Responsive Design */
        @media (max-width: 1000px) {
            .team-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .team-grid {
                grid-template-columns: 1fr;
            }
            .team-frame {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="overlay" class="overlay" onclick="closePopup()"></div>

        

        <div class="header">
            <div class="menu-icon" onclick="toggleSidebar()">☰</div>
            <asp:Label ID="Label1" CssClass="hello-text" runat="server" Text="MODERN SECURITY PERSONNEL OPERATION AND TASK"></asp:Label>
            <span class="date-time" id="dateTime"></span>
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

        <div id="popupContainer" class="popup">
            <iframe id="popupFrame" class="popup-frame"></iframe>
            <span class="close-btn" onclick="closePopup()">✖</span>
        </div>

        <div class="main-container">
            <h1>Meet Our Team</h1>
            <asp:Panel ID="TeamGrid" runat="server" CssClass="team-grid">
                <!-- Dynamically populated in code-behind -->
            </asp:Panel>
        </div>

        <div id="inactiveNotification" class="inactive-notification">
            <span id="inactiveText">You have been inactive for <span id="inactiveTimer">0:00</span>. Press any key or move the mouse to stay active.</span>
        </div>
    </form>

    <script>
        

        // Initialize PIN attempts
        if (!localStorage.getItem("pinAttempts")) {
            localStorage.setItem("pinAttempts", "0");
        }

        function initializeLockState() {
            return fetch("Dashboard.aspx/GetSystemLocked", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({})
            })
                .then(response => response.json())
                .then(data => {
                    console.log("GetSystemLocked response:", data);
                    if (data.d) {
                        localStorage.setItem("isLocked", "true");
                        showLockScreen();
                    } else {
                        localStorage.removeItem("isLocked");
                        document.body.classList.remove("locked");
                    }
                    return data.d;
                })
                .catch(error => {
                    console.error("Failed to get lock state:", error);
                    return false;
                });
        }

        function limitPinAttempts() {
            let attempts = parseInt(localStorage.getItem("pinAttempts") || "0");
            const maxAttempts = 3;
            if (attempts >= maxAttempts) {
                console.log("Max PIN attempts reached. Logging out.");
                logoutUser();
                return false;
            }
            return true;
        }

        function showLockScreen() {
            document.body.classList.add("locked");
            const pinOverlay = document.getElementById("pinOverlay");
            pinOverlay.style.display = "flex";
            setTimeout(() => {
                document.getElementById("pinInput").focus();
            }, 100);
        }

        function unlockSystem() {
            console.log("Unlocking system...");
            localStorage.removeItem("isLocked");
            localStorage.setItem("pinAttempts", "0");
            const pinOverlay = document.getElementById("pinOverlay");
            pinOverlay.style.display = "none";
            document.body.classList.remove("locked");
            setTimeout(() => {
                document.getElementById("pinInput").blur();
            }, 100);
        }

        function inactivityTime() {
            let timeout;
            let countingInterval;
            const notifyAfter = 2; // 10 Minutes
            const lockAfter = 3; // 17.5 Minutes
            let inactiveSeconds = 0;

            function lockSystem() {
                localStorage.setItem("isLocked", "true");
                clearInterval(countingInterval);
                document.getElementById("inactiveNotification").classList.add("show");
                document.getElementById("inactiveNotification").style.backgroundColor = "#222";
                document.getElementById("inactiveText").innerText = "SYSTEM LOCKED";
                fetch("Dashboard.aspx/SetSystemLocked", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ locked: true })
                })
                    .then(response => response.json())
                    .catch(error => console.error("Locking failed:", error));
                showLockScreen();
            }

            function updateInactiveDisplay() {
                const mins = Math.floor(inactiveSeconds / 60);
                const secs = inactiveSeconds % 60;
                const display = `${mins}:${secs < 10 ? '0' : ''}${secs}`;
                document.getElementById("inactiveTimer").innerText = display;
            }

            function showInactiveNotice() {
                document.getElementById("inactiveNotification").classList.add("show");
                updateInactiveDisplay();
                countingInterval = setInterval(() => {
                    inactiveSeconds++;
                    updateInactiveDisplay();
                    if (inactiveSeconds >= lockAfter) {
                        clearInterval(countingInterval);
                        lockSystem();
                    }
                }, 1000);
            }

            function resetTimer() {
                if (localStorage.getItem("isLocked") === "true") return;
                localStorage.setItem("lastInteraction", Date.now().toString());
                clearTimeout(timeout);
                clearInterval(countingInterval);
                inactiveSeconds = 0;
                document.getElementById("inactiveNotification").classList.remove("show");
                timeout = setTimeout(() => {
                    inactiveSeconds = notifyAfter;
                    showInactiveNotice();
                }, notifyAfter * 1000);
            }

            const resetEvents = ['mousemove', 'keypress', 'scroll', 'click', 'mousedown', 'touchstart'];
            resetEvents.forEach(event => {
                document.addEventListener(event, resetTimer, { passive: true });
            });

            return resetTimer;
        }

        function dismissInactivity() {
            document.getElementById("inactiveNotification").classList.remove("show");
            inactivityTime()();
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
            document.getElementById("dateTime").innerText = now.toLocaleString('en-US', options);
        }

        window.onload = async function () {
            updateTime();
            setInterval(updateTime, 1000);
            if (localStorage.getItem("isLocked") === "true") {
                await initializeLockState();
            } else {
                localStorage.removeItem("isLocked");
                document.body.classList.remove("locked");
            }
            const resetTimer = inactivityTime();
            resetTimer();
        };

        function logoutUser() {
            console.log("Logging out...");
            localStorage.removeItem("isLocked");
            localStorage.setItem("pinAttempts", "0");
            window.location.href = "../log_in/logout.aspx";
        }

        function safeOpenPopup(url, urlEvaluation) {
            if (urlEvaluation === 1) {
                openPopup(url);
            } else {
                openSidebar(url);
            }
        }

        function showNotification() {
                showLockScreen();
        }

        function openPopup(page) {
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
            if (!page || page === "#") {
                console.error("Invalid page URL.");
                return;
            }
            window.location.href = page; // Navigate directly to the page
        }

        function closePopup() {
            document.getElementById("popupContainer").classList.remove("show");
            document.getElementById("overlay").classList.remove("active");
            document.getElementById("popupFrame").src = "";
        }

        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("hidden");
        }

        function submitPin() {
            if (!limitPinAttempts()) return;
            const enteredPin = document.getElementById("pinInput").value;
            if (!enteredPin) {
                document.getElementById("pinError").style.display = "block";
                document.getElementById("pinError").innerText = "Please enter a PIN";
                return;
            }
            console.log("Submitting PIN:", enteredPin);
            fetch("Dashboard.aspx/TryUnlock", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ pin: enteredPin })
            })
                .then(response => {
                    if (!response.ok) throw new Error("Network response was not ok");
                    return response.json();
                })
                .then(data => {
                    console.log("TryUnlock response:", data);
                    if (data.d) {
                        unlockSystem();
                        document.getElementById("pinError").style.display = "none";
                        inactivityTime()();
                    } else {
                        let attempts = parseInt(localStorage.getItem("pinAttempts") || "0") + 1;
                        localStorage.setItem("pinAttempts", attempts.toString());
                        document.getElementById("pinError").style.display = "inline";
                        document.getElementById("pinError").innerText = `Invalid PIN. ${3 - attempts} attempts remaining.`;
                    }
                })
                .catch(err => {
                    console.error("PIN validation failed:", err);
                    document.getElementById("pinError").style.display = "inline";
                    document.getElementById("pinError").innerText = "Error validating PIN. Please try again.";
                });
        }

        function isSystemLocked() {
            const isLocked = localStorage.getItem("isLocked") === "true";
            if (isLocked) {
                showLockScreen();
            }
            return isLocked;
        }

        // Prevent form submission on Enter key
        document.getElementById("pinInput").addEventListener("keypress", function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                submitPin();
            }
        });

        // Team-specific edit functionality
        function editField(serial, field) {
            const element = document.getElementById(`${field}-${serial}`);
            const currentValue = element.innerText === 'N/A' ? '' : element.innerText;
            const input = document.createElement('input');
            input.type = 'text';
            input.value = currentValue;
            input.className = 'edit-input';
            input.onblur = function () {
                saveField(serial, field, input.value);
                element.innerText = input.value || 'N/A';
                element.style.display = 'block';
                input.remove();
            };
            element.style.display = 'none';
            element.parentNode.insertBefore(input, element);
            input.focus();
        }

        function saveField(serial, field, value) {
            const data = { serial: serial, field: field, value: value };
            fetch('meetTheTeam.aspx/SaveProfileData', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
                .then(response => response.json())
                .then(data => {
                    if (!data.success) {
                        alert('Error saving data: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error: ' + error.message);
                });
        }
    </script>
</body>
</html>