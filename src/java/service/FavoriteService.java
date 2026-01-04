package service;

import config.JDBC;
import model.Film; 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteService {

    // 1. Ambil Data Favorit
    public List<Film> getByUser(int userId) {
        List<Film> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            // REVISI PENTING: Join dengan tabel genre dan gunakan nama kolom yang benar, serta ambil rating dan cast_film
            String sql = "SELECT f.idFilm, f.judul, f.posterUrl, f.deskripsi, f.rating, f.cast_film, g.namaGenre " +
                         "FROM film f " +
                         "JOIN favorite fav ON f.idFilm = fav.idFilm " +
                         "LEFT JOIN genre g ON f.genre_id = g.idGenre " +
                         "WHERE fav.idUser = ?";
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Film f = new Film();
                f.setIdFilm(rs.getInt("idFilm"));
                f.setJudul(rs.getString("judul"));
                
                // Pastikan nama kolom ini sesuai dengan tabel 'film' Anda
                f.setPosterUrl(rs.getString("posterUrl")); 
                f.setDeskripsi(rs.getString("deskripsi"));
                f.setNamaGenre(rs.getString("namaGenre"));
                
                // Tambahan mapping untuk Rating dan Cast
                f.setRating(rs.getDouble("rating"));
                f.setCastFilm(rs.getString("cast_film"));
                
                list.add(f);
            }

        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 2. Tambah Favorit
    public boolean addFavorite(int userId, int filmId) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            
            // REVISI PENTING: Ubah 'idAkun' jadi 'idUser'
            String sql = "INSERT INTO favorite(idUser, idFilm) VALUES(?,?)"; 
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            pst.setInt(2, filmId);
            
            return pst.executeUpdate() > 0; 
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // 3. Hapus Favorit
    public boolean removeFavorite(int userId, int filmId) {
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            
            // REVISI PENTING: Ubah 'idAkun' jadi 'idUser'
            String sql = "DELETE FROM favorite WHERE idUser=? AND idFilm=?";
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            pst.setInt(2, filmId);
            
            return pst.executeUpdate() > 0;
            
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
    // 4. Cek Status Favorit
    public boolean isFavorite(int userId, int filmId) {
        JDBC db = new JDBC();
        boolean status = false;
        try {
            db.connect();
            Connection con = db.getConnection();
            
            // REVISI PENTING: Ubah 'idAkun' jadi 'idUser'
            String sql = "SELECT idFavorite FROM favorite WHERE idUser=? AND idFilm=?";
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            pst.setInt(2, filmId);
            
            ResultSet rs = pst.executeQuery();
            if (rs.next()) status = true;
            
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }
    
    public int countFavorites(int userId) {
        int count = 0;
        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            
            // Query menghitung jumlah baris berdasarkan idUser
            String sql = "SELECT COUNT(*) FROM favorite WHERE idUser = ?";
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1); // Ambil angka hasil hitungan
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}