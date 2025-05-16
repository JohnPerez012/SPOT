<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SPOT.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StaffPro Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .navbar {
            background-color: #fff;
            border-bottom: 1px solid #e0e0e0;
        }
        .navbar-brand {
            color: #007bff !important;
            font-weight: bold;
        }
        .profile-pic {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
        .schedule-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            background-color: #f1f1f1;
            padding: 10px;
            border-radius: 5px;
        }
        .schedule-header .nav-btn {
            cursor: pointer;
            margin: 0 5px;
            font-weight: bold;
        }
        .schedule-header .month-year {
            cursor: pointer;
            font-weight: bold;
        }
        .schedule-item {
            display: inline-block;
            width: 300px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            margin: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            vertical-align: top;
        }
        .schedule-item .status {
            font-weight: bold;
            color: #f4a261;
            text-align: center;
            margin-top: 10px;
        }
        .schedule-item .cancelled {
            background-color: #ffebee;
            color: #d32f2f;
            text-align: center;
            padding: 5px;
            border-radius: 3px;
        }
        .schedule-item img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .schedule-item .time {
            font-size: 0.9rem;
            color: #666;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg">
            <div class="container-fluid">
                <a class="navbar-brand" href="#">STAFFPRO</a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link" href="#">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">My Profile</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">People</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Documents</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Reports</a></li>
                    </ul>
                    <div class="d-flex">
                        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" />
                        <img src="https://via.placeholder.com/40" class="rounded-circle" alt="User" />
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container mt-4">
            <div class="row">
                <!-- Left Sidebar -->
                <div class="col-md-4">
                    <div class="card p-4">
                        <div class="d-flex align-items-center">
                            <img src="https://via.placeholder.com/80" class="profile-pic me-3" alt="Profile" />
                            <div>
                                <h4>Hi, Oliver!</h4>
                                <p>Embrace the journey of a workplace where potential transforms into achievement.</p>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mt-4">
                            <div class="text-center">
                                <h5>20</h5>
                                <p>VACATION</p>
                            </div>
                            <div class="text-center">
                                <h5>13 days</h5>
                                <p>SICK DAYS AVAILABLE</p>
                            </div>
                            <div class="text-center">
                                <button class="btn btn-outline-primary btn-sm">REQUEST TIME OFF</button>
                            </div>
                        </div>
                    </div>

                    <!-- Notifications -->
                    <h5 class="mt-4">NOTIFICATIONS</h5>
                    <div class="notification">
                        <div class="d-flex">
                            <img src="https://via.placeholder.com/40" class="rounded-circle me-2" alt="User" />
                            <div>
                                <p><strong>Trevor Bradley</strong></p>
                                <p>Just create a new Project in Dashprops...</p>
                                <small>2m ago</small>
                            </div>
                        </div>
                    </div>
                    <div class="notification">
                        <div class="d-flex">
                            <img src="https://via.placeholder.com/40" class="rounded-circle me-2" alt="User" />
                            <div>
                                <p><strong>Work Anniversary - Jane Mitchell</strong></p>
                                <p>Celebrating Jane Mitchell's 10 years of dedication to the company.</p>
                                <small>1hr ago</small>
                            </div>
                        </div>
                    </div>
                    <div class="notification">
                        <div class="d-flex">
                            <i class="bi bi-calendar me-2"></i>
                            <div>
                                <p><strong>Upcoming Company Event</strong></p>
                                <p>SparkConnect 2023, Oct 23</p>
                                <small>2m ago</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Content (Security Schedules) -->
                <div class="col-md-8">
                    <!-- Stats -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="stat-box">
                                <h3>184</h3>
                                <p>PROJECTS</p>
                                <small>2 completed</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-box">
                                <h3>1302</h3>
                                <p>EMPLOYEES</p>
                                <small>28 absent</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-box">
                                <h3>112</h3>
                                <p>TEAMS</p>
                                <small>1 in the formation process</small>
                            </div>
                        </div>
                    </div>

                    <!-- Security Schedules -->
                    <h5 class="mt-4">Security Schedules</h5>
                    <div class="schedule-header">
                        <div>
                            <span class="nav-btn" onclick="goToday()">Today</span>
                            <span class="nav-btn" onclick="prevMonth()"><</span>
                            <span class="nav-btn" onclick="nextMonth()">></span>
                        </div>
                        <div>
                            <span class="month-year" onclick="changeMonth()">July</span>
                            <span class="month-year" onclick="changeYear()">2024</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Brett Drake</strong></p>
                                        <p class="time">Wed, 5 Jul - 02:00 - 03:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Francis Mills</strong></p>
                                        <p class="time">Thu, 6 Jul - 02:00 - 03:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Roxie Ward</strong></p>
                                        <p class="time">Wed, 5 Jul - 07:00 - 08:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://interview.skype/user/12345</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Benjamin Delgado</strong></p>
                                        <p class="time">Fri, 6 Jul - 02:00 - 03:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Floyd Hansen</strong></p>
                                        <p class="time">Fri, 6 Jul - 04:00 - 04:30 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Agnes Armstrong</strong></p>
                                        <p class="time">Fri, 6 Jul - 07:00 - 08:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Jon McCormick</strong></p>
                                        <p class="time">Sat, 7 Jul - 02:00 - 03:00 PM</p>
                                    </div>
                                </div>
                                <div class="cancelled">Cancelled</div>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                            <div class="schedule-item">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="profile-pic" alt="Profile" />
                                    <div>
                                        <p><strong>Blanche Hoffman</strong></p>
                                        <p class="time">Thu, 23 Jul - 02:00 - 03:00 PM</p>
                                    </div>
                                </div>
                                <p class="status">Waiting for New Schedule</p>
                                <small>https://calendly.com/idealrahi</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function goToday() {
                // Placeholder for today functionality
                alert("Go to today selected");
            }
            function prevMonth() {
                // Placeholder for previous month functionality
                alert("Previous month selected");
            }
            function nextMonth() {
                // Placeholder for next month functionality
                alert("Next month selected");
            }
            function changeMonth() {
                // Placeholder for month change functionality
                alert("Change month selected");
            }
            function changeYear() {
                // Placeholder for year change functionality
                alert("Change year selected");
            }
        </script>
    </form>
</body>
</html>