<%@page import="model.Berita"%>
<%@page import="service.BeritaService"%>
<%@page import="service.FavoriteService"%>
<%@page import="model.Akun"%>
<%@page import="java.util.List"%>
<%@page import="model.Film"%>
<%@page import="service.FilmService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK SESSION LOGIN
    Akun akun = (Akun) session.getAttribute("user");

    if (akun == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // 2. Inisialisasi Service Film
    FilmService filmService = new FilmService();
    List<Film> listFilm = filmService.getAll();

    // 3. Inisialisasi Service Favorite
    FavoriteService favService = new FavoriteService();

    // 4. Inisialisasi Service Berita
    BeritaService beritaService = new BeritaService();
    List<Berita> listBerita = beritaService.getAll();
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

            /* Hero Carousel Style */
            .hero-section { margin-top: 20px; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.15); background: #000; }
            .carousel-item { height: 450px; position: relative; }
            .hero-img { width: 100%; height: 100%; object-fit: cover; filter: brightness(0.5); transition: transform 0.8s ease; }
            .carousel-item.active .hero-img { transform: scale(1.05); }
            .hero-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0) 60%); }
            .hero-text { position: absolute; bottom: 50px; left: 50px; z-index: 5; color: white; max-width: 700px; text-align: left; }
            .hero-text h2 { font-weight: 700; font-size: 2.8rem; margin-bottom: 15px; text-shadow: 2px 2px 10px rgba(0,0,0,0.5); }
            .carousel-indicators [data-bs-target] { width: 10px; height: 10px; border-radius: 50%; }

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
            
            /* Modal & News Styles (Tetap sama seperti punyamu) */
            .modal-content-custom { border: none; border-radius: 20px; overflow: hidden; }
            .modal-poster-top { width: 100%; height: 250px; object-fit: cover; }
            .modal-body-custom { padding: 25px; max-height: 50vh; overflow-y: auto; }
            .btn-close-modal { background-color: #58007e; color: white; width: 100%; border-radius: 50px; padding: 10px; font-weight: 600; border: none; }
            .news-card { border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 20px; height: 100%; transition: 0.3s; background: white; }
            .news-img { width: 100%; height: 180px; object-fit: cover; }
            .news-body { padding: 20px; }
            .news-badge { background: #e0ccff; color: #58007e; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; margin-bottom: 10px; display: inline-block; }
            
            footer { background-color: #2c003e; color: white; margin-top: auto; padding: 40px 0 20px; }
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
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" href="dashboard.jsp">Beranda</a></li>
                        <li class="nav-item"><a class="nav-link" href="film.jsp">Film</a></li>
                        <li class="nav-item"><a class="nav-link" href="berita.jsp">Berita</a></li>
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
                                <img src="https://ui-avatars.com/api/?name=<%= akun.getUsername() %>&background=random" class="rounded-circle me-2" width="32" height="32" alt="User">
                                <span>Halo, <%= akun.getUsername() %></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile Saya</a></li>
                                <li><a class="dropdown-item" href="favorite.jsp"><i class="fas fa-heart me-2"></i>Favorit</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="../logout" onclick="return confirm('Yakin ingin keluar?');"><i class="fas fa-sign-out-alt me-2"></i>Keluar</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mb-5">
            
            <div id="heroBanner" class="carousel slide hero-section" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <% 
                        int bannerLimit = Math.min(listBerita.size(), 3);
                        for(int i=0; i < bannerLimit; i++) { 
                    %>
                        <button type="button" data-bs-target="#heroBanner" data-bs-slide-to="<%= i %>" class="<%= (i==0) ? "active" : "" %>"></button>
                    <% } %>
                </div>
                <div class="carousel-inner">
                    <% 
                        if (listBerita != null && !listBerita.isEmpty()) {
                            for(int i=0; i < bannerLimit; i++) {
                                Berita b = listBerita.get(i);
                                String cleanDesc = b.getIsi().replaceAll("<[^>]*>", "");
                                if(cleanDesc.length() > 120) cleanDesc = cleanDesc.substring(0, 120) + "...";
                    %>
                    <div class="carousel-item <%= (i==0) ? "active" : "" %>" data-bs-interval="4000">
                        <img src="<%= (b.getGambarUrl() == null || b.getGambarUrl().isEmpty()) ? "https://images.unsplash.com/photo-1478720568477-152d9b164e63" : request.getContextPath() + "/uploads/berita/" + b.getGambarUrl() %>" class="hero-img" alt="...">
                        <div class="hero-overlay"></div>
                        <div class="hero-text">
                            <span class="badge bg-warning text-dark mb-2 fw-bold px-3 py-2">HOT UPDATE</span>
                            <h2><%= b.getJudul() %></h2>
                            <p class="lead opacity-75"><%= cleanDesc %></p>
                            <a href="detail_berita.jsp?id=<%= b.getIdBerita() %>" class="btn btn-light btn-lg mt-2 px-4 fw-bold" style="border-radius: 30px; color: #58007e;">Baca Selengkapnya</a>
                        </div>
                    </div>
                    <% } } else { %>
                    <div class="carousel-item active">
                        <img src="https://images.unsplash.com/photo-1478720568477-152d9b164e63" class="hero-img" alt="Default">
                        <div class="hero-text"><h2>Selamat Datang di movINFO</h2><p>Temukan informasi film terbaik.</p></div>
                    </div>
                    <% } %>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#heroBanner" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
                <button class="carousel-control-next" type="button" data-bs-target="#heroBanner" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
            </div>

            <div class="d-flex justify-content-between align-items-end mt-5 mb-3">
                <div>
                    <h3 class="section-title">Film Terbaru</h3>
                    <p class="section-subtitle mb-0">Rekomendasi film terbaik untukmu</p>
                </div>
                <a href="film.jsp" class="text-decoration-none" style="color: #58007e; font-weight: 600;">Lihat Semua <i class="fas fa-arrow-right ms-1"></i></a>
            </div>

            <div class="row">
                <% 
                    if (listFilm != null && !listFilm.isEmpty()) {
                        for(Film f : listFilm) { 
                            String modalId = "modalFilm" + f.getIdFilm();
                            boolean isLiked = favService.isFavorite(akun.getIdAkun(), f.getIdFilm());
                %>
                <div class="col-lg-4 col-md-6 mb-4">
                    <a href="#" class="movie-link" data-bs-toggle="modal" data-bs-target="#<%= modalId %>">
                        <div class="movie-card d-flex">
                            <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/150x225" : request.getContextPath() + "/uploads/posters/" + f.getPosterUrl() %>" class="movie-poster" alt="...">
                            <div class="card-body-custom">
                                <div class="movie-title"><%= f.getJudul() %></div>
                                <div class="movie-meta"><i class="far fa-folder-open fa-xs"></i> <%= f.getNamaGenre() %></div>
                                <div class="movie-meta"><i class="far fa-calendar-alt fa-xs"></i> <%= f.getTahunRilis() %></div>
                                <div class="movie-desc"><%= f.getDeskripsi() %></div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content modal-content-custom">
                            <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/600x300" : request.getContextPath() + "/uploads/posters/" + f.getPosterUrl() %>" class="modal-poster-top" alt="Banner">
                            <div class="modal-body-custom">
                                <h3 class="modal-title-custom"><%= f.getJudul() %></h3>
                                <div class="row mb-3">
                                    <div class="col-6"><div class="modal-info-label">Genre</div><div class="modal-info-value"><%= f.getNamaGenre() %></div></div>
                                    <div class="col-6"><div class="modal-info-label">Rating</div><div class="modal-info-value"><span class="rating-stars"><i class="fas fa-star"></i></span> <%= f.getRating() %>/10</div></div>
                                </div>
                                <div class="mb-3"><div class="modal-info-label">Cast</div><div class="modal-info-value"><%= f.getCastFilm() %></div></div>
                                <div class="mb-3"><div class="modal-info-label">Deskripsi</div><p style="font-size: 0.9rem; color: #555;"><%= f.getDeskripsi() %></p></div>
                                <button type="button" class="btn-close-modal mb-2" data-bs-dismiss="modal">Tutup</button>
                                <div class="text-center">
                                    <button type="button" onclick="toggleFavorite(<%= f.getIdFilm() %>)" id="btn-fav-<%= f.getIdFilm() %>" class="btn btn-sm btn-link text-decoration-none" style="color: <%= isLiked ? "#dc3545" : "#58007e" %>; font-weight: 600;">
                                        <i class="<%= isLiked ? "fas" : "far" %> fa-heart me-1" id="icon-fav-<%= f.getIdFilm() %>"></i> 
                                        <span id="text-fav-<%= f.getIdFilm() %>"><%= isLiked ? "Hapus dari Favorit" : "Tambah ke Favorit" %></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } } %>
            </div>

            <div class="d-flex justify-content-between align-items-end mt-5 mb-3">
                <div>
                    <h3 class="section-title">Berita Terkini</h3>
                    <p class="section-subtitle mb-0">Update terbaru dunia perfilman</p>
                </div>
                <a href="berita.jsp" class="text-decoration-none" style="color: #58007e; font-weight: 600;">Lihat Semua <i class="fas fa-arrow-right ms-1"></i></a>
            </div>

            <div class="row">
                <% if (listBerita != null) { for(Berita b : listBerita) { %>
                <div class="col-lg-3 col-md-6 mb-4">
                    <a href="detail_berita.jsp?id=<%= b.getIdBerita() %>" class="news-link">
                        <div class="news-card">
                            <img src="<%= (b.getGambarUrl() == null || b.getGambarUrl().isEmpty()) ? "https://via.placeholder.com/800x450" : request.getContextPath() + "/uploads/berita/" + b.getGambarUrl() %>" class="news-img" alt="...">
                            <div class="news-body">
                                <span class="news-badge">Info Film</span>
                                <div class="news-title text-truncate-2"><%= b.getJudul() %></div>
                                <div class="mt-3 text-muted" style="font-size: 0.75rem;"><i class="far fa-clock me-1"></i> <%= b.getTanggal() %></div>
                            </div>
                        </div>
                    </a>
                </div>
                <% } } %>
            </div>
        </div> 

        <footer>
            <div class="container text-center">
                <h4 class="text-white fw-bold mb-3">movINFO</h4>
                <p class="text-white-50 small">Platform informasi film terlengkap & terupdate.</p>
                <div class="copyright pt-4 mt-4 border-top border-secondary">
                    &copy; 2025 movINFO Group PBO. All Rights Reserved.
                </div>
            </div>
        </footer>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Fungsi Favorit (AJAX)
            function toggleFavorite(filmId) {
                var btn = document.getElementById("btn-fav-" + filmId);
                var icon = document.getElementById("icon-fav-" + filmId);
                var text = document.getElementById("text-fav-" + filmId);

                fetch('<%= request.getContextPath() %>/favorite', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'idFilm=' + filmId
                })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === "ADDED") {
                        icon.classList.replace("far", "fas");
                        btn.style.color = "#dc3545";
                        text.innerText = "Hapus dari Favorit";
                    } else if (data.trim() === "REMOVED") {
                        icon.classList.replace("fas", "far");
                        btn.style.color = "#58007e";
                        text.innerText = "Tambah ke Favorit";
                    }
                });
            }

            // Fitur Search Client-side
            document.querySelector('.search-input').addEventListener('keyup', function(e) {
                const term = e.target.value.toLowerCase().trim();
                document.querySelectorAll('.movie-card, .news-card').forEach(card => {
                    const title = card.querySelector('.movie-title, .news-title').textContent.toLowerCase();
                    card.closest('.col-lg-4, .col-md-6, .col-lg-3').style.display = title.includes(term) ? "" : "none";
                });
            });
        </script>
    </body>
</html>