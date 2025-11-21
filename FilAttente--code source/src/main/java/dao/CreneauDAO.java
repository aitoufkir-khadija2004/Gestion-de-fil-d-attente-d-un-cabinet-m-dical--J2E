package dao;

import beans.Creneau;
import java.util.List;

public interface CreneauDAO {
    List<Creneau> getCreneauxDisponibles();
    List<Creneau> getCreneauxByMedecin(int medecinId);
    Creneau getCreneauById(int id);
    boolean creerCreneau(Creneau creneau);
    boolean updateCreneau(Creneau creneau);
    boolean incrementerTicketsPris(int creneauId);
    boolean deleteCreneau(int id);
	List<Creneau> getAllCreneaux();
}