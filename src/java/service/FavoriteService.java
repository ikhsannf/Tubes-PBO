package service;

import config.JDBC;
import model.Favorite;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteService {

    public List<Favorite> getByUser(int userId) {
        List<Favorite> list = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM favorite WHERE idUser=?"
            );

            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new Favorite(
                        rs.getInt("idFavorite"),
                        rs.getInt("idUser"),
                        rs.getInt("idFilm")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }


    public boolean addFavorite(int userId, int filmId) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO favorite(idUser, idFilm) VALUES(?,?)"
            );

            pst.setInt(1, userId);
            pst.setInt(2, filmId);

            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }


    public boolean removeFavorite(int idFavorite) {
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            PreparedStatement pst = con.prepareStatement(
                "DELETE FROM favorite WHERE idFavorite=?"
            );

            pst.setInt(1, idFavorite);
            return pst.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }
}

