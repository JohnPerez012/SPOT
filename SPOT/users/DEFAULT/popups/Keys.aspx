<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Keys.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Keys" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Key Management System</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: white;
            margin: 0;
        }

        .key-container {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            justify-content: center;
        }

        @media screen and (min-width: 600px) {
            .key-container {
                grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
                max-width: 500px;
            }
        }

        .key-box {
            color: black;
            padding: 20px 35px;
            text-align: center;
            border-radius: 12px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            border: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 120px;
            width: auto;
        }

        .key-box:hover {
            background: rgba(0, 0, 0, 0.1);
            transform: scale(1.1);
        }

        .borrowed {
            background: rgba(255, 0, 0, 0.7) !important;
        }

        .available {
            background: #00c897;
        }

        .form-popup {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.3);
            width: 350px;
            text-align: center;
            transition: all 0.3s ease-in-out;
            color: black;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: none;
            border: 1px solid black;
            z-index: 1000;
        }

        .form-popup:not(.hidden) {
            display: block;
        }

        .hidden {
            display: none;
        }

        input[type="text"], textarea {
            width: 90%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid black;
            margin-top: 8px;
            font-size: 14px;
            background: white;
            color: black;
        }

        input:focus, textarea:focus {
            outline: none;
            border: 2px solid black;
        }

        .btn-primary {
            background: #00c897;
            color: black;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: #00a579;
        }

        .btn-secondary {
            background: #e63946;
            color: black;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-secondary:hover {
            background: #d62839;
        }

        input[type="checkbox"] {
            margin-top: 10px;
        }

        .register-bar {
            position: fixed;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 50px;
            height: 300px;
            background-color: rgb(0, 208, 255);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1000;
            transition: transform 0.3s ease, background-color 0.3s ease;
            border-radius: 10px 0 0 10px;
            box-shadow: -2px 0 5px rgba(0, 0, 0, 0.2);
        }

        .register-bar:hover {
            transform: translateY(-50%) scale(1.1);
            background-color: cornflowerblue;
        }

        .register-bar span {
            writing-mode: vertical-rl;
            color: white;
            font-size: 18px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .form-header span {
            display: block;
            font-size: 12px;
            color: #555;
            margin-bottom: 10px;
        }

        .form-body label {
            display: block;
            text-align: left;
            margin: 10px 0 5px;
        }
    </style>
    <script>
        function toggleCKBar() {
            const modal = document.getElementById("registerFormModal");
            modal.classList.toggle("hidden");
            if (!modal.classList.contains("hidden")) {
                updateDateTime();
            }
        }

        function updateDateTime() {
            const dateTimeElement = document.getElementById("currentDateTime");
            const now = new Date();
            dateTimeElement.textContent = now.toLocaleString();
        }

        function validateRegisterAgreement() {
            let createBtn = document.getElementById("<%= btnCreate.ClientID %>");
            let confirmCheckbox = document.getElementById("<%= chkConfirm.ClientID %>");
            createBtn.disabled = !confirmCheckbox.checked;
        }

        function showForm(key, isBorrowed, borrower, contact, id, borrowTime) {
            event.preventDefault();
            document.getElementById("<%= hiddenSelectedKey.ClientID %>").value = key;
            document.getElementById("BorrowForm").classList.add("hidden");
            document.getElementById("ReturnForm").classList.add("hidden");

            if (isBorrowed === "True") {
                document.getElementById("ReturnKey").value = key;
                document.getElementById("BorrowedBy").innerText = borrower ? borrower : "Unknown";
                document.getElementById("BorrowedContact").innerText = contact ? contact : "N/A";
                document.getElementById("BorrowedID").innerText = id ? id : "N/A";
                document.getElementById("BorrowedTime").innerText = borrowTime ? borrowTime : "N/A";
                document.getElementById("ReturnForm").classList.remove("hidden");
            } else {
                document.getElementById("BorrowForm").classList.remove("hidden");
            }
        }

        function validateAgreement() {
            let submitBtn = document.getElementById("<%= btnSubmit.ClientID %>");
            let agreeCheckbox = document.getElementById("<%= chkAgree.ClientID %>");
            submitBtn.disabled = !agreeCheckbox.checked;
        }

        function closeForm(formId) {
            document.getElementById(formId).classList.add("hidden");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-bar" onclick="toggleCKBar()"><span>REGISTER NEW CAMPUS KEY</span></div>
        <asp:HiddenField ID="hiddenSelectedKey" runat="server" />

        <!-- Register New Campus Key Modal -->
        <div id="registerFormModal" class="form-popup hidden">
            <div class="modal-content">
                <div class="form-header">
                    <span id="currentDateTime"></span>
                    <h3>CAMPUS KEY IDENTITY</h3>
                </div>
                <div class="form-body">
                    <label for="txtKeyName">Key Name:</label>
                    <asp:TextBox ID="txtKeyName" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-footer">
                    <asp:CheckBox ID="chkConfirm" runat="server" onchange="validateRegisterAgreement()" />
                    <label for="chkConfirm">Confirm</label>
                    <asp:Button ID="btnCreate" runat="server" Text="Create" CssClass="btn-primary" OnClick="CreateNewKey" disabled="disabled" />
                    <button type="button" class="btn-secondary" onclick="closeForm('registerFormModal')">Cancel</button>
                </div>
            </div>
        </div>

        <div class="key-container">
            <asp:Repeater ID="rptKeys" runat="server">
                <ItemTemplate>
                    <button type="button"
                            class="key-box <%# Convert.ToBoolean(Eval("IsBorrowed")) ? "borrowed" : "available" %>"
                            onclick="showForm('<%# Eval("KeyName") %>', '<%# Eval("IsBorrowed").ToString() %>', '<%# Eval("BorrowerName") %>', '<%# Eval("ContactNumber") %>', '<%# Eval("BorrowerID") %>', '<%# Eval("BorrowTime") %>')">
                        <%# Eval("KeyName") %>
                        <%# Convert.ToBoolean(Eval("isLost")) ? " (Lost)" : "" %>
                    </button>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Borrow Form -->
        <div id="BorrowForm" class="form-popup hidden">
            <h2>Borrow Key</h2>
            <label>Full Name</label>
            <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
            <label>ID Number</label>
            <asp:TextBox ID="txtID" runat="server"></asp:TextBox>
            <label>Contact Number</label>
            <asp:TextBox ID="txtContact" runat="server"></asp:TextBox>
            <label>Purpose</label>
            <asp:TextBox ID="txtPurpose" runat="server" TextMode="MultiLine"></asp:TextBox>
            <asp:CheckBox ID="chkAgree" runat="server" onchange="validateAgreement()" />
            <label>I agree to return this key.<br />I agree that I am responsible for returning the key.<br />If lost, I will be accountable.</label>
            <br />
            <asp:Button ID="btnSubmit" runat="server" Text="BORROW" CssClass="btn-primary" OnClick="btnSubmit_Click" disabled="disabled" />
            <button type="button" class="btn-secondary" onclick="closeForm('BorrowForm')">Cancel</button>
        </div>

        <!-- Return Form -->
        <div id="ReturnForm" class="form-popup hidden">
            <h2>Return Key</h2>
            <asp:HiddenField ID="ReturnKey" runat="server" />
            <h3>Borrowed By:</h3>
            <p>Name: <span id="BorrowedBy"></span></p>
            <p>Contact: <span id="BorrowedContact"></span></p>
            <p>ID Number: <span id="BorrowedID"></span></p>
            <p>Time Borrowed: <span id="BorrowedTime"></span></p>
            <label>Returnee Name</label>
            <asp:TextBox ID="txtReturnee" runat="server"></asp:TextBox>
            <asp:Button ID="btnReturn" runat="server" Text="RETURN" CssClass="btn-primary" OnClick="btnReturn_Click" />
            <button type="button" class="btn-secondary" onclick="closeForm('ReturnForm')">Cancel</button>
        </div>
    </form>
</body>
</html>