<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PROFILE.aspx.cs" Inherits="SPOT.users.Popup_master.PROFILE" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Profile</title>
    <!-- Add Cropper.js CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" />
    <style>
        /* Full-Screen Overlay */
.profile-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Centered Profile Box */
.profile-container {
/*    margin-left:10px;*/
    width: 550px;
    padding: 20px;
    border-radius: 12px;
    background: white;
    box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
    text-align: left;
    font-family: 'Arial', sans-serif;
    position: relative;
}

/* Profile Icon */
.profile-icon {
    position: absolute;
    top: -70px;
    right: -70px;
    width: 150px;
    height: 150px;
    border-radius: 10%;
    overflow: hidden;
    border: 3px solid #007bff;
    background: transparent; /* Ensure transparent background */
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Profile Image */

/* Plus Icon */
.plus-icon {
    position: absolute;
    right: -70px;
    bottom: 170px;
    width: 30px;
    height: 30px;
    background: #007bff;
    color: white;
    font-size: 18px;
    font-weight: bold;
    text-align: center;
    line-height: 25px;
    border-radius: 50%;
    cursor: pointer;
    transition: background 0.3s;
    z-index: 10;
    align-content:center;
}

    .plus-icon:hover {
        background: #0056b3;
    }

/* Dropdown Menu */
.dropdown-menu {
    position: absolute;
    top: 60px;
    right: -50px;
    width: 350px;
/*    height: 5px;*/
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
    border-radius: 8px;
    display: none;
    flex-direction: column;
    z-index: 100;
    padding: 10px;
    min-height: 100px;
}

/* Dropdown Items */
.dropdown-item {
    padding: 8px;
    font-size: 14px;
    cursor: pointer;
    border: none;
    background: none;
    text-align: left;
    width: 100%;
    display: block;
}

    .dropdown-item:hover {
        background: #f4f4f4;
    }

/* Dropdown Stays Open When Hovering */
.plus-icon:hover + .dropdown-menu,
.dropdown-menu:hover {
    display: flex;
}

/* Name Styling */
/*.middle-initial {
    
    font-size: 25px;
    font-weight: lighter;
    color: #777;
}
*/
.firstname {
    font-size: 30px;
    font-weight: bold;
/*    color: #007bff;*/
    margin-top: -5px;
}

.lastname {
    margin-left: 15px;
}
.profile-info {
}

.profile-container p {
    font-weight: bold;
    margin-left: 15px;
    font-size: 16px;
    color: #555;
    margin-bottom: 10px;
}








        /* Modal Styling */
        .cropper-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1001;
            justify-content: center;
            align-items: center;
        }
        .cropper-modal-content {
            background: white;
            padding: 20px;
            border-radius: 5px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        .cropper-container {
            max-height: 400px;
            overflow: hidden;
        }
        .cropper-modal-content img {
            max-width: 100%;
        }
        .cropper-modal-content button {
            margin: 10px;
            padding: 10px 20px;
            cursor: pointer;
        }
        /* Ensure profile image fits the frame */
        .profile-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- Full-Screen Overlay -->
        <div class="profile-overlay">
            <!-- Centered Box -->
            <div class="profile-container">
                <!-- Profile Icon -->
                <div class="profile-icon">
                    <asp:Image ID="Image1" runat="server" CssClass="profile-img" AlternateText="User profile picture" />
                </div>

                <!-- Plus Icon -->
                <div class="plus-icon" onmouseover="showDropdown()" onmouseleave="hideDropdown()">+</div>

                <!-- Dropdown Menu -->
                <div class="dropdown-menu" id="profileOptions" onmouseover="showDropdown()" onmouseleave="hideDropdown()">
                    <asp:FileUpload ID="fileUploadProfile" runat="server" CssClass="dropdown-item" onchange="previewImage(event)" />
                    <asp:Button ID="btnUpload" runat="server" Text="Upload" CssClass="dropdown-item" OnClick="btnUpload_Click" style="display:none;" />
                    <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="dropdown-item" OnClick="btnRemove_Click" Visible="false" data-debug="remove-button" />
                </div>

                <h1>
                    <span class="lastname"><asp:Label ID="lblLastName" runat="server"></asp:Label></span>
                    <span class="middle-initial"><asp:Label ID="lblMiddleInitial" runat="server"></asp:Label></span>
                    <span class="firstname"><asp:Label ID="lblFirstName" runat="server" CssClass="blue-text"></asp:Label></span>
                </h1>

                <p>
  <img src="https://img.icons8.com/color/48/000000/address--v1.png" 
       alt="Address" style="width: 18px; vertical-align: middle; margin-right: 6px;" />
  Address: <asp:Label ID="lblAddress" runat="server"></asp:Label>
</p>

<p>
  <img src="https://img.icons8.com/color/48/000000/phone.png" 
       alt="Phone" style="width: 18px; vertical-align: middle; margin-right: 6px;" />
  Phone: <asp:Label ID="lblPhoneHidden" runat="server"></asp:Label>
</p>

<p>
  <img src="https://img.icons8.com/color/48/000000/new-post.png" 
       alt="Email" style="width: 18px; vertical-align: middle; margin-right: 6px;" />
  Email: <asp:Label ID="lblEmail" runat="server"></asp:Label>
</p>

<p>
  <img src="https://img.icons8.com/color/48/000000/planner.png" 
       alt="Account Created" style="width: 18px; vertical-align: middle; margin-right: 6px;" />
  Account Created: <asp:Label ID="lblAccCreatedAgo" runat="server"></asp:Label>
</p>
   </div>
        </div>

        <!-- Cropping Modal -->
        <div id="cropperModal" class="cropper-modal">
            <div class="cropper-modal-content">
                <h3>Crop Image</h3>
                <div class="cropper-container">
                    <img id="imageToCrop" src="" alt="Image to crop" />
                </div>
                <button type="button" onclick="cropImage()">Crop & Upload</button>
                <button type="button" onclick="closeCropperModal()">Cancel</button>
            </div>
        </div>
    </form>

    <!-- Add Cropper.js and Custom JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.js"></script>
    <script>
        let cropper;
        let fileToUpload;

        function showDropdown() {
            document.getElementById("profileOptions").style.display = "block";
        }

        function hideDropdown() {
            document.getElementById("profileOptions").style.display = "none";
        }

        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                if (!file.type.match('image/(jpeg|png)')) {
                    alert('Only JPG and PNG files are allowed.');
                    event.target.value = '';
                    return;
                }
                fileToUpload = file;
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.getElementById("imageToCrop");
                    img.src = e.target.result;
                    openCropperModal(img);
                };
                reader.readAsDataURL(file);
            }
        }

        function openCropperModal(img) {
            const modal = document.getElementById("cropperModal");
            modal.style.display = "flex";

            if (cropper) {
                cropper.destroy();
            }

            cropper = new Cropper(img, {
                aspectRatio: 1,
                viewMode: 1,
                autoCropArea: 0.8,
                responsive: true,
                minCropBoxWidth: 100,
                minCropBoxHeight: 100,
                background: false // Disable Cropper.js background
            });
        }

        function closeCropperModal() {
            const modal = document.getElementById("cropperModal");
            modal.style.display = "none";
            if (cropper) {
                cropper.destroy();
            }
            document.getElementById("fileUploadProfile").value = "";
        }

        function cropImage() {
            if (!cropper) return;

            cropper.getCroppedCanvas({
                width: 100,
                height: 100,
                imageSmoothingQuality: 'high',
                fillColor: 'transparent' // Set transparent background
            }).toBlob(function (blob) {
                // Force PNG format for transparency
                const croppedFile = new File([blob], fileToUpload.name.replace(/\.[^/.]+$/, ".png"), { type: 'image/png' });

                // Replace the file in the FileUpload control
                const fileInput = document.getElementById("fileUploadProfile");
                const dataTransfer = new DataTransfer();
                dataTransfer.items.add(croppedFile);
                fileInput.files = dataTransfer.files;

                // Trigger the ASP.NET upload button click
                document.getElementById("<%= btnUpload.ClientID %>").click();

                // Close the modal
                closeCropperModal();
            }, 'image/png', 0.9); // Use PNG format with 90% quality
        }
    </script>
</body>
</html>