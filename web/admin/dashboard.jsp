<%@page import="service.FilmService"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Film" %>
<%@ page import="config.JDBC" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Dashboard Admin | movInfo</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f2f8 0%, #e6e9f0 100%);
            color: #333;
            min-height: 100vh;
        }

        .app-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar-wrapper {
            width: 260px;
            flex-shrink: 0;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-x: auto;
        }

        /* Page Header */
        .page-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }

        .page-header h2 {
            color: #4B0082;
            font-size: 26px;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header p {
            color: #777;
            margin: 8px 0 0 0;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-info h3 {
            font-size: 32px;
            color: #1e1e2d;
            margin: 0 0 5px 0;
        }

        .stat-info p {
            color: #777;
            margin: 0;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
        }

        .bg-blue { background: #eef5ff; color: #1a73e8; }
        .bg-purple { background: #f4edff; color: #7d3cff; }
        .bg-orange { background: #fff4e6; color: #ffa800; }

        /* Films Section */
        .section-title {
            font-size: 20px;
            color: #4B0082;
            font-weight: 600;
            margin: 40px 0 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .films-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .film-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            cursor: pointer;
        }

        .film-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .film-poster {
            width: 100%;
            height: 400px;
            object-fit: cover;
            display: block;
        }

        .film-content {
            padding: 20px;
        }

        .film-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e1e2d;
            margin: 0 0 8px 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .film-year {
            color: #777;
            font-size: 14px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .film-description {
            color: #52526c;
            font-size: 14px;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .film-genres {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 15px;
        }

        .genre-tag {
            background: rgba(75, 0, 130, 0.1);
            color: #4B0082;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }

        .film-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            border-top: 1px solid #f0f2f8;
            padding-top: 15px;
        }

        .stars {
            color: #ffc107;
            font-size: 14px;
        }

        .rating-value {
            font-weight: 600;
            color: #4B0082;
        }

        .rating-count {
            color: #777;
            font-size: 13px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar-wrapper {
                width: 240px;
            }
            .main-content {
                padding: 20px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .films-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }
        }
    </style>
</head>

<body>

<%
    // Hitung statistik dari DB
    int countUser = 0, countFilm = 0, countBerita = 0;
    
    JDBC db = new JDBC();
    db.connect();
    Connection con = db.getConnection();
    
    try {
        PreparedStatement pst1 = con.prepareStatement("SELECT COUNT(*) FROM akun");
        ResultSet rs1 = pst1.executeQuery();
        if (rs1.next()) countUser = rs1.getInt(1);

        PreparedStatement pst2 = con.prepareStatement("SELECT COUNT(*) FROM film");
        ResultSet rs2 = pst2.executeQuery();
        if (rs2.next()) countFilm = rs2.getInt(1);

        PreparedStatement pst3 = con.prepareStatement("SELECT COUNT(*) FROM berita");
        ResultSet rs3 = pst3.executeQuery();
        if (rs3.next()) countBerita = rs3.getInt(1);
    } catch (Exception e) {
        out.println("<!-- Error DB: " + e.getMessage() + " -->");
    } finally {
        try { if (con != null) con.close(); } catch (SQLException e) {}
    }
    
    // 2. Ambil list film dari attribute (lewat controller)
    List<Film> films = (List<Film>) request.getAttribute("list");
    
    // 3. FALLBACK: Jika null, ambil langsung dari service
    if (films == null) {
        FilmService service = new FilmService();
        films = service.getAll();
        // Ambil 8 terbaru
        films = films.subList(0, Math.min(films.size(), 8));
    }
%>

<div class="app-container">
    <!-- Sidebar -->
    <div class="sidebar-wrapper">
        <%@ include file="sidebar.jsp" %>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h2><i class="fas fa-tachometer-alt"></i> Dashboard Overview</h2>
            <p>Ringkasan data aplikasi movInfo hari ini.</p>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-info">
                    <h3><%= countUser %></h3>
                    <p>Total Pengguna</p>
                </div>
                <div class="stat-icon bg-blue">
                    <i class="fas fa-users"></i>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-info">
                    <h3><%= countFilm %></h3>
                    <p>Total Film</p>
                </div>
                <div class="stat-icon bg-purple">
                    <i class="fas fa-film"></i>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-info">
                    <h3><%= countBerita %></h3>
                    <p>Total Berita</p>
                </div>
                <div class="stat-icon bg-orange">
                    <i class="fas fa-newspaper"></i>
                </div>
            </div>
        </div>

        <!-- Films Section -->
        <h3 class="section-title">
            <i class="fas fa-star"></i> Film Terbaru
        </h3>
        
        <div class="films-grid">
            <%
                if (films == null || films.isEmpty()) {
            %>
                <div class="card" style="grid-column: 1/-1; text-align: center; padding: 40px; color: #777;">
                    <i class="fas fa-film" style="font-size: 50px; margin-bottom: 15px;"></i>
                    <p>Belum ada film yang ditambahkan.</p>
                </div>
            <%
                } else {
                    // Ambil 8 film terbaru (asumsi sudah diurutkan di service)
                    int limit = Math.min(films.size(), 8);
                    for (int i = 0; i < limit; i++) {
                        Film film = films.get(i);
            %>
                <div class="film-card" onclick="window.location.href='<%= request.getContextPath() %>/film?action=edit&id=<%= film.getIdFilm() %>'">
                    <%
                        String posterUrl = film.getPosterUrl();
                        if (posterUrl == null || posterUrl.trim().isEmpty()) {
                            posterUrl = "https://i.ibb.co/3sW5bM8/placeholder-poster.png";
                        } else {
                            posterUrl = request.getContextPath() + "/uploads/posters/" + posterUrl;
                        }
                    %>
                    <img src="<%= posterUrl %>" alt="<%= film.getJudul() %>" class="film-poster" 
                         onerror="this.src='https://i.ibb.co/3sW5bM8/placeholder-poster.png'">
                    
                    <div class="film-content">
                        <h4 class="film-title"><%= film.getJudul() %></h4>
                        <div class="film-year">
                            <i class="fas fa-calendar-alt"></i> <%= film.getTahunRilis() %>
                        </div>
                        
                        <p class="film-description"><%= film.getDeskripsi() %></p>
                        
                        <div class="film-genres">
                            <%
                                // Placeholder genre - nanti ganti dengan film.getGenres() jika ada
                                String genres = film.getNamaGenre();
                                
                            %>
                                <span class="genre-tag"><%= genres %></span>
                            <%
                                
                            %>
                        </div>
                        
                        <div class="film-rating">
                            <span class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </span>
                            <span class="rating-value">4.7</span>
                            <span class="rating-count">(2.1k)</span>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</div>

</body>
</html>