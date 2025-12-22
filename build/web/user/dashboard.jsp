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
        <title>movINFO - Home</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
            .navbar-custom { background-color: #58007e; padding: 15px 0; }
            .navbar-brand { font-weight: 700; font-size: 24px; color: white !important; }
            .search-bar { width: 100%; max-width: 500px; position: relative; }
            .search-input { border-radius: 20px; padding-right: 40px; border: none; }
            .search-icon { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888; }
            .nav-link { color: white !important; margin-left: 15px; font-weight: 500; }
            .user-badge { background-color: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 5px; }

            .hero-section { position: relative; margin-top: 20px; border-radius: 15px; overflow: hidden; color: white; }
            .hero-img { width: 100%; height: 400px; object-fit: cover; filter: brightness(0.7); }
            .hero-text { position: absolute; bottom: 40px; left: 40px; z-index: 2; max-width: 600px; }
            .hero-text h2 { font-weight: 700; text-shadow: 2px 2px 4px rgba(0,0,0,0.7); }
            
            .section-title { color: #58007e; font-weight: 700; margin-top: 40px; margin-bottom: 10px; }
            .section-subtitle { color: #6c757d; margin-bottom: 20px; font-size: 0.9rem; }

            .movie-card { background: white; border: none; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; overflow: hidden; transition: transform 0.2s; height: 180px; }
            .movie-card:hover { transform: translateY(-5px); }
            .movie-poster { width: 130px; height: 100%; object-fit: cover; }
            .card-body-custom { padding: 12px; overflow: hidden; display: flex; flex-direction: column; justify-content: center; }
            .movie-title { font-weight: 700; font-size: 1rem; margin-bottom: 2px; color: #333; }
            .movie-meta { font-size: 0.7rem; color: #666; margin-bottom: 2px; }
            .rating-stars { color: #ffc107; font-size: 0.7rem; margin-bottom: 5px; }
            .movie-desc { font-size: 0.75rem; color: #555; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.3; }

            .news-card { border: none; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; height: 100%; }
            .news-img { width: 100%; height: 180px; object-fit: cover; }
            .news-body { padding: 15px; background: white; }
            .news-title { font-weight: 700; font-size: 1rem; margin-bottom: 10px; line-height: 1.4; }
            .news-date { font-size: 0.75rem; color: #8844ff; font-weight: 600; margin-bottom: 8px; }
            .news-snippet { font-size: 0.8rem; color: #666; }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">movINFO</a>
                <div class="collapse navbar-collapse" id="navbarContent">
                    <div class="mx-auto search-bar">
                        <form class="d-flex">
                            <input class="form-control search-input" type="search" placeholder="Cari berita film anda..." aria-label="Search">
                            <i class="fas fa-search search-icon"></i>
                        </form>
                    </div>
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link" href="#">Beranda</a></li>
                        <li class="nav-item"><a class="nav-link" href="film">Admin Panel</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="hero-section">
                <img src="https://images.unsplash.com/photo-1478720568477-152d9b164e63?q=80&w=1920&auto=format&fit=crop" class="hero-img" alt="Hero Banner">
                <div class="hero-text">
                    <h3>Setelah 3 Musim Serial,</h3>
                    <h2>The Summer I Turned Pretty Resmi Dibuat Versi Film</h2>
                </div>
            </div>

            <h3 class="section-title">Film Terbaru</h3>
            <p class="section-subtitle">Kumpulan film terbaik terpopuler saat ini</p>

            <div class="row">
                <% 
                    if (listFilm != null && !listFilm.isEmpty()) {
                        for(Film f : listFilm) { 
                %>
                <div class="col-lg-4 col-md-6">
                    <div class="movie-card d-flex">
                        <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/150x225?text=No+Poster" : f.getPosterUrl() %>" 
                             class="movie-poster" alt="<%= f.getJudul() %>">
                        
                        <div class="card-body-custom">
                            <div class="movie-title"><%= f.getJudul() %></div>
                            
                            <div class="movie-meta">Genre : <%= f.getNamaGenre() %></div>
                            <div class="movie-meta">Tahun : <%= f.getTahunRilis() %></div>
                            
                           
                            
                            <div class="movie-desc">
                                <%= f.getDeskripsi() %>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                        } 
                    } else { 
                %>
                    <div class="col-12 text-center my-5">
                        <p class="text-muted">Belum ada data film tersedia.</p>
                    </div>
                <% } %>
            </div>

            <h3 class="section-title">Berita Film Terkini</h3>
            <p class="section-subtitle">Berita terbaru di dunia perfilman</p>
            <div class="row mb-5">
                <% for(int j=0; j<4; j++) { %>
                <div class="col-lg-3 col-md-6">
                    <div class="news-card">
                        <img src="https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=800&auto=format&fit=crop" class="news-img" alt="News">
                        <div class="news-body">
                            <div class="news-title">Marvel Studios Umumkan Lineup Film Terbaru untuk 2025</div>
                            <div class="news-date">BERITA STUDIO</div>
                            <div class="news-snippet">Marvel Studios akhirnya mengumumkan fase baru dari MCU dengan deretan judul yang sangat dinanti...</div>
                            <div class="mt-2 text-muted" style="font-size: 0.7rem;">25 Oktober 2025</div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div> 
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>