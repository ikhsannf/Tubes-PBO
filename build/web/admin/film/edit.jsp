<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Film" %>

<%
    // Ambil data film dari request attribute
    Film film = (Film) request.getAttribute("film");
    if (film == null) {
        response.sendRedirect(request.getContextPath() + "/film");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Edit Film | movInfo</title>
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
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-title h2 {
            color: #4B0082;
            font-size: 26px;
            font-weight: 600;
            margin: 0;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            background: rgba(75, 0, 130, 0.1);
            color: #4B0082;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #4B0082;
            color: white;
            transform: translateX(-5px);
        }

        /* Form Card */
        .form-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            max-width: 700px;
            margin: 0 auto;
        }

        .form-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f2f8;
        }

        .form-header h3 {
            color: #4B0082;
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4B0082;
            font-size: 14px;
        }
        .form-group input,
        .form-group textarea,
        .form-group select { 
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5eb;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            background: #f8f9fc;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5eb;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fc;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4B0082;
            box-shadow: 0 0 0 3px rgba(75, 0, 130, 0.15);
            background: white;
        }

        .form-group input[type="number"] {
            width: 200px;
        }

        /* Button */
        .btn-container {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .btn-update {
            background: linear-gradient(135deg, #4B0082 0%, #6a0dad 100%);
            color: white;
            padding: 12px 28px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            box-shadow: 0 4px 15px rgba(75, 0, 130, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-update:hover {
            background: linear-gradient(135deg, #3a0063 0%, #5a0c9d 100%);
            box-shadow: 0 6px 20px rgba(75, 0, 130, 0.4);
            transform: translateY(-2px);
        }

        .btn-update:active {
            transform: translateY(0);
            box-shadow: 0 2px 10px rgba(75, 0, 130, 0.3);
        }

        .btn-cancel {
            background: #e1e5eb;
            color: #5e6278;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-cancel:hover {
            background: #d1d6e0;
            transform: translateY(-1px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .sidebar-wrapper {
                width: 240px;
            }
        }
    </style>
</head>
<body>

<div class="app-container">
    <!-- Sidebar -->
    <div class="sidebar-wrapper">
        <%@ include file="../sidebar.jsp" %>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h2><i class="fas fa-edit"></i> Edit Film</h2>
            </div>
            <a href="<%= request.getContextPath() %>/film" class="back-btn">
                <i class="fas fa-arrow-left"></i> Kembali ke Daftar
            </a>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <div class="form-header">
                <h3><i class="fas fa-info-circle"></i> Informasi Film</h3>
            </div>

            <form action="<%= request.getContextPath() %>/film?action=update" method="post" id="editFilmForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="<%= film.getIdFilm() %>"/>

                <div class="form-group">
                    <label>Judul Film</label>
                    <input type="text" name="judul" value="<%= film.getJudul() %>" 
                           placeholder="Masukkan judul film..." required>
                </div>

                <div class="form-group">
                    <label>Deskripsi Film</label>
                    <textarea name="deskripsi" rows="4" 
                              placeholder="Tuliskan deskripsi film..." required><%= film.getDeskripsi() %></textarea>
                </div>

                <div class="form-group">
                    <label>Tahun Rilis</label>
                    <input type="number" name="tahun" value="<%= film.getTahunRilis() %>" 
                           placeholder="Contoh: 2023" min="1900" max="2099" required>
                </div>
                           
                <div class="form-group">
                    <label>Genre Film</label>
                    <select name="genre" required>
                        <option value="">-- Pilih Genre --</option>
                        <option value="1" <%= (film.getNamaGenre() != null && film.getNamaGenre().equals("Action")) ? "selected" : "" %>>Action</option>
                        <option value="2" <%= (film.getNamaGenre() != null && film.getNamaGenre().equals("Drama")) ? "selected" : "" %>>Drama</option>
                        <option value="3" <%= (film.getNamaGenre() != null && film.getNamaGenre().equals("Sci-Fi")) ? "selected" : "" %>>Sci-Fi</option>
                        <option value="4" <%= (film.getNamaGenre() != null && film.getNamaGenre().equals("Adventure")) ? "selected" : "" %>>Adventure</option>
                        <option value="5" <%= (film.getNamaGenre() != null && film.getNamaGenre().equals("Thriller")) ? "selected" : "" %>>Thriller</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Rating (0.0 - 10.0)</label>
                    <input type="number" name="rating" step="0.1" min="0" max="10" 
                           value="<%= film.getRating() %>" placeholder="Contoh: 8.5" required>
                </div>

                <div class="form-group">
                    <label>Cast / Pemeran</label>
                    <input type="text" name="cast" value="<%= film.getCastFilm() %>" 
                           placeholder="Aktor 1, Aktor 2, ..." required>
                </div>

                <div class="form-group">
                    <label>Upload Poster Baru (Opsional)</label>
                    <input type="file" name="poster" accept="image/*">
                    <% if (film.getPosterUrl() != null && !film.getPosterUrl().isEmpty()) { %>
                        <div class="mt-2">
                            <small>Poster Saat Ini:</small><br>
                            <img src="<%= request.getContextPath() %>/uploads/posters/<%= film.getPosterUrl() %>" alt="Current Poster" style="max-width: 150px; border-radius: 8px; margin-top: 5px;">
                        </div>
                    <% } %>
                </div>

                <div class="btn-container">
                    <a href="<%= request.getContextPath() %>/film" class="btn-cancel">
                        <i class="fas fa-times"></i> Batal
                    </a>
                    <button type="submit" class="btn-update">
                        <i class="fas fa-save"></i> Update Film
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tambahkan konfirmasi sebelum submit
    document.getElementById('editFilmForm').addEventListener('submit', function(e) {
        const judul = document.querySelector('input[name="judul"]').value;
        if (!confirm(`Simpan perubahan untuk film "${judul}"?`)) {
            e.preventDefault();
        }
    });

    // Auto-resize textarea
    const textarea = document.querySelector('textarea[name="deskripsi"]');
    textarea.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
    });
</script>

</body>
</html>