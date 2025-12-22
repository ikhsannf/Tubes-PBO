<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<h2>Tambah Film Baru</h2>

<a href="<%=request.getContextPath()%>/film">⬅ Kembali</a>
<br><br>

<form action="<%=request.getContextPath()%>/film?action=insert" method="post">
    <input type="hidden" name="action" value="insert"/>

    <label>Judul:</label><br>
    <input type="text" name="judul" required><br><br>

    <label>Deskripsi:</label><br>
    <textarea name="deskripsi" rows="5"></textarea><br><br>

    <label>Tahun Rilis:</label><br>
    <input type="number" name="tahun" required><br><br>

    <label>Poster URL:</label><br>
    <input type="text" name="poster"><br><br>

    <button type="submit">Simpan</button>
</form>
