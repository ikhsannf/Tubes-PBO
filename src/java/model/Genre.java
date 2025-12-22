package model;

public class Genre {
    private int idGenre;
    private String namaGenre;

    public Genre() {}

    public Genre(int idGenre, String namaGenre) {
        this.idGenre = idGenre;
        this.namaGenre = namaGenre;
    }

    public int getIdGenre() {
        return idGenre;
    }

    public void setIdGenre(int idGenre) {
        this.idGenre = idGenre;
    }

    public String getNamaGenre() {
        return namaGenre;
    }

    public void setNamaGenre(String namaGenre) {
        this.namaGenre = namaGenre;
    }
}
