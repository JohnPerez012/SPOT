<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VehiclesDrivers.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.VehiclesDrivers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vehicle & Driver Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <style>
        body {
            background-color: transparent;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            font-family: system-ui;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            gap: 20px;
            transition: filter 0.3s ease;
        }
        .container.blurred {
            filter: blur(5px);
        }
        .form-section {
            width: 48%;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .input-fields, select, textarea {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .input-fields.valid-driver {
            border: 2px solid #4CAF50;
        }
        .input-fields.invalid-driver {
            border: 2px solid #f44336;
        }
        .vehicle-Color {
            margin-bottom: 15px;
        }
        .vehicle-Color .flex {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .vehicle-Color input[type="color"] {
            width: 40px;
            height: 40px;
            padding: 0;
            border: none;
        }
        .vehicle-Color select {
            width: 120px;
        }
        .vehicle-Color #colorPreview {
            height: 30px;
            border-radius: 4px;
        }
        label {
            font-weight: bold;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-primary:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        .clear-button {
            background-color: #f44336;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .clear-button:hover {
            background-color: #d32f2f;
        }
        .error-message {
            color: #f44336;
            font-size: 12px;
            margin-top: -10px;
            margin-bottom: 10px;
        }
        .error-message.hidden {
            display: none;
        }
        .modal-content {
            border-radius: 8px;
            font-family: system-ui;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .modal-header {
            background-color: #f9f9f9;
            border-bottom: 1px solid #ccc;
        }
        .modal-footer .btn-secondary {
            background-color: #6c757d;
        }
        .modal-footer .btn-primary {
            background-color: #4CAF50;
        }
        .back-button {
            position: absolute;
            bottom: 0%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 300px;
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        .back-button:hover {
            background-color: #5a6268;
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
        .modal.register-form-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }
        .register-form-modal .modal-content {
            width: 90%;
            max-width: 500px;
            margin: auto;
        }
        .register-form-modal .form-group {
            margin: 15px 0;
        }
        .register-form-modal label {
            font-size: 14px;
            color: #333;
            display: block;
            margin-bottom: 5px;
        }
        .register-form-modal input, .register-form-modal select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }
        .register-form-modal .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .submit-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .submit-button:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function toggleUVRBar() {
            var modal = document.getElementById('registerFormModal');
            var container = document.querySelector('.container');
            if (modal.style.display === 'block') {
                modal.style.display = 'none';
                container.classList.remove('blurred');
            } else {
                modal.style.display = 'flex';
                container.classList.add('blurred');
            }
        }

        function closeModal() {
            document.getElementById('registerFormModal').style.display = 'none';
            document.querySelector('.container').classList.remove('blurred');
            document.getElementById('<%= txtPlateNumberUVR.ClientID %>').value = '';
            document.getElementById('<%= ddlVehicleTypeUVR.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= txtVehicleColorUVR.ClientID %>').value = '';
        }

        function validateColor(source, args) {
            var color = args.Value.trim();
            if (color === '') {
                args.IsValid = false;
                return;
            }
            args.IsValid = true;
        }

        // Existing JavaScript functions (unchanged)
        function clearVehicleForm() {
            if (confirm("⚠ Are you sure you want to clear the vehicle registration form?")) {
                document.getElementById("<%= txtPlateNumber.ClientID %>").value = "";
                document.getElementById("<%= ddlVehicleType.ClientID %>").selectedIndex = 0;
                document.getElementById("<%= txtOwnerName.ClientID %>").value = "";
                document.getElementById("<%= txtVehicleContact.ClientID %>").value = "";
                document.getElementById("<%= btnRegisterVehicle.ClientID %>").disabled = true;
                document.getElementById("<%= txtOwnerName.ClientID %>").className = "input-fields";
                document.getElementById("ownerNameError").className = "error-message hidden";
            }
        }

        function clearDriverForm() {
            if (confirm("⚠ Are you sure you want to clear the driver registration form?")) {
                document.getElementById("<%= txtDriverName.ClientID %>").value = "";
                document.getElementById("<%= txtDriverContact.ClientID %>").value = "";
                document.getElementById("<%= ddlRole.ClientID %>").selectedIndex = 0;
                document.getElementById("<%= btnRegisterDriver.ClientID %>").disabled = true;
                document.getElementById("<%= txtDriverName.ClientID %>").className = "input-fields";
                document.getElementById("<%= txtDriverContact.ClientID %>").className = "input-fields";
                document.getElementById("driverNameError").className = "error-message hidden";
                document.getElementById("driverContactError").className = "error-message hidden";
                $("#modifyDriverModal").modal("hide");
                $("#duplicateAlertModal").modal("hide");
            }
        }

        function updateVehicleValidation(isOwnerValid) {
            var ownerInput = document.getElementById("<%= txtOwnerName.ClientID %>");
            var registerButton = document.getElementById("<%= btnRegisterVehicle.ClientID %>");
            var ownerError = document.getElementById("ownerNameError");

            if (isOwnerValid) {
                ownerInput.className = "input-fields valid-driver";
                ownerError.className = "error-message hidden";
                registerButton.disabled = false;
            } else {
                ownerInput.className = "input-fields invalid-driver";
                ownerError.textContent = "Owner must be a registered driver.";
                ownerError.className = "error-message";
                registerButton.disabled = true;
            }
        }

        function updateDriverValidation() {
            var nameInput = document.getElementById("<%= txtDriverName.ClientID %>");
            var contactInput = document.getElementById("<%= txtDriverContact.ClientID %>");
            var registerButton = document.getElementById("<%= btnRegisterDriver.ClientID %>");
            var nameError = document.getElementById("driverNameError");
            var contactError = document.getElementById("driverContactError");

            var isNameValid = nameInput.value.trim() !== "";
            var isContactValid = contactInput.value.trim() !== "";

            if (isNameValid) {
                nameInput.className = "input-fields valid-driver";
                nameError.className = "error-message hidden";
            } else {
                nameInput.className = "input-fields invalid-driver";
                nameError.textContent = "Full name is required.";
                nameError.className = "error-message";
            }

            if (isContactValid) {
                contactInput.className = "input-fields valid-driver";
                contactError.className = "error-message hidden";
            } else {
                contactInput.className = "input-fields invalid-driver";
                contactError.textContent = "Contact number is required.";
                contactError.className = "error-message";
            }

            registerButton.disabled = !(isNameValid && isContactValid);
        }

        function showDuplicateAlert(field, value) {
            $("#duplicateAlertMessage").text(`⚠ This ${field} is already registered to a driver.`);
            $("#duplicateAlertModal").data("field", field).data("value", value).modal("show");
        }

        function openModifyModal(driverData) {
            $("#modifyDriverId").val(driverData.DriverID);
            $("#modifyFullName").val(driverData.FullName);
            $("#modifyContactNumber").val(driverData.ContactNumber);
            $("#modifyDriverType").val(driverData.DriverType);
            $("#modifyFullNameError").addClass("hidden");
            $("#modifyContactError").addClass("hidden");
            $("#modifyDriverModal").modal("show");
        }

        $(document).ready(function () {
            $("#<%= btnRegisterDriver.ClientID %>").click(function () {
                console.log("Register Driver button clicked");
                var fullName = $("#<%= txtDriverName.ClientID %>").val();
                var contactNumber = $("#<%= txtDriverContact.ClientID %>").val();
                var driverType = $("#<%= ddlRole.ClientID %>").val();
                console.log("Driver Data:", { fullName: fullName, contactNumber: contactNumber, driverType: driverType });
                return true;
            });

            $("#<%= txtDriverName.ClientID %>").on("blur", function () {
                var fullName = $(this).val().trim();
                var nameInput = $("#<%= txtDriverName.ClientID %>");
                var nameError = $("#driverNameError");
                updateDriverValidation();

                if (fullName) {
                    $.ajax({
                        type: "POST",
                        url: "VehiclesDrivers.aspx/GetDriverDetails",
                        data: JSON.stringify({ fullName: fullName, contactNumber: "" }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d) {
                                nameInput.addClass("invalid-driver").removeClass("valid-driver");
                                nameError.textContent = "This full name is already registered.";
                                nameError.removeClass("hidden");
                                $("#<%= btnRegisterDriver.ClientID %>").prop("disabled", true);
                                showDuplicateAlert("full name", fullName);
                            } else {
                                nameInput.addClass("valid-driver").removeClass("invalid-driver");
                                nameError.addClass("hidden");
                                updateDriverValidation();
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error checking full name: " + error);
                            nameError.textContent = "Error checking full name.";
                            nameError.removeClass("hidden");
                            nameInput.addClass("invalid-driver").removeClass("valid-driver");
                            $("#<%= btnRegisterDriver.ClientID %>").prop("disabled", true);
                        }
                    });
                } else {
                    nameInput.removeClass("valid-driver invalid-driver");
                    nameError.textContent = "Full name is required.";
                    nameError.removeClass("hidden");
                    updateDriverValidation();
                }
            });

            $("#<%= txtDriverContact.ClientID %>").on("blur", function () {
                var contactNumber = $(this).val().trim();
                var contactInput = $("#<%= txtDriverContact.ClientID %>");
                var contactError = $("#driverContactError");
                updateDriverValidation();

                if (contactNumber) {
                    $.ajax({
                        type: "POST",
                        url: "VehiclesDrivers.aspx/GetDriverDetails",
                        data: JSON.stringify({ fullName: "", contactNumber: contactNumber }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d) {
                                contactInput.addClass("invalid-driver").removeClass("valid-driver");
                                contactError.textContent = "This contact number is already registered.";
                                contactError.removeClass("hidden");
                                $("#<%= btnRegisterDriver.ClientID %>").prop("disabled", true);
                                showDuplicateAlert("contact number", contactNumber);
                            } else {
                                contactInput.addClass("valid-driver").removeClass("invalid-driver");
                                contactError.addClass("hidden");
                                updateDriverValidation();
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error checking contact number: " + error);
                            contactError.textContent = "Error checking contact number.";
                            contactError.removeClass("hidden");
                            contactInput.addClass("invalid-driver").removeClass("valid-driver");
                            $("#<%= btnRegisterDriver.ClientID %>").prop("disabled", true);
                        }
                    });
                } else {
                    contactInput.removeClass("valid-driver invalid-driver");
                    contactError.textContent = "Contact number is required.";
                    contactError.removeClass("hidden");
                    updateDriverValidation();
                }
            });

            $("#btnModifyDriver").click(function () {
                var field = $("#duplicateAlertModal").data("field");
                var value = $("#duplicateAlertModal").data("value");
                $("#duplicateAlertModal").modal("hide");

                $.ajax({
                    type: "POST",
                    url: "VehiclesDrivers.aspx/GetDriverDetails",
                    data: JSON.stringify({ fullName: field === "full name" ? value : "", contactNumber: field === "contact number" ? value : "" }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d) {
                            openModifyModal(response.d);
                        } else {
                            alert("⚠ Error: Driver details not found.");
                        }
                    },
                    error: function (xhr, status, error) {
                        console.log("Error fetching driver details: " + error);
                        alert("⚠ Error fetching driver details: " + error);
                    }
                });
            });

            $("#btnSaveDriverChanges").click(function () {
                var driverId = $("#modifyDriverId").val();
                var fullName = $("#modifyFullName").val().trim();
                var contactNumber = $("#modifyContactNumber").val().trim();
                var driverType = $("#modifyDriverType").val();
                var isValid = true;

                if (!fullName) {
                    $("#modifyFullNameError").text("Full name is required.").removeClass("hidden");
                    $("#modifyFullName").addClass("invalid-driver").removeClass("valid-driver");
                    isValid = false;
                } else {
                    $("#modifyFullNameError").addClass("hidden");
                    $("#modifyFullName").addClass("valid-driver").removeClass("invalid-driver");
                }

                if (!contactNumber) {
                    $("#modifyContactError").text("Contact number is required.").removeClass("hidden");
                    $("#modifyContactNumber").addClass("invalid-driver").removeClass("valid-driver");
                    isValid = false;
                } else {
                    $("#modifyContactError").addClass("hidden");
                    $("#modifyContactNumber").addClass("valid-driver").removeClass("invalid-driver");
                }

                if (isValid) {
                    $.ajax({
                        type: "POST",
                        url: "VehiclesDrivers.aspx/UpdateDriver",
                        data: JSON.stringify({ driverId: driverId, fullName: fullName, contactNumber: contactNumber, driverType: driverType }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d.success) {
                                $("#modifyDriverModal").modal("hide");
                                alert("✅ Driver details updated successfully!");
                                clearDriverForm();
                            } else {
                                $("#modifyContactError").text(response.d.error).removeClass("hidden");
                                $("#modifyContactNumber").addClass("invalid-driver").removeClass("valid-driver");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error updating driver: " + error);
                            $("#modifyContactError").text("Error updating driver.").removeClass("hidden");
                        }
                    });
                }
            });
        });

        // Color picker JavaScript (unchanged)
        const colorPicker = document.getElementById('vehicleColor');
        const textInput = document.getElementById('colorTextInput');
        const colorDropdown = document.getElementById('colorDropdown');
        const colorPreview = document.getElementById('colorPreview');
        const colorName = document.getElementById('colorName');
        const errorMessage = document.getElementById('errorMessage');
        const hiddenColorInput = document.getElementById('<%= txtVehicleColor.ClientID %>');

        const colorMap = {
            'aliceblue': '#F0F8FF', 'antiquewhite': '#FAEBD7', 'aqua': '#00FFFF', 'aquamarine': '#7FFFD4',
            'azure': '#F0FFFF', 'beige': '#F5F5DC', 'bisque': '#FFE4C4', 'black': '#000000',
            'blanchedalmond': '#FFEBCD', 'blue': '#0000FF', 'blueviolet': '#8A2BE2', 'brown': '#A52A2A',
            'burlywood': '#DEB887', 'cadetblue': '#5F9EA0', 'chartreuse': '#7FFF00', 'chocolate': '#D2691E',
            'coral': '#FF7F50', 'cornflowerblue': '#6495ED', 'cornsilk': '#FFF8DC', 'crimson': '#DC143C',
            'cyan': '#00FFFF', 'darkblue': '#00008B', 'darkcyan': '#008B8B', 'darkgoldenrod': '#B8860B',
            'darkgray': '#A9A9A9', 'darkgreen': '#006400', 'darkkhaki': '#BDB76B', 'darkmagenta': '#8B008B',
            'darkolivegreen': '#556B2F', 'darkorange': '#FF8C00', 'darkorchid': '#9932CC', 'darkred': '#8B0000',
            'darksalmon': '#E9967A', 'darkseagreen': '#8FBC8F', 'darkslateblue': '#483D8B', 'darkslategray': '#2F4F4F',
            'darkturquoise': '#00CED1', 'darkviolet': '#9400D3', 'deeppink': '#FF1493', 'deepskyblue': '#00BFFF',
            'dimgray': '#696969', 'dodgerblue': '#1E90FF', 'firebrick': '#B22222', 'floralwhite': '#FFFAF0',
            'forestgreen': '#228B22', 'fuchsia': '#FF00FF', 'gainsboro': '#DCDCDC', 'ghostwhite': '#F8F8FF',
            'gold': '#FFD700', 'goldenrod': '#DAA520', 'gray': '#808080', 'green': '#008000',
            'greenyellow': '#ADFF2F', 'honeydew': '#F0FFF0', 'hotpink': '#FF69B4', 'indianred': '#CD5C5C',
            'indigo': '#4B0082', 'ivory': '#FFFFF0', 'khaki': '#F0E68C', 'lavender': '#E6E6FA',
            'lavenderblush': '#FFF0F5', 'lawngreen': '#7CFC00', 'lemonchiffon': '#FFFACD', 'lightblue': '#ADD8E6',
            'lightcoral': '#F08080', 'lightcyan': '#E0FFFF', 'lightgoldenrodyellow': '#FAFAD2', 'lightgray': '#D3D3D3',
            'lightgreen': '#90EE90', 'lightpink': '#FFB6C1', 'lightsalmon': '#FFA07A', 'lightseagreen': '#20B2AA',
            'lightskyblue': '#87CEFA', 'lightslategray': '#778899', 'lightsteelblue': '#B0C4DE', 'lightyellow': '#FFFFE0',
            'lime': '#00FF00', 'limegreen': '#32CD32', 'linen': '#FAF0E6', 'magenta': '#FF00FF',
            'maroon': '#800000', 'mediumaquamarine': '#66CDAA', 'mediumblue': '#0000CD', 'mediumorchid': '#BA55D3',
            'mediumpurple': '#9370DB', 'mediumseagreen': '#3CB371', 'mediumslateblue': '#7B68EE', 'mediumspringgreen': '#00FA9A',
            'mediumturquoise': '#48D1CC', 'mediumvioletred': '#C71585', 'midnightblue': '#191970', 'mintcream': '#F5FFFA',
            'mistyrose': '#FFE4E1', 'moccasin': '#FFE4B5', 'navajowhite': '#FFDEAD', 'navy': '#000080',
            'oldlace': '#FDF5E6', 'olive': '#808000', 'olivedrab': '#6B8E23', 'orange': '#FFA500',
            'orangered': '#FF4500', 'orchid': '#DA70D6', 'palegoldenrod': '#EEE8AA', 'palegreen': '#98FB98',
            'paleturquoise': '#AFEEEE', 'palevioletred': '#DB7093', 'papayawhip': '#FFEFD5', 'peachpuff': '#FFDAB9',
            'peru': '#CD853F', 'pink': '#FFC0CB', 'plum': '#DDA0DD', 'powderblue': '#B0E0E6',
            'purple': '#800080', 'rebeccapurple': '#663399', 'red': '#FF0000', 'rosybrown': '#BC8F8F',
            'royalblue': '#4169E1', 'saddlebrown': '#8B4513', 'salmon': '#FA8072', 'sandybrown': '#F4A460',
            'seagreen': '#2E8B57', 'seashell': '#FFF5EE', 'sienna': '#A0522D', 'silver': '#C0C0C0',
            'skyblue': '#87CEEB', 'slateblue': '#6A5ACD', 'slategray': '#708090', 'snow': '#FFFAFA',
            'springgreen': '#00FF7F', 'steelblue': '#4682B4', 'tan': '#D2B48C', 'teal': '#008080',
            'thistle': '#D8BFD8', 'tomato': '#FF6347', 'turquoise': '#40E0D0', 'violet': '#EE82EE',
            'wheat': '#F5DEB3', 'white': '#FFFFFF', 'whitesmoke': '#F5F5F5', 'yellow': '#FFFF00',
            'yellowgreen': '#9ACD32'
        };

        const hexToColorName = Object.fromEntries(
            Object.entries(colorMap).map(([name, hex]) => [hex.toUpperCase(), name])
        );

        function updatePreview(color, showColorName = false, name = '') {
            colorPreview.style.backgroundColor = color;
            if (showColorName && name) {
                colorName.textContent = name.charAt(0).toUpperCase() + name.slice(1);
                colorName.classList.remove('hidden');
            } else {
                colorName.textContent = '';
                colorName.classList.add('hidden');
            }
        }

        colorPicker.addEventListener('input', () => {
            textInput.value = colorPicker.value;
            colorDropdown.value = colorPicker.value.toUpperCase();
            hiddenColorInput.value = colorPicker.value;
            updatePreview(colorPicker.value);
            errorMessage.classList.add('hidden');
        });

        colorDropdown.addEventListener('change', () => {
            const selectedColor = colorDropdown.value;
            colorPicker.value = selectedColor;
            textInput.value = selectedColor;
            hiddenColorInput.value = selectedColor;
            updatePreview(selectedColor);
            errorMessage.classList.add('hidden');
        });

        function applyColor(inputValue) {
            const trimmedValue = inputValue.trim().toLowerCase();
            if (!trimmedValue) {
                errorMessage.classList.add('hidden');
                updatePreview(colorPicker.value);
                return;
            }

            let hexColor = null;
            let isHexInput = false;

            if (/^#[0-9A-Fa-f]{6}$/.test(trimmedValue)) {
                hexColor = trimmedValue.toUpperCase();
                isHexInput = true;
            } else {
                hexColor = colorMap[trimmedValue] || null;
            }

            if (hexColor) {
                colorPicker.value = hexColor;
                textInput.value = hexColor;
                colorDropdown.value = hexColor;
                hiddenColorInput.value = hexColor;
                const colorNameText = isHexInput ? hexToColorName[hexColor] || '' : '';
                updatePreview(hexColor, isHexInput, colorNameText);
                errorMessage.classList.add('hidden');
            } else {
                errorMessage.classList.remove('hidden');
                updatePreview(colorPicker.value);
            }
        }

        textInput.addEventListener('keypress', (event) => {
            if (event.key === 'Enter') {
                event.preventDefault();
                applyColor(textInput.value);
            }
        });

        window.onload = function () {
            var isValid = '<%= ViewState["IsDriverRegistered"] != null ? ViewState["IsDriverRegistered"].ToString().ToLower() : "false" %>';
            updateVehicleValidation(isValid === "true");
            updateDriverValidation();
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <button type="button" class="back-button" onclick="window.location.href='VehicleLog.aspx'">B A C K</button>
        <div class="register-bar" onclick="toggleUVRBar()"><span>REGISTER UNIVERSITY VEHICLE</span></div>

        <div id="registerFormModal" class="modal register-form-modal">
            <div class="modal-content">
                <h2>REGISTER UNIVERSITY VEHICLE</h2>
                <div class="form-group">
                    <label for="txtPlateNumberUVR">Plate Number:</label>
                    <asp:TextBox ID="txtPlateNumberUVR" runat="server" CssClass="input-fields" placeholder="Enter Plate Number" MaxLength="20" />
                </div>
                <div class="form-group">
                    <label for="ddlVehicleTypeUVR">Vehicle Type:</label>
                    <asp:DropDownList ID="ddlVehicleTypeUVR" runat="server" CssClass="input-fields">
                        <asp:ListItem Value="" Text="Select Vehicle Type" />
                        <asp:ListItem Value="Car">Car</asp:ListItem>
                        <asp:ListItem Value="Motorcycle">Motorcycle</asp:ListItem>
                        <asp:ListItem Value="Van">Van</asp:ListItem>
                        <asp:ListItem Value="Truck">Truck</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label for="txtVehicleColorUVR">Vehicle Color:</label>
                    <asp:TextBox ID="txtVehicleColorUVR" runat="server" CssClass="input-fields" placeholder="Enter Vehicle Color" MaxLength="20" />
                    <asp:CustomValidator ID="cvVehicleColor" runat="server" ControlToValidate="txtVehicleColorUVR" 
                        ClientValidationFunction="validateColor" ErrorMessage="Invalid color. Please enter a valid color name or hex code." 
                        CssClass="error-message" Display="Dynamic" />
                </div>
                <div class="form-group modal-buttons">
                    <asp:Button ID="Button1" runat="server" Text="Register" OnClick="btnUVRegisterVehicle_Click" CssClass="submit-button" />
                    <input type="button" value="Cancel" class="clear-button" onclick="closeModal();" />
                </div>
            </div>
        </div>

        <div class="container">
            <!-- 🚗 Vehicle Registration (Left Side) -->
            <div class="form-section">
                <h2>Vehicle Registration</h2>
                <label>Plate Number:</label>
                <asp:TextBox ID="txtPlateNumber" runat="server" CssClass="input-fields"></asp:TextBox>

                <label>Vehicle Type:</label>
                <asp:DropDownList ID="ddlVehicleType" runat="server" CssClass="input-fields">
                    <asp:ListItem Text="Car" Value="Car"></asp:ListItem>
                    <asp:ListItem Text="Motorcycle" Value="Motorcycle"></asp:ListItem>
                    <asp:ListItem Text="Truck" Value="Truck"></asp:ListItem>
                </asp:DropDownList>

                <div class="vehicle-Color">
                    <label>Vehicle Color:</label>
                    <div class="flex items-center space-x-2">
                        <input 
                            type="color" 
                            id="vehicleColor" 
                            name="vehicleColor" 
                            class="w-12 h-12 rounded-md border-none cursor-pointer transition-transform hover:scale-110 input-fields" 
                            value="#6495ED"
                        >
                        <input 
                            type="text" 
                            id="colorTextInput" 
                            placeholder="Enter color (e.g., red, #ff0000)" 
                            class="w-[80%] p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors input-fields"
                        >
                        <select 
                            id="colorDropdown" 
                            class="w-[15%] h-10 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors input-fields"
                            style="width: 200px; height: 40px;"
                        >
                            <option value="#F0F8FF">AliceBlue</option>
                            <option value="#FAEBD7">AntiqueWhite</option>
                            <option value="#00FFFF">Aqua</option>
                            <option value="#7FFFD4">Aquamarine</option>
                            <option value="#F0FFFF">Azure</option>
                            <option value="#F5F5DC">Beige</option>
                            <option value="#FFE4C4">Bisque</option>
                            <option value="#000000">Black</option>
                            <option value="#FFEBCD">BlanchedAlmond</option>
                            <option value="#0000FF">Blue</option>
                            <option value="#8A2BE2">BlueViolet</option>
                            <option value="#A52A2A">Brown</option>
                            <option value="#DEB887">BurlyWood</option>
                            <option value="#5F9EA0">CadetBlue</option>
                            <option value="#7FFF00">Chartreuse</option>
                            <option value="#D2691E">Chocolate</option>
                            <option value="#FF7F50">Coral</option>
                            <option value="#6495ED" selected>CornflowerBlue</option>
                            <option value="#FFF8DC">Cornsilk</option>
                            <option value="#DC143C">Crimson</option>
                            <option value="#00FFFF">Cyan</option>
                            <option value="#00008B">DarkBlue</option>
                            <option value="#008B8B">DarkCyan</option>
                            <option value="#B8860B">DarkGoldenRod</option>
                            <option value="#A9A9A9">DarkGray</option>
                            <option value="#006400">DarkGreen</option>
                            <option value="#BDB76B">DarkKhaki</option>
                            <option value="#8B008B">DarkMagenta</option>
                            <option value="#556B2F">DarkOliveGreen</option>
                            <option value="#FF8C00">DarkOrange</option>
                            <option value="#9932CC">DarkOrchid</option>
                            <option value="#8B0000">DarkRed</option>
                            <option value="#E9967A">DarkSalmon</option>
                            <option value="#8FBC8F">DarkSeaGreen</option>
                            <option value="#483D8B">DarkSlateBlue</option>
                            <option value="#2F4F4F">DarkSlateGray</option>
                            <option value="#00CED1">DarkTurquoise</option>
                            <option value="#9400D3">DarkViolet</option>
                            <option value="#FF1493">DeepPink</option>
                            <option value="#00BFFF">DeepSkyBlue</option>
                            <option value="#696969">DimGray</option>
                            <option value="#1E90FF">DodgerBlue</option>
                            <option value="#B22222">FireBrick</option>
                            <option value="#FFFAF0">FloralWhite</option>
                            <option value="#228B22">ForestGreen</option>
                            <option value="#FF00FF">Fuchsia</option>
                            <option value="#DCDCDC">Gainsboro</option>
                            <option value="#F8F8FF">GhostWhite</option>
                            <option value="#FFD700">Gold</option>
                            <option value="#DAA520">GoldenRod</option>
                            <option value="#808080">Gray</option>
                            <option value="#008000">Green</option>
                            <option value="#ADFF2F">GreenYellow</option>
                            <option value="#F0FFF0">HoneyDew</option>
                            <option value="#FF69B4">HotPink</option>
                            <option value="#CD5C5C">IndianRed</option>
                            <option value="#4B0082">Indigo</option>
                            <option value="#FFFFF0">Ivory</option>
                            <option value="#F0E68C">Khaki</option>
                            <option value="#E6E6FA">Lavender</option>
                            <option value="#FFF0F5">LavenderBlush</option>
                            <option value="#7CFC00">LawnGreen</option>
                            <option value="#FFFACD">LemonChiffon</option>
                            <option value="#ADD8E6">LightBlue</option>
                            <option value="#F08080">LightCoral</option>
                            <option value="#E0FFFF">LightCyan</option>
                            <option value="#FAFAD2">LightGoldenRodYellow</option>
                            <option value="#D3D3D3">LightGray</option>
                            <option value="#90EE90">LightGreen</option>
                            <option value="#FFB6C1">LightPink</option>
                            <option value="#FFA07A">LightSalmon</option>
                            <option value="#20B2AA">LightSeaGreen</option>
                            <option value="#87CEFA">LightSkyBlue</option>
                            <option value="#778899">LightSlateGray</option>
                            <option value="#B0C4DE">LightSteelBlue</option>
                            <option value="#FFFFE0">LightYellow</option>
                            <option value="#00FF00">Lime</option>
                            <option value="#32CD32">LimeGreen</option>
                            <option value="#FAF0E6">Linen</option>
                            <option value="#FF00FF">Magenta</option>
                            <option value="#800000">Maroon</option>
                            <option value="#66CDAA">MediumAquaMarine</option>
                            <option value="#0000CD">MediumBlue</option>
                            <option value="#BA55D3">MediumOrchid</option>
                            <option value="#9370DB">MediumPurple</option>
                            <option value="#3CB371">MediumSeaGreen</option>
                            <option value="#7B68EE">MediumSlateBlue</option>
                            <option value="#00FA9A">MediumSpringGreen</option>
                            <option value="#48D1CC">MediumTurquoise</option>
                            <option value="#C71585">MediumVioletRed</option>
                            <option value="#191970">MidnightBlue</option>
                            <option value="#F5FFFA">MintCream</option>
                            <option value="#FFE4E1">MistyRose</option>
                            <option value="#FFE4B5">Moccasin</option>
                            <option value="#FFDEAD">NavajoWhite</option>
                            <option value="#000080">Navy</option>
                            <option value="#FDF5E6">OldLace</option>
                            <option value="#808000">Olive</option>
                            <option value="#6B8E23">OliveDrab</option>
                            <option value="#FFA500">Orange</option>
                            <option value="#FF4500">OrangeRed</option>
                            <option value="#DA70D6">Orchid</option>
                            <option value="#EEE8AA">PaleGoldenRod</option>
                            <option value="#98FB98">PaleGreen</option>
                            <option value="#AFEEEE">PaleTurquoise</option>
                            <option value="#DB7093">PaleVioletRed</option>
                            <option value="#FFEFD5">PapayaWhip</option>
                            <option value="#FFDAB9">PeachPuff</option>
                            <option value="#CD853F">Peru</option>
                            <option value="#FFC0CB">Pink</option>
                            <option value="#DDA0DD">Plum</option>
                            <option value="#B0E0E6">PowderBlue</option>
                            <option value="#800080">Purple</option>
                            <option value="#663399">RebeccaPurple</option>
                            <option value="#FF0000">Red</option>
                            <option value="#BC8F8F">RosyBrown</option>
                            <option value="#4169E1">RoyalBlue</option>
                            <option value="#8B4513">SaddleBrown</option>
                            <option value="#FA8072">Salmon</option>
                            <option value="#F4A460">SandyBrown</option>
                            <option value="#2E8B57">SeaGreen</option>
                            <option value="#FFF5EE">Seashell</option>
                            <option value="#A0522D">Sienna</option>
                            <option value="#C0C0C0">Silver</option>
                            <option value="#87CEEB">SkyBlue</option>
                            <option value="#6A5ACD">SlateBlue</option>
                            <option value="#708090">SlateGray</option>
                            <option value="#FFFAFA">Snow</option>
                            <option value="#00FF7F">SpringGreen</option>
                            <option value="#4682B4">SteelBlue</option>
                            <option value="#D2B48C">Tan</option>
                            <option value="#008080">Teal</option>
                            <option value="#D8BFD8">Thistle</option>
                            <option value="#FF6347">Tomato</option>
                            <option value="#40E0D0">Turquoise</option>
                            <option value="#EE82EE">Violet</option>
                            <option value="#F5DEB3">Wheat</option>
                            <option value="#FFFFFF">White</option>
                            <option value="#F5F5F5">WhiteSmoke</option>
                            <option value="#FFFF00">Yellow</option>
                            <option value="#9ACD32">YellowGreen</option>
                        </select>
                    </div>
                    <div 
                        id="colorPreview" 
                        class="mt-2 h-8 w-full rounded-md border border-gray-200 relative flex items-center justify-center" 
                        style="background-color: #6495ED"
                    >
                        <span id="colorName" class="text-sm font-medium text-white hidden"></span>
                    </div>
                    <p id="errorMessage" class="error-message hidden">Invalid color. Please enter a valid color name or hex code.</p>
                    <asp:TextBox ID="txtVehicleColor" runat="server" style="display: none;" Text="#6495ED"></asp:TextBox>
                </div>

                <label>Owner Name:</label>
                <asp:TextBox ID="txtOwnerName" runat="server" CssClass="input-fields" AutoPostBack="true" OnTextChanged="txtOwnerName_TextChanged"></asp:TextBox>
                <p id="ownerNameError" class="error-message hidden"></p>

                <label>Contact Number:</label>
                <asp:TextBox ID="txtVehicleContact" runat="server" CssClass="input-fields" MaxLength="15"></asp:TextBox>

                <asp:Button ID="btnRegisterVehicle" runat="server" Text="Register Vehicle" CssClass="btn-primary" OnClick="btnRegisterVehicle_Click" Enabled="false" />

                <button type="button" onclick="clearVehicleForm()" class="clear-button">Clear Vehicle</button>
            </div>

            <!-- 🚶‍♂️ Driver Registration (Right Side) -->
            <div class="form-section">
                <h2>Driver Registration</h2>
                <label>Full Name:</label>
                <asp:TextBox ID="txtDriverName" runat="server" CssClass="input-fields"></asp:TextBox>
                <p id="driverNameError" class="error-message hidden"></p>

                <label>Contact Number:</label>
                <asp:TextBox ID="txtDriverContact" runat="server" CssClass="input-fields" MaxLength="15"></asp:TextBox>
                <p id="driverContactError" class="error-message hidden"></p>

                <label>Driver Type:</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="input-fields">
                    <asp:ListItem Text="Student" Value="Student"></asp:ListItem>
                    <asp:ListItem Text="Staff" Value="Staff"></asp:ListItem>
                </asp:DropDownList>

                <asp:Button ID="btnRegisterDriver" runat="server" Text="Register Driver" CssClass="btn-primary" OnClick="btnRegisterDriver_Click" OnClientClick="console.log('Submitting driver form'); return true;" Enabled="false" />

                <button type="button" onclick="clearDriverForm()" class="clear-button">Clear Driver</button>
            </div>
        </div>

        <!-- Duplicate Alert Modal -->
        <div class="modal fade" id="duplicateAlertModal" tabindex="-1" aria-labelledby="duplicateAlertLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="duplicateAlertLabel">Duplicate Entry</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="duplicateAlertMessage"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
                        <button type="button" class="btn btn-primary" id="btnModifyDriver">Modify</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modify Driver Modal -->
        <div class="modal fade" id="modifyDriverModal" tabindex="-1" aria-labelledby="modifyDriverLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modifyDriverLabel">Modify Driver Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="modifyDriverId" />
                        <div class="mb-3">
                            <label for="modifyFullName" class="form-label">Full Name:</label>
                            <input type="text" id="modifyFullName" class="form-control input-fields" maxlength="100" />
                            <p id="modifyFullNameError" class="error-message hidden"></p>
                        </div>
                        <div class="mb-3">
                            <label for="modifyContactNumber" class="form-label">Contact Number:</label>
                            <input type="text" id="modifyContactNumber" class="form-control input-fields" maxlength="15" />
                            <p id="modifyContactError" class="error-message hidden"></p>
                        </div>
                        <div class="mb-3">
                            <label for="modifyDriverType" class="form-label">Driver Type:</label>
                            <select id="modifyDriverType" class="form-select input-fields">
                                <option value="Student">Student</option>
                                <option value="Staff">Staff</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnSaveDriverChanges">Save Changes</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>