package service;

import config.JDBC;
import model.LikeBerita;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LikeBeritaService {

    public List<LikeBerita> getLikesByBerita(int idBerita) {
        List<LikeBerita> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM likeberita WHERE idBerita=?"
            );

            pst.setInt(1, idBerita);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new LikeBerita(
                        rs.getInt("idLike"),
                        rs.getInt("idAkun"),
                        rs.getInt("idBerita"),
                        rs.getTimestamp("tanggalLike")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }


    public boolean like(int idAkun, int idBerita) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO likeberita(idAkun, idBerita) VALUES(?,?)"
            );

            pst.setInt(1, idAkun);
            pst.setInt(2, idBerita);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }


    public boolean unlike(int idAkun, int idBerita) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "DELETE FROM likeberita WHERE idAkun=? AND idBerita=?"
            );

            pst.setInt(1, idAkun);
            pst.setInt(2, idBerita);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
}
