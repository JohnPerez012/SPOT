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
    } else {
        console.error('closePopup: One or more elements not found', {
            popupContainer: !!popupContainer,
            overlay: !!overlay,
            popupFrame: !!popupFrame
        });
    }

    // Call UpdateCircles WebMethod via AJAX
    console.log('closePopup: Initiating AJAX call to UpdateCircles');
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/UpdateCircles",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{}', // Explicitly send empty data
        success: function (response) {
            console.log('UpdateCircles success: Response:', response);
            if (response && response.d) {
                console.log('UpdateCircles data:', response.d);
                updatePendingCircles(response.d);
            } else {
                console.error('UpdateCircles: No data in response');
            }
        },
        error: function (xhr, status, error) {
            console.error('UpdateCircles AJAX error:', {
                status: status,
                error: error,
                responseText: xhr.responseText,
                statusCode: xhr.status
            });
        }
    });
}

function updatePendingCircles(data) {
    console.log('updatePendingCircles: Received data:', data);
    // Find the PENDING box
    const pendingBox = Array.from(document.querySelectorAll('.box')).find(box =>
        box.textContent.trim().startsWith('PENDING')
    );
    if (!pendingBox) {
        console.error('updatePendingCircles: PENDING box not found. Box contents:',
            Array.from(document.querySelectorAll('.box')).map(box => box.textContent.trim()));
        return;
    }
    console.log('updatePendingCircles: PENDING box found');

    const circlesContainer = pendingBox.querySelector('.pending-circles-container');
    if (!circlesContainer) {
        console.error('updatePendingCircles: Circles container not found in PENDING box');
        return;
    }
    console.log('updatePendingCircles: Circles container found');

    // Update the circles with new counts
    const universityCount = data.university || 0;
    const visitorsCount = data.visitors || 0;
    const vehiclesCount = data.vehicles || 0;

    circlesContainer.innerHTML = `
        <span class="circle ${universityCount === 0 ? 'green' : ''}">${universityCount}</span>
        <span class="circle ${visitorsCount === 0 ? 'green' : ''}">${visitorsCount}</span>
        <span class="circle ${vehiclesCount === 0 ? 'green' : ''}">${vehiclesCount}</span>
    `;
    console.log('updatePendingCircles: Circles updated with counts:', {
        universityCount,
        visitorsCount,
        vehiclesCount
    });
}

function toggleSidebar() {
    console.log('toggleSidebar: Toggling sidebar');
    const sidebar = document.getElementById("sidebar");
    if (sidebar) {
        sidebar.classList.toggle("hidden");
    } else {
        console.error('toggleSidebar: Sidebar element not found');
    }
}

function showNotification() {
    console.log('showNotification: Notification clicked');
    // Implement notification logic if needed
}

function refreshDashboard() {
    console.log('refreshDashboard: Refreshing dashboard');
    // Implement refresh logic if needed
}

// Initialize on window load
window.onload = function () {
    console.log('window.onload: Initializing');
    updateTime();
    setInterval(updateTime, 1000);
};