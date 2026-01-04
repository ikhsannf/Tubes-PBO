<%@page import="model.Akun"%>
<%@page import="java.util.List"%>
<%@page import="model.Berita"%>
<%@page import="service.BeritaService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Cek Login (Security)
    Akun akun = (Akun) session.getAttribute("user");
    if (akun == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // 2. Ambil Data Berita dari Database (Dinamis)
    BeritaService beritaService = new BeritaService();
    List<Berita> listBerita = beritaService.getAll();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Berita & Artikel - movINFO</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* Menggunakan Style yang sama persis dengan Dashboard agar konsisten */
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
        
        /* News Card Styles */
        .news-link { text-decoration: none; color: inherit; display: block; height: 100%; }
        .news-card { border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 25px; height: 100%; transition: 0.3s; background: white; display: flex; flex-direction: column; }
        .news-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .news-img { width: 100%; height: 200px; object-fit: cover; }
        .news-body { padding: 20px; flex-grow: 1; display: flex; flex-direction: column; }
        .news-badge { background: #e0ccff; color: #58007e; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; margin-bottom: 10px; display: inline-block; width: fit-content; }
        .news-title { font-weight: 700; font-size: 1.1rem; margin-bottom: 10px; line-height: 1.4; color: #333; }
        .news-snippet { font-size: 0.85rem; color: #666; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 15px; }
        
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
                    <li class="nav-item"><a class="nav-link" href="film.jsp">Film</a></li>
                    <li class="nav-item"><a class="nav-link active" href="berita.jsp">Berita</a></li>
                </ul>

                <div class="search-bar me-3 d-none d-lg-block">
                    <form class="d-flex">
                        <input class="form-control search-input" type="search" placeholder="Cari berita" aria-label="Search">
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
            Berita & Artikel Terbaru
        </h2>

        <div class="row">
            <% 
                // Cek apakah listBerita ada isinya
                if (listBerita != null && !listBerita.isEmpty()) {
                    // LOOPING DATA DARI DATABASE (Bukan Hardcode lagi)
                    for(Berita b : listBerita) { 
            %>
            <div class="col-lg-3 col-md-6 mb-4">
                <a href="detail_berita.jsp?id=<%= b.getIdBerita() %>" class="news-link">
                    <div class="news-card">
                        <img src="<%= (b.getGambarUrl() == null || b.getGambarUrl().isEmpty()) ? "https://via.placeholder.com/800x450?text=No+Image" : request.getContextPath() + "/uploads/berita/" + b.getGambarUrl() %>" 
                             class="news-img" alt="<%= b.getJudul() %>">
                        
                        <div class="news-body">
                            <span class="news-badge">Info Film</span>
                            
                            <div class="news-title"><%= b.getJudul() %></div>
                            
                            <div class="news-snippet">
                                <% 
                                    // Logika memotong teks agar tidak kepanjangan di card
                                    String isi = b.getIsi();
                                    if (isi != null && isi.length() > 100) {
                                        out.print(isi.substring(0, 100) + "...");
                                    } else {
                                        out.print(isi != null ? isi : "");
                                    }
                                %>
                            </div>
                            
                            <div class="mt-auto text-muted d-flex align-items-center" style="font-size: 0.75rem;">
                                <i class="far fa-clock me-1"></i> <%= b.getTanggal() %>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
            <% 
                    } // Tutup Loop
                } else { 
            %>
                <div class="col-12 text-center my-5">
                    <i class="far fa-newspaper fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Belum ada berita terkini.</p>
                </div>
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
        // SEARCH FUNCTIONALITY
        document.addEventListener("DOMContentLoaded", function() {
            const searchInput = document.querySelector('.search-input');
            if (searchInput) {
                searchInput.addEventListener('keyup', function(e) {
                    const term = e.target.value.toLowerCase().trim();
                    
                    const newsCards = document.querySelectorAll('.news-card');
                    let hasVisible = false;
                    
                    newsCards.forEach(card => {
                        const title = card.querySelector('.news-title').textContent.toLowerCase();
                        const column = card.closest('.col-lg-3, .col-md-6'); // Match the column classes in berita.jsp
                        
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
                        if (!hasVisible && newsCards.length > 0) {
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