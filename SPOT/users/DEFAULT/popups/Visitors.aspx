<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Visitors.aspx.cs" Inherits="SPOT.users.DEFAULT.popups.Visitors" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <title>Visitor Log</title>
    <script>
        function clearForm() {
            const form = document.getElementById('form1');
            form.querySelector('#<%= txtFullName.ClientID %>').value = "";
            form.querySelector('#<%= txtContact.ClientID %>').value = "+63";
            form.querySelector('#<%= txtReason.ClientID %>').value = "";
            validateForm();
        }

        function updateTime() {
            const now = new Date().toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true
            });
            document.getElementById("timeIn").value = now;
            document.getElementById("timeOut").value = now;
        }

        function validateForm() {
            const fullName = document.getElementById('<%= txtFullName.ClientID %>').value.trim();
            const contact = document.getElementById('<%= txtContact.ClientID %>').value.trim();
            const reason = document.getElementById('<%= txtReason.ClientID %>').value.trim();
            const submitBtn = document.getElementById('<%= btnSubmit.ClientID %>');
            const nameError = document.getElementById('nameError');
            const contactError = document.getElementById('contactError');
            const reasonError = document.getElementById('reasonError');

            const namePattern = /^[a-zA-Z\s]{2,}$/;
            const contactPattern = /^\+63\d{10}$/;

            let isValid = true;

            if (!namePattern.test(fullName)) {
                nameError.textContent = 'Valid name required';
                isValid = false;
            } else {
                nameError.textContent = '';
            }

            if (!contactPattern.test(contact)) {
                contactError.textContent = 'Valid PH number needed';
                isValid = false;
            } else {
                contactError.textContent = '';
            }

            if (reason.length < 5) {
                reasonError.textContent = 'Reason too short';
                isValid = false;
            } else {
                reasonError.textContent = '';
            }

            submitBtn.disabled = !isValid;
        }

        window.onload = function () {
            updateTime();
            validateForm();
            setInterval(updateTime, 1000);
        };
    </script>
    <style>
        :root {
    --primary-color: #3b82f6;
    --secondary-color: #f472b6;
    --error-color: #ef4444;
    --background-color: #fef2f2;
    --text-color: #1e293b;
    --border-radius: 8px;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: system-ui;
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    color: var(--text-color);
    line-height: 2;
}

.popup-container {
    background: white;
    padding: 2rem;
    border-radius: var(--border-radius);
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    width: 500px;
    margin: 0.3rem;
    border: 2px solid var(--primary-color);
}

.popup-title {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
    text-align: center;
    color: var(--primary-color);
    text-transform: uppercase;
}

.form-group {
    margin-bottom: 0.4rem;
}

    .form-group label {
        display: block;
        font-size: 0.8rem;
        font-weight: 600;
        margin-bottom: 0.1rem;
        color: var(--text-color);
    }

.input-field {
    width: 100%;
    padding: 0.4rem;
    border: 2px solid #e5e7eb;
    border-radius: 6px;
    font-size: 0.85rem;
    font-weight: 500;
    transition: border-color 0.2s ease;
}

    .input-field:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
    }

    .input-field:disabled {
        background-color: #f3f4f6;
        cursor: not-allowed;
        opacity: 0.8;
        border-color: #d1d5db;
    }

.textarea {
    min-height: 40px;
    resize: none;
}

.error-message {
    display: block;
    color: var(--error-color);
    font-size: 0.6rem;
    margin-top: 0.05rem;
    font-weight: 500;
    min-height: 0.7rem;
}

.button-group {
    display: flex;
    gap: 0.4rem;
    margin-top: 0.5rem;
}

.btn-primary, .btn-secondary {
    flex: 1;
    padding: 0.4rem;
    border: none;
    border-radius: 6px;
    font-size: 0.8rem;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s ease, background-color 0.2s ease;
}

.btn-primary {
    background: var(--primary-color);
    color: white;
}

    .btn-primary:hover:not(:disabled) {
        background: #2563eb;
        transform: scale(1.05);
    }

    .btn-primary:disabled {
        background: #bfdbfe;
        cursor: not-allowed;
    }

.btn-secondary {
    background: var(--secondary-color);
    color: white;
}

    .btn-secondary:hover {
        background: #ec4899;
        transform: scale(1.05);
    }

@media (max-width: 360px) {
    .popup-container {
        padding: 0.6rem;
        max-width: 340px;
    }

    .popup-title {
        font-size: 1rem;
    }

    .input-field {
        font-size: 0.8rem;
        padding: 0.3rem;
    }

    .btn-primary, .btn-secondary {
        font-size: 0.75rem;
        padding: 0.3rem;
    }
}

    </style>
</head>
<body>
    <form id="form1" runat="server" aria-label="Visitor Log Form">
        <div class="popup-container">
            <h2 class="popup-title">Visitor Log</h2>

            <div class="form-group">
                <label for="<%= txtFullName.ClientID %>">Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="input-field" 
                    onkeyup="validateForm()" aria-required="true" placeholder="Full Name"></asp:TextBox>
                <span class="error-message" id="nameError"></span>
            </div>

            <div class="form-group">
                <label for="<%= txtContact.ClientID %>">Contact</label>
                <asp:TextBox ID="txtContact" runat="server" CssClass="input-field" 
                    Text="+63" onkeyup="validateForm()" aria-required="true" 
                    placeholder="+639123456789"></asp:TextBox>
                <span class="error-message" id="contactError"></span>
            </div>

            <div class="form-group">
                <label for="<%= txtDate.ClientID %>">Date</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="input-field" 
                    ReadOnly="true" Enabled="false" aria-readonly="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="timeIn">Time In</label>
                <asp:TextBox ID="timeIn" runat="server" CssClass="input-field" 
                    ReadOnly="true" Enabled="false" aria-readonly="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="timeOut">Time Out</label>
                <asp:TextBox ID="timeOut" runat="server" CssClass="input-field" 
                    ReadOnly="true" Enabled="false" aria-readonly="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="<%= txtReason.ClientID %>">Purpose</label>
                <asp:TextBox ID="txtReason" runat="server" CssClass="input-field textarea" 
                    TextMode="MultiLine" onkeyup="validateForm()" aria-required="true" 
                    placeholder="Reason for visit"></asp:TextBox>
                <span class="error-message" id="reasonError"></span>
            </div>

            <div class="button-group">
                <asp:Button ID="btnSubmit" runat="server" CssClass="btn-primary" Text="Add" 
                    OnClick="btnSubmit_Click" Enabled="false" aria-label="Submit visitor info" />
                <asp:Button ID="btnClear" runat="server" CssClass="btn-secondary" Text="Clear" 
                    OnClientClick="clearForm(); return false;" aria-label="Clear form" />
            </div>
        </div>
    </form>
</body>
</html>