function togglePinVisibility() {
    var pinInput = document.getElementById("txtPin");
    if (pinInput.type === "password") {
        pinInput.type = "text";
    } else {
        pinInput.type = "password";
    }
}

