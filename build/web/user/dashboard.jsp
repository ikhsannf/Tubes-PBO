<%@page import="java.util.List"%>
<%@page import="model.Film"%>
<%@page import="service.FilmService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Inisialisasi Service dan ambil data film
    FilmService filmService = new FilmService();
    List<Film> listFilm = filmService.getAll();
%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>movINFO - Dashboard</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh; }
            
            /* Navbar Styles */
            .navbar-custom { background-color: #58007e; padding: 15px 0; }
            .navbar-brand { font-weight: 700; font-size: 24px; color: white !important; }
            .nav-link { color: rgba(255,255,255,0.8) !important; margin-left: 15px; font-weight: 500; transition: 0.3s; }
            .nav-link:hover, .nav-link.active { color: white !important; }
            
            /* Search Bar */
            .search-bar { width: 100%; max-width: 400px; position: relative; }
            .search-input { border-radius: 20px; padding-right: 40px; border: none; background: rgba(255,255,255,0.1); color: white; }
            .search-input::placeholder { color: rgba(255,255,255,0.6); }
            .search-input:focus { background: white; color: #333; box-shadow: none; }
            .search-icon { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: rgba(255,255,255,0.6); pointer-events: none; }
            .search-input:focus + .search-icon { color: #58007e; }

            /* Hero Section */
            .hero-section { position: relative; margin-top: 20px; border-radius: 15px; overflow: hidden; color: white; box-shadow: 0 10px 30px rgba(0,0,0,0.15); }
            .hero-img { width: 100%; height: 400px; object-fit: cover; filter: brightness(0.6); transition: 0.5s; }
            .hero-section:hover .hero-img { transform: scale(1.02); }
            .hero-text { position: absolute; bottom: 40px; left: 40px; z-index: 2; max-width: 600px; }
            .hero-text h2 { font-weight: 700; text-shadow: 2px 2px 4px rgba(0,0,0,0.7); font-size: 2.5rem; }
            
            /* Content Styles */
            .section-title { color: #58007e; font-weight: 700; margin-top: 50px; margin-bottom: 5px; position: relative; display: inline-block; }
            .section-title::after { content: ''; position: absolute; width: 40%; height: 3px; background: #58007e; bottom: -5px; left: 0; border-radius: 2px; }
            .section-subtitle { color: #6c757d; margin-bottom: 25px; font-size: 0.9rem; }

            /* Movie Card */
            .movie-link { text-decoration: none; color: inherit; display: block; height: 100%; cursor: pointer; }
            .movie-card { background: white; border: none; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; transition: all 0.3s ease; height: 180px; position: relative; }
            .movie-card:hover { transform: translateY(-7px); box-shadow: 0 10px 25px rgba(88, 0, 126, 0.15); }
            .movie-poster { width: 130px; height: 100%; object-fit: cover; }
            .card-body-custom { padding: 15px; overflow: hidden; display: flex; flex-direction: column; justify-content: center; width: 100%; }
            .movie-title { font-weight: 700; font-size: 1.1rem; margin-bottom: 5px; color: #2c3e50; line-height: 1.2; }
            .movie-meta { font-size: 0.75rem; color: #888; margin-bottom: 3px; display: flex; align-items: center; gap: 5px; }
            .movie-desc { font-size: 0.8rem; color: #555; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-top: 8px; line-height: 1.4; }
            
            /* --- MODAL STYLES (Update Baru) --- */
            .modal-content-custom { border: none; border-radius: 20px; overflow: hidden; }
            .modal-poster-top { width: 100%; height: 250px; object-fit: cover; object-position: top; }
            .modal-body-custom { padding: 25px; }
            .modal-title-custom { font-weight: 700; font-size: 1.5rem; color: #2c3e50; margin-bottom: 5px; }
            .modal-info-label { font-size: 0.8rem; font-weight: 600; color: #888; margin-bottom: 2px; }
            .modal-info-value { font-size: 0.9rem; font-weight: 500; color: #333; margin-bottom: 10px; }
            .rating-stars { color: #ffc107; font-size: 0.8rem; }
            .btn-close-modal { background-color: #58007e; color: white; width: 100%; border-radius: 50px; padding: 10px; font-weight: 600; border: none; transition: 0.3s; margin-top: 15px; }
            .btn-close-modal:hover { background-color: #420061; color: white; }

            /* News Card */
            .news-link { text-decoration: none; color: inherit; }
            .news-card { border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 20px; height: 100%; transition: 0.3s; background: white; }
            .news-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
            .news-img { width: 100%; height: 180px; object-fit: cover; }
            .news-body { padding: 20px; }
            .news-badge { background: #e0ccff; color: #58007e; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px; display: inline-block; }
            .news-title { font-weight: 700; font-size: 1.05rem; margin-bottom: 10px; line-height: 1.4; color: #333; }
            .news-snippet { font-size: 0.85rem; color: #666; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }

            /* Footer */
            footer { background-color: #2c003e; color: white; margin-top: auto; padding: 40px 0 20px; }
            .footer-title { font-weight: 700; margin-bottom: 20px; color: #cbb2ff; }
            .footer-link { color: rgba(255,255,255,0.7); text-decoration: none; margin-bottom: 10px; display: block; transition: 0.3s; font-size: 0.9rem; }
            .footer-link:hover { color: white; transform: translateX(5px); }
            .social-icon { width: 35px; height: 35px; background: rgba(255,255,255,0.1); display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; color: white; margin-right: 10px; transition: 0.3s; text-decoration: none; }
            .social-icon:hover { background: #58007e; color: white; }
            .copyright { border-top: 1px solid rgba(255,255,255,0.1); margin-top: 30px; padding-top: 20px; text-align: center; font-size: 0.8rem; color: rgba(255,255,255,0.5); }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
            <div class="container">
                <a class="navbar-brand" href="dashboard.jsp">
                    movINFO
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" href="dashboard.jsp">Beranda</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Film</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Berita</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Ulasan</a></li>
                    </ul>

                    <div class="search-bar me-3 d-none d-lg-block">
                        <form class="d-flex">
                            <input class="form-control search-input" type="search" placeholder="Cari film atau berita..." aria-label="Search">
                            <i class="fas fa-search search-icon"></i>
                        </form>
                    </div>

                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="https://ui-avatars.com/api/?name=User+Name&background=random" class="rounded-circle me-2" width="32" height="32" alt="User">
                                <span>Halo, User</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile Saya</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-heart me-2"></i>Favorit</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="../index.jsp"><i class="fas fa-sign-out-alt me-2"></i>Keluar</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mb-5">
            <div class="hero-section">
                <img src="https://images.unsplash.com/photo-1478720568477-152d9b164e63?q=80&w=1920&auto=format&fit=crop" class="hero-img" alt="Hero Banner">
                <div class="hero-text">
                    <span class="badge bg-warning text-dark mb-2">TRENDING NOW</span>
                    <h3>Setelah 3 Musim Serial,</h3>
                    <h2>The Summer I Turned Pretty Resmi Dibuat Versi Film</h2>
                    <a href="#" class="btn btn-light mt-3 px-4 fw-bold" style="border-radius: 20px;">Baca Selengkapnya</a>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-end mt-5 mb-3">
                <div>
                    <h3 class="section-title">Film Terbaru</h3>
                    <p class="section-subtitle mb-0">Rekomendasi film terbaik untukmu</p>
                </div>
                <a href="#" class="text-decoration-none" style="color: #58007e; font-weight: 600;">Lihat Semua <i class="fas fa-arrow-right ms-1"></i></a>
            </div>

            <div class="row">
                <% 
                    if (listFilm != null && !listFilm.isEmpty()) {
                        for(Film f : listFilm) { 
                            // Membuat ID unik untuk Modal berdasarkan ID Film
                            String modalId = "modalFilm" + f.getIdFilm();
                %>
                <div class="col-lg-4 col-md-6 mb-4">
                    <a href="#" class="movie-link" data-bs-toggle="modal" data-bs-target="#<%= modalId %>">
                        <div class="movie-card d-flex">
                            <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/150x225?text=No+Poster" : f.getPosterUrl() %>" 
                                 class="movie-poster" alt="<%= f.getJudul() %>">
                            
                            <div class="card-body-custom">
                                <div class="movie-title"><%= f.getJudul() %></div>
                                
                                <div class="movie-meta">
                                    <i class="far fa-folder-open fa-xs"></i> <%= f.getNamaGenre() %>
                                </div>
                                <div class="movie-meta">
                                    <i class="far fa-calendar-alt fa-xs"></i> <%= f.getTahunRilis() %>
                                </div>
                                
                                <div class="movie-desc">
                                    <%= f.getDeskripsi() %>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content modal-content-custom">
                            
                            <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/600x300?text=No+Image" : f.getPosterUrl() %>" 
                                 class="modal-poster-top" alt="Banner">
                            
                            <div class="modal-body-custom">
                                <h3 class="modal-title-custom"><%= f.getJudul() %></h3>
                                
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <div class="modal-info-label">Genre</div>
                                        <div class="modal-info-value"><%= f.getNamaGenre() %></div>
                                    </div>
                                    <div class="col-6">
                                        <div class="modal-info-label">Rating</div>
                                        <div class="modal-info-value">
                                            <span class="rating-stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star-half-alt"></i>
                                            </span> 
                                            <span style="font-size: 0.8rem; color: #666;">(4.7/5)</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <div class="modal-info-label">Cast</div>
                                    <div class="modal-info-value">Wentworth Miller, Dominic Purcell, Amaury Nolasco</div>
                                </div>

                                <div class="mb-3">
                                    <div class="modal-info-label">Deskripsi</div>
                                    <p style="font-size: 0.9rem; color: #555; text-align: justify; line-height: 1.6;">
                                        <%= f.getDeskripsi() %>
                                    </p>
                                </div>

                                <button type="button" class="btn-close-modal" data-bs-dismiss="modal">
                                    Tutup
                                </button>
                                
                                <form action="../FavoriteServlet" method="POST" class="mt-2 text-center">
                                    <input type="hidden" name="idFilm" value="<%= f.getIdFilm() %>">
                                    <button type="submit" class="btn btn-sm btn-link text-decoration-none" style="color: #58007e;">
                                        <i class="far fa-heart me-1"></i> Tambah ke Favorit
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                        } 
                    } else { 
                %>
                    <div class="col-12 text-center my-5">
                        <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="100" class="mb-3 opacity-50">
                        <p class="text-muted">Belum ada data film tersedia saat ini.</p>
                    </div>
                <% } %>
            </div>

            <div class="d-flex justify-content-between align-items-end mt-5 mb-3">
                <div>
                    <h3 class="section-title">Berita Terkini</h3>
                    <p class="section-subtitle mb-0">Update terbaru dunia perfilman</p>
                </div>
                <a href="#" class="text-decoration-none" style="color: #58007e; font-weight: 600;">Lihat Semua <i class="fas fa-arrow-right ms-1"></i></a>
            </div>

            <div class="row">
                <% for(int j=0; j<4; j++) { %>
                <div class="col-lg-3 col-md-6">
                    <a href="detail_berita.jsp?id=<%= j %>" class="news-link">
                        <div class="news-card">
                            <img src="https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=800&auto=format&fit=crop" class="news-img" alt="News">
                            <div class="news-body">
                                <span class="news-badge">Update Studio</span>
                                <div class="news-title">Marvel Studios Umumkan Lineup Film Terbaru untuk 2025</div>
                                <div class="news-snippet">Marvel Studios akhirnya mengumumkan fase baru dari MCU dengan deretan judul yang sangat dinanti...</div>
                                <div class="mt-3 text-muted d-flex align-items-center" style="font-size: 0.75rem;">
                                    <i class="far fa-clock me-1"></i> 25 Oktober 2025
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
                <% } %>
            </div>
        </div> 

        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <h4 class="text-white fw-bold mb-3"><a class="navbar-brand" href="dashboard.jsp">
                            movINFO
                        </a>
                        </h4>
                        <p class="text-white-50" style="font-size: 0.9rem;">
                            Platform informasi film terlengkap. Temukan review, rating, dan berita terbaru seputar dunia perfilman hanya di sini.
                        </p>
                        <div class="mt-3">
                            <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-4">
                        <h5 class="footer-title">Jelajahi</h5>
                        <a href="#" class="footer-link">Beranda</a>
                        <a href="#" class="footer-link">Daftar Film</a>
                        <a href="#" class="footer-link">Berita</a>
                        <a href="#" class="footer-link">Ulasan</a>
                    </div>
                    <div class="col-md-2 col-6 mb-4">
                        <h5 class="footer-title">Kategori</h5>
                        <a href="#" class="footer-link">Action</a>
                        <a href="#" class="footer-link">Drama</a>
                        <a href="#" class="footer-link">Horror</a>
                        <a href="#" class="footer-link">Comedy</a>
                    </div>
                    <div class="col-md-4 mb-4">
                        <h5 class="footer-title">Berlangganan</h5>
                        <p class="text-white-50" style="font-size: 0.9rem;">Dapatkan info terbaru langsung ke emailmu.</p>
                        <div class="input-group mb-3">
                            <input type="text" class="form-control border-0" placeholder="Email Anda" aria-label="Email">
                            <button class="btn btn-warning fw-bold" type="button">Kirim</button>
                        </div>
                    </div>
                </div>
                <div class="copyright">
                    &copy; 2025 movINFO Group PBO. All Rights Reserved.
                </div>
            </div>
        </footer>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>