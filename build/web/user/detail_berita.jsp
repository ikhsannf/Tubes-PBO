<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Berita"%>
<%@page import="model.Akun"%>
<%@page import="model.LikeBerita"%>
<%@page import="service.BeritaService"%>
<%@page import="service.LikeBeritaService"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String idStr = request.getParameter("id");
    Berita berita = null;
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
    
    // Variabel untuk fitur Like
    int totalLikes = 0;
    boolean isLikedByCurrentUser = false;

    if(idStr != null && !idStr.isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            
            // 1. Ambil Data Berita
            BeritaService service = new BeritaService();
            berita = service.getById(id);
            
            // 2. Ambil Data Like
            LikeBeritaService likeService = new LikeBeritaService();
            List<LikeBerita> likeList = likeService.getLikesByBerita(id);
            totalLikes = likeList.size(); // Hitung total like

            // 3. Cek apakah user login sudah like
            Akun currentUser = (Akun) session.getAttribute("user");
            if (currentUser != null) {
                for (LikeBerita lb : likeList) {
                    if (lb.getIdAkun() == currentUser.getIdAkun()) {
                        isLikedByCurrentUser = true;
                        break;
                    }
                }
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    if(berita == null) {
        response.sendRedirect("dashboard.jsp"); 
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= berita.getJudul() %> - movINFO</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
            .navbar-custom { background-color: #58007e; padding: 15px 0; }
            .navbar-brand { font-weight: 700; font-size: 24px; color: white !important; }
            .nav-link { color: white !important; margin-left: 15px; font-weight: 500; }
            
            .detail-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.05);
                padding: 40px;
                margin-top: 30px;
                margin-bottom: 50px;
            }
            
            .news-header { border-bottom: 2px solid #f0f0f0; padding-bottom: 20px; margin-bottom: 30px; }
            .news-title { font-weight: 800; color: #333; margin-bottom: 15px; }
            .news-meta { color: #6c757d; font-size: 0.9rem; display: flex; align-items: center; gap: 20px; }
            .news-meta i { color: #58007e; margin-right: 5px; }

            .news-image-hero { width: 100%; height: 400px; object-fit: cover; border-radius: 10px; margin-bottom: 30px; }
            .news-content { font-size: 1.1rem; line-height: 1.8; color: #444; text-align: justify; }

            .like-section { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; display: flex; align-items: center; justify-content: space-between; }
            
            /* Button Style */
            .btn-like {
                border: 2px solid #dc3545;
                background: white;
                color: #dc3545;
                padding: 8px 20px;
                border-radius: 50px;
                font-weight: 600;
                transition: 0.3s;
                display: flex; align-items: center; gap: 8px;
            }
            .btn-like:hover { background-color: #f8d7da; }
            
            /* Style Active (Liked) */
            .btn-like.liked {
                background-color: #dc3545;
                color: white;
            }
            
            .like-count { font-size: 1rem; color: #555; font-weight: 600; margin-left: 10px; }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container">
                <a class="navbar-brand" href="dashboard.jsp">movINFO</a>
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Beranda</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="detail-container">
                
                <div class="news-header">
                    <h1 class="news-title"><%= berita.getJudul() %></h1>
                    <div class="news-meta">
                        <span><i class="fas fa-calendar-alt"></i> <%= sdf.format(berita.getTanggal()) %></span>
                        <span><i class="fas fa-user-edit"></i> <%= berita.getPenulis() %></span>
                    </div>
                </div>

                <img src="<%= (berita.getGambarUrl() == null || berita.getGambarUrl().isEmpty()) ? "https://via.placeholder.com/1200x600?text=No+Image" : request.getContextPath() + "/uploads/berita/" + berita.getGambarUrl() %>" 
                     class="news-image-hero" alt="<%= berita.getJudul() %>">

                <div class="news-content">
                    <%= berita.getIsi().replace("\n", "<br>") %>
                </div>

                <div class="like-section">
                    <div class="d-flex align-items-center gap-2">
                        <% if(session.getAttribute("user") != null) { %>
                            <button type="button" 
                                    id="btn-like"
                                    onclick="toggleLike(<%= berita.getIdBerita() %>)"
                                    class="btn btn-like <%= isLikedByCurrentUser ? "liked" : "" %>">
                                <i class="<%= isLikedByCurrentUser ? "fas" : "far" %> fa-heart" id="icon-like"></i>
                                <span id="text-like"><%= isLikedByCurrentUser ? "Disukai" : "Suka" %></span>
                            </button>
                        <% } else { %>
                            <a href="login.jsp" class="btn btn-like">
                                <i class="far fa-heart"></i> Suka
                            </a>
                        <% } %>
                        
                        <span class="like-count" id="count-like">
                            <%= totalLikes %> Likes
                        </span>
                    </div>

                    <a href="dashboard.jsp" class="text-decoration-none text-muted">
                        <i class="fas fa-arrow-left"></i> Kembali
                    </a>
                </div>

            </div>
        </div> 

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function toggleLike(beritaId) {
                fetch('<%= request.getContextPath() %>/like', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'beritaId=' + beritaId
                })
                .then(response => {
                    if (response.redirected) {
                         window.location.href = response.url;
                         return;
                    }
                    return response.text();
                })
                .then(data => {
                    // Expected format: "STATUS:COUNT" e.g. "LIKED:5"
                    if (data && data.includes(":")) {
                        const parts = data.split(":");
                        const status = parts[0];
                        const count = parts[1];

                        const btn = document.getElementById("btn-like");
                        const icon = document.getElementById("icon-like");
                        const text = document.getElementById("text-like");
                        const countSpan = document.getElementById("count-like");

                        // Update Count
                        countSpan.innerText = count + " Likes";

                        // Update Button UI
                        if (status === "LIKED") {
                            btn.classList.add("liked");
                            icon.classList.remove("far");
                            icon.classList.add("fas");
                            text.innerText = "Disukai";
                        } else {
                            btn.classList.remove("liked");
                            icon.classList.remove("fas");
                            icon.classList.add("far");
                            text.innerText = "Suka";
                        }
                    } else {
                         // Fallback if session expired or other error (handled by redirect check usually)
                         console.error("Invalid response:", data);
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        </script>
    </body>
</html>