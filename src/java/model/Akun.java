package model;

public class Akun {
    private int idAkun;
    private String username;
    private String password;
    private String email;
    private String role; // admin / pengguna

    public Akun() {}

    public Akun(int idAkun, String username, String password, String role, String email) {
        this.idAkun = idAkun;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
    }

    public int getIdAkun() {
        return idAkun;
    }

    public void setIdAkun(int idAkun) {
        this.idAkun = idAkun;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
