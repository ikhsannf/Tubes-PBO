<%@ page import="java.util.List" %>
<%@ page import="model.Film" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Data Film | movInfo</title>
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

        .container {
             display: flex;
        min-height: 100vh;
        background: linear-gradient(135deg, #f0f2f8 0%, #e6e9f0 100%);
        }

        /* Sidebar Enhancement */
        .sidebar {
            width: 260px;
           margin-right: 2rem;
        }
        .content {
            margin: 10px;
            
            background: transparent;
            flex: 1;
        padding: 0; /* Hapus padding jika ada */
        overflow-x: auto; /* Prevent horizontal scroll */
        }

        .content-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

       

        
        .content-header h3 {
            color: #4B0082;
            font-size: 26px;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
        }

        .content-header h3::before {
            content: "🎬";
            margin-right: 12px;
            font-size: 28px;
        }

        /* Modern Button */
        .btn-add {
            background: linear-gradient(135deg, #4B0082 0%, #6a0dad 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            box-shadow: 0 4px 15px rgba(75, 0, 130, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add:hover {
            background: linear-gradient(135deg, #3a0063 0%, #5a0c9d 100%);
            box-shadow: 0 6px 20px rgba(75, 0, 130, 0.4);
            transform: translateY(-2px);
        }

        .btn-add:active {
            transform: translateY(0);
            box-shadow: 0 2px 10px rgba(75, 0, 130, 0.3);
        }

        /* Table Modern Design */
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th {
            background: linear-gradient(to bottom, #f8f9fc 0%, #eef2f7 100%);
            color: #4B0082;
            font-weight: 600;
            font-size: 15px;
            padding: 18px 20px;
            text-align: left;
            border-bottom: 2px solid #e1e5eb;
        }

        td {
            padding: 16px 20px;
            border-bottom: 1px solid #eef2f7;
            color: #52526c;
            font-size: 14px;
        }

        tbody tr {
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(75, 0, 130, 0.04);
            transform: scale(1.01);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #a0a0b8;
            font-style: italic;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .action-link:first-child {
            background: rgba(75, 0, 130, 0.1);
            color: #4B0082;
        }

        .action-link:first-child:hover {
            background: #4B0082;
            color: white;
            transform: translateY(-1px);
        }

        .action-link:last-child {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
        }

        .action-link:last-child:hover {
            background: #dc3545;
            color: white;
            transform: translateY(-1px);
        }
        
        .form-group input,
.form-group textarea,
.form-group select { /* Tambahkan select di sini */
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #e1e5eb;
    border-radius: 8px;
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    background: #f8f9fc;
}

        /* Modal Enhancement */
        /* Container Overlay Modal */
.modal {
    display: none; 
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    
    /* Tambahkan Flexbox agar konten di tengah */
    display: none; /* Akan diubah jadi flex via JS */
    align-items: center; /* Vertikal tengah */
    justify-content: center; /* Horisontal tengah */
    padding: 20px; /* Jarak aman di layar kecil */
    animation: fadeIn 0.3s ease;
}

/* Konten Box Modal */
.modal-content {
    background: white;
    padding: 0;
    /* Hapus margin: 5% auto; karena sudah pakai flex center */
    margin: 0; 
    width: 100%;
    max-width: 500px;
    /* Maksimal tinggi agar tidak melebihi layar jika form panjang */
    max-height: 90vh; 
    overflow-y: auto; 
    border-radius: 12px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    animation: slideUp 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    position: relative;
}

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        

        @keyframes slideUp {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            background: linear-gradient(135deg, #4B0082 0%, #6a0dad 100%);
            color: white;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }

        .close {
            font-size: 28px;
            color: white;
            cursor: pointer;
            font-weight: 300;
            transition: transform 0.2s ease;
        }

        .close:hover {
            transform: rotate(90deg);
            color: #ffcc00;
        }

        .modal-body {
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4B0082;
            font-size: 14px;
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

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid #eef2f7;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-cancel {
            background: #e1e5eb;
            color: #5e6278;
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-cancel:hover {
            background: #d1d6e0;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="sidebar">
        <%@ include file="../sidebar.jsp" %>
    </div>

    <div class="content">
        <div class="content-header">
            <h3>Daftar Film</h3>
            <button class="btn-add" onclick="openModal()">
                <i class="fas fa-plus-circle"></i> Tambah Film
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th>Judul Film</th>
                        <th style="width: 120px;">Tahun Rilis</th>
                        <th style="width: 120px">Genre</th>
                        <th style="width: 150px;">Aksi</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Film> films = (List<Film>) request.getAttribute("list");
                        if (films != null && !films.isEmpty()) {
                            for (Film film : films) {
                    %>
                        <tr>
                            <td><strong><%= film.getIdFilm() %></strong></td>
                            <td><%= film.getJudul() %></td>
                            <td><%= film.getTahunRilis() %></td>
                            <td><%= film.getNamaGenre() %></td>
                            
                            
                            
                            <td>
                                <div class="action-buttons">
                                    <a href="<%= request.getContextPath() %>/film?action=edit&id=<%= film.getIdFilm() %>" 
                                       class="action-link">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <form action="<%= request.getContextPath() %>/film" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="<%= film.getIdFilm() %>" />
                                        <button type="submit" onclick="return confirm('Hapus film ini?')" 
                                                class="action-link">
                                            <i class="fas fa-trash-alt"></i> Hapus
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% }} else { %>
                        <tr>
                            <td colspan="4" class="empty-state">
                                <i class="fas fa-film" style="font-size: 40px; margin-bottom: 10px;"></i>
                                <p>Belum ada film yang ditambahkan.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Add Film -->
<div id="modalAdd" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Tambah Film Baru</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form action="<%= request.getContextPath() %>/film" method="post" id="addFilmForm">
                <input type="hidden" name="action" value="insert" />
                
                <div class="form-group">
                    <label>Judul Film</label>
                    <input type="text" name="judul" placeholder="Masukkan judul film..." required />
                </div>
                
                <div class="form-group">
                    <label>Deskripsi Singkat</label>
                    <textarea name="deskripsi" rows="3" placeholder="Tuliskan deskripsi film..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label>Tahun Rilis</label>
                    <input type="number" name="tahun" placeholder="Contoh: 2023" min="1900" max="2099" required />
                </div>
                
                <div class="form-group">
                    <label>Genre Film</label>
                    <select name="genre" required>
                        <option value="1">Action</option>
                        <option value="2">Drama</option>
                        <option value="3">Sci-Fi</option>
                        <option value="4">Adventure</option>
                        <option value="5">Thriller</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>URL Poster (Opsional)</label>
                    <input type="text" name="poster" placeholder="https://example.com/poster.jpg" />
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal()">Batal</button>
                    <button type="submit" class="btn-add">
                        <i class="fas fa-save"></i> Simpan Film
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById("modalAdd").style.display = "flex";
        document.body.style.overflow = 'hidden'; // Prevent scrolling
    }
    
    function closeModal() {
        document.getElementById("modalAdd").style.display = "none";
        document.body.style.overflow = 'auto';
        document.getElementById("addFilmForm").reset(); // Reset form
    }
    
    window.onclick = function(event) {
        if (event.target === document.getElementById("modalAdd")) {
            closeModal();
        }
    };
    
    // Close modal on Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });
</script>

</body>
</html>