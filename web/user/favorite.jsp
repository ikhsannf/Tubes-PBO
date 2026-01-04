<%@page import="model.Akun"%>
<%@page import="model.Film"%>
<%@page import="service.FavoriteService"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Cek User Login
    Akun user = (Akun) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // 2. Ambil data REAL dari Database via Service (Sudah return List<Film>)
    FavoriteService favService = new FavoriteService();
    List<Film> listFilmFavorit = favService.getByUser(user.getIdAkun());
%>

<!DOCTYPE html>
<html>
<head>
    <title>movINFO - Favorite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Poppins', sans-serif; }
        .navbar-custom { background-color: #58007e; padding: 15px 0; color: white; }
        .fav-card { 
            background: white; border-radius: 15px; padding: 20px; 
            margin-bottom: 20px; display: flex; align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .fav-poster { width: 120px; height: 160px; object-fit: cover; border-radius: 10px; margin-right: 25px; }
        .movie-title { font-weight: 700; font-size: 1.8rem; margin: 0; }
        .rating-text { color: #ffc107; font-size: 0.9rem; margin-bottom: 10px; }
        .info-label { font-weight: 400; color: #555; min-width: 60px; display: inline-block; }
        
        /* Tombol Un-like agar bisa diklik */
        .btn-unlike {
            background: none; border: none; padding: 0;
            color: #58007e; font-size: 2.5rem; margin-left: auto; cursor: pointer;
            transition: 0.3s;
        }
        .btn-unlike:hover { color: #dc3545; transform: scale(1.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-custom mb-5 shadow-sm">
        <div class="container d-flex justify-content-between">
            <a href="dashboard.jsp" class="text-white text-decoration-none fs-3 fw-bold">movINFO</a>
            <a href="dashboard.jsp" class="text-white text-decoration-none"><i class="fas fa-arrow-left"></i> Kembali</a>
        </div>
    </nav>

    <div class="container" style="max-width: 900px;">
        <h2 style="color: #58007e; font-weight: 700;">Daftar Favorit</h2>
        <h4 class="mb-4 text-muted">Film yang Anda simpan</h4>

        <% 
            // PERBAIKAN: Gunakan variable 'listFilmFavorit'
            if (listFilmFavorit != null && !listFilmFavorit.isEmpty()) {
                // Loop langsung ke object Film (karena Service sudah nge-JOIN)
                for (Film f : listFilmFavorit) {
        %>
        
        <div class="fav-card" id="card-<%= f.getIdFilm() %>">
            <img src="<%= (f.getPosterUrl() == null || f.getPosterUrl().isEmpty()) ? "https://via.placeholder.com/150x225?text=No+Poster" : request.getContextPath() + "/uploads/posters/" + f.getPosterUrl() %>" class="fav-poster" alt="Poster">
            
            <div>
                <h3 class="movie-title"><%= f.getJudul() %></h3>
                
                <div class="rating-text">
                    <i class="fas fa-star"></i> <%= f.getRating() %> / 10
                </div>
                
                <p class="mb-1"><span class="info-label">Genre</span> : <%= f.getGenre() %></p>
                <p class="mb-1"><span class="info-label">Cast</span> : 
                    <%= (f.getCastFilm() == null || f.getCastFilm().isEmpty() || f.getCastFilm().equals("-")) 
                        ? "Belum tersedia" 
                        : f.getCastFilm() %>
                </p>
            </div>

            <button type="button" class="btn-unlike" title="Hapus dari Favorit" onclick="unlikeFilm(<%= f.getIdFilm() %>)">
                <i class="fas fa-heart"></i>
            </button>
        </div>

        <% 
                } // End For Loop
            } else { 
        %>
        
        <div class="text-center mt-5 text-muted py-5">
            <i class="far fa-folder-open fa-3x mb-3"></i>
            <p class="fs-5">Belum ada film favorit.</p>
            <a href="dashboard.jsp" class="btn btn-primary" style="background:#58007e; border:none;">Cari Film Sekarang</a>
        </div>
        
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function unlikeFilm(filmId) {
            if(!confirm("Hapus film ini dari favorit?")) return;

            fetch('<%= request.getContextPath() %>/favorite', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'idFilm=' + filmId 
            })
            .then(response => {
                if (response.status === 401) {
                    alert("Sesi habis. Silakan login kembali.");
                    window.location.href = "../login.jsp";
                    return;
                }
                return response.text(); 
            })
            .then(data => {
                if (data && data.trim() === "REMOVED") {
                    const card = document.getElementById("card-" + filmId);
                    if (card) {
                        card.style.transition = "all 0.5s ease";
                        card.style.opacity = "0";
                        card.style.transform = "translateX(100px)";
                        setTimeout(() => {
                            card.remove();
                            // Jika tidak ada kartu tersisa, reload agar muncul pesan "Belum ada film"
                            if (document.querySelectorAll('.fav-card').length === 0) {
                                location.reload();
                            }
                        }, 500);
                    }
                } else {
                    alert("Gagal menghapus data. Silakan coba lagi.");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("Terjadi kesalahan koneksi.");
            });
        }
    </script>
</body>
</html>