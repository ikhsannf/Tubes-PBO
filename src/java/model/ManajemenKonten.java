package model;

import java.util.List;

public interface ManajemenKonten<T> {
    List<T> getAll();
    T getById(int id);
    boolean insert(T obj);
    boolean update(T obj);
    boolean delete(int id);
}
