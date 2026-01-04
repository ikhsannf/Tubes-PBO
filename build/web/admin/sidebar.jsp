<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // Dapatkan URI saat ini untuk highlight menu aktif
    String currentURI = request.getRequestURI();
    String contextPath = request.getContextPath();
%>

<div class="sidebar">
    <div class="sidebar-header">
        <div class="logo-wrapper">
            <i class="fas fa-camera-movie"></i>
            <h3>movINFO</h3>
        </div>
        <p class="tagline">Movie Admin Panel</p>
    </div>

    <div class="menu-section">
        <p class="section-title">MAIN MENU</p>
        <div class="menu">
            <a href="<%= contextPath %>/admin/dashboard.jsp" class="<%= currentURI.endsWith("dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> <span>Beranda</span>
            </a>
            
            <a href="<%= contextPath %>/film" class="<%= currentURI.contains("/film") ? "active" : "" %>">
                <i class="fas fa-film"></i> <span>Film</span>
            </a>
            
            <a href="<%= contextPath %>/berita" class="<%= currentURI.contains("/berita") ? "active" : "" %>">
                <i class="fas fa-newspaper"></i> <span>Berita</span>
            </a>
            
            <a href="<%= contextPath %>/user" class="<%= currentURI.contains("/user") ? "active" : "" %>">
                <i class="fas fa-users"></i> <span>User</span>
            </a>
        </div>
    </div>

    <div class="sidebar-footer">
        <a href="<%= contextPath %>/logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> <span>Keluar</span>
        </a>
    </div>
</div>

<script>
    function toggleSubmenu(element) {
        const submenu = element.nextElementSibling;
        const arrow = element.querySelector('.arrow');
        
        if (submenu.style.display === 'block') {
            submenu.style.display = 'none';
            arrow.style.transform = 'rotate(0deg)';
        } else {
            submenu.style.display = 'block';
            arrow.style.transform = 'rotate(90deg)';
        }
    }
</script>

<style>
    /* Sidebar Modern Styling */
    .sidebar {
        width: 260px;
        background: linear-gradient(180deg, #1e1e2d 0%, #2a2a3d 100%);
        color: white;
        padding: 0;
        box-shadow: 4px 0 15px rgba(0, 0, 0, 0.15);
        position: relative;
        height: 100%;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
    }

    .sidebar-header {
        padding: 25px 20px;
        background: #4B0082;
        text-align: center;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .logo-wrapper {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        margin-bottom: 5px;
    }

    .logo-wrapper i {
        font-size: 28px;
        color: #fff;
    }

    .sidebar-header h3 {
        margin: 0;
        font-size: 22px;
        font-weight: 700;
        color: #fff;
        letter-spacing: 0.5px;
    }

    .tagline {
        margin: 0;
        font-size: 11px;
        color: rgba(255, 255, 255, 0.7);
        letter-spacing: 1px;
    }

    .menu-section {
        flex: 1;
        padding: 20px 0;
    }

    .section-title {
        padding: 0 25px;
        margin: 15px 0 10px;
        font-size: 11px;
        color: rgba(184, 184, 201, 0.7);
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .menu {
        display: flex;
        flex-direction: column;
    }

    .menu a, .parent-menu {
        display: flex;
        align-items: center;
        padding: 14px 25px;
        text-decoration: none;
        color: #b8b8c9;
        font-size: 15px;
        font-weight: 500;
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
    }

    .menu a:hover, .parent-menu:hover {
        background: rgba(255, 255, 255, 0.05);
        color: #ffffff;
    }

    .menu a.active {
        background: rgba(75, 0, 130, 0.2);
        color: #ffffff;
        border-left: 4px solid #4B0082;
    }

    .menu a i, .parent-menu i {
        margin-right: 12px;
        font-size: 16px;
        width: 20px;
        text-align: center;
    }

    .parent-menu .arrow {
        margin-left: auto;
        margin-right: 0;
        transition: transform 0.3s ease;
    }

    /* Submenu Styling */
    .submenu {
        background: rgba(0, 0, 0, 0.2);
        padding-left: 20px;
    }

    .submenu a {
        padding: 12px 25px;
        font-size: 14px;
        color: #a0a0b8;
    }

    .submenu a:hover {
        background: rgba(75, 0, 130, 0.15);
        color: #fff;
    }

    .submenu a.active {
        background: rgba(75, 0, 130, 0.3);
        color: #fff;
        border-left: 4px solid #6a0dad;
    }

    /* Sidebar Footer */
    .sidebar-footer {
        padding: 20px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.1);
    }

    .logout-btn {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        border-radius: 8px;
        background: rgba(220, 53, 69, 0.15);
        color: #ff6b6b;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        width: 100%;
    }

    .logout-btn:hover {
        background: rgba(220, 53, 69, 0.3);
        color: #fff;
        transform: translateX(5px);
    }

    .logout-btn i {
        margin-right: 12px;
    }

    /* Scrollbar styling */
    .sidebar::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.1);
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: #4B0082;
        border-radius: 3px;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .sidebar {
            width: 240px;
        }
    }
</style>