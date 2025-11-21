package dao;

import beans.Specialite;
import java.util.List;

public interface SpecialiteDAO {
    List<Specialite> getAllSpecialites();
    Specialite getSpecialiteById(int id);
    boolean creerSpecialite(Specialite specialite);
    boolean updateSpecialite(Specialite specialite);
    boolean deleteSpecialite(int id);
    boolean isSpecialiteUsed(int specialiteId);  
}