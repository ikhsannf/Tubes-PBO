<%@page import="model.Akun"%>
<%@page import="java.util.List"%>
<%@page import="model.Film"%>
<%@page import="service.FilmService"%>
<%@page import="service.FavoriteService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Cek Login
    Akun akun = (Akun) session.getAttribute("user");
    if (akun == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // 2. Ambil Data Film
    FilmService filmService = new FilmService();
    List<Film> listFilm = filmService.getAll();
    
    // 3. Service Favorite
    FavoriteService favService = new FavoriteService();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Film - movINFO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh; }
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
        
        /* Movie Card & Modal Styles (Sama Persis) */
        .movie-link { text-decoration: none; color: inherit; display: block; height: 100%; cursor: pointer; }
        .movie-card { background: white; border: none; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; transition: all 0.3s ease; height: 100%; position: relative; display: flex; flex-direction: column; }
        .movie-card:hover { transform: translateY(-7px); box-shadow: 0 10px 25px rgba(88, 0, 126, 0.15); }
        .movie-poster { width: 100%; height: 350px; object-fit: cover; } /* Sedikit lebih tinggi untuk halaman list */
        .card-body-custom { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; }
        .movie-title { font-weight: 700; font-size: 1.1rem; margin-bottom: 5px; color: #2c3e50; line-height: 1.2; }
        .movie-meta { font-size: 0.75rem; color: #888; margin-bottom: 3px; }
        
        /* Modal Styles */
        .modal-content-custom { border: none; border-radius: 20px; overflow: hidden; }
        .modal-poster-top { width: 100%; height: 250px; object-fit: cover; object-position: top; flex-shrink: 0; }
        .modal-body-custom { padding: 25px; max-height: 60vh; overflow-y: auto; }
        .modal-body-custom::-webkit-scrollbar { width: 8px; }
        .modal-body-custom::-webkit-scrollbar-thumb { background: #58007e; border-radius: 4px; }
        .modal-title-custom { font-weight: 700; font-size: 1.5rem; color: #2c3e50; margin-bottom: 5px; }
        .modal-info-label { font-size: 0.8rem; font-weight: 600; color: #888; margin-bottom: 2px; }
        .modal-info-value { font-size: 0.9rem; font-weight: 500; color: #333; margin-bottom: 10px; }
        .btn-close-modal { background-color: #58007e; color: white; width: 100%; border-radius: 50px; padding: 10px; font-weight: 600; border: none; margin-top: 15px; }
        
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
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Beranda</a></li>
                    <li class="nav-item"><a class="nav-link active" href="film.jsp">Film</a></li>
                    <li class="nav-item"><a class="nav-link" href="berita.jsp">Berita</a></li>
                </ul>

                <div class="search-bar me-3 d-none d-lg-block">
                    <form class="d-flex">
                        <input class="form-control search-input" type="search" placeholder="Cari film" aria-label="Search">
                        <i class="fas fa-search search-icon"></i>
                    </form>
                </div>

                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <img src="https://ui-avatars.com/api/?name=<%= akun.getUsername() %>&background=random" class="rounded-circle me-2" width="32" height="32">
                            <span><%= akun.getUsername() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="profile.jsp">Profile Saya</a></li>
                            <li><a class="dropdown-item" href="favorite.jsp">Favorit</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="../logout">Keluar</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mb-5 mt-4">
        <h2 class="fw-bold mb-4" style="color: #58007e; border-bottom: 3px solid #58007e; display: inline-block; padding-bottom: 5px;">
            Daftar Semua Film
        </h2>
        
        <div class="row">
            <% 
                if (listFilm != null && !listFilm.isEmpty()) {
                    for(Film f : listFilm) { 
                        String modalId = "modalFilm" + f.getIdFilm();
                        boolean isLiked = favService.isFavorite(akun.getIdAkun(), f.getIdFilm());
            %>
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <a href="#" class="movie-link" data-bs-toggle="modal" data-bs-target="#<%= modalId %>">
                    <div class="movie-card">
                        <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/150x225?text=No+Poster" : request.getContextPath() + "/uploads/posters/" + f.getPosterUrl() %>" 
                             class="movie-poster" alt="<%= f.getJudul() %>">
                        <div class="card-body-custom">
                            <div class="movie-title"><%= f.getJudul() %></div>
                            <div class="movie-meta"><i class="far fa-folder-open me-1"></i> <%= f.getNamaGenre() %></div>
                            <div class="movie-meta"><i class="far fa-calendar-alt me-1"></i> <%= f.getTahunRilis() %></div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content modal-content-custom">
                        <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/600x300?text=No+Image" : request.getContextPath() + "/uploads/posters/" + f.getPosterUrl() %>" class="modal-poster-top">
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
                                        <i class="fas fa-star text-warning"></i> 
                                        <span style="font-weight:700; color:#58007e;"><%= f.getRating() %></span>/10
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="modal-info-label">Cast</div>
                                <div class="modal-info-value"><%= f.getCastFilm() %></div>
                            </div>
                            <div class="mb-3">
                                <div class="modal-info-label">Deskripsi</div>
                                <p style="font-size: 0.9rem; color: #555; text-align: justify;"><%= f.getDeskripsi() %></p>
                            </div>
                            
                            <button type="button" class="btn-close-modal" data-bs-dismiss="modal">Tutup</button>
                            
                            <div class="mt-2 text-center">
                                <button type="button" onclick="toggleFavorite(<%= f.getIdFilm() %>)" id="btn-fav-<%= f.getIdFilm() %>"
                                        class="btn btn-sm btn-link text-decoration-none" style="color: <%= isLiked ? "#dc3545" : "#58007e" %>; font-weight: 600;">
                                    <i class="<%= isLiked ? "fas" : "far" %> fa-heart me-1" id="icon-fav-<%= f.getIdFilm() %>"></i> 
                                    <span id="text-fav-<%= f.getIdFilm() %>"><%= isLiked ? "Hapus dari Favorit" : "Tambah ke Favorit" %></span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                    } 
                } else { 
            %>
                <div class="col-12 text-center my-5"><p class="text-muted">Tidak ada film ditemukan.</p></div>
            <% } %>
            
            <!-- NO SEARCH RESULTS -->
            <div id="no-search-results" class="col-12 text-center my-5" style="display: none;">
                <i class="fas fa-search fa-3x text-muted mb-3 opacity-50"></i>
                <p class="text-muted">Pencarian tidak ditemukan.</p>
            </div>
        </div>
    </div>

    <footer>
        <div class="container text-center">
            <div class="copyright">&copy; 2025 movINFO Group PBO. All Rights Reserved.</div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function toggleFavorite(filmId) {
            var btn = document.getElementById("btn-fav-" + filmId);
            var icon = document.getElementById("icon-fav-" + filmId);
            var text = document.getElementById("text-fav-" + filmId);

            fetch('<%= request.getContextPath() %>/favorite', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'idFilm=' + filmId 
            })
            .then(response => response.text())
            .then(data => {
                if (data && data.trim() === "ADDED") {
                    icon.classList.remove("far"); icon.classList.add("fas");
                    btn.style.color = "#dc3545"; text.innerText = "Hapus dari Favorit";
                } else if (data && data.trim() === "REMOVED") {
                    icon.classList.remove("fas"); icon.classList.add("far");
                    btn.style.color = "#58007e"; text.innerText = "Tambah ke Favorit";
                }
            });
        }

        // SEARCH FUNCTIONALITY
        document.addEventListener("DOMContentLoaded", function() {
            const searchInput = document.querySelector('.search-input');
            if (searchInput) {
                searchInput.addEventListener('keyup', function(e) {
                    const term = e.target.value.toLowerCase().trim();
                    
                    const movieCards = document.querySelectorAll('.movie-card');
                    let hasVisible = false;
                    
                    movieCards.forEach(card => {
                        const title = card.querySelector('.movie-title').textContent.toLowerCase();
                        const column = card.closest('.col-lg-3, .col-md-4, .col-sm-6'); // Match the column classes in film.jsp
                        
                        if (title.includes(term)) {
                            column.style.display = "";
                            hasVisible = true;
                        } else {
                            column.style.display = "none";
                        }
                    });
                    
                    // Toggle No Results Message
                    const noResult = document.getElementById('no-search-results');
                    if (noResult) {
                        if (!hasVisible && movieCards.length > 0) {
                            noResult.style.display = 'block';
                        } else {
                            noResult.style.display = 'none';
                        }
                    }
                });
                
                // Prevent form submission
                const form = searchInput.closest('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        e.preventDefault();
                    });
                }
            }
        });
    </script>
</body>
</html>