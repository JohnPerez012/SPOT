<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VehicleLog.aspx.cs" Inherits="SPOT.users.DEFAULT.VehicleLog" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vehicle Entry Log</title>
    <style>
        /* General Styling */
        body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
/*            color: #333;*/
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow:hidden;
        }

        /* Form Containers (Both Forms) */
        .container,
        .setout-form-container {
            background: #fff;
            padding: 20px;
            width: 100%;
            max-width: 600px;
            min-height: 480px;
            border: 1px solid #ddd;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
            position: relative; /* For sliding animation */
            transition: opacity 0.5s ease, transform 0.5s ease; /* Animation for fade and slide */
        }

        /* Form Title */
        h2 {
            font-size: 24px;
            margin: 0 0 20px;
            text-align: center;
        }

        /* Form Grid */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            flex-grow: 1;
        }

        /* Set-out form uses single column */
        .setout-form-container .form-grid {
            grid-template-columns: 1fr;
        }

        /* Full-width fields */
        .full-width {
            grid-column: 1 / -1;
        }

        /* Paired fields */
        .pair {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        /* Form Group */
        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .form-group .input-field,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
            background: #fff;
            color: #333;
        }

        .pair button {
            padding: 8px 16px;
            background: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            flex-shrink: 0;
        }

        .pair button:hover {
            background: #555;
        }

        .form-group textarea {
            height: 60px;
            resize: none;
        }

        .btn-primary {
            padding: 8px 16px;
            background: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            display: block;
            margin: 20px auto 0;
            transition: transform 0.5s ease; /* Animation for fade and slide */

        }

        .btn-primary:hover {
            background: #555;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #fff;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            max-width: 300px;
            text-align: center;
        }

        .modal-content h2 {
            font-size: 18px;
            margin: 0 0 15px;
        }

        .modal-content .close {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 20px;
            cursor: pointer;
        }

        .modal button {
            padding: 8px 16px;
            background: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            margin: 10px 5px;
        }

        .modal button:hover {
            background: #555;
        }

        .modal:not(.hidden) {
            display: block;
        }

        .hidden {
            display: none;
        }

        /* Wrapper for Forms and Bar */
        .form-wrapper {
            width: 100%;
            max-width: 600px;
            margin: 20px auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Horizontal Bar Styling */
        .horizontal-bar {
            width: 100%;
            height: 10px;
            background: black;
            opacity: 1;
            margin: 20px 0;
            transition: opacity 0.5s ease, transform 0.5s ease; /* Animation for fade and slide */
        }

        /* Hidden state for top form and bar */
        .fade-out {
            opacity: 1;
            pointer-events: none; /* Prevent interaction */
        }

        /* Move bottom form up */
        .moved-up {
            transform: translateY(-500px); /* Move up by top form height + bar + margins */
        }
         .moved-ups {
     transform: translateX(-300px); /* Move up by top form height + bar + margins */
 }

        .moved-up-center {
    transform: translateY(-500px); /* Move up by top form height + bar + margins */
}
        
       .fixed{
    transform: translateY(495px); 
        }
      
       .move_btnUp{
    transform: translateY(-150px);

       }
       .disabled{
           cursor:not-allowed;
           background-color:grey;
       }
        
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        var isformContAbove = false;
        $(document).ready(function () {

            $('.container').on('click', function (e) {

                $('.container .form-grid .full-width .btn-primary').removeClass('move_btnUp');
                $('.container h2').removeClass('fixed');
                $('.horizontal-bar').removeClass('moved-up');

                if ($('.setout-form-container').hasClass('moved-up-center')) {
                    console.log('Set-out form is visible, toggling back to entry form');
                    $('.setout-form-container').removeClass('moved-up-center').removeClass('moved-up');
                    $('.container').removeClass('moved-up');
               
                } 
            });

            $('.setout-form-container').on('click', function (e) {

                if ($(e.target).is('input, textarea, select, button')) {
                    return;
                }


                    $('.horizontal-bar').addClass('moved-up');
                    $('.container h2').addClass('fixed');
                    $('.container .form-grid .full-width .btn-primary').addClass('move_btnUp');
                    console.log('Entry form is visible, toggling to set-out form');
                    $('.container').addClass('moved-up');
                    $('.setout-form-container').addClass('moved-up-center');

            });
        });


        function checkUniVehicle(plateNumberFieldId, vehicleTypeFieldId, vehicleColorFieldId, driverNameFieldId, modalId, isSetOutForm) {
            var plateNumber = document.getElementById(plateNumberFieldId).value.trim();
            if (plateNumber === "") {
                alert("⚠ Please enter a plate number.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "VehicleLog.aspx/checkUniVehicle",
                data: JSON.stringify({ plateNumber: plateNumber }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (data.exists) {
                        alert("✅ Vehicle found in the database!");
                        $(`#${vehicleTypeFieldId}`).val(data.vehicleType);
                        $(`#${vehicleColorFieldId}`).val(data.vehicleColor);
                        $(`#${driverNameFieldId}`).val(data.ownerName);
                        window.vehicleData = data;
                        $(`#${modalId}`).removeClass('hidden');
                    } else {
                        var confirmRegister = confirm("❌ Vehicle not found! Would you like to register it now?");
                        if (confirmRegister) {
                            window.location.href = "VehiclesDrivers.aspx?plateNumber=" + plateNumber;
                        }
                        if (isSetOutForm) {
                            console.log('checkSetOutVehicle1111111');

                            setSetOutFieldsToClear();
                        } else {
                            setEntryFieldsToClear();
                        }
                    }
                },
                error: function (error) {
                    console.log(error);
                    alert("⚠ Error checking vehicle.");
                }
            });
        }




        function checkVehicle(plateNumberFieldId, vehicleTypeFieldId, vehicleColorFieldId, driverNameFieldId, modalId, isSetOutForm) {
            var plateNumber = document.getElementById(plateNumberFieldId).value.trim();
            if (plateNumber === "") {
                alert("⚠ Please enter a plate number.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "VehicleLog.aspx/CheckVehicle",
                data: JSON.stringify({ plateNumber: plateNumber }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (data.exists) {
                        alert("✅ Vehicle found in the database!");
                        $(`#${vehicleTypeFieldId}`).val(data.vehicleType);
                        $(`#${vehicleColorFieldId}`).val(data.vehicleColor);
                        $(`#${driverNameFieldId}`).val(data.ownerName);
                        window.vehicleData = data;
                        $(`#${modalId}`).removeClass('hidden');
                    } else {
                        var confirmRegister = confirm("❌ Vehicle not found! Would you like to register it now?");
                        if (confirmRegister) {
                            window.location.href = "VehiclesDrivers.aspx?plateNumber=" + plateNumber;
                        }
                        if (isSetOutForm) {
                            console.log('checkSetOutVehicle1111111');

                            setSetOutFieldsToClear();
                        } else {
                            setEntryFieldsToClear();
                        }
                    }
                },
                error: function (error) {
                    console.log(error);
                    alert("⚠ Error checking vehicle.");
                }
            });
        }

        function checkSetOutVehicle() {
            console.log('checkSetOutVehicle');

            checkUniVehicle(
                "<%= txtSetOutPlateNumber.ClientID %>",
                "<%= txtSetOutVehicleType.ClientID %>",
                "<%= txtSetOutVehicleColor.ClientID %>",
                "setOutVehicleModal",
                true
            );
        }

        function checkEntryVehicle() {
            console.log('checkEntryVehicle');

            checkVehicle(
                "<%= txtPlateNumber.ClientID %>",
                "<%= ddlVehicleType.ClientID %>",
                "<%= txtVehicleColor.ClientID %>",
                "<%= txtDriverName.ClientID %>",
                "vehicleModal",
                false
            );
        }

        function setEntryFieldsToClear() {
            document.getElementById("<%= ddlVehicleType.ClientID %>").value = "";
            document.getElementById("<%= txtVehicleColor.ClientID %>").value = "";
            document.getElementById("<%= txtDriverName.ClientID %>").value = "";
            document.getElementById("<%= txtContactNumber.ClientID %>").value = "";
            document.getElementById("<%= ddlDriverType.ClientID %>").value = "";
            document.getElementById("<%= txtPurpose.ClientID %>").value = "";
        }

        function setSetOutFieldsToClear() {
            document.getElementById("<%= txtSetOutVehicleType.ClientID %>").value = "";
            document.getElementById("<%= txtSetOutVehicleColor.ClientID %>").value = "";
            document.getElementById("<%= txtSetOutDriverName.ClientID %>").value = "";
            document.getElementById("<%= txtSetOutPersonCount.ClientID %>").value = "";
            document.getElementById("<%= txtSetOutPurpose.ClientID %>").value = "";
        }

        function showVehicleDetails(modalId, detailsId, okButtonId) {
            if (window.vehicleData) {
                var details = `
                    <p><strong>Vehicle ID:</strong> ${window.vehicleData.vehicleID}</p>
                    <p><strong>Plate Number:</strong> ${window.vehicleData.plateNumber}</p>
                    <p><strong>Vehicle Type:</strong> ${window.vehicleData.vehicleType}</p>
                    <p><strong>Vehicle Color:</strong> ${window.vehicleData.vehicleColor}</p>
                    <p><strong>Owner Name:</strong> ${window.vehicleData.ownerName}</p>
                    <p><strong>Contact Number:</strong> ${window.vehicleData.contactNumber || 'N/A'}</p>
                `;
                $(`#${detailsId}`).html(details);
            }
            $(`#${okButtonId}`).addClass('hidden');
        }

        function closeModal(modalId, detailsId, okButtonId) {
            $(`#${modalId}`).addClass('hidden');
            $(`#${detailsId}`).html('');
            $(`#${okButtonId}`).removeClass('hidden');
            window.vehicleData = null;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-wrapper">
            <!-- Vehicle Entry Log Form -->

            <div class="container">
                <h2 style="transition:transform 0.5s ease;">Vehicle Entry Log</h2>
                <div class="form-grid">
                    <!-- Date and Time -->
                    <div class="form-group full-width">
                        <label>Date & Time</label>
                        <asp:TextBox ID="txtDateTime" runat="server" ReadOnly="true" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Plate Number + Check Button -->
                    <div class="form-group pair">
                        <div class="form-group">
                            <label>Plate Number</label>
                            <asp:TextBox ID="txtPlateNumber" runat="server" CssClass="input-field"></asp:TextBox>
                        </div>
                        <button type="button" onclick="checkEntryVehicle()">Check</button>
                    </div>
                    <!-- Vehicle Type + Vehicle Color -->
                    <div class="form-group">
                        <label>Vehicle Type</label>
                        <asp:DropDownList ID="ddlVehicleType" runat="server" CssClass="input-field">
                            <asp:ListItem Text="Car" Value="Car"></asp:ListItem>
                            <asp:ListItem Text="Motorcycle" Value="Motorcycle"></asp:ListItem>
                            <asp:ListItem Text="Truck" Value="Truck"></asp:ListItem>
                            <asp:ListItem Text="Van" Value="Van"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Vehicle Color</label>
                        <asp:TextBox ID="txtVehicleColor" runat="server" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Driver's Name + Contact Number -->
                    <div class="form-group">
                        <label>Driver's Name</label>
                        <asp:TextBox ID="txtDriverName" runat="server" CssClass="input-field"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Contact Number</label>
                        <asp:TextBox ID="txtContactNumber" runat="server" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Driver Type -->
                    <div class="form-group">
                        <label>Driver Type</label>
                        <asp:DropDownList ID="ddlDriverType" runat="server" CssClass="input-field">
                            <asp:ListItem Text="Student" Value="Student"></asp:ListItem>
                            <asp:ListItem Text="Staff/Teacher" Value="Staff"></asp:ListItem>
                            <asp:ListItem Text="Visitor" Value="Visitor"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <!-- Purpose -->
                    <div class="form-group full-width">
                        <label>Purpose</label>
                        <asp:TextBox ID="txtPurpose" runat="server" TextMode="MultiLine" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Log Entry Button -->
                    <div class="full-width">
                        <asp:Button ID="btnLogEntry" runat="server" Text="Log Entry" CssClass="btn-primary" OnClick="btnLogEntry_Click" />
                    </div>
                </div>
            </div>

            <span class="horizontal-bar"></span>
            <!-- University Vehicle Set Out Form -->

            <div class="setout-form-container">
                <h2>University Vehicle Set Out</h2>
                <div class="form-grid">
                    <!-- Date and Time -->
                    <div class="form-group full-width">
                        <label>Date & Time</label>
                        <asp:TextBox ID="txtsetoutDateTime" runat="server" ReadOnly="true" CssClass="input-field"></asp:TextBox>

                    </div>
                    <!-- Plate Number + Check Button -->
                    <div class="form-group pair">
                        <div class="form-group">
                            <label>Plate Number</label>
                            <asp:TextBox ID="txtSetOutPlateNumber" runat="server" CssClass="input-field"></asp:TextBox>
                        </div>
                        <button type="button" onclick="checkSetOutVehicle()">Check</button>
                    </div>
                    <!-- Hidden Fields for Vehicle Type and Color -->
                    <asp:TextBox ID="txtSetOutVehicleType" runat="server" CssClass="input-field hidden"></asp:TextBox>
                    <asp:TextBox ID="txtSetOutVehicleColor" runat="server" CssClass="input-field hidden"></asp:TextBox>
                    <!-- Driver's Name -->
                    <div class="form-group">
                        <label>Driver's Name</label>
                        <asp:TextBox ID="txtSetOutDriverName" runat="server" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Person Count -->
                    <div class="form-group">
                        <label>Person Count</label>
                        <asp:TextBox ID="txtSetOutPersonCount" runat="server" CssClass="input-field" TextMode="Number" min="1"></asp:TextBox>
                    </div>
                    <!-- Purpose -->
                    <div class="form-group full-width">
                        <label>Purpose</label>
                        <asp:TextBox ID="txtSetOutPurpose" runat="server" TextMode="MultiLine" CssClass="input-field"></asp:TextBox>
                    </div>
                    <!-- Set Out Button -->
                    <div class="full-width">
                        <asp:Button ID="btnSetOut" runat="server" Text="Set Out" CssClass="btn-primary" OnClick="btnSetOut_Click" />
                    </div>
                </div>
            </div>

        </div>
        <!-- Modal for Set Out Form -->
        <div id="setOutVehicleModal" class="modal hidden">
            <div class="modal-content">
                <span class="close" onclick="closeModal('setOutVehicleModal', 'setOutVehicleDetails', 'setOutOkButton')">×</span>
                <h2>Vehicle Information</h2>
                <div id="setOutVehicleDetails"></div>
                <button id="setOutOkButton" type="button" onclick="showVehicleDetails('setOutVehicleModal', 'setOutVehicleDetails', 'setOutOkButton')">OK</button>
            </div>
        </div>
        <!-- Modal for Entry Form -->
        <div id="vehicleModal" class="modal hidden">
            <div class="modal-content">
                <span class="close" onclick="closeModal('vehicleModal', 'vehicleDetails', 'okButton')">×</span>
                <h2>Vehicle Information</h2>
                <div id="vehicleDetails"></div>
                <button id="okButton" type="button" onclick="showVehicleDetails('vehicleModal', 'vehicleDetails', 'okButton')">OK</button>
            </div>
        </div>
    </form>
</body>
</html>