<%@page import="model.Akun"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="service.FavoriteService"%>

<%
    // CEK SESSION (Wajib ada di halaman user)
    Akun akun = (Akun) session.getAttribute("user");

    // Jika belum login, tendang ke login page
    if (akun == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    FavoriteService favService = new FavoriteService();
    int jumlahFavorit = favService.countFavorites(akun.getIdAkun());
%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profil Saya - movINFO</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh; }
            
            /* Navbar */
            .navbar-custom { background-color: #58007e; padding: 15px 0; }
            .navbar-brand { font-weight: 700; font-size: 24px; color: white !important; }
            .nav-link { color: rgba(255,255,255,0.8) !important; margin-left: 15px; font-weight: 500; }
            .nav-link:hover { color: white !important; }
            
            /* Profile Styles */
            .profile-section { padding-top: 80px; padding-bottom: 80px; }
            .profile-card { background: white; border: none; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
            .profile-header-bg { height: 150px; background: linear-gradient(135deg, #58007e 0%, #8a2be2 100%); position: relative; }
            .profile-avatar-container { position: absolute; bottom: -50px; left: 50%; transform: translateX(-50%); }
            .profile-avatar { width: 120px; height: 120px; border-radius: 50%; border: 5px solid white; object-fit: cover; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
            
            .profile-body { padding-top: 60px; padding-bottom: 40px; padding-left: 30px; padding-right: 30px; text-align: center; }
            .user-name { font-weight: 700; color: #2c3e50; font-size: 1.5rem; margin-bottom: 5px; }
            .user-role { color: #888; font-size: 0.9rem; margin-bottom: 20px; font-weight: 500; }

            .stat-box { background-color: #f8f9fa; border-radius: 15px; padding: 15px; text-align: center; transition: 0.3s; }
            .stat-box:hover { background-color: #e0ccff; transform: translateY(-3px); }
            .stat-value { font-weight: 700; font-size: 1.2rem; color: #58007e; }
            .stat-label { font-size: 0.8rem; color: #666; }

            .info-item { text-align: left; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
            .info-label { font-size: 0.85rem; font-weight: 600; color: #888; display: block; margin-bottom: 3px; }
            .info-value { font-size: 1rem; color: #333; font-weight: 500; }

            .btn-edit-profile { border: 2px solid #58007e; color: #58007e; font-weight: 600; border-radius: 50px; padding: 10px 30px; background: transparent; transition: 0.3s; }
            .btn-edit-profile:hover { background: #58007e; color: white; }

            /* Footer */
            footer { background-color: #2c003e; color: white; margin-top: auto; padding: 40px 0 20px; }
            .copyright { border-top: 1px solid rgba(255,255,255,0.1); margin-top: 30px; padding-top: 20px; text-align: center; font-size: 0.8rem; color: rgba(255,255,255,0.5); }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
            <div class="container">
                <a class="navbar-brand" href="dashboard.jsp">movINFO</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Kembali ke Beranda</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container profile-section">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="profile-card">
                        <div class="profile-header-bg">
                            <div class="profile-avatar-container">
                                <img src="https://ui-avatars.com/api/?name=<%= akun.getUsername() %>&background=random&size=128" class="profile-avatar" alt="Avatar">
                            </div>
                        </div>

                        <div class="profile-body">
                            <div class="user-name"><%= akun.getUsername() %></div>
                            <div class="user-role">Role: <%= akun.getRole() %></div>

                            <div class="row justify-content-center mb-4 mt-3">
                                <div class="col-4 col-md-3">
                                    <div class="stat-box">
                                        <div class="stat-value"><%= jumlahFavorit %></div> 
                                        <div class="stat-label">Favorit</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row justify-content-center text-start">
                                <div class="col-md-8">
                                    <div class="info-item">
                                        <span class="info-label">Username</span>
                                        <div class="info-value">@<%= akun.getUsername() %></div>
                                    </div>
                                    </div>
                            </div>

                            <div class="mt-4">
                                <button class="btn btn-edit-profile me-2" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fas fa-pen me-2"></i>Edit Profile
                                </button>
                                
                                <a href="../logout" class="btn btn-outline-danger rounded-pill px-4 py-2 fw-bold" onclick="return confirm('Yakin ingin keluar?');">
                                    Logout
                                </a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 20px; border: none;">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold" style="color: #58007e;">Edit Profil</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="../updateProfile" method="POST">
                            
                            <div class="mb-3">
                                <label for="username" class="form-label fw-bold" style="font-size: 0.9rem;">Username</label>
                                <input type="text" class="form-control" id="username" name="username" value="<%= akun.getUsername() %>" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn text-white fw-bold py-2" style="background-color: #58007e; border-radius: 50px;">Simpan Perubahan</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <footer>
            <div class="container">
                <div class="text-center">
                    <h4 class="text-white fw-bold mb-3">movINFO</h4>
                    <div class="copyright">
                        &copy; 2025 movINFO Group PBO. All Rights Reserved.
                    </div>
                </div>
            </div>
        </footer>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>