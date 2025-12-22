package model;

public class Favorite {
    private int idFavorite;
    private int idUser;
    private int idFilm;

    public Favorite() {}

    public Favorite(int idFavorite, int idUser, int idFilm) {
        this.idFavorite = idFavorite;
        this.idUser = idUser;
        this.idFilm = idFilm;
    }

    public int getIdFavorite() {
        return idFavorite;
    }

    public void setIdFavorite(int idFavorite) {
        this.idFavorite = idFavorite;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }
}
