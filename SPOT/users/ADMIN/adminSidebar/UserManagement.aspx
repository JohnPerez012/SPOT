<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="SPOT.users.ADMIN.adminSidebar.UserManagement" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function updateTime() {
            const now = new Date();
            const options = {
                year: 'numeric',
                month: 'long',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true
            };
            const dateTimeString = now.toLocaleString('en-US', options);
            const [date, time] = dateTimeString.split(', ');
            const dateElement = document.getElementById("dateTime");
            const registerDateElement = document.getElementById("registerDate");
            const registerTimeElement = document.getElementById("registerTime");
            if (dateElement) {
                dateElement.innerText = date + ', ' + time;
            }
            if (registerDateElement) {
                registerDateElement.innerText = date;
            }
            if (registerTimeElement) {
                registerTimeElement.innerText = time;
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
        }

        // Modal functions
        let currentRowData = {};
        function showUpdateModal(serial, fname, lname, mname, dob, address, phonenumber, email) {
            console.log('showUpdateModal: Serial:', serial);
            currentRowData = { serial, fname, lname, mname, dob, address, phonenumber, email };
            document.getElementById('updateModal').style.display = 'block';
            document.getElementById('modalOverlay').style.display = 'block';
        }

        function showUpdateFormModal(data) {
            console.log('showUpdateFormModal: Populating form with:', data);
            document.getElementById('updateFormSerial').value = data.serial || '';
            document.getElementById('updateFormHiddenSerial').value = data.serial || '';
            document.getElementById('updateFormFname').value = data.fname || '';
            document.getElementById('updateFormLname').value = data.lname || '';
            document.getElementById('updateFormMname').value = data.mname || '';
            document.getElementById('updateFormDob').value = data.dob || '';
            document.getElementById('updateFormAddress').value = data.address || '';
            document.getElementById('updateFormPhonenumber').value = data.phonenumber || '';
            document.getElementById('updateFormEmail').value = data.email || '';
            document.getElementById('updateFormModal').style.display = 'block';
            document.getElementById('modalOverlay').style.display = 'block';
        }

        function confirmModalAction(type) {
            console.log('confirmModalAction: Type:', type);
            if (type === 'update') {
                // Fetch latest record data via AJAX
                $.ajax({
                    type: "POST",
                    url: "UserManagement.aspx/GetRecord",
                    data: JSON.stringify({ serial: currentRowData.serial }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log('AJAX Success:', response.d);
                        if (response.d) {
                            closeModal();
                            showUpdateFormModal(response.d);
                        } else {
                            alert('Record not found.');
                            closeModal();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', error, xhr.responseText);
                        alert('Failed to fetch record data. Using table data.');
                        closeModal();
                        showUpdateFormModal(currentRowData); // Fallback to table data
                    }
                });
            } else if (type === 'delete') {
                safeOpenPopup(currentRowData.url, 1);
                closeModal();
            }
        }

        function closeModal() {
            console.log('closeModal: Closing modals');
            document.getElementById('updateModal').style.display = 'none';
            document.getElementById('deleteModal').style.display = 'none';
            document.getElementById('updateFormModal').style.display = 'none';
            document.getElementById('registerFormModal').style.display = 'none';
            document.getElementById('modalOverlay').style.display = 'none';
            currentRowData = {};
        }

        function submitUpdateForm() {
            console.log('submitUpdateForm: Validating and submitting');
            const formDiv = document.getElementById('updateRecordForm');
            const serialInput = document.getElementById('updateFormHiddenSerial');
            const fnameInput = document.getElementById('updateFormFname');
            const lnameInput = document.getElementById('updateFormLname');

            // Check validity of required inputs
            if (!serialInput.value) {
                alert('Serial number is required.');
                serialInput.focus();
                return;
            }
            if (!fnameInput.value) {
                alert('First name is required.');
                fnameInput.focus();
                return;
            }
            if (!lnameInput.value) {
                alert('Last name is required.');
                lnameInput.focus();
                return;
            }

            // Log form data
            const formData = {
                serial: document.getElementById('updateFormSerial').value,
                fname: fnameInput.value,
                lname: lnameInput.value,
                mname: document.getElementById('updateFormMname').value,
                dob: document.getElementById('updateFormDob').value,
                address: document.getElementById('updateFormAddress').value,
                phonenumber: document.getElementById('updateFormPhonenumber').value,
                email: document.getElementById('updateFormEmail').value
            };
            console.log('Form Data:', formData);

            // Trigger server-side update
            document.getElementById('hiddenUpdateButton').click();
            closeModal();
        }

        window.onload = function () {
            console.log('window.onload: Initializing');
            updateTime();
            setInterval(updateTime, 999);
        };

        function handleClick(section) {
            console.log(`${section} clicked`);
        }

        function toggleRegisterBar() {
            console.log('toggleRegisterBar: Toggling form');
            const formModal = document.getElementById('registerFormModal');
            const modalOverlay = document.getElementById('modalOverlay');
            if (formModal.classList.contains('active')) {
                formModal.classList.remove('active');
                modalOverlay.style.display = 'none';
            } else {
                formModal.classList.add('active');
                modalOverlay.style.display = 'block';
            }
        }

        function validateRegisterForm() {
            console.log('validateRegisterForm: Validating form');
            const form = document.forms[0]; // Get the first form (ASP.NET form)
            const dobInput = document.getElementById('<%= txtDOB.ClientID %>');
            const fnameInput = document.getElementById('<%= txtFirstName.ClientID %>');
            const lnameInput = document.getElementById('<%= txtLastName.ClientID %>');
            const emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            const phoneInput = document.getElementById('<%= txtPhoneNumber.ClientID %>');
            const pinInput = document.getElementById('<%= txtPin.ClientID %>');

            // Check required fields
            if (!dobInput.value) {
                alert('Date of Birth is required.');
                dobInput.focus();
                return false;
            }
            if (!fnameInput.value) {
                alert('First name is required.');
                fnameInput.focus();
                return false;
            }
            if (!lnameInput.value) {
                alert('Last name is required.');
                lnameInput.focus();
                return false;
            }
            if (!emailInput.value) {
                alert('Email is required.');
                emailInput.focus();
                return false;
            }
            if (!phoneInput.value) {
                alert('Phone number is required.');
                phoneInput.focus();
                return false;
            }
            if (!pinInput.value) {
                alert('PIN is required.');
                pinInput.focus();
                return false;
            }

            // Trigger ASP.NET validation
            if (typeof Page_ClientValidate === 'function' && Page_ClientValidate()) {
                console.log('validateRegisterForm: Validation passed, triggering postback');
                __doPostBack('<%= Button1.UniqueID %>', '');
            } else {
                alert('Please correct the highlighted errors before submitting.');
            }
            return false; // Prevent default form submission
        }

        function showDeleteModal(serial) {
            console.log('showDeleteModal: Serial:', serial);
            // Set hidden field
            const hdnSerial = document.getElementById('<%= hdnSerial.ClientID %>');
            hdnSerial.value = serial;
            console.log('showDeleteModal: hdnSerial set to:', hdnSerial.value);

            // Fetch account details via AJAX
            $.ajax({
                type: "POST",
                url: "UserManagement.aspx/GetRecord",
                data: JSON.stringify({ serial: serial }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('AJAX Success:', response.d);
                    if (response.d) {
                        document.getElementById('modalSerial').textContent = response.d.serial || '';
                        document.getElementById('modalFullName').textContent = response.d.fname + ' ' + (response.d.mname ? response.d.mname + ' ' : '') + response.d.lname;
                        document.getElementById('modalFname').textContent = response.d.fname || '';
                        document.getElementById('modalMname').textContent = response.d.mname || '';
                        document.getElementById('modalLname').textContent = response.d.lname || '';
                        document.getElementById('modalDob').textContent = response.d.dob || '';
                        document.getElementById('modalPhone').textContent = response.d.phonenumber || '';
                        document.getElementById('modalAddress').textContent = response.d.address || '';
                        document.getElementById('modalEmail').textContent = response.d.email || '';
                        document.getElementById('modalAlias').textContent = response.d.alias || '';
                        document.getElementById('modalRole').textContent = response.d.role || '';
                        document.getElementById('modalDateTime').textContent = new Date().toLocaleString();

                        // Reset checkboxes
                        document.getElementById('<%= chkConfirmDelete.ClientID %>').checked = false;
                        document.getElementById('<%= chkAdminConfirm.ClientID %>').checked = false;

                        // Show modal and overlay
                        document.getElementById('deleteModal').style.display = 'block';
                        document.getElementById('modalOverlay').style.display = 'block';
                    } else {
                        alert('Account not found.');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX Error:', error, xhr.responseText);
                    alert('Failed to fetch account details.');
                }
            });
        }

        function hideDeleteModal() {
            console.log('hideDeleteModal: Hiding modal');
            document.getElementById('deleteModal').style.display = 'none';
            document.getElementById('modalOverlay').style.display = 'none';
            // Do not clear hdnSerial to preserve value for postback
        }

        function validateDeleteForm() {
            console.log('validateDeleteForm: Validating checkboxes');
            var chkConfirm = document.getElementById('<%= chkConfirmDelete.ClientID %>');
            var chkAdmin = document.getElementById('<%= chkAdminConfirm.ClientID %>');
            var hdnSerial = document.getElementById('<%= hdnSerial.ClientID %>');
            if (!chkConfirm.checked || !chkAdmin.checked) {
                alert('Please check both confirmation boxes to proceed with deletion.');
                console.log('validateDeleteForm: Validation failed');
                return false;
            }
            if (!hdnSerial.value) {
                alert('Serial number is missing.');
                console.log('validateDeleteForm: Missing serial number');
                return false;
            }
            console.log('validateDeleteForm: Validation passed, serial:', hdnSerial.value);
            // Ensure modal remains visible during postback
            document.getElementById('deleteModal').style.display = 'block';
            document.getElementById('modalOverlay').style.display = 'block';
            // Explicitly trigger postback
            console.log('validateDeleteForm: Triggering postback for btnConfirmDelete');
            __doPostBack('<%= btnConfirmDelete.UniqueID %>', '');
            return false; // Prevent default form submission
        }
    </script>
    <style>
        body {
            overflow: hidden;
            margin: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f5f5f5;
        }

        .header {
            background-color: cornflowerblue;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .right-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-profile {
            font-size: 30px;
            cursor: pointer;
        }

        .date-time {
            font-size: 18px;
        }

        .sidebar {
            background: #e0e0e0;
            width: 200px;
            height: calc(100vh - 60px);
            padding: 20px;
            position: absolute;
            top: 60px;
            left: 0;
            display: flex;
            flex-direction: column;
            gap: 10px;
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

        .main-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #f5f5f5;
            padding: 20px;
            margin-left: 230px;
        }

        .content-container {
            width: 1050px;
            height: 550px;
            background-color: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            padding: 10px;
            font-size: 16px;
            overflow-x: auto;
        }

        .summary-section {
            position: sticky;
            top: -1%;
            border: 2px solid #ccc;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        .summary-section p {
            margin: 5px 0;
            font-size: 16px;
        }

        .accounts-table {
            width: 100%;
            border-collapse: collapse;
        }

        .accounts-table th,
        .accounts-table td {
            position: sticky;
            top: 27%;
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }

        .accounts-table th {
            z-index: 1;
            background-color: cornflowerblue;
            color: white;
            font-weight: bold;
        }

        .accounts-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .accounts-table tr:hover {
            background-color: #e0e0e0;
        }

        .action-button {
            padding: 5px 10px;
            margin: 2px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .action-button.update {
            background-color: #c0c0c0;
            color: black;
        }

        .action-button.update:hover {
            background: rgb(0, 208, 255);
            color: white;
        }

        .action-button.delete {
            background-color: #ff4d4d;
            color: white;
        }

        .action-button.delete:hover {
            background: #cc0000;
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
        }

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

        .popup-frame {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: auto;
        }

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

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            z-index: 998;
        }

        .modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
            z-index: 999;
            display: none;
            width: 300px;
            text-align: center;
        }

        .modal h3 {
            margin: 0 0 10px;
            font-size: 18px;
            color: #333;
        }

        .modal p {
            margin: 0 0 20px;
            font-size: 16px;
            color: #666;
        }

        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .modal-button {
            padding: 8px 20px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .modal-button.confirm {
            background: cornflowerblue;
            color: white;
        }

        .modal-button.confirm:hover {
            background: rgb(0, 208, 255);
        }

        .modal-button.cancel {
            background: #ff4d4d;
            color: white;
        }

        .modal-button.cancel:hover {
            background: #cc0000;
        }

        /* Update Form Modal Styles */
        .update-form-modal {
            width: 600px;
            text-align: left;
        }

        .update-form-modal .form-field {
            display: flex;
            flex-direction: column;
        }

        .update-form-modal label {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
        }

        .update-form-modal input {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }

        .update-form-modal input[readonly] {
            background: #f0f0f0;
            cursor: not-allowed;
        }

        .update-form-modal .modal-buttons {
            grid-column: 1 / -1;
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }

        #updateRecordForm {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        @media (max-width: 600px) {
            .update-form-modal {
                width: 90%;
            }

            #updateRecordForm {
                grid-template-columns: 1fr;
            }
        }

        .logout-button {
            position: absolute;
            width: 100px;
            height: 40px;
            background: #ff4d4d;
            color: white;
            border: none;
            cursor: pointer;
            margin: 0;
            padding: 0;
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
        .register-form-modal {
            width: 400px;
            text-align: left;
        }

        .register-form-modal .form-field {
            display: flex;
            flex-direction: column;
            margin-bottom: 15px;
        }

        .register-form-modal label {
            font-size: 12px;
            color: #333;
        }

        .register-form-modal input {
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 13px;
            width: 100%;
            box-sizing: border-box;
        }

        .register-form-modal .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        #registerForm {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        #registerForm .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        #registerForm .form-row.full-width {
            grid-template-columns: 1fr;
        }

        #registerForm .date-time-section,
        #registerForm .serial-section {
            text-align: center;
            margin-bottom: 15px;
        }

        #registerForm .serial-section p {
            color: red;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }

        #registerForm .date-time-section p {
            margin: 5px 0;
            font-size: 16px;
            color: #333;
        }

        @media (max-width: 600px) {
            .register-form-modal {
                width: 90%;
            }

            #registerForm .form-row {
                grid-template-columns: 1fr;
            }
        }

        .register-form-modal {
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.3s ease;
        }

        .register-form-modal.active {
            display: block;
            opacity: 1;
        }

        .warning {
            color: red;
            font-size: 10px;
        }

        .delete-form-modal {
            width: 500px;
            text-align: left;
        }

        .delete-form-modal .modal-content {
            padding: 20px;
        }

        .delete-form-modal .form-row {
            margin: 10px 0;
        }

        .delete-form-modal .form-row p {
            margin: 5px 0;
            font-size: 14px;
        }

        .delete-form-modal strong {
            color: #333;
        }

        .delete-form-modal .modal-buttons {
            justify-content: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <form runat="server" id="mainForm">
        <asp:HiddenField ID="hdnSerial" runat="server" />

        <div id="registerFormModal" class="modal register-form-modal">
            <h3>Register New User</h3>
            <div id="registerForm">
                <div class="date-time-section">
                    <p id="registerDate"></p>
                    <p id="registerTime"></p>
                </div>
                <div class="serial-section">
                    <p><i>AUTO GENERATED SERIAL</i> <br />
                    <strong><%= GetNextSerialID() %></strong>
                    </p> 
                </div>

                <div class="form-row">
                    <div class="form-field">
                        <label for="registerFname">First Name:</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                            ErrorMessage="Please enter your first name." CssClass="warning" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revFirstName" runat="server" ControlToValidate="txtFirstName"
                            ErrorMessage="First name can only contain letters and spaces." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[A-Za-z\s]+$" />
                    </div>
                    <div class="form-field">
                        <label for="lname">Last Name:</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                            ErrorMessage="Please enter your last name." CssClass="warning" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revLastName" runat="server" ControlToValidate="txtLastName"
                            ErrorMessage="Last name can only contain letters and spaces." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[A-Za-z\s]+$" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-field">
                        <label for="mname">Middle Name:</label>
                        <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control" placeholder="optional"/>
                        <asp:RegularExpressionValidator ID="revMiddleName" runat="server" ControlToValidate="txtMiddleName"
                            ErrorMessage="Middle name can only contain letters and spaces." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[A-Za-z\s]*$" />
                    </div>
                    <div class="form-field">
                        <label for="dob">Date of Birth</label>
                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row full-width">
                    <div class="form-field">
                        <label for="email">Email:</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Please enter your email." CssClass="warning" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Please enter a valid email address." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>
                </div>

                <div class="form-row full-width">
                    <div class="form-field">
                        <label for="address">Address:</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
                        <asp:RegularExpressionValidator ID="revAddress" runat="server" ControlToValidate="txtAddress"
                            ErrorMessage="Address contains invalid characters." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[A-Za-z0-9\s,.-]+$" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-field">
                        <label for="phone">Phone Number</label>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control" value="+63 "/>
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhoneNumber"
                            ErrorMessage="Please enter your phone number." CssClass="warning" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhoneNumber"
                            ErrorMessage="Phone number must be in the format [10 digits]." CssClass="warning"
                            ValidationExpression="^((\+63\s?|0)9\d{9})$" Display="Dynamic" />
                    </div>
                    <div class="form-field">
                        <label for="alias">Alias / Nickname</label>
                        <asp:TextBox ID="txtAlias" runat="server" CssClass="form-control" placeholder="optional"/>
                        <asp:RegularExpressionValidator ID="rfvAlias" runat="server" ControlToValidate="txtAlias"
                            ErrorMessage="Alias can only contain letters and spaces." CssClass="warning" Display="Dynamic"
                            ValidationExpression="^[A-Za-z\s]*$" />
                    </div>
                </div>

                <div class="form-row full-width">
                    <label for="pin">6-Digit PIN:</label>
                    <asp:TextBox ID="txtPin" runat="server" CssClass="form-control" TextMode="Password" />
                    <asp:RequiredFieldValidator ID="rfvPIN" runat="server" ControlToValidate="txtPIN"
                        ErrorMessage="Please enter your 6-digit PIN." CssClass="warning" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPIN" runat="server" ControlToValidate="txtPIN"
                        ErrorMessage="PIN must be exactly 6 digits." CssClass="warning" Display="Dynamic"
                        ValidationExpression="^\d{6}$" />
                </div>

                <div class="modal-buttons">
                    <asp:Button ID="Button1" class="modal-button confirm" runat="server" Text="Register" OnClientClick="return validateRegisterForm();" OnClick="btnRegister_Click" />
                    <button type="button" class="modal-button cancel" onclick="toggleRegisterBar()">Cancel</button>
                </div>
            </div>
        </div>

        <div id="modalOverlay" class="modal-overlay"></div>
        <div id="updateModal" class="modal">
            <h3>Confirm Update</h3>
            <p>Are you sure you want to update this record?</p>
            <div class="modal-buttons">
                <button class="modal-button confirm" onclick="confirmModalAction('update')">Confirm</button>
                <button class="modal-button cancel" onclick="closeModal()">Cancel</button>
            </div>
        </div>

        <div id="updateFormModal" class="modal update-form-modal">
            <h3>Update Record</h3>
            <div id="updateRecordForm">
                <input  id="updateFormHiddenSerial" name="serial" />
                <div class="form-field">
                    <label for="updateFormSerial">Serial</label>
                    <input type="text" id="updateFormSerial" readonly required />
                </div>
                <div class="form-field">
                    <label for="updateFormFname">First Name</label>
                    <input type="text" id="updateFormFname" name="fname" required />
                </div>
                <div class="form-field">
                    <label for="updateFormLname">Last Name</label>
                    <input type="text" id="updateFormLname" name="lname" required />
                </div>
                <div class="form-field">
                    <label for="updateFormMname">Middle Name</label>
                    <input type="text" id="updateFormMname" name="mname" />
                </div>
                <div class="form-field">
                    <label for="updateFormDob">Date of Birth</label>
                    <input type="date" id="updateFormDob" name="dob" />
                </div>
                <div class="form-field">
                    <label for="updateFormAddress">Address</label>
                    <input type="text" id="updateFormAddress" name="address" />
                </div>
                <div class="form-field">
                    <label for="updateFormPhonenumber">Phone Number</label>
                    <input type="tel" id="updateFormPhonenumber" name="phonenumber" />
                </div>
                <div class="form-field">
                    <label for="updateFormEmail">Email</label>
                    <input type="email" id="updateFormEmail" name="email" />
                </div>
                <div class="modal-buttons">
                    <button type="button" class="modal-button confirm" onclick="submitUpdateForm()">Save</button>
                    <button type="button" class="modal-button cancel" onclick="closeModal()">Cancel</button>
                </div>
            </div>
        </div>

        <div id="deleteModal" class="modal delete-form-modal" style="display:none;">
            <div class="modal-content">
                <h3>Confirm Account Deletion</h3>
                <div id="deleteForm">
                    <p>Administrator agrees that this account: <strong><span id="modalFullName"></span></strong> will be removed 
                        <asp:CheckBox ID="chkConfirmDelete" runat="server" Text="" />
                    </p>
                    <div class="form-row">
                        <p><strong>Serial:</strong> <span id="modalSerial"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>First Name:</strong> <span id="modalFname"></span></p>
                        <p><strong>Middle Name:</strong> <span id="modalMname"></span></p>
                        <p><strong>Last Name:</strong> <span id="modalLname"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>Date of Birth:</strong> <span id="modalDob"></span></p>
                        <p><strong>Phone Number:</strong> <span id="modalPhone"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>Address:</strong> <span id="modalAddress"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>Email:</strong> <span id="modalEmail"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>Alias:</strong> <span id="modalAlias"></span></p>
                        <p><strong>Role:</strong> <span id="modalRole"></span></p>
                    </div>
                    <div class="form-row">
                        <p><strong>Date and Time:</strong> <span id="modalDateTime"></span></p>
                    </div>
                    <p>I, <asp:Label ID="lblAdminName" runat="server" Text="[Admin Last Name]"></asp:Label>, hereby remove this account 
                        <asp:CheckBox ID="chkAdminConfirm" runat="server" Text="" />
                    </p>
                    <div class="modal-buttons">
                        <button type="button" class="modal-button abort" style="background-color:green;color:white;" onclick="hideDeleteModal()">Abort</button>
                        <button type="button" class="modal-button continue" style="background-color:red;color:white;" onclick="validateDeleteForm()">Continue</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Hidden button for delete postback -->
        <asp:Button ID="btnConfirmDelete" runat="server" Text="Confirm Delete" OnClick="btnConfirmDelete_Click" Style="display: none;" />

        <div class="register-bar" onclick="toggleRegisterBar()"><span>R e g i s t e r </span></div>
        <asp:Button ID="hiddenUpdateButton" runat="server" OnClick="UpdateRecord" Style="display: none;" />
        <div id="overlay" class="overlay" onclick="closePopup()"></div>
        <div id="popupContainer" class="popup">
            <iframe id="popupFrame" class="popup-frame"></iframe>
            <span class="close-btn" onclick="closePopup()">✖</span>
        </div>

        <div class="header">
            <div class="logo">
                <img class="dashboardlogo" src="/images/logo.png" alt="asd jacket" width="55" height="55" />
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
                        <i class='<%# Eval("Icon") %>'></i>
                        <%# Eval("Title") %>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>

        <div class="main-container">
            <div class="content-container">
                <div class="summary-section">
                    <p>Total user: <%= ViewState["TotalUsers"] ?? "0" %></p>
                    <p>Total Officers: <%= ViewState["TotalOfficers"] ?? "0" %></p>
                    <p>Total Admin: <%= ViewState["TotalAdmins"] ?? "0" %></p>
                    <p>As of <%= DateTime.Now.ToString("MMMM") %>, <%= ViewState["AccountsRegistered"] ?? "0" %> account being registered</p>
                    <p>As of <%= DateTime.Now.ToString("MMMM") %>, <%= ViewState["AccountsRemoved"] ?? "0" %> account being removed</p>
                </div>
                <table class="accounts-table">
                    <thead>
                        <tr>
                            <th>Serial</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Middle Name</th>
                            <th>Date of Birth</th>
                            <th>Address</th>
                            <th>Phone Number</th>
                            <th>Email</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (LogData != null && LogData.Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow row in LogData.Rows)
                                {
                        %>
                        <tr>
                            <td><%= row["serial"] %></td>
                            <td><%= row["fname"] %></td>
                            <td><%= row["lname"] %></td>
                            <td><%= row["mname"] %></td>
                            <td><%= row["dob"] %></td>
                            <td><%= row["address"] %></td>
                            <td><%= row["phonenumber"] %></td>
                            <td><%= row["email"] %></td>
                            <td>
                                <button class="action-button update" onclick="showUpdateModal('<%= row["serial"] %>', '<%= row["fname"]?.ToString().Replace("'", "\\'") %>', '<%= row["lname"]?.ToString().Replace("'", "\\'") %>', '<%= row["mname"]?.ToString().Replace("'", "\\'") %>', '<%= row["dob"]?.ToString().Replace("'", "\\'") %>', '<%= row["address"]?.ToString().Replace("'", "\\'") %>', '<%= row["phonenumber"]?.ToString().Replace("'", "\\'") %>', '<%= row["email"]?.ToString().Replace("'", "\\'") %>')">Update</button>
                                <button class="action-button delete" onclick="showDeleteModal('<%= row["serial"] %>')">Delete</button>
                            </td>
                        </tr>
                        <%
                                }
                            }
                            else
                            {
                        %>
                        <tr>
                            <td colspan="9">No logs found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
</body>
</html>