<%@ page import="java.util.List" %>
<%@ page import="model.Berita" %>
<%@ page import="model.Akun" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // 1. Proteksi Session Login
    Akun userSession = (Akun) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // 2. Ambil data pagination dari Request Attribute (dikirim oleh BeritaController)
    List<Berita> beritaList = (List<Berita>) request.getAttribute("list");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    
    // Fallback jika null agar tidak error
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Berita | movInfo</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f2f8 0%, #e6e9f0 100%);
            color: #333;
            min-height: 100vh;
        }
        .app-container { display: flex; min-height: 100vh; }
        .sidebar-wrapper { width: 260px; flex-shrink: 0; }
        .main-content { flex: 1; padding: 40px; overflow-x: auto; }
        
        .content-header {
            background: white; padding: 25px 30px; border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); margin-bottom: 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .content-header h3 { color: #4B0082; font-size: 26px; font-weight: 600; display: flex; align-items: center; }
        .content-header h3::before { content: "📰"; margin-right: 12px; font-size: 28px; }

        .btn-add {
            background: linear-gradient(135deg, #4B0082 0%, #6a0dad 100%);
            color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none;
            font-size: 14px; font-weight: 500; border: none; cursor: pointer;
            transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(75, 0, 130, 0.25);
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(75, 0, 130, 0.4); }

        .table-container { background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); overflow: hidden; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; }
        th { background: #f8f9fc; color: #4B0082; font-weight: 600; padding: 18px 20px; text-align: left; border-bottom: 2px solid #e1e5eb; }
        td { padding: 16px 20px; border-bottom: 1px solid #eef2f7; color: #52526c; font-size: 14px; }
        tbody tr:hover { background: rgba(75, 0, 130, 0.04); }

        /* Pagination Style */
        .pagination-wrapper { display: flex; justify-content: center; margin-top: 25px; gap: 8px; }
        .page-link {
            padding: 8px 16px; border-radius: 6px; background: white;
            color: #4B0082; text-decoration: none; font-size: 14px; font-weight: 500;
            transition: all 0.2s; border: 1px solid #e1e5eb;
        }
        .page-link:hover { background: #4B0082; color: white; }
        .page-link.active { background: #4B0082; color: white; border-color: #4B0082; }
        .page-link.disabled { background: #f1f1f1; color: #aaa; pointer-events: none; opacity: 0.6; }

        .action-buttons { display: flex; gap: 8px; }
        .action-link {
            padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px;
            font-weight: 500; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px;
        }
        .btn-edit { background: rgba(75, 0, 130, 0.1); color: #4B0082; }
        .btn-edit:hover { background: #4B0082; color: white; }
        .btn-delete { background: rgba(220, 53, 69, 0.1); color: #dc3545; border: none; cursor: pointer; }
        .btn-delete:hover { background: #dc3545; color: white; }

        /* Modal */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); align-items: center; justify-content: center; }
        .modal-content { background: white; width: 100%; max-width: 550px; border-radius: 12px; overflow: hidden; animation: slideUp 0.3s ease; }
        .modal-header { background: #4B0082; color: white; padding: 20px; display: flex; justify-content: space-between; align-items: center; }
        .modal-body { padding: 25px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 14px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-family: inherit; }
    </style>
</head>
<body>

<div class="app-container">
    <div class="sidebar-wrapper">
        <%@ include file="../sidebar.jsp" %>
    </div>

    <div class="main-content">
        <div class="content-header">
            <h3>Daftar Berita</h3>
            <button class="btn-add" onclick="openModal()">
                <i class="fas fa-plus-circle"></i> Tambah Berita
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 60px;">ID</th>
                        <th>Judul Berita</th>
                        <th>Tanggal</th>
                        <th>Penulis</th>
                        <th style="width: 180px;">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                        if (beritaList != null && !beritaList.isEmpty()) {
                            for (Berita b : beritaList) {
                    %>
                        <tr>
                            <td><strong>#<%= b.getIdBerita() %></strong></td>
                            <td style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                <%= b.getJudul() %>
                            </td>
                            <td><%= (b.getTanggal() != null) ? sdf.format(b.getTanggal()) : "-" %></td>
                            <td><i class="far fa-user"></i> <%= b.getPenulis() %></td>
                            <td>
                                <div class="action-buttons">
                                    <%-- Link Edit dengan membawa parameter page --%>
                                    <a href="berita?action=edit&id=<%= b.getIdBerita() %>&page=<%= currentPage %>" class="action-link btn-edit">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    
                                    <form action="berita" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="<%= b.getIdBerita() %>" />
                                        <%-- Input Hidden Page agar setelah hapus tetap di halaman yang sama --%>
                                        <input type="hidden" name="page" value="<%= currentPage %>" />
                                        <button type="submit" onclick="return confirm('Hapus berita ini?')" class="action-link btn-delete">
                                            <i class="fas fa-trash-alt"></i> Hapus
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <%      } 
                        } else { 
                    %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 50px; color: #999;">
                                <i class="fas fa-folder-open" style="font-size: 40px; display: block; margin-bottom: 10px;"></i>
                                Belum ada data berita.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <%-- Navigasi Pagination --%>
        <% if (totalPages > 1) { %>
        <div class="pagination-wrapper">
            <a href="berita?page=<%= currentPage - 1 %>" 
               class="page-link <%= (currentPage == 1) ? "disabled" : "" %>">
               <i class="fas fa-chevron-left"></i>
            </a>

            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="berita?page=<%= i %>" 
                   class="page-link <%= (currentPage == i) ? "active" : "" %>">
                   <%= i %>
                </a>
            <% } %>

            <a href="berita?page=<%= currentPage + 1 %>" 
               class="page-link <%= (currentPage == totalPages) ? "disabled" : "" %>">
               <i class="fas fa-chevron-right"></i>
            </a>
        </div>
        <% } %>
    </div>
</div>

<%-- Modal Tambah --%>
<div id="modalAdd" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Tambah Berita Baru</h3>
            <span style="cursor:pointer; font-size:24px" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form action="berita" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="insert" />
                <div class="form-group">
                    <label>Judul Berita</label>
                    <input type="text" name="judul" required />
                </div>
                <div class="form-group">
                    <label>Isi Berita</label>
                    <textarea name="isi" rows="5" required></textarea>
                </div>
                <div class="form-group">
                    <label>Tanggal</label>
                    <input type="date" name="tanggal" required />
                </div>
                <div class="form-group">
                    <label>Penulis</label>
                    <input type="text" name="penulis" required />
                </div>
                <div class="form-group">
                    <label>Gambar</label>
                    <input type="file" name="gambar" accept="image/*" />
                </div>
                <div style="text-align:right; margin-top:20px;">
                    <button type="button" onclick="closeModal()" style="padding:10px 20px; border:none; background:#eee; border-radius:6px; cursor:pointer; margin-right:10px;">Batal</button>
                    <button type="submit" class="btn-add">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openModal() { document.getElementById("modalAdd").style.display = "flex"; }
    function closeModal() { document.getElementById("modalAdd").style.display = "none"; }
    window.onclick = function(event) {
        if (event.target == document.getElementById("modalAdd")) closeModal();
    }
</script>

</body>
</html>