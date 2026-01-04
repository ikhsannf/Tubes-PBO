<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Berita" %>
<%@ page import="model.Akun" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Cek Session Login
    Akun userSession = (Akun) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect("../../login.jsp");
        return;
    }

    // Ambil data berita dari request attribute
    Berita berita = (Berita) request.getAttribute("berita");
    if (berita == null) {
        response.sendRedirect(request.getContextPath() + "/berita");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Edit Berita | movInfo</title>
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
            max-width: 800px; /* Lebar form agak lebih besar utk berita */
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
    <div class="sidebar-wrapper">
        <%@ include file="../sidebar.jsp" %>
    </div>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h2><i class="fas fa-edit"></i> Edit Berita</h2>
            </div>
            <a href="<%= request.getContextPath() %>/berita" class="back-btn">
                <i class="fas fa-arrow-left"></i> Kembali ke Daftar
            </a>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <div class="form-header">
                <h3><i class="fas fa-info-circle"></i> Informasi Berita</h3>
            </div>

            <form action="<%= request.getContextPath() %>/berita?action=update" method="post" id="editBeritaForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="<%= berita.getIdBerita() %>"/>

                <div class="form-group">
                    <label>Judul Berita</label>
                    <input type="text" name="judul" value="<%= berita.getJudul() %>" 
                           placeholder="Masukkan judul berita..." required>
                </div>

                <div class="form-group">
                    <label>Isi Berita</label>
                    <textarea name="isi" rows="10" 
                              placeholder="Tuliskan isi berita lengkap..." required><%= berita.getIsi() %></textarea>
                </div>

                <div class="form-group">
                    <label>Tanggal Publikasi</label>
                    <input type="date" name="tanggal" value="<%= berita.getTanggal() %>" required>
                </div>

                <div class="form-group">
                    <label>Penulis</label>
                    <input type="text" name="penulis" value="<%= berita.getPenulis() %>" 
                           placeholder="Nama penulis..." required>
                </div>

                <div class="form-group">
                    <label>Upload Gambar Baru (Opsional)</label>
                    <input type="file" name="gambar" accept="image/*">
                </div>

                <div class="btn-container">
                    <a href="<%= request.getContextPath() %>/berita" class="btn-cancel">
                        <i class="fas fa-times"></i> Batal
                    </a>
                    <button type="submit" class="btn-update">
                        <i class="fas fa-save"></i> Update Berita
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tambahkan konfirmasi sebelum submit
    document.getElementById('editBeritaForm').addEventListener('submit', function(e) {
        const judul = document.querySelector('input[name="judul"]').value;
        if (!confirm(`Simpan perubahan untuk berita "${judul}"?`)) {
            e.preventDefault();
        }
    });

    // Auto-resize textarea
    const textarea = document.querySelector('textarea[name="isi"]');
    textarea.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
    });
</script>

</body>
</html>