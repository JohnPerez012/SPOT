<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="SPOT.log_in.login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" href="login.css" />

</head>

<script>
    function moveNext(input, nextRowStartId = null) {
        let numericRegex = /^[0-9]*$/;

        if (!numericRegex.test(input.value)) {
            input.value = input.value.replace(/\D/g, ''); // Remove non-numeric characters
            alert("⚠️ Only numbers are allowed in Serial and PIN fields!");
            return;
        }

        if (input.value.length === 1) {
            let next = input.nextElementSibling;

            // Skip to the next empty field
            while (next && next.value.length === 1) {
                next = next.nextElementSibling;
            }

            if (next) {
                next.focus();
            } else if (nextRowStartId) {
                document.getElementById(nextRowStartId).focus();
            }
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        let serialInputs = document.querySelectorAll(".digit-box");
        let pinInputs = document.querySelectorAll(".pin-box");

        // Automatically focus on serial4 when page loads
        document.getElementById("serial4").focus();

        function checkSerialComplete() {
            let allSerialFilled = Array.from(serialInputs).every(input => input.value.trim() !== "");

            if (allSerialFilled) {
                let firstEmptyPin = Array.from(pinInputs).find(input => input.value.trim() === "");
                if (firstEmptyPin) {
                    firstEmptyPin.focus();
                }
            }
        }

        serialInputs.forEach(input => {
            input.addEventListener("input", checkSerialComplete);
        });
    });




    function zeroPadding(num, digit) {
        var zero = '';
        for (var i = 0; i < digit; i++) {
            zero += '0';
        }
        return (zero + num).slice(-digit);
    }


    function showIncorrect() {
        alert("❌ INCORRECT SERIAL OR PIN");
    }


    function updateTime() {
        let cd = new Date();
        let week = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
        let time = `${zeroPadding(cd.getHours(), 2)}:${zeroPadding(cd.getMinutes(), 2)}:${zeroPadding(cd.getSeconds(), 2)}`;
        let date = `${zeroPadding(cd.getFullYear(), 4)}-${zeroPadding(cd.getMonth() + 1, 2)}-${zeroPadding(cd.getDate(), 2)} ${week[cd.getDay()]}`;

        document.getElementById("time").innerText = time;
        document.getElementById("date").innerText = date;
    }

    function zeroPadding(num, digit) {
        return num.toString().padStart(digit, '0');
    }

    setInterval(updateTime, 1000);
    updateTime();

    function togglePin() {
        let pinBoxes = document.querySelectorAll(".pin-box");
        let btn = document.querySelector(".toggle-btn");
        let isHidden = pinBoxes[0].style.webkitTextSecurity === "disc";

        pinBoxes.forEach(box => {
            box.style.webkitTextSecurity = isHidden ? "none" : "disc";
        });

        btn.textContent = isHidden ? "Hide" : "Show";
    }
</script>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" />
      
         <div class="clock-cont">
        <div id="clock">
            <p class="date" id="date" ></p>
            <p class="time" id="time"></p>
   <!-- <p class="text">DIGITAL CLOCK wsdfds</p> -->  

        </div>
    </div>

                <!-- Loader -->
      

                <div class="container">
                    <!-- Left Side - Logo -->
                    <div class="logo-box">
                        <img src="images/logo.png" alt="Logo" class="logo-img">
                    </div>

                    <!-- Right Side - Login Form -->
                    <div class="login-box">

                   
                        <!-- First Row - SERIAL -->
                        <label class="label">S E R I A L</label>
                        <div class="input-container">
                            <asp:TextBox ID="serial1" CssClass="digit-box" MaxLength="1" runat="server" Text="7" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="serial2" CssClass="digit-box" MaxLength="1" runat="server" Text="2" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="serial3" CssClass="digit-box" MaxLength="1" runat="server" Text="5" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="serial4" CssClass="digit-box" MaxLength="1" runat="server" oninput="moveNext(this, 'pin1')"  ></asp:TextBox>
                            <asp:TextBox ID="serial5" CssClass="digit-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="serial6" CssClass="digit-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                        </div>

                        <!-- Second Row - PIN -->
                        <label class="label">P I N</label>
                        <div class="input-container">
                            <asp:TextBox ID="pin1" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="pin2" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="pin3" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="pin4" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="pin5" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                            <asp:TextBox ID="pin6" CssClass="pin-box" MaxLength="1" runat="server" oninput="moveNext(this)"></asp:TextBox>
                        </div>

                        <div class="button-row">
                            <button type="button" class="toggle-btn" onclick="togglePin()">Show</button>
                            <asp:Button ID="btnLogin" CssClass="toggle-btn login-btn" runat="server" Text="Login" OnClick="btnLogin_Click" />

                        </div>

                            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                    </div>

                </div>

    </form>
</body>
</html>








