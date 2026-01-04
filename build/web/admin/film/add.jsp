<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<h2>Tambah Film Baru</h2>

<a href="<%=request.getContextPath()%>/film">⬅ Kembali</a>
<br><br>

<form action="<%=request.getContextPath()%>/film?action=insert" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="insert"/>

    <label>Judul:</label><br>
    <input type="text" name="judul" required><br><br>

    <label>Deskripsi:</label><br>
    <textarea name="deskripsi" rows="5"></textarea><br><br>

    <label>Tahun Rilis:</label><br>
    <input type="number" name="tahun" required><br><br>

    <label>Rating (0.0 - 10.0):</label><br>
    <input type="number" name="rating" step="0.1" min="0" max="10" required><br><br>

    <label>Cast:</label><br>
    <input type="text" name="cast" required><br><br>

    <label>Genre:</label><br>
    <select name="genre" required>
        <option value="1">Action</option>
        <option value="2">Drama</option>
        <option value="3">Sci-Fi</option>
        <option value="4">Adventure</option>
        <option value="5">Thriller</option>
    </select><br><br>

    <label>Poster File:</label><br>
    <input type="file" name="poster" accept="image/*"><br><br>

    <button type="submit">Simpan</button>
</form>
